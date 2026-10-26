# typed: false
# frozen_string_literal: true

class XBackup < Formula
  desc "MongoDB/PostgreSQL backup & restore CLI - full/incremental, PITR, encrypted, S3-compatible"
  homepage "https://github.com/x-mesh/x-backup"
  version "0.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.0/x-backup_darwin_arm64.tar.gz"
      sha256 "a16a13b46192b8e0edff79a02370c7253884601d1c9149d7647fd0b016907d06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.0/x-backup_darwin_amd64.tar.gz"
      sha256 "446df76415889e5e380020c0ec62af2f8baae49a619381f91c9bb47f6f797a1b"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.0/x-backup_linux_amd64.tar.gz"
      sha256 "c6c9bbc21a503b88f92aa002ab6f28aaca4fb50aa9adac11081c4de25951a504"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/x-backup/releases/download/v0.6.0/x-backup_linux_arm64.tar.gz"
      sha256 "0fa6c173b3add5af765113815794f6a255893d9928db21853762eafcb9c2123a"
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
