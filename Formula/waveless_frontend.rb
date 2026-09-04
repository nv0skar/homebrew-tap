class WavelessFrontend < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/Waveless"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless_frontend-aarch64-apple-darwin.tar.xz"
    sha256 "378c4c640040b7e2bcbc9b9dd439ed160a82d0635deb4ad4f65d7813cd2b37ce"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless_frontend-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd4110e882379ef01e6b1299736831aec1e05067e6f8281cd7dd766a46a690a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless_frontend-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b49cf03cfbdf5d9a9d624409870f10e29fe6641ef2b07ee9f6fad6bfe33b9a21"
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
