# This file is published by the httprove release (x-mesh/httprove).
cask "httprove" do
  version "0.1.0"

  on_macos do
    on_arm do
      sha256 "87961c562a3dd64d97192bc69f78bb232b97b3e8f77cad43935fc97080b3e04f"
      url "https://github.com/x-mesh/httprove/releases/download/v#{version}/httprove_darwin_arm64.tar.gz"
    end
    on_intel do
      sha256 "6fe0f2f167111ade58e6c195ce9ea80313336ac0a9e2434e5f1964a2309f7ef0"
      url "https://github.com/x-mesh/httprove/releases/download/v#{version}/httprove_darwin_amd64.tar.gz"
    end
  end

  on_linux do
    on_arm do
      sha256 "e6e5ffcfcbf75d9c889567a7230260f8109a3d21195e5b13ec174463ed5bad7a"
      url "https://github.com/x-mesh/httprove/releases/download/v#{version}/httprove_linux_arm64.tar.gz"
    end
    on_intel do
      sha256 "8cd14a836355c919dce99ef0322f285f2e8d5e196cf05fc8f26a821965fedca0"
      url "https://github.com/x-mesh/httprove/releases/download/v#{version}/httprove_linux_amd64.tar.gz"
    end
  end

  name "httprove"
  desc "HTTP(S) service diagnostics for SREs: latency waterfall, TLS inspection, TUI"
  homepage "https://github.com/x-mesh/httprove"

  livecheck do
    skip "Published on release."
  end

  binary "httprove"
  # 단축 명령 hpr 를 같은 바이너리로 노출.
  binary "httprove", target: "hpr"

  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{staged_path}/httprove"]
  end

  caveats <<~EOS
    Two commands are installed: httprove (primary) and hpr (alias).
    Run 'httprove update' to self-update.
  EOS
end
