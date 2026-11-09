require "fileutils"

class CronaBeta < Formula
  desc "Local-first work tracker for developers"
  homepage "https://crona.work"
  version "1.10.0-beta.7"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.7/crona-bundle-1.10.0-beta.7-darwin-arm64.zip"
      sha256 "bdec70657351c5d6d5922c3293e21b049f01aae7f22d7d7a31a25e99f11c467a"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.7/crona-bundle-1.10.0-beta.7-darwin-amd64.zip"
      sha256 "77824b494647633f164d1adba9ab0f01f08ac6cdea295c487fd843311cc1e908"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.7/crona-bundle-1.10.0-beta.7-linux-arm64.zip"
      sha256 "fe0b8cc9287205bf52cd8965e219318561968544833ba6b4799846dae5476734"
    else
      url "https://github.com/crona-app/crona/releases/download/v1.10.0-beta.7/crona-bundle-1.10.0-beta.7-linux-amd64.zip"
      sha256 "20ff9acc05e56b4c66a13144da391c7a22f0d37c2d2c2d57d7fd587503feb4bf"
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
