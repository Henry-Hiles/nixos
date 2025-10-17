@echo off

set RL_PATH="Z:\home\quadradical\Documents\Games\rocketleague\Binaries\Win64"

C:
cd "C:\Program Files\BakkesMod"
start BakkesMod.exe
Z:
cd %RL_PATH%
RocketLeague.exe %*
