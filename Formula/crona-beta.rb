require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.1/crona-bundle-1.6.0-beta.1-darwin-arm64.zip"
      sha256 "cd6cce23c1acdcca527c97718d939f16948fb231f7e45e4dcc31ccb4d5619237"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.1/crona-bundle-1.6.0-beta.1-darwin-amd64.zip"
      sha256 "16c424cab3be125466c95ec3cb87c0d2e40d2047bfac5415932b48fc5e2528b8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.1/crona-bundle-1.6.0-beta.1-linux-arm64.zip"
      sha256 "e1457c8f1853b35eced5cb4d095814db152b7b84ef2e2bea4502bd10deeb9429"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.1/crona-bundle-1.6.0-beta.1-linux-amd64.zip"
      sha256 "42a4aa92d4f7db5327064392c7897d9c8caac87c88fa9da17478432856995a92"
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
        bin.install "crona-kernel"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      end
    elsif OS.linux?
      if Hardware::CPU.arm?
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      else
        bin.install "crona"
        bin.install "crona-kernel"
        bin.install "crona-tui"
      end
    end
  end

  def post_install
    write_install_source("brew", "crona-beta")
  end
  test do
    system "#{bin}/crona", "--version"
  end
end
