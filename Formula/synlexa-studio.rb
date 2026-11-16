class SynlexaStudio < Formula
  desc "Deterministic structural biology, peptide, CRISPR, SMILES, and MCP workbench"
  homepage "https://www.synlexa.com/download"
  version "0.4.0"
  license "Apache-2.0"

  on_macos do
    url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-universal-apple-darwin.tar.gz"
    sha256 "a151254af8fa938d3e327e623dc310a722811fcbc540738a8c2679afadf94d21"
  end

  on_linux do
    on_intel do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb0c4d8364be01f6c645c3e1d995df87db8919afb6579d66bbbe5ba1b88e6372"
    end
    on_arm do
      url "https://github.com/Synlexa/synlexa-studio/releases/download/v#{version}/synlexa-studio-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f869fae356e1a36d3f95268efef69f4af82c893953799154342bdb1ba7b9016d"
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
