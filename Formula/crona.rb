require "fileutils"

class Crona < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.1/crona-bundle-1.6.1-darwin-arm64.zip"
      sha256 "eb482a7a256a5db263f87046c3bb63563ed11018d6a42c43397cf7667d1a1157"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.1/crona-bundle-1.6.1-darwin-amd64.zip"
      sha256 "4a1d46b02f115bf474ad4c3c203de46379fc2c8cc42a8f69b9bf4c8a00269aac"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.1/crona-bundle-1.6.1-linux-arm64.zip"
      sha256 "595a0e813670431e47d0cc1efe7857b73d3fc4f8fd4fdc4dbbdefb3e6171a215"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.1/crona-bundle-1.6.1-linux-amd64.zip"
      sha256 "78ae0778dc6ad5a58d101a89c4d37869ff26e5f66f41c16ced49f16f5cf17cb4"
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
    write_install_source("brew", "crona")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
