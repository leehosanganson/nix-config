{ config, lib, pkgs, ... }:

let
  cfg = config.services.llama-cpp;
in {
  options.services.llama-cpp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the llama.cpp server.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for the OpenAI-compatible API server.";
    };

    bindAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Network address to bind the server to.";
    };

    gpuLayers = lib.mkOption {
      type = lib.types.int;
      default = 99;
      description = "Number of layers to offload to GPU (Metal on Apple Silicon). Use 99 to offload all layers.";
    };

    contextSize = lib.mkOption {
      type = lib.types.int;
      default = 8192;
      description = "Context size for the model.";
    };

    batchSize = lib.mkOption {
      type = lib.types.int;
      default = 512;
      description = "Batch size for processing.";
    };

    threads = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Number of CPU threads (0 = auto-detect).";
    };

    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "API key for access control. Set to null for open access.";
    };

    logDirectory = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/logs";
      description = "Directory for llama.cpp server logs.";
    };
  };

  config = let
    modelFile = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-IQ2_M.gguf";
      sha256 = "0hrx82chg9i3rr75nrsdnvfxaavckb7h54c2sc88pbz1swgfzrrb";
    };
  in lib.mkIf cfg.enable {
    launchd.agents."llama-cpp" = {
      config = {
        ProgramArguments =
          [ "${pkgs.llama}/bin/llama-server" ]
          ++ [ "--model" "${modelFile}" ]
          ++ [ "--host" cfg.bindAddress ]
          ++ [ "--port" (builtins.toString cfg.port) ]
          ++ [ "--n-gpu-layers" (builtins.toString cfg.gpuLayers) ]
          ++ [ "--ctx-size" (builtins.toString cfg.contextSize) ]
          ++ [ "--batch-size" (builtins.toString cfg.batchSize) ]
          ++ lib.optional (cfg.threads > 0) [ "-t" (builtins.toString cfg.threads) ]
          ++ [ "--cont-batching" ]
          ++ lib.optional (cfg.apiKey != null) [ "--api-key" cfg.apiKey ];

        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "${cfg.logDirectory}/llama-cpp.out";
        StandardErrorPath = "${cfg.logDirectory}/llama-cpp.err";
      };
    };
  };
}
