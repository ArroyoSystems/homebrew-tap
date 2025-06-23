class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.14.1"

  depends_on "python@3.12"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.14.1/arroyo-macos-m1-python.tar.gz"
      sha256 "ba53c45bf0d705e14d4b9c675d0abb2b2b730573a835fa8697facc4fd1dd8b40"
      if Hardware::CPU.intel?
        url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.14.1/arroyo-macos-x86_64-python".tar.gz
        sha256 "1eb92e8e10a421f313c7d41560659b8212227359fa47482b5f43531f5dfedae7"
      end
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.14.1/arroyo-linux-x86_64-python.tar.gz"
      sha256 "27abf850e8dc9a3e9a2a34b06bb693edb697a66a43415c9852f1b91dbae27540"
    end
    if Hard::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.14.1/arroyo-linux-aarch64-python.tar.gz"
      sha256 "780fe4e65518f082c6d10a162ee4d62073c225c2005b19539b84f42ab2aeb21b"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}}

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
      bin.install "arroyo"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "arroyo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "arroyo"
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
