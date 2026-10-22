class Waveless < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/waveless"
  version "0.4.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/waveless/releases/download/0.4.2/waveless-aarch64-apple-darwin.tar.xz"
    sha256 "69904436f48ac5a97f8c0dc8bb864a2ccdff0523b6d8b8df866b4a9aa12ce803"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/waveless/releases/download/0.4.2/waveless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2f0fb7c61522d431c8a6f7fa4626f554e041c31ef62f4a84f095f2513224488"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/waveless/releases/download/0.4.2/waveless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9085c488596dfa16fda4e7455fbb10e38c90714b12c40a5cf1ce8fc92c0f89dd"
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
