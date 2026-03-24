{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    desktop-gremlin = {
      url = "github:iluvgirlswithglasses/linux-desktop-gremlin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      desktop-gremlin,
      ...
    }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          fetchCharacter =
            name: hash:
            pkgs.fetchurl {
              url = "https://github.com/iluvgirlswithglasses/linux-desktop-gremlin/releases/download/v1.0.0/${name}.zip";
              sha256 = hash;
            };
        in
        {
          default = desktop-gremlin.packages.${system}.default.overridePythonAttrs (old: {
            dependencies = (old.dependencies or [ ]) ++ [ pkgs.python3Packages.requests ];
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.unzip ];
            postInstall = (old.postInstall or "") + ''
              mkdir -p $out/share/linux-desktop-gremlin/spritesheet

              unzip ${fetchCharacter "agnes-tachyon" "1hmram8sdx37fx4z06z3vxgkqd4qp9plkkmnnlx4ajphivglw4ys"} -d /tmp/gremlin-agnes/
              unzip ${fetchCharacter "cafe" "178iiqzh6sgq9cdk8j2mq6673y28s78bjgm9cyvz7qdjw5lcyh6g"} -d /tmp/gremlin-cafe/

              mkdir -p $out/share/linux-desktop-gremlin/spritesheet/agnes-tachyon
              cp -r /tmp/gremlin-agnes/agnes-tachyon/sprites/. $out/share/linux-desktop-gremlin/spritesheet/agnes-tachyon/

              mkdir -p $out/share/linux-desktop-gremlin/spritesheet/cafe
              cp -r /tmp/gremlin-cafe/cafe/sprites/. $out/share/linux-desktop-gremlin/spritesheet/cafe/

              mkdir -p $out/share/linux-desktop-gremlin/sounds/agnes-tachyon
              cp -r /tmp/gremlin-agnes/agnes-tachyon/sounds/. $out/share/linux-desktop-gremlin/sounds/agnes-tachyon/

              mkdir -p $out/share/linux-desktop-gremlin/sounds/cafe
              cp -r /tmp/gremlin-cafe/cafe/sounds/. $out/share/linux-desktop-gremlin/sounds/cafe/

              cat > $out/share/linux-desktop-gremlin/config.json << 'EOF'
              {
                  "AnnoyEmote": true,
                  "StartingChar": "agnes-tachyon",
                  "Systray": false,
                  "MoveSpeed": 5,
                  "Volume": 0.8,
                  "AudioDevice": "Default",
                  "EmoteKeyEnabled": true,
                  "EmoteKey": "P",
                  "IdleMinutes": 5,
                  "SleepMinutes": 5
              }
              EOF
            '';
          });
        }
      );
    };
}
