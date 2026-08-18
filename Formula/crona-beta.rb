require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.7/crona-bundle-1.9.0-beta.7-darwin-arm64.zip"
      sha256 "762db1a98e15806f96cda4097ea80e44de6835b98f5c357b1a27a6e0a6171a7c"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.7/crona-bundle-1.9.0-beta.7-darwin-amd64.zip"
      sha256 "d9832c88a26d61415e7224af0669b1119fec2e52a8c05e23ff3e44249fa4cdc1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.7/crona-bundle-1.9.0-beta.7-linux-arm64.zip"
      sha256 "fdd6e2229094da31c277c99dd1f9765309ebdac447c757e25b4da35d4043cbf0"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.7/crona-bundle-1.9.0-beta.7-linux-amd64.zip"
      sha256 "3bcb82b3a075027b72785e98f332d1c09eeee14933e8f33d00a235b6aee4a7f9"
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
