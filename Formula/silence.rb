class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/nv0skar/SilenceEvolution"
  version "0.0.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.10/silence-aarch64-apple-darwin.tar.xz"
    sha256 "a0738aa5ed0ac74b3f938a5fb8988a11844e73c75a345483adabf1b26f5d4617"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.10/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79358cb2ef2b2942c0b3e6794e12c67a52f93c0f0c29862d67e77101f3336204"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.10/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "43176e14818a60612a1d3ef40e9b253ae7f534d01c0458c6cebe047b7e51a358"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":       {},
    "aarch64-pc-windows-gnu":     {},
    "aarch64-pc-windows-gnullvm": {},
    "aarch64-unknown-linux-gnu":  {},
    "x86_64-pc-windows-gnu":      {},
    "x86_64-unknown-linux-gnu":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "silence"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "silence"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "silence"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
