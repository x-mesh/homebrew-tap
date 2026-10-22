# typed: false
# frozen_string_literal: true

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.5.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.5.0/x-backup_darwin_arm64.tar.gz"
      sha256 "51b7d9143bb88fff4498fdd86106c4d52797ebf41990732b2603cb4cca61a16b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.5.0/x-backup_darwin_amd64.tar.gz"
      sha256 "26765a94631142b9e76563aae3d372e4d04288a4f0d875732be0aa4b51310b96"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.5.0/x-backup_linux_amd64.tar.gz"
      sha256 "5850f685a5a3cacd854fa8de99dba30cefcdb2965cfb29475b4a9c16279cc293"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.5.0/x-backup_linux_arm64.tar.gz"
      sha256 "efd4e1eb52b863f72dce6c571545986af99db84666c6eab907f0ae39f0d8b6e1"
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
