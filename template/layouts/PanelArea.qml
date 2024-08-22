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
    Behavior on height {NumberAnimation {duration: 125}}

    property Item current: panel_area
    property string current_s: "info"

    clip: true

    //Functions--
        property var onUp: current.onUp
        property var onDown: current.onDown
        property var onLeft: current.onLeft
        property var onRight: current.onRight
        property var onPrevious: current.onPrevious
        property var onNext: current.onNext
        property var onFirst: current.onFirst
        property var onLast: current.onLast
        property var onDetails: current.onDetails
        property var onSort: current.onSort
        property var onCancel: current.onCancel
        property var onAccept: current.onAccept
    
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
