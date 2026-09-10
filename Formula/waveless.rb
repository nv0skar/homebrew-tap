class Waveless < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/waveless"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/waveless/releases/download/0.2.2/waveless-aarch64-apple-darwin.tar.xz"
    sha256 "91ee8f8e9e4353e19115cb43f28efbb7a474ef7669a235b2dff79be3dfe9aea3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/waveless/releases/download/0.2.2/waveless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a7a45f23ef8c3c01ca2a391ec839140d69a6be97fbdcd0d7e538355d433d8ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/waveless/releases/download/0.2.2/waveless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eabe7755256827857623b90735b57bc814f553f79999f5b3a4205e0f0b42ff78"
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
      bin.install "waveless"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "waveless"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "waveless"
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
