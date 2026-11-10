{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "alternity-assets";
  version = "1.0.0";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/alt-assets/wallpapers

    cp -r $src/wallpapers/. \
      $out/share/alt-assets/wallpapers/

    runHook postInstall
  '';
}
