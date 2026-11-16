cask "synlexa-studio" do
  version "0.3.0"
  sha256 "d61b3aa50744c748a4137f12932052582ab5db1fe1f7baa50169ac4c76fc3474"

  url "https://studio.synlexa.com/releases/Synlexa-Studio-v#{version}-universal-apple-darwin.dmg",
      verified: "studio.synlexa.com/releases/"
  name "Synlexa Studio"
  desc "Offline-capable structural biology, peptide, CRISPR, SMILES, and MCP desktop workbench (RUO)"
  homepage "https://www.synlexa.com/download"

  app "Synlexa Studio.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Synlexa Studio.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/.synlexa-studio/state.vscdb",
    "~/Library/Application Support/com.synlexa.studio",
  ]
end
