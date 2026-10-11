{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  just,
  libcosmicAppHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-boards";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "boards";
    rev = "2adfe6b2be0e0517243b39f7450fd4ade8853830";
    hash = "sha256-yUkDaLnMXA9PV3qjlpGP5YpBASB/QAy9Vlt/Suu0zQ0=";
  };

  cargoHash = "sha256-PHpjtJzcJCaOKRrOJWF3gGowuar/67eENRvbVFCFoBE=";

  nativeBuildInputs = [
    just
    pkg-config
    libcosmicAppHook
  ];

  buildPhase = ''
    runHook preBuild

    just build-release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 target/release/boards $out/bin/boards

    install -Dm0644 resources/app.desktop $out/share/applications/app.desktop

    install -Dm0644 resources/app.metainfo.xml $out/share/metainfo/app.metainfo.xml

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/cosmic-utils/boards";
    description = "Trello-like application for the COSMIC desktop";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-boards";
  };
})
