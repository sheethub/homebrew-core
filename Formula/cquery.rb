class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git", :tag => "v20180302",
                                                      :revision => "f3e9e756e182b122bef8826a77047f6ccf5529b6"
  head "https://github.com/cquery-project/cquery.git"
  revision 1 unless OS.mac?

  unless OS.mac?
    depends_on "python@2" => :build
    depends_on "llvm"

    needs :cxx11
  end

  bottle do
    cellar :any
    sha256 "0f567e5d88299f28d489b666fca2cf320b91062fc053e0c2a8a1ad9e1bc76598" => :high_sierra
    sha256 "06bb25b1c91c76c894d3aebdc18b76591ab2ff1c5f8190c376b69e60d6c22787" => :sierra
    sha256 "9692d28682c009a9bec583ff20aa16ce5c790975375755a5a48a28ec3e3953c4" => :el_capitan
    sha256 "af561ae561200570f79e22725a1d13aee04827d40e036b3750babe36164ce5ef" => :x86_64_linux
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["JOBS"] = "8" if ENV["CIRCLECI"]

    system "./waf", "configure", "--prefix=#{prefix}", ("--llvm-config=#{Formula["llvm"].opt_bin/"llvm-config"}" unless OS.mac?)
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
