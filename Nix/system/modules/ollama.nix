{ pkgs, inputs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    host = "0.0.0.0";
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];
}
