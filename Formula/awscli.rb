class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.15.40.tar.gz"
  sha256 "be54580551ef27cf68792ab4252772d819c7e05153d4498bd8848c7d9dc042aa"
  revision 1
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "8635694b2beb21918f98994a564ac4f930003e818a8aab1903825b614ea98d15" => :high_sierra
    sha256 "bf9505c5a572c45e67b4252e0f60ce2b3bcbe6ed93d938b545948d643009cfa3" => :sierra
    sha256 "4230f006b4b92c9953dc6044487a027104e841b943f6b93c2624d843d703af57" => :el_capitan
    sha256 "e4404aaa60d65556874715e189dba7669f1ca73467e4b96d9ca4377f351bc9f6" => :x86_64_linux
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python"

  depends_on "libyaml" unless OS.mac?

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==4.2b1", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
  EOS
  end

  test do
    if OS.mac?
      assert_match "topics", shell_output("#{bin}/aws help")
    else
      # aws-cli needs groff as dependency, which we do not want to install
      # just to display the help.
      system "#{bin}/aws", "--version"
    end
  end
end
