require "fileutils"

class CronaBeta < Formula
  desc "local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.0-beta.4"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-darwin-arm64.zip"
      sha256 "d1b295efc98ddc245ad4f218f9527869ce287b0a8335ba44ac85bee614eb7d2e"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-darwin-amd64.zip"
      sha256 "e95291bd20effbd87428b2a4e7525e01581563229f8126b5ea08ab9e6ba4df1f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-linux-arm64.zip"
      sha256 "e724ae04ef3c103f861cceb88c7b4543f79febcaf4c5cb3166f971d8509fff36"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.0-beta.4/crona-bundle-1.6.0-beta.4-linux-amd64.zip"
      sha256 "78e4951e81f984f638aef6ca09737dad8b6c07c7df428b6d45cacd338316c1d7"
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
