{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre-no-speech # base calibre has a huge japanese tts lib...

    qbittorrent
  ];

}
