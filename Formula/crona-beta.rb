require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.9/crona-bundle-1.9.0-beta.9-darwin-arm64.zip"
      sha256 "f210fb06000968b85d4c0e30021cd6a52ad938c1605edf29c4f251be47ae9013"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.9/crona-bundle-1.9.0-beta.9-darwin-amd64.zip"
      sha256 "b580f1f5fc42223b0aeb665f1031330bf583af39b00284da801ab52620f0c84a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.9/crona-bundle-1.9.0-beta.9-linux-arm64.zip"
      sha256 "8a7c1a58c98440545d13355e5db5498817af880f7fe4628a0f375b818031c20a"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.9/crona-bundle-1.9.0-beta.9-linux-amd64.zip"
      sha256 "67a5f5de2e5942d39f56b842d85ae7b8606dce7edc4d5b19cfddb7eb4a2b9f26"
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
