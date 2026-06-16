require "fileutils"

class Crona < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0/crona-bundle-1.6.0-darwin-arm64.zip"
      sha256 "1334e623fcdbbb5632d5714b804e568cdee0a48adc24d3eba7fe63de2d9c5faf"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0/crona-bundle-1.6.0-darwin-amd64.zip"
      sha256 "979628dc01ef64eb002e46e120cec9fd89f70f9723eb3eaa4c1bb3bbd8a75dba"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0/crona-bundle-1.6.0-linux-arm64.zip"
      sha256 "7f62a5ee1cb57de6e552b8f8acac964547813daf82ef252dbc83420a38c1edbe"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0/crona-bundle-1.6.0-linux-amd64.zip"
      sha256 "0f6a1352a0b2e40ffad56d3270285eec0777c35375b2d3687b25ff1d7c510322"
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
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\"\n}\n",
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
