class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/2.64.0.tar.gz"
  sha256 "229fd8fc51325ebb5a357af6af116094d6be6a5f1e0f0923b7892ed01b208abb"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99a59976040152f50c31940a210e5aaa383f1956a791ffa282e0a597b56bceeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99a59976040152f50c31940a210e5aaa383f1956a791ffa282e0a597b56bceeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99a59976040152f50c31940a210e5aaa383f1956a791ffa282e0a597b56bceeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28cd8e77bc05822dade47072bacdc88594cfcdbeba85b315847ccd179de7074"
    sha256 cellar: :any_skip_relocation, ventura:       "057b49b75e1fe1d785a85856867fa99dbb7c61b0b2791b871d4ea54306c0a8e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "576fefdd5107aee69719b0161ceb1bda6b598221242b5accf84f7c836a012329"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
