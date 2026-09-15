class Waveless < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/waveless"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/waveless/releases/download/0.3.0/waveless-aarch64-apple-darwin.tar.xz"
    sha256 "43a2226f0a9ba0fabe38c70d3008234359d49b0b866dbc28a86c651b64e9eef5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/waveless/releases/download/0.3.0/waveless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9701b2463c4951a341d268cd8be816bca4dcc40d45463467f861bd5057def850"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/waveless/releases/download/0.3.0/waveless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "895249d6f01601c8d027c19ec104b5d9e064c11465626e8d5d78a8afda586ef4"
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
