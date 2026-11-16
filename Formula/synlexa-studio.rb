class SynlexaStudio < Formula
  desc "Deterministic structural biology, peptide, CRISPR, SMILES, and MCP workbench (Research-Use-Only)"
  homepage "https://www.synlexa.com/download"
  version "0.3.0"
  license "Proprietary"

  on_macos do
    url "https://studio.synlexa.com/releases/synlexa-studio-v#{version}-universal-apple-darwin.tar.gz"
    sha256 "8d1557e9827e6a4c0f57929766f0457436f9dc19c133b0dcec118f1a22f68815"
  end

  on_linux do
    on_intel do
      url "https://studio.synlexa.com/releases/synlexa-studio-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "575e9ec8cfcbd800675338dbc0b0cedcd91bfd79af4a7e7415b354b998f40b8d"
    end
    on_arm do
      url "https://studio.synlexa.com/releases/synlexa-studio-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ecb58cb1e5cc2dd8b17408081e19f7ee8935a619735c1e1985c252c99ba2abce"
    end
  end

  def install
    libexec.install Dir["*"]
    (bin/"synlexa-studio").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ "${1:-}" == "mcp" || "${1:-}" == "inspect" || "${1:-}" == "compare" || "${1:-}" == "peptide" || "${1:-}" == "gene" || "${1:-}" == "smiles" || "${1:-}" == "ramachandran" ]]; then
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
