class Stepsheet < Formula
  desc "Menu bar app for always-on-top checklist overlay for demos"
  homepage "https://github.com/scdozier/stepsheet"
  url "https://github.com/scdozier/stepsheet/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5742a2ee817ab9f7cd5392bfa316f5acbe4a0994304877aee2ed9f9cc9988d9d"
  license "MIT"

  depends_on "node@22"

  # Skip relinking - Electron apps are self-contained
  skip_clean :all

  def install
    system "npm", "ci"
    system "npm", "run", "build"
    # Build unpacked app (no DMG) - works in sandboxed environment
    system "npx", "electron-builder", "--mac", "--dir"
    
    # Find and install the .app bundle
    app = Dir["release/mac*/*.app"].first
    if app
      prefix.install app
      # Also link to bin for easy CLI access
      bin.install_symlink prefix/"StepSheet.app/Contents/MacOS/StepSheet" => "stepsheet"
    end
  end

  def caveats
    <<~EOS
      StepSheet has been installed to:
        #{prefix}/StepSheet.app

      To add to your Applications folder, run:
        ln -sf #{opt_prefix}/StepSheet.app /Applications/StepSheet.app

      To launch:
        open #{opt_prefix}/StepSheet.app

      Or simply run:
        stepsheet
    EOS
  end

  test do
    assert_predicate prefix/"StepSheet.app", :exist?
  end
end
