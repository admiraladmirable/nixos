{
  lib,
  awscli2,
  fetchFromGitHub,
  python3,
  testers,
}:
let
  version = "2.39.3";

  # Keep the newer CRT dependency private to AWS CLI.
  python = python3 // {
    pkgs = python3.pkgs.overrideScope (
      _final: prev: {
        awscrt = prev.awscrt.overridePythonAttrs (old: {
          version = "0.38.0";
          src = old.src.override {
            version = "0.38.0";
            hash = "sha256-SoQjxKdjkMblxPOG4+Nn3M3PZ9bRoLwcWXdrsUzcKtk=";
          };
        });
      }
    );
  };
in
# Temporary override until https://github.com/NixOS/nixpkgs/pull/581111 lands.
# Use nixpkgs again automatically when it provides this version or newer.
if lib.versionAtLeast awscli2.version version then
  awscli2
else
  (awscli2.override { python3 = python; }).overrideAttrs (
    finalAttrs: old: {
      inherit version;

      src = fetchFromGitHub {
        owner = "aws";
        repo = "aws-cli";
        tag = finalAttrs.version;
        hash = "sha256-HEQ73GYAi/MS24mNYoC3Cth4fZcLw5Q8hV7/ZF0GByU=";
      };

      disabledTestPaths = (old.disabledTestPaths or [ ]) ++ [
        # Requires localstub, which is not packaged in nixpkgs.
        "tests/blackbox"
      ];
      disabledTests = (old.disabledTests or [ ]) ++ [
        # Creates an awscrt S3 client that requires a system trust store.
        "test_upper_bound_matches_what_awscrt_accepts"
      ];

      passthru = old.passthru // {
        tests = (old.passthru.tests or { }) // {
          version = testers.testVersion {
            package = finalAttrs.finalPackage;
            command = "aws --version";
            version = finalAttrs.version;
          };
        };
      };

      meta = old.meta // {
        changelog = "https://github.com/aws/aws-cli/blob/${finalAttrs.version}/CHANGELOG.rst";
      };
    }
  )
