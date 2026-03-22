{
  pkgs,
  nix-phps,
  system,
  ...
}:
let
  phps = nix-phps.packages.${system};

  mkPhpAll = ver: pkg: [
    (pkgs.writeShellScriptBin "php${ver}" ''exec ${pkg}/bin/php "$@"'')
    (pkgs.writeShellScriptBin "php-fpm${ver}" ''exec ${pkg}/sbin/php-fpm "$@"'')
    (pkgs.writeShellScriptBin "php-cgi${ver}" ''exec ${pkg}/bin/php-cgi "$@"'')
    (pkgs.writeShellScriptBin "phpdbg${ver}" ''exec ${pkg}/bin/phpdbg "$@"'')
    (pkgs.writeShellScriptBin "phar${ver}" ''exec ${pkg}/bin/phar "$@"'')
  ];
in
(mkPhpAll "81" phps.php81)
++ (mkPhpAll "82" phps.php82)
++ (mkPhpAll "83" phps.php83)
++ [ phps.php84 ]
