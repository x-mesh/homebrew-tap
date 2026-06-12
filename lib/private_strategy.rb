# typed: false
# frozen_string_literal: true

# Private GitHub 저장소의 릴리스 자산 다운로드 전략.
#
# browser_download_url은 private 자산에 대해 인증 다운로드가 불가하므로,
# API asset endpoint(/releases/assets/{id})를 Accept: octet-stream + Bearer
# 토큰으로 받는다. 토큰: HOMEBREW_GITHUB_API_TOKEN > GITHUB_TOKEN > `gh auth token`.
#
# 저장소가 public이 되면 formula에서 `using:` 만 제거하면 된다.
require "download_strategy"
require "json"

class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    pattern = %r{https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    raise CurlDownloadStrategyError, "GitHub Release URL 형식이 아님: #{@url}" unless @url =~ pattern

    @owner = Regexp.last_match(1)
    @repo = Regexp.last_match(2)
    @tag = Regexp.last_match(3)
    @filename = Regexp.last_match(4)
  end

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"].to_s
    @github_token = ENV["GITHUB_TOKEN"].to_s if @github_token.empty?
    if @github_token.empty?
      @github_token = begin
        Utils.popen_read("gh", "auth", "token").chomp
      rescue StandardError
        ""
      end
    end
    return unless @github_token.empty?

    raise CurlDownloadStrategyError,
          "private 릴리스 다운로드에 토큰이 필요합니다 — " \
          "export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)"
  end

  def asset_id
    @asset_id ||= begin
      out = Utils.popen_read(
        "curl", "-fsSL",
        "-H", "Authorization: Bearer #{@github_token}",
        "-H", "Accept: application/vnd.github+json",
        "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
      )
      release = JSON.parse(out)
      asset = release.fetch("assets", []).find { |a| a["name"] == @filename }
      raise CurlDownloadStrategyError, "릴리스 #{@tag}에 자산 없음: #{@filename}" unless asset

      asset["id"]
    end
  end

  def _fetch(url:, resolved_url:, timeout:)
    curl_download(
      "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}",
      "--header", "Accept: application/octet-stream",
      "--header", "Authorization: Bearer #{@github_token}",
      to: temporary_path, timeout: timeout
    )
  end
end
