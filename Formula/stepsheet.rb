class Stepsheet < Formula
  desc "Menu bar app for always-on-top checklist overlay for demos"
  homepage "https://github.com/scdozier/stepsheet"
  url "https://github.com/scdozier/stepsheet/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "5f9ed306009527ad657e6d5ae3bdbcfd9407f66a8c7dfdd240dbcb86e864747c"
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
