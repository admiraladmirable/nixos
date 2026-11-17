{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      imports = [ inputs.lan-mouse.homeManagerModules.default ];

      programs.lan-mouse = {
        enable = true;
        systemd = false;

        # libei capture timestamps are microseconds; wlroots emulation expects
        # milliseconds. Convert on the sender so double clicks reach Dolphin
        # with the correct interval.
        package =
          inputs.lan-mouse.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
            (old: {
              # nixpkgs' cargo setup hook sets LIBGIT2_NO_VENDOR=1, so
              # libgit2-sys needs a system libgit2.
              buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libgit2 ];
              # Include the input-event crate's scroll regression tests.
              cargoTestFlags = (old.cargoTestFlags or [ ]) ++ [ "--workspace" ];
              patches = (old.patches or [ ]) ++ [
                ./lan-mouse-libei-timestamps.patch
                # Avoid forwarding both representations of one captured wheel step.
                ./lan-mouse-libei-scroll-frames.patch
              ];
            });
      };
    };
}
