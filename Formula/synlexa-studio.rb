class SynlexaStudio < Formula
  desc "Deterministic structural biology, peptide, CRISPR, SMILES, and MCP workbench"
  homepage "https://www.synlexa.com/download"
  version "0.4.1"
  license "Apache-2.0"

  on_macos do
    url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-universal-apple-darwin.tar.gz"
    sha256 "f3b37abd44d237cf3bbabae76d0e6cf13381124f25210d90f9959394b2b18ee1"
  end

  on_linux do
    on_intel do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5aeec4192fa1ef9012fe4f241fde43f2f1834a9c267e0852678d8743dd54a9f4"
    end
    on_arm do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "33cd86be45f42797241b99930c23072688bb6626600e073888e87c4595cb4ace"
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
