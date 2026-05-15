cask "term-mesh" do
  version "0.117.0"
  sha256 "01b398284691251503a2504c74f4f56f32c1ce17922bf9266a7f27257a8db611"

  url "https://github.com/x-mesh/term-mesh/releases/download/v#{version}/term-mesh-macos-#{version}.dmg"
  name "term-mesh"
  desc "Terminal emulator with tabs, splits, and agent orchestration"
  homepage "https://github.com/x-mesh/term-mesh"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  # Quit a running term-mesh before brew tries to replace the bundle.
  # macOS technically allows replacing a running .app via rename, but
  # brew-cask sometimes silently no-ops the move when the app holds an
  # active LaunchServices registration — leaving the user on the old
  # version with a "successfully installed" message. Quitting first
  # eliminates the race for both fresh installs and upgrades.
  preflight do
    system_command "/usr/bin/osascript",
                   args: ["-e", 'tell application "term-mesh" to quit'],
                   must_succeed: false
    sleep 2
  end

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
