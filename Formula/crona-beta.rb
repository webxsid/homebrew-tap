require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.9.0-beta.3"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.3/crona-bundle-1.9.0-beta.3-darwin-arm64.zip"
      sha256 "f02393b42e32c0663165f9f347262b3855b11da8c07b1b0084db5f5d64720247"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.3/crona-bundle-1.9.0-beta.3-darwin-amd64.zip"
      sha256 "54acf721ed537d462d8590b1c5d6632009d8b847b8832c6d8ded8d7e78b65c36"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.3/crona-bundle-1.9.0-beta.3-linux-arm64.zip"
      sha256 "2e51d6abbf2e2655312555457d1c1f230533a2db08c3dee50c392eede97bd640"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.9.0-beta.3/crona-bundle-1.9.0-beta.3-linux-amd64.zip"
      sha256 "50830326be7cdbd93385839cf115622e7ddac604a1544a472e86707f8900a1f8"
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
