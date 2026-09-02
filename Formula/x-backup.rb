# typed: false
# frozen_string_literal: true

require_relative "../lib/private_strategy"

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.3.0/x-backup_darwin_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "145e6b9187a4cc871744dc048116aa1ac8015ae0ab47d7ca5ada8a934b725587"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.3.0/x-backup_darwin_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "c7f8f51f0db271206ccc342d332f2ae8121d186ebb76eff4262ce425bf5567bf"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.3.0/x-backup_linux_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "a7b9a0092b231b2eaf0070c774e6359542cb263a8665b7d2c1b0b95c9d28658a"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.3.0/x-backup_linux_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "846a2b471a3bfe57b5b5fa708e3ea18c62c291fb749abe33b4ad2282afb0d47f"
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
