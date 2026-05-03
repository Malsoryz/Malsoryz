{ pkgs, inputs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    loadModels = [ "gemma4:e2b" ];

    host = "127.0.0.1";
    port = 11434;
  };

  services.nextjs-ollama-llm-ui = {
    enable = false;
    hostname = "127.0.0.1";
    port = 3005;
    ollamaUrl = "http://127.0.0.1:11434";
  };
}
