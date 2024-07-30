class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.11.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.2/arroyo-macos-m1.tar.gz"
      sha256 "03c32202821b9947545735379d614da304c56ced7494a699b5ac7e2cc39f9781"
    end
    if Hardware::CPU.intel?
      odie "This formula does not support Intel Macs. You can run Arroyo using the docker image or build a binary using the developer instructions: https://doc.arroyo.dev/developing/dev-setup."
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.2/arroyo-linux-x86_64.tar.gz"
      sha256 "89055bfb36c85102e19fef836b75dfd8552b55240db66c35556d2ccecf640d88"
    end
    if Hard::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.2/arroyo-linux-arm64.tar.gz"
      sha256 "0d01ec35e8b9b3046bea8d4081ac93a2fd3ed6ac77ce4bec1eebb17e2afb6133"
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
