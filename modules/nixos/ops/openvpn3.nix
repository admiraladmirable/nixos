{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.openvpn3.enable = mkEnableOption "Enable openvpn3";

  config = mkIf config.openvpn3.enable {
    nixpkgs.overlays = [
      (final: prev: {
        openvpn3 = prev.openvpn3.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (prev.writeText "fix-openvpn3-header-conflicts.patch" ''
              --- a/openvpn3-core/openvpn/dco/ovpn_dco_linux.h
              +++ b/openvpn3-core/openvpn/dco/ovpn_dco_linux.h
              @@ -239,22 +239,6 @@ enum ovpn_netlink_packet_attrs {
               	OVPN_PACKET_ATTR_MAX = __OVPN_PACKET_ATTR_AFTER_LAST - 1,
               };
               
              -enum ovpn_ifla_attrs {
              -	IFLA_OVPN_UNSPEC = 0,
              -	IFLA_OVPN_MODE,
              -
              -	__IFLA_OVPN_AFTER_LAST,
              -	IFLA_OVPN_MAX = __IFLA_OVPN_AFTER_LAST - 1,
              -};
              -
              -enum ovpn_mode {
              -	__OVPN_MODE_FIRST = 0,
              -	OVPN_MODE_P2P = __OVPN_MODE_FIRST,
              -	OVPN_MODE_MP,
              -
              -	__OVPN_MODE_AFTER_LAST,
              -};
              -
               /// \endcond
               
               #endif /* _UAPI_LINUX_OVPN_DCO_H_ */
            '')
          ];
        });
      })
    ];

    programs.openvpn3.enable = true;
  };
}
