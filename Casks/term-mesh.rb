cask "term-mesh" do
  version "0.217.0"
  sha256 "bcfcf93bd6ea8404a18c7fb4e62cdaf4ae13a05a7ee021ba77612265e500fbd9"

  url "https://github.com/x-mesh/term-mesh/releases/download/v#{version}/term-mesh-macos-#{version}.dmg"
  name "term-mesh"
  desc "Terminal emulator with tabs, splits, and agent orchestration"
  homepage "https://github.com/x-mesh/term-mesh"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "term-mesh.app"
  binary "#{appdir}/term-mesh.app/Contents/Resources/bin/tm-agent"
  binary "#{appdir}/term-mesh.app/Contents/Resources/bin/term-mesh-run"

  # Fresh installs never run the uninstall stanza below, so a hand-installed
  # copy could still be holding the bundle when brew moves the new one in.
  # pkill matches on process name only, so unlike AppleScript it can never
  # put up a GUI prompt — see the uninstall comment for why that matters. The
  # daemon deliberately outlives an ordinary quit while serving peers, but an
  # upgrade must replace it or the new app adopts an old protocol process.
  #
  # Scope it to the bundle this install actually replaces. Matching on process
  # name alone means an unguarded preflight kills every running term-mesh on
  # the machine, including one launched from outside appdir that this install
  # never touches. That is what lets an isolated `--appdir` install — the
  # release smoke test — run beside a live app instead of taking it down.
  preflight do
    if File.exist?("#{appdir}/term-mesh.app")
      quit = system_command "/usr/bin/pkill",
                            args:         ["-x", "term-mesh"],
                            must_succeed: false
      sleep 2 if quit.success?
      system_command "/usr/bin/pkill",
                     args: ["-f", "^#{appdir}/term-mesh[.]app/Contents/Resources/bin/term-meshd$"],
                     must_succeed: false
    end
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/term-mesh.app"],
                   sudo: false
  end

  # Quit a running term-mesh before brew replaces the bundle. macOS
  # technically allows replacing a running .app via rename, but brew-cask
  # sometimes silently no-ops the move when the app holds an active
  # LaunchServices registration — leaving the user on the old version with a
  # "successfully installed" message.
  #
  # This belongs in `uninstall quit:`, which brew runs on upgrade while the
  # old bundle is still in place, so the bundle id resolves and the app exits
  # gracefully before the move.
  #
  # Do NOT do this from `preflight` with a name-based AppleScript
  # (`tell application "term-mesh" to quit`): on upgrade, preflight runs
  # *after* brew has already removed /Applications/term-mesh.app, macOS cannot
  # resolve the name, and it puts up a blocking "choose application" chooser.
  # The upgrade then hangs until a human dismisses it — `must_succeed: false`
  # does not help, because the call never returns at all.
  uninstall quit: "com.termmesh.app",
            script: {
              executable: "/usr/bin/pkill",
              args: ["-f", "^#{appdir}/term-mesh[.]app/Contents/Resources/bin/term-meshd$"],
              must_succeed: false,
              sudo: false,
            }

  zap trash: [
    "~/.term-mesh",
    "~/Library/Application Support/term-mesh",
    "~/Library/Caches/com.termmesh.app",
    "~/Library/Preferences/com.termmesh.app.plist",
    "~/Library/Saved Application State/com.termmesh.app.savedState",
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
