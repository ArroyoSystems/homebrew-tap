class Arroyo < Formula
  desc "The Arroyo stream processing engine"
  homepage "https://www.arroyo.dev"
  version "0.12.0"

  depends_on "python@3.12"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.12.0/arroyo-macos-m1-python.tar.gz"
      sha256 "4cc7eea2327e373d5cac3f50f80e272807fbaca6403228d8d5f4e4131dde284f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.12.0/arroyo-macos-x86_64-python".tar.gz
      sha256 "ab4d2c5029fc6ac563308fe396b76812b24226618aa04bdc03f0862aaa3c4110"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.12.0/arroyo-linux-x86_64-python.tar.gz"
      sha256 "5a21624e79ced7a0734f37168b18e257589c07ac6805534eef2495a666445d80"
    end
    if Hard::CPU.arm?
      url "https://github.com/ArroyoSystems/arroyo/releases/download/v0.12.0/arroyo-linux-aarch64-python.tar.gz"
      sha256 "732c65b6559eb09574746696cd9fd2d9619b2270dd21074a85e6845e9fc0caca"
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
