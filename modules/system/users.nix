{ ... }:
{
  flake.modules.nixos.base = {
    users.users.rmrf = {
      isNormalUser = true;
      description = "rm-rf";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "dialout"
        "gamemode"
        "audio"
        "render"
        "video"
      ];
      hashedPassword = "$6$dAbP8R68N39TelAh$8TagDN12cSuGOrCvz9pCvKBwJzaJochIj1HE70MbDcPXeTyrfHXfUdy3Mo7E4ZtCvHWjJyFyr7j6crQBUZn.h/";
    };
  };
}
