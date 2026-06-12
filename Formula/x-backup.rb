# typed: false
# frozen_string_literal: true

require_relative "../lib/private_strategy"

class XBackup < Formula
  desc "MongoDB backup/restore CLI - full/incremental(oplog), PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.1.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.1.0/x-backup_darwin_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "095fd9fea8be708cb09f85c826c9762763f62e378267869a23f5565298eebbee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.1.0/x-backup_darwin_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "9158115abf2cd3c1b52db1ca3313e3873b65ff241c53564357880c938c90b504"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.1.0/x-backup_linux_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "b0aea312009c82da1646c1bde3109bdb56d00dc6617a9e79a2865a4817c6d6dd"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.1.0/x-backup_linux_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "f8a5042b632b2380dc07c67bf736c4751cb37cbc97ed3c37517a1145bf918149"
    end
  end

  def install
    bin.install "x-backup"
  end

  def caveats
    <<~EOS
      private 단계에서는 다운로드에 GitHub 토큰이 필요합니다:
        export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)

      백업/복구 실행에는 MongoDB Database Tools(mongodump/mongorestore)가
      PATH에 필요합니다: https://www.mongodb.com/try/download/database-tools

      자기 갱신: x-backup update  (brew 설치는 brew upgrade로 위임됩니다)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x-backup --version")
  end
end
