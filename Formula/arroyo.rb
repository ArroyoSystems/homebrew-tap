class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.16.0"

  depends_on "python@3.12"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.16.0/arroyo-macos-m1-python.tar.gz"
      sha256 "02dc911520d16add71b7d487607d2bbe2bfe7d3350bbb989156489cf6da7e1b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.16.0/arroyo-macos-x86_64-python.tar.gz"
      sha256 "d24212eb539bb9b49b8af0aea612f88bc2dcc3e87b9ecbed77bbef5e1d37fbfd"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.16.0/arroyo-linux-x86_64-python.tar.gz"
      sha256 "e47902934aaf67f41fc337c2abab7abb1eab19cef0e16a6a9ae1dacc344a8f68"
    end
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.16.0/arroyo-linux-aarch64-python.tar.gz"
      sha256 "2b2060b4f1068ba8c79b01a2423e71173fd8791ee0f6aa21a88eeb9688911b40"
    end
  end

  BINARY_ALIASES = {"aarch64-apple-darwin": {}, "x86_64-apple-darwin": {}, "x86_64-pc-windows-gnu": {}, "x86_64-unknown-linux-gnu": {}, "aarch64-unknown-linux-gnu": {}}

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
    bin.install "arroyo"

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
