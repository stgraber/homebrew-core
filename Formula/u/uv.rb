class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://docs.astral.sh/uv/"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.6.16.tar.gz"
  sha256 "506c5970777ace5840c2d3a90b507265aab24749469ba03f88526c4b6f9bfa70"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ac31db5e9e40c8c98fcb4f60bc8500196b517c320b715544c75a12c228a0a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffe886ad43d105e45aeba22f56fb09f799099d964458524c3a4b9cf1de962ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a368b09e6bc8b18196fb01adb132519527a1ef7cfef4b3b3f0f86a3c34c528b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e56369e6cbecd9bdc1ee23c954f0fbc160aff8b7ab03eaf7ab8396b978f3b30"
    sha256 cellar: :any_skip_relocation, ventura:       "b67074452e206a3b8e56368d467e6d566e9cd4d6d865fc98beed92f352ba9f56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e9f612771c707f7284f6ce1b7d06aa18f70f53fa2ec356effb621b326e0c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b88c2bc592d0732be6fede6c78bc20ffce2dfc2b1a11c70b548387f24a98d8d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
