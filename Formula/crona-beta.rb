require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.5/crona-bundle-1.9.0-beta.5-darwin-arm64.zip"
      sha256 "ac94d946ad0b467207fc438e91181d2142e60c53ce6ed7178baf518e02f33028"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.5/crona-bundle-1.9.0-beta.5-darwin-amd64.zip"
      sha256 "296ebda2e4df3239cf5fb8f3835c137624e6ec594951744ea0ad2cacfca8b74f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.5/crona-bundle-1.9.0-beta.5-linux-arm64.zip"
      sha256 "502cf0a177b03ece16b23300f671bccc0edb0aeb030a07fe6f7b9e99123d33a5"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.5/crona-bundle-1.9.0-beta.5-linux-amd64.zip"
      sha256 "991f0f82b9210d02308a81dc0882879df00390162a4bf23af597260f5f53e5cd"
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
