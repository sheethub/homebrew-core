class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.46.1/meson-0.46.1.tar.gz"
  sha256 "19497a03e7e5b303d8d11f98789a79aba59b5ad4a81bd00f4d099be0212cee78"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1695d2cffa2207a5c0b99999bacb239822593e50550ec3ed99ca1d5f1ab257b1" => :high_sierra
    sha256 "1695d2cffa2207a5c0b99999bacb239822593e50550ec3ed99ca1d5f1ab257b1" => :sierra
    sha256 "1695d2cffa2207a5c0b99999bacb239822593e50550ec3ed99ca1d5f1ab257b1" => :el_capitan
    sha256 "31dedd2b7ab55d96d0d0da3929240f52e709bf1d4e06e0aa528042307852f58d" => :x86_64_linux
  end

  depends_on "python"
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
