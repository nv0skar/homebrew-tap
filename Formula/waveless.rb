class Waveless < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/waveless"
  version "0.4.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/waveless/releases/download/0.4.0/waveless-aarch64-apple-darwin.tar.xz"
    sha256 "bae07e67939443ea8e27e2141547520d2060a5fbd75a5140f8611817da46ef43"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/waveless/releases/download/0.4.0/waveless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a1bcc89b845580c538212247e09a13da8dedfbe49c3bbc0c92eccc1a915be914"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/waveless/releases/download/0.4.0/waveless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74c2ca5e651815845a156a244e6c06463880f2f1804d1ab95e7d14a34132003b"
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
