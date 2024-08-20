class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.11.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.3/arroyo-macos-m1.tar.gz"
      sha256 "4d5514d278c2ed76e2dc7076f65d52f0c66330824c54c00fb765a8938007c2f8"
    end
    if Hardware::CPU.intel?
      odie "This formula does not support Intel Macs. You can run Arroyo using the docker image or build a binary using the developer instructions: https://doc.arroyo.dev/developing/dev-setup."
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.3/arroyo-linux-x86_64.tar.gz"
      sha256 "6d1874410a992b21162c2bd84fac7c6fd0a534b572f1e82e72b83e8a3fa595d1"
    end
    if Hard::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.11.3/arroyo-linux-arm64.tar.gz"
      sha256 "5d38ce6ef8aae653d74e5bff8c8598e3d8393474d19972419249b0396a6f588f"
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
