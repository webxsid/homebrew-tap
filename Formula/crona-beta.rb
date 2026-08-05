require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.1/crona-bundle-1.9.0-beta.1-darwin-arm64.zip"
      sha256 "c7970c5e3014e0f577ca21066ee9fe3f8280108495207e7bc86695f33f049948"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.1/crona-bundle-1.9.0-beta.1-darwin-amd64.zip"
      sha256 "849fb795a602d7f472ebf2db36003bf59d7c1bffa4a626dc0c16ec07b21d2f6f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.1/crona-bundle-1.9.0-beta.1-linux-arm64.zip"
      sha256 "457afc60a98daf3b870340126c248d8351debe307a0918e9723417430887d23e"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.1/crona-bundle-1.9.0-beta.1-linux-amd64.zip"
      sha256 "7e8ff526bee3f7ef4d3b6cbce60bf59e51e5c4207911ff32387de1502dd5a2ec"
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
