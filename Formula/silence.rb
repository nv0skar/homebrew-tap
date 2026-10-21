class Silence < Formula
  desc "An educational framework for deploying APIs (based on a MySQL schema) and web applications."
  homepage "https://github.com/nv0skar/SilenceEvolution"
  version "0.0.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.10/silence-aarch64-apple-darwin.tar.xz"
    sha256 "e25bef8dbb3f4254d62df8529de07853a0957161f060dbb3748d51306780f099"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.10/silence-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2ff1e9cad55792ae64fbc4fd2fea92555b6a9b7e9ac1d515f9fc8ff0ab548b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/nv0skar/SilenceEvolution/releases/download/0.0.10/silence-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7cb6a1a6dea949602a788d728b2db04d98fe16919f2ed36dce6da6c7a875a8d4"
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
