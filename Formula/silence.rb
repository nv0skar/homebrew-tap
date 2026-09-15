class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/nv0skar/SilenceEvolution"
  version "0.0.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/SilenceEvolution/releases/download/v0.0.6/silence-aarch64-apple-darwin.tar.xz"
    sha256 "8fcaaae66ad7cbcd585f9d7680cba626ede60613f6d0048c7c54217719ecc62f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/v0.0.6/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8e1425b7fab53cccead94f5805bb56e571ef8da38df26067727cfbd012499375"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/v0.0.6/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01ef5485dede7ba0c0709a17a3e74ac57651b6ac3e51bbe96e9e378f1565db07"
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
