require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.2/crona-bundle-1.9.0-beta.2-darwin-arm64.zip"
      sha256 "28451f4f24b33bcd832fea56a49d2de0042092d436dca1378de61dd4fbf979e0"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.2/crona-bundle-1.9.0-beta.2-darwin-amd64.zip"
      sha256 "cc5407ab23ee8fb188612d9f3e4706320cac6d123705c6a2449d13585631c292"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.2/crona-bundle-1.9.0-beta.2-linux-arm64.zip"
      sha256 "90f95c3dc6118a7649bc446fa45ce7c05e654ca05a32e1a558974d6891f440dc"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.2/crona-bundle-1.9.0-beta.2-linux-amd64.zip"
      sha256 "3ea85748df6123dee25999713052e11eb13cd237d8907c52bfbee50837bad6b7"
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
