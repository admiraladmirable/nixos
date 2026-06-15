{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
}:

# Helm 4 is not yet in nixpkgs (kubernetes-helm is still on the 3.x line as of
# 2026-06), so we build it from source here. Based on the upstream nixpkgs
# kubernetes-helm derivation, adapted for v4:
#   * Go module path moved from helm.sh/helm/v3 to helm.sh/helm/v4.
#   * The v3-era preBuild that injected k8sVersionMajor/Minor via ldflags is
#     gone: v4 derives the client-go version at runtime from build info
#     (internal/version/clientgo.go), so those symbols no longer exist.
buildGoModule (finalAttrs: {
  pname = "kubernetes-helm";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "helm";
    repo = "helm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Wyihzf7KpnVuIdp5lmjhB7uLAGgtmI0TXYl29uaVC5Y=";
  };
  vendorHash = "sha256-QTDC0v0BPE3FoK9AAq1n2jWxOE9gB9OsoY2wnpcCDUQ=";

  subPackages = [ "cmd/helm" ];
  ldflags = [
    "-w"
    "-s"
    "-X helm.sh/helm/v4/internal/version.version=v${finalAttrs.version}"
    "-X helm.sh/helm/v4/internal/version.gitCommit=${finalAttrs.src.rev}"
  ];

  # Upstream's test suite expects a git checkout and network access; not worth
  # running for a personal overlay override.
  doCheck = false;

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/helm completion bash > helm.bash
    $out/bin/helm completion zsh > helm.zsh
    $out/bin/helm completion fish > helm.fish
    installShellCompletion helm.{bash,zsh,fish}
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "helm version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/helm/helm";
    description = "Package manager for Kubernetes (v4, overlay build)";
    mainProgram = "helm";
    license = lib.licenses.asl20;
  };
})
