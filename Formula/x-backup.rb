# typed: false
# frozen_string_literal: true

require_relative "../lib/private_strategy"

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.2.0/x-backup_darwin_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "a7e4cb110f2267d151b0118a6fbcd8d8345356b9555506aa0c0138eb9c8df0c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.2.0/x-backup_darwin_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "84719a9851d3fe7e337e0e71a3a07b72fde4261ee5aa5bd5a05edb09f8cc4a3e"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.2.0/x-backup_linux_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "eac3e3b6e08d9e47f3bed72ea80ac566796aba7282d3c2ad68dba8d22f67b632"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.2.0/x-backup_linux_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "c6c84749f17ba4417d9b36f22e1567440434b0a4deea3388e095f03e5a6857ad"
    end
  end

  def install
    bin.install "x-backup"
  end

  def caveats
    <<~EOS
      private 단계에서는 다운로드에 GitHub 토큰이 필요합니다:
        export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)

      백업/복구는 네이티브 드라이버로 동작합니다 — mongodump/mongorestore·pg_dump 등
      외부 CLI 도구는 필요하지 않습니다.

      자기 갱신: x-backup update  (brew 설치는 brew upgrade로 위임됩니다)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x-backup --version")
  end
end
