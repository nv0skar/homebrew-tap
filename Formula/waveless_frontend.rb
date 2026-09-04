class WavelessFrontend < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/Waveless"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless_frontend-aarch64-apple-darwin.tar.xz"
    sha256 "6c178b850537f2db89766e4070d9a4f279d9e47d6be14fba763566e528ede389"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless_frontend-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7cadd3884191dd5b969d71095d8f739b96251dd44214fe6e323114da40730d47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless_frontend-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5c81954ae00b8b0cf892d91be44b4abaf84dd7cc15cdcf1bb741c59546b58e33"
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
      bin.install "waveless_frontend"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "waveless_frontend"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "waveless_frontend"
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
