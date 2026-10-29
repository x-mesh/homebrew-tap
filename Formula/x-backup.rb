# typed: false
# frozen_string_literal: true

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.7.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.7.0/x-backup_darwin_arm64.tar.gz"
      sha256 "6b0328f273e898f8e93aafe360e87c6adc28c67a58f9a1f7c3ba57cb053b272a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.7.0/x-backup_darwin_amd64.tar.gz"
      sha256 "35285244832d7513e8b0afb7a798fe2b0e670ff03d283168c238a07e3dab38fd"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.7.0/x-backup_linux_amd64.tar.gz"
      sha256 "787f4b54623d6c313ba3e59785e478ee1ae264779f08c186679d87833393cf87"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.7.0/x-backup_linux_arm64.tar.gz"
      sha256 "76a321a1c9ae269222e03e3f1c844a79ece7637a8efdda31ea75189c5aa27dc0"
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
