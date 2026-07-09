require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-darwin-arm64.zip"
      sha256 "476f8f241efdbe73b8b648c43cc14dd82948e6a7965003f90b871ab7ac01ff35"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-darwin-amd64.zip"
      sha256 "bfe71710c90f02219bf28f1dcee788afe8cbfa3d8a78fadc3c09f51e6a366e5a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-linux-arm64.zip"
      sha256 "19412dcd9a73daa1c17944e63e4cdcfc8c3fae7ac9d0487b640780cc3ac8b228"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-linux-amd64.zip"
      sha256 "f329df4e3b4e3fd577e0cf7874766fc8f39469f27de79adede284fb40a16bc3b"
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
    write_install_source("brew", "crona-beta")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
