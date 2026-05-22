{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "book";
      runtimeInputs = with pkgs; [
        libgourou
        calibre
      ];
      text = ''
        input="$1"

        if echo "$input" | grep -qi "\.acsm$"; then
          if [ ! -d "$HOME/.config/adept" ]; then
            adept_activate --anonymous
          fi

          fullpath=$(acsmdownloader --output-dir /tmp "$input" \
            | tee /dev/tty \
            | grep "^Created " \
            | sed "s/^Created //")

          adept_remove "$fullpath"
        else
          fullpath="$input"
        fi

        name=$(basename "$fullpath" | rev | cut -d. -f2- | rev)
        ebook-convert "$fullpath" "/run/media/quadradical/Kindle/documents/$name.mobi"
      '';
    })
  ];
}
