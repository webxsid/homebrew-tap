require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.4/crona-bundle-1.10.0-beta.4-darwin-arm64.zip"
      sha256 "498f2abe4ca1bdaaf6920e18307138c9cb0f4f8313e92454a6be391a94f655b3"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.4/crona-bundle-1.10.0-beta.4-darwin-amd64.zip"
      sha256 "f4050a3320ea705f9f8f5e3bc8bfbf0f53f2edc2142c783dec8b3f7e1371dfe7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.4/crona-bundle-1.10.0-beta.4-linux-arm64.zip"
      sha256 "7c91a19d5dcf3a036ebed12f4b4cb7e0bfb6c1fcda08a14f4c071399e1a0077d"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.4/crona-bundle-1.10.0-beta.4-linux-amd64.zip"
      sha256 "eb01cebfcb5143ef782b9ad25291bef407fb3221f5ea76d26c4e81efebab5516"
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
