class Silo < Formula
  desc "SOL-only Solana wallet manager TUI"
  homepage "https://github.com/265866/silo"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/265866/silo/releases/download/v0.1.3/silo-aarch64-apple-darwin.tar.xz"
      sha256 "1909bd798c7b6ba14de88129cf1f4a669b7892714d9d6b0a26167e8be1a8501e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/265866/silo/releases/download/v0.1.3/silo-x86_64-apple-darwin.tar.xz"
      sha256 "f37cdc523228400a06f0764fe224fa8075fde354638bad1abc5e87a2f7a4a710"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/265866/silo/releases/download/v0.1.3/silo-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "5e0802c3715369d7a61ba3777ff32d370d8579abd5ed89908e3db1b4db99aff1"
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
