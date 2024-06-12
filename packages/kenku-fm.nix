with import <nixpkgs> {}; # bring all of Nixpkgs into scope

stdenv.mkDerivation rec {
  pkgname = "kenku-fm-bin";
  pkgver = "1.4.3";
  name = "${pkgname}-${pkgver}";
  pkgdesc = "Online tabletop audio sharing for Discord";
  arch = "amd64";
  url = "https://github.com/owlbear-rodeo/kenku-fm";
  src = fetchurl {
    url = "${url}/releases/download/v${pkgver}/kenku-fm_${pkgver}_${arch}.deb";
    sha256 = "0gx7n2a0xw4fsw45njxn6gdm161sv712m71fdj5b89gk0yhsrisk";
  };
  buildInputs = [ dpkg ];
  unpackPhase = ''
    dpkg-deb --fsys-tarfile ${src} | tar -x --no-same-permissions --no-same-owner
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/${pkgname}
    chmod +x $out/bin/${pkgname}
  '';
}
