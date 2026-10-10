require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.1/crona-bundle-1.10.0-beta.1-darwin-arm64.zip"
      sha256 "585efdce1dc983ecea3b7d5e36f4b4f94c59b8c6e4631f5228aa8b85fe78f2bc"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.1/crona-bundle-1.10.0-beta.1-darwin-amd64.zip"
      sha256 "74ad81a2bb304b59620802d346ceec2084a9222d43061d449d554dc26ec58b06"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.1/crona-bundle-1.10.0-beta.1-linux-arm64.zip"
      sha256 "712743101bcf77aca6f8af878909b59fed62aca299b797ff7438dfd20d1d4062"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.10.0-beta.1/crona-bundle-1.10.0-beta.1-linux-amd64.zip"
      sha256 "c106f7dd39e82221710d38535215d75f1f8a46d58407199163d2e3a68ec72f0c"
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
