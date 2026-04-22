cask "term-mesh" do
  version "0.98.2"
  sha256 "3b00fc4ceb99fc32e52575f6f9e47b0b9f9bdd86f523e9a87c28f0a160996f6a"

  url "https://github.com/x-mesh/term-mesh/releases/download/v#{version}/term-mesh-macos-#{version}.dmg"
  name "term-mesh"
  desc "Terminal emulator with tabs, splits, and agent orchestration"
  homepage "https://github.com/x-mesh/term-mesh"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "term-mesh.app"

  binary "#{appdir}/term-mesh.app/Contents/Resources/bin/tm-agent"
  binary "#{appdir}/term-mesh.app/Contents/Resources/bin/term-mesh-run"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/term-mesh.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/term-mesh",
    "~/Library/Caches/com.termmesh.app",
    "~/Library/Preferences/com.termmesh.app.plist",
    "~/Library/Saved Application State/com.termmesh.app.savedState",
    "~/.term-mesh",
  ]

  caveats <<~CAVEATS
    term-mesh is distributed without Apple notarization.
    This cask automatically removes the quarantine attribute so the app
    launches without a Gatekeeper warning. If you prefer to verify the
    Gatekeeper flow manually, run the following after install:

      xattr -dr com.apple.quarantine #{appdir}/term-mesh.app

    The bundled CLI helpers (tm-agent, term-mesh-run) are symlinked to
    #{HOMEBREW_PREFIX}/bin.
  CAVEATS
end
