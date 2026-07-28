require "fileutils"

class Crona < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.7.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.7.1/crona-bundle-1.7.1-darwin-arm64.zip"
      sha256 "97f697588a1a5249bf836b89b60ea6e6aa25a82f01fe098089e81ce9ae4cedfd"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.7.1/crona-bundle-1.7.1-darwin-amd64.zip"
      sha256 "427f58bd9f4efd1e454450b5c776eac51645ed9dec18bc2cdf0cdfb08cb28428"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.7.1/crona-bundle-1.7.1-linux-arm64.zip"
      sha256 "ffdcca7f16c7c86f3287bd4e1bd2dccf148625393593f04929a927f1b73e41a1"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.7.1/crona-bundle-1.7.1-linux-amd64.zip"
      sha256 "03bd5c0be953a7d858e1935436b483d4aaa96a7f982416ad815bc507fecbce0d"
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
    write_install_source("brew", "crona")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
