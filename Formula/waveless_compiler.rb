class WavelessCompiler < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/Waveless"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/Waveless/releases/download/0.2.0/waveless_compiler-aarch64-apple-darwin.tar.xz"
    sha256 "04951922c1d0a6f71d5ee7ddd6630937f45b388b3f596e2543fdeea0c7a39b80"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.0/waveless_compiler-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d23d0585fbcb4b1f11738997908c57466dceac79f3980d656f28392d2e7d787b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.0/waveless_compiler-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9244c54de88bf21df498c106b0f3553f7be9ab66d37dc3014ed17e289da800e5"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "waveless_compiler"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "waveless_compiler"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "waveless_compiler"
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
