class WavelessExecutor < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/Waveless"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/Waveless/releases/download/0.2.0/waveless_executor-aarch64-apple-darwin.tar.xz"
    sha256 "50e3141be25d8ba12db76145989b111db7b7be3ee3714c8786054f2e6d50fed9"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.0/waveless_executor-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f46832ef04a9a70353bcee7fdca91187b555c198862549baa3fe07e8a6aa08f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.0/waveless_executor-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d5edbc8a90764d5726be52d6e7037ae2d7ef8e364614242637a92ce570b22664"
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
      bin.install "waveless_executor"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "waveless_executor"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "waveless_executor"
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
