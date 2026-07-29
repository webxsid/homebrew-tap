require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.8.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.8.0/crona-bundle-1.8.0-darwin-arm64.zip"
      sha256 "5e971997641c5e9d5fd651f7e5708b22602b3b9a56374bc8d09af30bf3128cec"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.8.0/crona-bundle-1.8.0-darwin-amd64.zip"
      sha256 "5e2d2cfa79eae224917ad92ecd661a8cda4877697dfc438dc8cd85503ebd5bf5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.8.0/crona-bundle-1.8.0-linux-arm64.zip"
      sha256 "ab7914e2011bde193f9af1b854f27eb1822091a6182354b0b684e1930b9b92b8"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.8.0/crona-bundle-1.8.0-linux-amd64.zip"
      sha256 "cd8f8a66e9c509102ef954ca30d22c5bf9db2ce3256d184c6cb1247f3b87f70c"
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
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\",\n  \"releaseChannel\": \"stable\"\n}\n",
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
