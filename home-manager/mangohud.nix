{
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      gpu_stats = true;
      gpu_text = "GPU";
      gpu_load_change = true;
      gpu_load_value = [50 90];
      gpu_load_color = ["FFFFFF" "FFAA7F" "CC0000"];

      cpu_text = "CPU";
      cpu_color = "2e97cb";
      cpu_load_change = true;
      core_load_change = true;
      cpu_load_value = [50 90];
      cpu_load_color = ["FFFFFF" "FFAA7F" "CC0000"];

      vram = true;
      vram_color = "ad64c1";

      fps = true;
      frametime = false;
      frame_timing = false;
      engine_color = "eb5b5b";

      gpu_name = true;
      gpu_color = "2e9762";

      font_size = 24;
      table_columns = 2;
      round_corners = 10;
      text_color = "ffffff";
      background_alpha = 0.4;
      position = "bottom-right";
      background_color = "020202";
    };
  };
}
