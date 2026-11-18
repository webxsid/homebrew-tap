require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.9/crona-bundle-1.10.0-beta.9-darwin-arm64.zip"
      sha256 "b019e668991fd09d3f5f3d4154a9442e3386b6fa7d0f0bf7ce558d68de5be7fd"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.9/crona-bundle-1.10.0-beta.9-darwin-amd64.zip"
      sha256 "cbe764648f79d69a58ca15621efe9322878f0cd7389d53a59743862815b5de34"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.9/crona-bundle-1.10.0-beta.9-linux-arm64.zip"
      sha256 "c5a17f0f9e85dccfed116717febf428f94bde226a260bf660e5526595d1bf6d1"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.9/crona-bundle-1.10.0-beta.9-linux-amd64.zip"
      sha256 "3d843e7e51704a898e1d5ef1d23fd2e4dc5b9cb9297163b4cc0840a39beb0730"
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
