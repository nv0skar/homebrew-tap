class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/nv0skar/SilenceEvolution"
  version "0.0.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.8/silence-aarch64-apple-darwin.tar.xz"
    sha256 "0ea134f06cf333a7e74d0ad029e0f655b2ae024ed29833b68d9f8b5912d41deb"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.8/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c162b96664d1e7026967ce2859f00782f09d04ba803938a906177a9150ada9cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.8/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "622cd8027c5a5d83c7c1e3e317fdf7a831f3185918e033452b29fa109407af27"
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
