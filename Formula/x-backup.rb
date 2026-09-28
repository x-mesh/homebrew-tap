# typed: false
# frozen_string_literal: true

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.4.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.4.0/x-backup_darwin_arm64.tar.gz"
      sha256 "ea458bd77ef22e9ab985fa076bb04c0757d5528a2317b0e85122bf5c42069093"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.4.0/x-backup_darwin_amd64.tar.gz"
      sha256 "fc12847908b86f626ae33ac350f0a560e1faf17c9ab32fc255d552db2175db1d"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.4.0/x-backup_linux_amd64.tar.gz"
      sha256 "a22a2570b9365a52203e845753aa43bf534b825a91c83c0fa3bb05703fdd72ca"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.4.0/x-backup_linux_arm64.tar.gz"
      sha256 "7d43f9f5eefdfcf4601b58f3d5d0ef8a7c3741a1a38b79684f905f26290e785a"
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
