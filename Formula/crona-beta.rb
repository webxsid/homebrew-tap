require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.3/crona-bundle-1.10.0-beta.3-darwin-arm64.zip"
      sha256 "21d0c432cb5312b063680cd86ecd58531e357367b53c53b38b527db9707c4a04"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.3/crona-bundle-1.10.0-beta.3-darwin-amd64.zip"
      sha256 "b4ab6a959709558d4e482e851ef46c33c0fc0cd380d4487782aeb80962b75dee"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.3/crona-bundle-1.10.0-beta.3-linux-arm64.zip"
      sha256 "17b83596f1b108c11202bea76525bfe61e7448036a74a1d4358762c471bbe417"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.3/crona-bundle-1.10.0-beta.3-linux-amd64.zip"
      sha256 "8a7cbc875c3e0e5a2ce6e87b99860962319f5d1996f7570323534157cd7e25ad"
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
