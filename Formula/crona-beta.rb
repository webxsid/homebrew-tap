require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.4/crona-bundle-1.9.0-beta.4-darwin-arm64.zip"
      sha256 "435c9d94222f0a43c40fd2050f6dd5703520e0ef5d8d1fb221d3882ebdb6ccb3"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.4/crona-bundle-1.9.0-beta.4-darwin-amd64.zip"
      sha256 "e3538009b2ba2444d8c560c7ddb1d6b13890f4e3e26e3787a1e5852a987ad3da"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.4/crona-bundle-1.9.0-beta.4-linux-arm64.zip"
      sha256 "de04294c520e6ce2fd4a8834acdc61e7164bf477d7eedb4c3bf49bd95337858c"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.4/crona-bundle-1.9.0-beta.4-linux-amd64.zip"
      sha256 "2117f83280e3a491830d3ebcda13875197ef6170e9486ca075ac1b76e964a9f9"
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
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\",\n  \"releaseChannel\": \"beta\"\n}\n",
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
