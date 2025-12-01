class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.15.0"

  depends_on "python@3.12"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.15.0/arroyo-macos-m1-python.tar.gz"
      sha256 "3f37af584a1d8ebd950d9188ec9a8562c898d66f81f9934b26ae207482e5b99e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.15.0/arroyo-macos-x86_64-python".tar.gz
      sha256 "4b7549b18c3fb08df0fdde094eefd5f4969dd6716de6f99eb01c38a2f4a9074f"
    end
    if OS.linux?
      if Hardware::CPU.intel?
        url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.15.0/arroyo-linux-x86_64-python.tar.gz"
        sha256 "a29ca5e67cad4e579b6c0e548d4f9b4d0bd21d9add5ac14eb6adf78a92776ac7"
      end
      if Hard::CPU.arm?
        url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.15.0/arroyo-linux-aarch64-python.tar.gz"
        sha256 "101ba1330ddd35e7f11419dd578911799f32a75bf3fe6984b5c03e4264678ab5"
      end
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
