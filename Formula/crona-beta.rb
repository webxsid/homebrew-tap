require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.6/crona-bundle-1.9.0-beta.6-darwin-arm64.zip"
      sha256 "6e66121a14ed981745c6f92d145f6fe7d4fcc0b1b2778395a117f95453bb1463"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.6/crona-bundle-1.9.0-beta.6-darwin-amd64.zip"
      sha256 "07054a3f8e36e6ea625e85bb354e9d9c6d9a29a683ec1d25886c38365935ae04"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.6/crona-bundle-1.9.0-beta.6-linux-arm64.zip"
      sha256 "022f607b5447c70dafb3f944c4a684b02d681f4fb776eae8f238090c20672758"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.6/crona-bundle-1.9.0-beta.6-linux-amd64.zip"
      sha256 "4caf4347ebe8568b1c24f12670bf7cd3cce1f9c36ffcca3d026592edbcc6e04a"
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
