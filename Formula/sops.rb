class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/3.0.5.tar.gz"
  sha256 "4a47f33e5e4e5b7bd252ec2121a07e4b1b0081f3570d51477e36a85786dd3378"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77f7030a714b5be71d848307745105211419dd74ff456da9d06ae25be261d669" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/go.mozilla.org").mkpath
    ln_s buildpath, "src/go.mozilla.org/sops"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version 2>&1")
  end
end
