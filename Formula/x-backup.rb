# typed: false
# frozen_string_literal: true

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.6.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.1/x-backup_darwin_arm64.tar.gz"
      sha256 "af24ac13092b74be6ccf15a77a668d0e63d942e6bfbb038589c85ad720ea6223"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.1/x-backup_darwin_amd64.tar.gz"
      sha256 "32f6df16b20c0f1351c00cb425704f3bbe148f9524ba5659fae3720064201df9"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.1/x-backup_linux_amd64.tar.gz"
      sha256 "ebcbf42030ef775f89b3fb5925d5d3f9baff1c8db15a93f5249fb3fbd14f6be9"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.1/x-backup_linux_arm64.tar.gz"
      sha256 "37b8e0490ac1c18174ba434000a4783fadb544c1b6c23d02c25c73491d02970c"
    end
  end

  def install
    bin.install "x-backup"
  end

  def caveats
    <<~EOS
      백업/복구는 네이티브 드라이버로 동작합니다 — mongodump/mongorestore·pg_dump 등
      외부 CLI 도구는 필요하지 않습니다.

      자기 갱신: x-backup update  (brew 설치는 brew upgrade로 위임됩니다)
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x-backup --version")
  end
end
