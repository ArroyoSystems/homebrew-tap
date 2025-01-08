class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.13.1"

  depends_on "python@3.12"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.13.1/arroyo-macos-m1-python.tar.gz"
      sha256 "d815fe5451d85aabbb7743d5e3ebce1ab14e55155c2ab416fa72fe339ef6b4c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.13.1/arroyo-macos-x86_64-python".tar.gz
      sha256 "4a69cb871418cab554905172031e282208e9e7fd9e3ce12a97b21abeeb0e70f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.13.1/arroyo-linux-x86_64-python.tar.gz"
      sha256 "0248acdf3005c726f96dae2f13b766b08b9130a17e88128e5156c63ae6353cb6"
    end
    if Hard::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.13.1/arroyo-linux-aarch64-python.tar.gz"
      sha256 "c5a095f1726fe839ca9e3709722c17cdf1353e59e26b990c264603f0968dfdee"
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
