require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.5"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.5/crona-bundle-1.10.0-beta.5-darwin-arm64.zip"
      sha256 "c97482353e9a0f5021e017b266350ab676c173ef7a949ecb9bd40ee9ad627e94"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.5/crona-bundle-1.10.0-beta.5-darwin-amd64.zip"
      sha256 "8633be2442c1f56732231c0fbb4ffe69c69e112c9e29eb86c10da3bab0cad765"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.5/crona-bundle-1.10.0-beta.5-linux-arm64.zip"
      sha256 "0b2631a9976e68501a41d0d97401b91571459d1906637452885c91ef8f6dfa98"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.5/crona-bundle-1.10.0-beta.5-linux-amd64.zip"
      sha256 "42c753aa31bcc8e3ea91eaa6406999551a6af74bb9f63f45285eed32ccba476e"
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
