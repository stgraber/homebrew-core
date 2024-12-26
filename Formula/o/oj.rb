class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "b94977f7f7e67fe306fc2ccb949189741f88a3490140350d15f4d1eb703e0c7f"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9153182f84198a3d507ac662829301c226bbcd5023691908b78c53557d48209a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9153182f84198a3d507ac662829301c226bbcd5023691908b78c53557d48209a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9153182f84198a3d507ac662829301c226bbcd5023691908b78c53557d48209a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a69feec6f68b1e9181e3d76d0da206073999ad72aaa80ec88160ddd3cb4b8581"
    sha256 cellar: :any_skip_relocation, ventura:       "a69feec6f68b1e9181e3d76d0da206073999ad72aaa80ec88160ddd3cb4b8581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2d29b7b03cebcbdf0868e07590ffb01c42fdf0e1886997ae85ffdbdb8c1b1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
