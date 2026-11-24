# typed: false
# frozen_string_literal: true

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.8.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.8.0/x-backup_darwin_arm64.tar.gz"
      sha256 "e86eb72b7efd30627c015417634ffd3123daab0add6204a8260334a3da471937"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.8.0/x-backup_darwin_amd64.tar.gz"
      sha256 "8116c48054e2035694046ac8f9696e82a6bd00986f0837e260ec4af13367c624"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.8.0/x-backup_linux_amd64.tar.gz"
      sha256 "67ccd96688d7b97575a26051ed26a7546a8ca0afaa085c8542e79585392846cf"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.8.0/x-backup_linux_arm64.tar.gz"
      sha256 "48e148c72811288c1ce750b7f20679f1e76b4d898a56088d7e5401d6557a18d8"
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
