class Silo < Formula
  desc "SOL-only Solana wallet manager TUI"
  homepage "https://github.com/265866/silo"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/265866/silo/releases/download/v0.1.8/silo-aarch64-apple-darwin.tar.xz"
      sha256 "dfb82b7984355eba03d7af7a59953b818d4f49fb25e16690334e326b577f637a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/265866/silo/releases/download/v0.1.8/silo-x86_64-apple-darwin.tar.xz"
      sha256 "1551517faf0268de140990da0ee576725feadd4831b266a82d40ee2de87a8c8b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/265866/silo/releases/download/v0.1.8/silo-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "477210a86a53124d766b12fbf23c79bba2a913c5f542e240fc4377f6ca56a164"
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
