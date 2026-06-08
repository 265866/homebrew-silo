class Silo < Formula
  desc "SOL-only Solana wallet manager TUI"
  homepage "https://github.com/265866/silo"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/265866/silo/releases/download/v0.1.4/silo-aarch64-apple-darwin.tar.xz"
      sha256 "2eb56fc048c98e4a3fbc0971c62442ed28189985bdbdea77fde0dc1313381a63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/265866/silo/releases/download/v0.1.4/silo-x86_64-apple-darwin.tar.xz"
      sha256 "607d0aaa2cc102873585014c93e4d26ee2dc8900859bdf7f038ff3e07097ea07"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/265866/silo/releases/download/v0.1.4/silo-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1e946034c64c0824b5bd630586ed13e41d1b216e50ed2a8f274881c7404e5e43"
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "silo" if OS.mac? && Hardware::CPU.arm?
    bin.install "silo" if OS.mac? && Hardware::CPU.intel?
    bin.install "silo" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
