require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-darwin-arm64.zip"
      sha256 "ea1154b8888eaef552f1329ed8fd1a4725a368d319f26a892177bdae32bfa247"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-darwin-amd64.zip"
      sha256 "ef9e56dc11ae617ba6cb8a0242fa6d4ad43624673c06b549190801328a433d49"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-linux-arm64.zip"
      sha256 "ec9f7789cbac7508a6f1cbb33710b98ea0ec76b2bbec44231832cf57ca66fe2d"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-linux-amd64.zip"
      sha256 "db77ac5a5a454a177d4a862e447b0a6a685425b52061b3127a5b402558d71378"
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
      "{\n  \"installSource\": \"" + source + "\",\n  \"brewFormula\": \"" + formula_name + "\"\n}\n",
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
