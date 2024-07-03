{
   environment.etc."launch-rl.bat".text = """
    @echo off

    set RL_PATH=\"Z:\home\quadradical\Documents\My Games\Rocket League\Binaries\Win64\"

    echo Launching BakkesMod...
    C:
    cd \"C:\Program Files\BakkesMod\"
    start BakkesMod.exe
    echo BakkesMod started, starting Rocket League
    Z:
    cd %RL_PATH%
    RocketLeague.exe %*
  """;
}