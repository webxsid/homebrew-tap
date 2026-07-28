require "fileutils"

class Crona < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.7.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.7.2/crona-bundle-1.7.2-darwin-arm64.zip"
      sha256 "5aa5be0b998f7e854ce5e100ba4f6b2ae6850faacab06152f4adf5d4b410e3f1"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.7.2/crona-bundle-1.7.2-darwin-amd64.zip"
      sha256 "40c1d36b89b0cbd6856991f5804657781c67b3c6bb436bbd7e2d02a0f72ccdd7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.7.2/crona-bundle-1.7.2-linux-arm64.zip"
      sha256 "f589bb6c07064b44247923ccb8b2ec58f0394122f8b2e9adece121687cdd4580"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.7.2/crona-bundle-1.7.2-linux-amd64.zip"
      sha256 "a15c51c658a089da709cbbe571cf125f49535c9b1946833274238e0fb0701570"
    end
  end

  def crona_runtime_home
    if ENV["CRONA_HOME"] && !ENV["CRONA_HOME"].strip.empty?
      return ENV["CRONA_HOME"].strip
    end
    home = Dir.home
    if OS.mac?
      File.join(home, "Library", "Application Support", "Crona")
    else
      data_home = ENV["XDG_DATA_HOME"]
      if data_home && !data_home.strip.empty?
        File.join(data_home.strip, "crona")
      else
        File.join(home, ".local", "share", "crona")
      end
    end
  end

  def write_install_source(source, formula_name)
    runtime_home = crona_runtime_home
    FileUtils.mkdir_p(runtime_home)
    File.write(
      File.join(runtime_home, "install.json"),
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\",\n  \"releaseChannel\": \"stable\"\n}\n",
    )
  end

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-daemon"
        bin.install "crona-tui"
      end
    end
  end

  def post_install
    write_install_source("brew", "crona")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
