require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-darwin-arm64.zip"
      sha256 "58087ef0dc7bb71d9bf8c8cfa2ff47e9e6cbbc3abab77791086fe685d5290101"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-darwin-amd64.zip"
      sha256 "055d4419c5a0195e1b4ac8ed511e6b003cb0e7af8ad91b646e346fe89a1fdbd1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-linux-arm64.zip"
      sha256 "5df3715ee8d0bec1aa07dd56d1ee1aa9c322dd8e30052da3d7525dffe46270a8"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-linux-amd64.zip"
      sha256 "bde9aa385537c6850d4010fb5d629a476d1f8a76b43b3e84187219636657df5b"
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
