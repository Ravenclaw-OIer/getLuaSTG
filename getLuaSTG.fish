#!/usr/bin/env fish
function run
    echo (set_color yellow)'$ '$argv(set_color normal)
    $argv
end

argparse h/help d/download -- $argv
or exit 1
set rootDir (pwd)
set lstgDir $rootDir/LuaSTG-x
if set -q _flag_download
    run git clone --recursive https://github.com/Xrysnow/LuaSTG-x.git
    run cd LuaSTG-x/frameworks/cocos2d-x/external
    run git clone --recursive https://github.com/Xrysnow/cocos2d-x-3rd-party-libs-bin.git
    run cp cocos2d-x-cocos2d-x-3rd-party-libs-bin/* ./
    run cp cocos2d-x-cocos2d-x-3rd-party-libs-bin/.* ./
else
    echo (set_color orange)Skipping download (set_color normal)
end
run cd $lstgDir
echo (set_color green)Disabling Live2D (set_color normal)
run sed -i 's/option(LSTGX_NO_LIVE2D    "No live2d module"     OFF)/option(LSTGX_NO_LIVE2D    "No live2d module"     ON)/g' CMakeLists.txt
echo (set_color green)Fixing Box2D (set_color normal)
run cd frameworks/cocos2d-x/external/Box2D/include
run cp Box2D/Box2D.h box2d/box2d.h
run cd $lstgDir
echo (set_color green)Fixing std::strcmp (set_color normal)
run sed -i 's/std::strcmp/strcmp/g' frameworks/cocos2d-x/external/gfx/backend/gfx-vulkan/VKGPUObjects.h
run mkdir -p build
run cd build
run cmake ..
run make
