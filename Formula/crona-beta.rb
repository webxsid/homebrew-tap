require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.6"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.6/crona-bundle-1.10.0-beta.6-darwin-arm64.zip"
      sha256 "dee69ac4bcba62b50f28cd57d7bdeb2dde78b17bacbed4ea57650bdd6da5d4d0"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.6/crona-bundle-1.10.0-beta.6-darwin-amd64.zip"
      sha256 "a107548925640050c55d2abf44abf1cf2fb274a3f08aafe4e210bdbbddf87eda"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.6/crona-bundle-1.10.0-beta.6-linux-arm64.zip"
      sha256 "37f45af5c2499d0007c7e13d0f3dbb648c7963dfe4b9d10cc099e17e0044940b"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.6/crona-bundle-1.10.0-beta.6-linux-amd64.zip"
      sha256 "72762f8bd745d9c9dc52841ee35cca6345f0a6058ec57108ae1a4c8d4ade2159"
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
