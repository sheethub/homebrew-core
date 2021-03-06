class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/0.6.0.tar.gz"
  sha256 "ab20d1c9c20f3b25d0be62fdb8aba74c0e2f046e647327d85a0ecc84d40f8a94"

  bottle do
    sha256 "d0e5347b24fbd59bf0ca8119c9a4c9a5790e552bf076e8d9a0f986877b6da1f0" => :high_sierra
    sha256 "c387de211ad08b4e5f1b071683bda99886a810327cdcf141d8868fcb68ea95e8" => :sierra
    sha256 "e30beb8e8f46f2a4f53b6c6e74252ed88b9b141594afb978384efbab00ea12f8" => :el_capitan
    sha256 "b807edd25814919fc9caafb676d666f510e973ef1d69830fb15ae2915587ee34" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
