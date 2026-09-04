class Waveless < Formula
  desc "Bring your data model → generate fast, portable and battle-ready APIs 🚀."
  homepage "https://github.com/nv0skar/Waveless"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless-aarch64-apple-darwin.tar.xz"
    sha256 "1f52f39ab751dc781c48d2ef823c3af56707c4bf6badd546fe9fa3a1386ee86a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8b9e93849d58ed6028e6296403e3e1a436a6e5389ea2daa6ac238d22181f2e67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/Waveless/releases/download/0.2.1/waveless-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e45a1e4360aed04959830435d153eabe9293c1eb2c5dbb17f506848e5dea4c71"
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
