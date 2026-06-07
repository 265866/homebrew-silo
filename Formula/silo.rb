class Silo < Formula
  desc "SOL-only Solana wallet manager TUI"
  homepage "https://github.com/265866/silo"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/265866/silo/releases/download/v0.1.2/silo-aarch64-apple-darwin.tar.xz"
      sha256 "afc037770b283ce675dbcbd2f6f06bacbb9cc871176d5d7045fd98783b27bf34"
    end
    if Hardware::CPU.intel?
      url "https://github.com/265866/silo/releases/download/v0.1.2/silo-x86_64-apple-darwin.tar.xz"
      sha256 "0390d09bbae3c843b47ae16ac16fc5260c6aefe58ba6299b171ab22296f74e8f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/265866/silo/releases/download/v0.1.2/silo-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0779b3f82f62d316abd2c694b5102866316fd33db73de11010133624902e9841"
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
