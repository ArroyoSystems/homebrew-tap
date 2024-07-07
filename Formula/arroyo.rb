class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.0/arroyo-macos-m1.tar.gz"
      sha256 "56e4e0202ee3f6f38fd29bf7293baa370e584881c0b1d7ddc8a1b0a60e29caf3"
    end
    if Hardware::CPU.intel?
      odie "This formula does not support Intel Macs. You can run Arroyo using the docker image or build a binary using the developer instructions: https://doc.arroyo.dev/developing/dev-setup."
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.0/arroyo-linux-x86_64.tar.gz"
      sha256 "4e7509e0fc16637dd1f901a80e15098608871fc20580b03f09da884ae863d44f"
    end
    if Hard::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.0/arroyo-linux-arm64.tar.gz"
      sha256 "5f51c9c49df9eb0000af06a550bbc228414e6e13f7b68da6b1f3d23da45487b1"
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
