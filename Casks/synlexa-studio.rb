cask "synlexa-studio" do
  version "0.4.2"
  sha256 "25352e34616e3839179e68278186493a8e523499081dfc8099a963f71c9221f6"

  url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/Synlexa-Studio-v#{version}-universal-apple-darwin.dmg"
  name "Synlexa Studio"
  desc "Offline structural biology, peptide, CRISPR, SMILES, and MCP IDE"
  homepage "https://www.synlexa.com/download"

  app "Synlexa Studio.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args:         ["-cr", "#{appdir}/Synlexa Studio.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/.synlexa-studio/state.vscdb",
    "~/Library/Application Support/com.synlexa.studio",
  ]
end
