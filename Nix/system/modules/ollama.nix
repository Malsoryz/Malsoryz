{ pkgs, inputs, ... }:
{
  services.ollama = {
    enable = false;
    package = pkgs.ollama-rocm;

    host = "0.0.0.0";
    # port = 12139;
    # Birth day of mine, Aru Rikuhachima, and Agnes Tachyon.
  };

  #   services.open-webui = {
  #     enable = true;
  #     host = "127.0.0.1";
  #     port = 1134;
  #     # Birth month of mine, Aru Rikuhachima, and Agnes Tachyon.

  #     environment = {
  #       OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
  #       ANONYMIZED_TELEMETRY = "False";
  #       DO_NOT_TRACK = "True";
  #       SCARF_NO_ANALYTICS = "True";
  #       WEBUI_AUTH = "False";
  #     };
  #   };
}
