// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9
import "parts/panelarea"

Item { //panel_area
    id: panel_area

    height: { //height
        let h = parent.parent.height - (header.height)
        return settings.buttonHints ? h - vpx(72) : h * 0.95
    }

    property Item current: panel_area
    property string current_s: "info"

    clip: true

    //Functions--
        property var onUp: current != panel_area ? current.onUp : undefined
        property var onDown: current != panel_area ? current.onDown : undefined
        property var onLeft: current != panel_area ? current.onLeft : undefined
        property var onRight: current != panel_area ? current.onRight : undefined
        property var onPrevious: current != panel_area ? current.onPrevious : undefined
        property var onNext: current != panel_area ? current.onNext : undefined
        property var onFirst: current != panel_area ? current.onFirst : undefined
        property var onLast: current != panel_area ? current.onLast : undefined
        property var onDetails: current != panel_area ? current.onDetails : undefined
        property var onSort: current != panel_area ? current.onSort : undefined
        property var onCancel: current != panel_area ? current.onCancel : undefined
        property var onAccept: current != panel_area ? current.onAccept : undefined
    
        function open(panel = "info"){
            switch(panel){
                case "settings":
                    current_s = "settings"
                    current = settings_panel
                    resetFocus(panel_area)
                    break
                default:
                    if(games.currentIndex != -1){
                        current_s = "info"
                        current = info_panel
                        resetFocus(panel_area)
                    }
                    break
            }
        }
    //--

    InfoPanel {
        id: info_panel
        visible: panel_area.current === this
    }

    SettingsPanel {
        id: settings_panel
        visible: panel_area.current === this
    }

    Keys.onPressed: {
        if(event.key === 1048576 && event.isAutoRepeat)
            return
        s = s != null ? s : audio.toggle_down
    }

    property Video video: info_panel.video
    property InfoPanel info_panel: info_panel
    property SettingsPanel settings_panel: settings_panel
}
