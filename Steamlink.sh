#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Variables
GAMEDIR="/$directory/ports/steamlink"
QT_VERSION=5.14.1

# CD and set permissions
cd $GAMEDIR
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
$ESUDO chmod +x -R $GAMEDIR/*

# Exports
export LD_LIBRARY_PATH="$GAMEDIR/lib:$GAMEDIR/Qt-$QT_VERSION/lib:$LD_LIBRARY_PATH"
export QT_PLUGIN_PATH="$GAMEDIR/$QT_VERSION/plugins"
export QT_DEBUG_PLUGINS=1
if [ "$DISPLAY" = "" ]; then
    export QT_QPA_PLATFORM="linuxfb"
else
    export QT_QPA_PLATFORM="xcb"
fi

# Assign gptokeyb and load the game
pm_platform_helper "$GAMEDIR/bin/shell" >/dev/null
./bin/shell

# Cleanup
pm_finish
