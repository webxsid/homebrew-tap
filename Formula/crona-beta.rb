require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.6.2"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-darwin-arm64.zip"
      sha256 "83ee248fe685456e1797a223401af91a7e01b0d435ac62aba90a362c0ea2eb86"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-darwin-amd64.zip"
      sha256 "5d1e38853cda0bed16ad062e647e0a77e8d9a8c59d17001d72cf44a0b67f965c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-linux-arm64.zip"
      sha256 "4064c65b81af88445be7f31893ea4b5f38a74466c0e998fc7d2559d997b6e538"
    else
      url "https://github.com/webxsid/crona/releases/download/v1.6.2/crona-bundle-1.6.2-linux-amd64.zip"
      sha256 "3242c26c2eb330e347baa8ecdf0538846def02b6d84f5288b28f4e455921d26d"
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
    write_install_source("brew", "crona-beta")
  end
  test do
    system "#{bin}/crona", "--version"
    system "#{bin}/crona-daemon", "--version"
  end
end
