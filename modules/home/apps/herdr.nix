# herdr is not packaged in nixpkgs; it ships as a prebuilt binary per platform.
# To update: bump version + hashes from https://herdr.dev/latest.json.
{ pkgs, ... }:
{
  home.packages = let
    asset = {
      linux = {
        url = "https://github.com/herdrdev/herdr/releases/download/v0.9.1/herdr-linux-x86_64";
        sha256 = "2a02fed16beb651ef006e1d43f048f652ca4dc58ad053cd2d44450563d5c54b7";
      };
      linuxAarch64 = {
        url = "https://github.com/herdrdev/herdr/releases/download/v0.9.1/herdr-linux-aarch64";
        sha256 = "f4ccf4de745f2cb9a39a983e9ba3703dad50ec2a58dea83026ceab721bbd8d9e";
      };
      macos = {
        url = "https://github.com/herdrdev/herdr/releases/download/v0.9.1/herdr-macos-x86_64";
        sha256 = "053be0639935fe54ab5efbdb46651054e4f6a753a5b43153c88bd6912bce1e94";
      };
      macosAarch64 = {
        url = "https://github.com/herdrdev/herdr/releases/download/v0.9.1/herdr-macos-aarch64";
        sha256 = "5fc7a7e7adfaca56fa80aa89dcb025693357268dab8285b9ce2d08a2313c89de";
      };
    };
    assetOf = system: {
      "x86_64-linux" = asset.linux;
      "aarch64-linux" = asset.linuxAarch64;
      "x86_64-darwin" = asset.macos;
      "aarch64-darwin" = asset.macosAarch64;
    }.${system};
    herdr = pkgs.runCommand "herdr" {
      src = pkgs.fetchurl (assetOf pkgs.stdenv.hostPlatform.system);
    } ''
      mkdir -p "$out/bin"
      install -m755 "$src" "$out/bin/herdr"
    '';
  in
  [ herdr ];
}
