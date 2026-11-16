cask "synlexa-studio" do
  version "0.4.3"
  sha256 "a764564df56a760b1f2627c26932bd22973543646edf7e9f7352bf39fafebb00"

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
