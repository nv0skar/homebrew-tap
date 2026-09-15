class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/nv0skar/SilenceEvolution"
  version "0.0.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.7/silence-aarch64-apple-darwin.tar.xz"
    sha256 "00cb550d496d131df7991ca40a7a09604b8cbf4aabafe71605a2b849ab034055"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.7/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7bdaa73257661af77cd08daf4812d9b92a2d784978a5c1f2eb12ba9abed921fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.7/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e8eedccede8c9abed7a89cf5e560dc567e4447141e5112f9aaad54722a37dcb6"
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
