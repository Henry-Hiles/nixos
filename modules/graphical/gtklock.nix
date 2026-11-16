{
  config,
  pkgs,
  ...
}:
let
  inherit (config.lib.stylix) colors;

  background =
    pkgs.runCommand "lock-background.jpg" { nativeBuildInputs = [ pkgs.buildPackages.imagemagick ]; }
      ''
        magick ${../../background.jpg} -resize 50% -blur 0x16 -modulate 80 $out
      '';

  layout = pkgs.writeText "gtklock.ui" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkBox" id="window-box">
        <property name="name">window-box</property>
        <property name="halign">center</property>
        <property name="valign">center</property>
        <property name="orientation">vertical</property>
        <child>
          <object class="GtkBox" id="info-box">
            <property name="name">info-box</property>
            <property name="orientation">vertical</property>
            <child>
              <object class="GtkBox" id="time-box">
                <property name="name">time-box</property>
                <property name="orientation">vertical</property>
                <child>
                  <object class="GtkLabel" id="clock-label">
                    <property name="name">clock-label</property>
                  </object>
                </child>
                <child>
                  <object class="GtkLabel" id="date-label">
                    <property name="name">date-label</property>
                  </object>
                </child>
              </object>
            </child>
          </object>
        </child>
        <child>
          <object class="GtkRevealer" id="body-revealer">
            <property name="transition-type">none</property>
            <child>
              <object class="GtkGrid" id="body-grid">
                <property name="halign">center</property>
                <property name="row-spacing">8</property>
                <child>
                  <object class="GtkLabel" id="input-label">
                    <property name="no-show-all">1</property>
                  </object>
                </child>
                <child>
                  <object class="GtkEntry" id="input-field">
                    <property name="name">input-field</property>
                    <property name="width-request">300</property>
                    <property name="xalign">0.5</property>
                    <property name="visibility">0</property>
                    <property name="caps-lock-warning">0</property>
                    <property name="input-purpose">password</property>
                    <property name="placeholder-text">Input Password</property>
                    <signal name="activate" handler="window_pw_check"/>
                  </object>
                  <packing>
                    <property name="top-attach">0</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkRevealer" id="message-revealer">
                    <property name="transition-type">none</property>
                    <property name="no-show-all">1</property>
                    <child>
                      <object class="GtkScrolledWindow" id="message-scrolled-window">
                        <property name="hscrollbar-policy">never</property>
                        <property name="max-content-height">256</property>
                        <property name="propagate-natural-height">1</property>
                        <child>
                          <object class="GtkViewport">
                            <child>
                              <object class="GtkBox" id="message-box">
                                <property name="orientation">vertical</property>
                                <property name="homogeneous">1</property>
                              </object>
                            </child>
                          </object>
                        </child>
                      </object>
                    </child>
                  </object>
                  <packing>
                    <property name="top-attach">1</property>
                  </packing>
                </child>
                <child>
                  <object class="GtkBox">
                    <property name="halign">center</property>
                    <property name="spacing">8</property>
                    <child>
                      <object class="GtkLabel" id="warning-label">
                        <property name="name">warning-label</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkLabel" id="error-label">
                        <property name="name">error-label</property>
                      </object>
                    </child>
                    <child>
                      <object class="GtkButton" id="unlock-button">
                        <property name="no-show-all">1</property>
                        <signal name="clicked" handler="window_pw_check"/>
                      </object>
                    </child>
                  </object>
                  <packing>
                    <property name="top-attach">2</property>
                  </packing>
                </child>
              </object>
            </child>
          </object>
        </child>
      </object>
    </interface>
  '';
in
{
  programs.gtklock = {
    enable = true;

    config.main = {
      layout = "${layout}";
      time-format = "%H:%M";
      date-format = "%A, %B %-d";
    };

    style = ''
      window {
        background-image: url("${background}");
        background-size: cover;
        background-position: center;
      }

      #clock-label {
        font-size: 96pt;
        color: white;
      }

      #date-label {
        font-size: 20pt;
        color: white;
        margin-bottom: 80px;
      }

      #input-field {
        min-height: 50px;
        padding: 0 20px;
        border: none;
        border-radius: 25px;
        box-shadow: none;
        background: #${colors.base01};
        color: #${colors.base05};
      }

      #error-label,
      #warning-label {
        color: #${colors.base08};
      }
    '';
  };
}
