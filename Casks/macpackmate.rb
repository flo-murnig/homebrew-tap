cask "macpackmate" do
  version "0.47.0"
  sha256 "e546b9f6b69e6aa9709bf0551127e18e6d242614301a9abd3f611b1f547a6379"

  url "https://dynamo.at/macpackmate/MacPackMate-#{version}.dmg"
  name "MacPackMate"
  desc "Hub for all package managers: Homebrew, npm, pip, Cargo, Nix and more"
  homepage "https://dynamo.at/macpackmate/"

  livecheck do
    url "https://dynamo.at/macpackmate/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: :sonoma

  app "MacPackMate.app"
  binary "#{appdir}/MacPackMate.app/Contents/Helpers/macpackmate"

  zap trash: [
    "~/Library/Application Support/MacPackMate",
    "~/Library/Caches/at.dynamo.MacPackMate",
    "~/Library/HTTPStorages/at.dynamo.MacPackMate",
    "~/Library/LaunchAgents/at.dynamo.macpackmate.check.plist",
    "~/Library/Logs/MacPackMate",
    "~/Library/Preferences/at.dynamo.MacPackMate.plist",
    "~/Library/WebKit/at.dynamo.MacPackMate",
  ]
end
