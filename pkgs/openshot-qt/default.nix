{
  openshot-qt,
  libopenshot,
  fetchFromGitHub,
}:
(openshot-qt.override { inherit libopenshot; }).overrideAttrs (old: rec {
  version = "3.5.1";
  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    tag = "v${version}";
    hash = "sha256-iLbw3SPymHN+unSqr/82tC7swCAvMFAWQKUOMs/SyDU=";
  };
})
