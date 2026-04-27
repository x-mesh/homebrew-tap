# typed: false
# frozen_string_literal: true

# Initially seeded by hand for v0.1.0 because the goreleaser brews step
# couldn't open a PR (HOMEBREW_TAP_GITHUB_TOKEN was missing on x-mesh/aic).
# Once that secret is in place, future releases will overwrite this file
# automatically — the shape matches what GoReleaser generates.
class Aic < Formula
  desc "Shell command error analyzer with LLM (PTY wrapper + supervisor daemon)"
  homepage "https://github.com/x-mesh/aic"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/x-mesh/aic/releases/download/v0.1.0/aic_0.1.0_darwin_amd64.tar.gz"
      sha256 "84b2ba4a30ca80301140d87fb0c5a386089eafdf170edf0ca858350090dcb44c"

      def install
        bin.install "aic"
        bin.install "aic-session"
        bin.install "aicd"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/x-mesh/aic/releases/download/v0.1.0/aic_0.1.0_darwin_arm64.tar.gz"
      sha256 "440ed2ebe13279f7c9c6bfc4d7e128af640c5f694050d36b77ec0a8289183fa4"

      def install
        bin.install "aic"
        bin.install "aic-session"
        bin.install "aicd"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/aic/releases/download/v0.1.0/aic_0.1.0_linux_amd64.tar.gz"
      sha256 "884148eabe32d43151a25735f561d219773ab7e2a27cb51177f85342ef528239"

      def install
        bin.install "aic"
        bin.install "aic-session"
        bin.install "aicd"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/x-mesh/aic/releases/download/v0.1.0/aic_0.1.0_linux_arm64.tar.gz"
      sha256 "afb7b111e556c18624dc60bb8a30b8099f9df2a2c4da6fbe85df0265621c3512"

      def install
        bin.install "aic"
        bin.install "aic-session"
        bin.install "aicd"
      end
    end
  end

  def caveats
    <<~EOS
      To run aicd in the background and on login:

        aic daemon install        # writes the right unit for your OS

      What this does:
        macOS  -> ~/Library/LaunchAgents/com.x-mesh.aicd.plist (launchctl)
        Linux  -> ~/.config/systemd/user/aicd.service (systemctl --user)

      First-time setup:
        aic config                # interactive provider/api_key/model wizard
        aic init zsh              # add 'source ~/.aic/hooks.zsh' to your rc
    EOS
  end

  test do
    assert_match(/^aic /, shell_output("#{bin}/aic --version"))
    assert_match(/^aic-session /, shell_output("#{bin}/aic-session --version"))
    assert_match(/^aicd /, shell_output("#{bin}/aicd --version"))
  end
end
