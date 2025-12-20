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

        if [ -f "$input" ] && echo "$input" | grep -qi "\.epub$"; then
          fullpath="$input"
        else
          if [ ! -d "$HOME/.config/adept" ]; then
            adept_activate --anonymous
          fi

          fullpath=$(acsmdownloader --output-dir /tmp "$input" \
            | tee /dev/tty \
            | grep "^Created " \
            | sed "s/^Created //")

          adept_remove "$fullpath"
        fi

        name=$(basename "$fullpath" | rev | cut -d. -f2- | rev)
        ext=$(echo "$fullpath" | rev | cut -d. -f1 | rev)

        if [ "$ext" = "epub" ]; then
          ebook-convert "$fullpath" "/run/media/quadradical/Kindle/documents/$name.mobi"
          rm $fullpath"
        else
          mv "$fullpath" "/run/media/quadradical/Kindle/documents/$name.pdf"
        fi
      '';
    })
  ];
}
