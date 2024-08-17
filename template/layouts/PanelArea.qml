// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9
import "panels"

Rectangle { //panel_area
    id: panel_area

    color: addAlphaToHex(0.95, colors.accent)
    clip: true

    height: { //height
        let h = parent.parent.height - (header.height)
        return settings.buttonHints ? h - vpx(72) : h * 0.95
    }
    Behavior on height {NumberAnimation {duration: 125}}

    property Item current: panel_area
    property string current_s: "info"

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
            info_panel.closePanel()
            resetFocus(panel_area)
            switch(panel){
                case "settings":
                    current_s = "settings"
                    current = settings_panel
                    break
                default:
                    current_s = "info"
                    current = info_panel
                    video.reset()
                    break
            }
        }
    //--

    InfoPanel { //clean
        id: info_panel
        visible: panel_area.current === this
    }

    SettingsPanel {
        id: settings_panel
        visible: panel_area.current === this
    }

    Keys.onPressed: { //Keys
        s = s != null ? s : audio.toggle_down
    }

    property Video video: info_panel.video
}
