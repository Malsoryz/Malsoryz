{ pkgs, inputs, ... }:
{
  services.phpfpm.pools.presence = {
    user = "alternity";
    group = "nginx";
    settings = {
      "listen" = "/run/phpfpm/presence.sock";
      "listen.owner" = "nginx";
      "listen.group" = "nginx";
      "listen.mode" = "0660";
      "pm" = "dynamic";
      "pm.max_children" = 20;
      "pm.start_servers" = 5;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 10;
      "php_value[upload_max_filesize]" = "64M";
      "php_value[post_max_size]" = "64M";
      "php_value[memory_limit]" = "256M";
      "php_value[max_execution_time]" = "300";
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
      fastcgi_buffers      8 16k;
      fastcgi_buffer_size  32k;
    '';

    # server_tokens        off;
    # client_max_body_size 64M;

    virtualHosts."presence.org" = {
      root = "/var/www/presensi/public";

      extraConfig = ''
        index index.php;
      '';

      locations."/" = {
        tryFiles = "$uri $uri/ /index.php?$query_string";
        extraConfig = ''
          add_header X-Frame-Options        "SAMEORIGIN"    always;
          add_header X-XSS-Protection       "1; mode=block" always;
          add_header X-Content-Type-Options "nosniff"       always;
        '';
      };

      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass  unix:/run/phpfpm/presence.sock;
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
          include       ${pkgs.nginx}/conf/fastcgi_params;
          fastcgi_read_timeout 300;
        '';
      };

      locations."~ /\\." = {
        extraConfig = "deny all;";
      };

      locations."~* \\.(jpg|jpeg|png|gif|ico|css|js|woff2?|svg|webp)$" = {
        extraConfig = ''
          expires    30d;
          add_header Cache-Control "public, immutable";
          access_log off;
        '';
      };
    };
  };

  systemd.services.laravel-queue = {
    description = "Laravel Queue Worker";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      User = "alternity";
      WorkingDirectory = "/var/www/presensi";
      ExecStart = "${pkgs.php}/bin/php artisan queue:work --sleep=3 --tries=3 --max-time=3600";
      Restart = "always";
      RestartSec = "5s";
      RuntimeMaxSec = "3600";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
