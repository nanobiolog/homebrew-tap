cask "synlexa-studio" do
  version "0.4.5"
  sha256 "ce92ab081457224611c256b5ade1e4f3ddf18000d95e694e8f7a999e5d10919a"

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
