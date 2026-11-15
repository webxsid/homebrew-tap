require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.8"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.8/crona-bundle-1.10.0-beta.8-darwin-arm64.zip"
      sha256 "f014061c31fd8c53dd98eee267a6f964f99825f2d17eaf464c7b1e39ff9e16d9"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.8/crona-bundle-1.10.0-beta.8-darwin-amd64.zip"
      sha256 "e76712a0530f27e995a61751cf74589b66442bc1b03e3856c7f49b696db1fb0d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.8/crona-bundle-1.10.0-beta.8-linux-arm64.zip"
      sha256 "a25492cb363330ed38d69c18870028e47da7c3746c92c67f5816d07e50d2c6eb"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.8/crona-bundle-1.10.0-beta.8-linux-amd64.zip"
      sha256 "70344a2c4f6bb47d622fac02325897bc4f2162eda2686f62382145b46ff0573f"
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
