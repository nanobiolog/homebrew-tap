cask "synlexa-studio" do
  version "0.4.1"
  sha256 "ccc881832eb4cbac3350efdb9b918bdc7231b39732f6ccd314bb957375f23052"

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
