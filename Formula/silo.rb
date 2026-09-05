class Silo < Formula
  desc "SOL-only Solana wallet manager TUI"
  homepage "https://github.com/265866/silo"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/265866/silo/releases/download/v0.1.11/silo-aarch64-apple-darwin.tar.xz"
      sha256 "486709f448a805db62500e1a447010dc78535ed677e50478cf3c82ee72177775"
    end
    if Hardware::CPU.intel?
      url "https://github.com/265866/silo/releases/download/v0.1.11/silo-x86_64-apple-darwin.tar.xz"
      sha256 "d14fcbc973f5a0f2002b40ec6445ca06f852b58558d55aaa8fd24ed8e250396e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/265866/silo/releases/download/v0.1.11/silo-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5a3756ea47602d0cac1e31087de75e4b70930b039a608abdbb7bfcaf4277e2a3"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "silo"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "silo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "silo"
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
