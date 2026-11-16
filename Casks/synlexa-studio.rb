cask "synlexa-studio" do
  version "0.4.4"
  sha256 "ac957ce940f5367e2721811eeac7a9f857af7b60abd451e6d841ae2feb0ff24f"

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
