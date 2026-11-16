class SynlexaStudio < Formula
  desc "Deterministic structural biology, peptide, CRISPR, SMILES, and MCP workbench"
  homepage "https://www.synlexa.com/download"
  version "0.4.3"
  license "Apache-2.0"

  on_macos do
    url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-universal-apple-darwin.tar.gz"
    sha256 "911da9e0547c8ab8bbf8269c9f83cb96548b5b2877e5a77503dcf32a50f5a819"
  end

  on_linux do
    on_intel do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7209c4fdfa326bf14837859ed12da19426a59d2e35637a570c516255a59b3921"
    end
    on_arm do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0336b4aa88927fcd02c72b8ecf7d897cb7c04a54415fcfb9cdf9c7c1633640fb"
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"synlexa-studio").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ "${1:-}" == "mcp" || "${1:-}" == "inspect" || "${1:-}" == "compare" || "${1:-}" == "peptide" || "${1:-}" == "gene" || "${1:-}" == "smiles" || "${1:-}" == "ramachandran" || "${1:-}" == "--version" || "${1:-}" == "-V" || "${1:-}" == "version" ]]; then
        exec "#{libexec}/bin/studio-cli" "$@"
      fi
      exec "#{libexec}/bin/synlexa-studio-desktop-native" --dist "#{libexec}/web-dist" "$@"
    EOS
    bin.install_symlink libexec/"bin/studio-cli"
  end

  test do
    assert_match "C4H6N4O3S2", shell_output("#{bin}/studio-cli smiles --name Acetazolamide --smiles 'CC(=O)Nc1nnc(S(N)(=O)=O)s1'")
    mcp_out = pipe_output("#{bin}/synlexa-studio mcp --stdio", "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\"}\n")
    assert_match "synlexa-studio-native-mcp", mcp_out
  end
end
