cask "warmy" do
  version "1.0.24"
  sha256 "3ec068b800674bb2d7b0400fa42f10be99875d091ef8f030004ee327ec262381"

  url "https://warmy.dev/dl/Warmy-#{version}.dmg"
  name "Warmy"
  desc "Keeps Claude's prompt cache warm while you are away from a chat"
  homepage "https://warmy.dev/"

  livecheck do
    url "https://warmy.dev/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :ventura

  app "Warmy.app"

  uninstall quit: "dev.warmy.Warmy"

  zap early_script: {
        executable:   "/bin/sh",
        args:         ["-c", '[ -x "$0" ] && "$0" uninstall || true', "#{appdir}/Warmy.app/Contents/MacOS/warmctl"],
        must_succeed: false,
      },
      launchctl:    "dev.warmy.warmd",
      trash:        [
        "~/Library/Application Support/Warmy",
        "~/Library/Caches/dev.warmy.Warmy",
        "~/Library/HTTPStorages/dev.warmy.Warmy",
        "~/Library/LaunchAgents/dev.warmy.warmd.plist.removed",
        "~/Library/Preferences/dev.warmy.Warmy.plist",
        "~/Library/Preferences/dev.warmy.Warmy.rehearsal.plist",
      ]

  caveats <<~EOS
    Warmy routes Claude Code (and other tools you connect) through a local helper.
    `brew uninstall --cask warmy` removes the app but leaves the helper running so those tools keep working.
    To undo every change, use Warmy > Settings > Uninstall, or run:
      brew uninstall --zap --cask warmy
  EOS
end
