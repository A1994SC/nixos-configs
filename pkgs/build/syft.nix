{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "syft";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "anchore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7O1QDGerDbVYoN+sKq6wmoD9waXgiIWFy6nCLrfZZkI=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorSha256 = "sha256-DzAdY0HlSjBsTYpi+FDwMMKOmOQy0yx+lep6f1MPuXA=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/syft" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anchore/syft/internal/version.version=${version}"
    "-X github.com/anchore/syft/internal/version.gitDescription=v${version}"
    "-X github.com/anchore/syft/internal/version.gitTreeState=clean"
  ];

  preBuild = ''
    ldflags+=" -X github.com/anchore/syft/internal/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X github.com/anchore/syft/internal/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  # tests require a running docker instance
  doCheck = false;

  postInstall = ''
    # avoid update checks when generating completions
    export SYFT_CHECK_FOR_APP_UPDATE=false

    installShellCompletion --cmd syft \
      --bash <($out/bin/syft completion bash) \
      --fish <($out/bin/syft completion fish) \
      --zsh <($out/bin/syft completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export SYFT_CHECK_FOR_APP_UPDATE=false
    $out/bin/syft --help
    $out/bin/syft version | grep "${version}"

    runHook postInstallCheck
  '';

}
