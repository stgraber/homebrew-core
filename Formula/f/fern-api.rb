class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.9.tgz"
  sha256 "3b21b8672e7315147bb4615d86a17fa9bc10d31a80c7d97f11502fdfdf826b9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84748ac7270fd312816fcdef0620a417f726a53af5d7cf309f264deff955ac01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
