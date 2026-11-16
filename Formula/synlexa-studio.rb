class SynlexaStudio < Formula
  desc "Deterministic structural biology, peptide, CRISPR, SMILES, and MCP workbench"
  homepage "https://www.synlexa.com/download"
  version "0.4.5"
  license "Apache-2.0"

  on_macos do
    url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-universal-apple-darwin.tar.gz"
    sha256 "223bb84d604813f2b513a353bde5d5268f7546ba37890290cdf9bf603e25cbcc"
  end

  on_linux do
    on_intel do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "732dd870b7bc41596d646ea88184d714c98de4f3ff554c3cbd97a35d47ba2aa4"
    end
    on_arm do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "51c45e8e259d1405982fbfae741983820dfd9110fb1691c2ce93fce36de2da09"
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
