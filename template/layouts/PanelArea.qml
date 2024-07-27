// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtMultimedia 5.9
import "panels"

Rectangle {
    id: panel_area

    color: addAlphaToHex(0.95, colors.accent)
    clip: true

    property real topMargin: (parent.height - (header.height + collections_menu.height))

    height: f === this ? 
                settings.buttonHints ? 
                    topMargin - vpx(72) : 
                    topMargin * 0.95  : 
                0

    Behavior on height {NumberAnimation {duration: 125}}

    property Item current: info_panel

    //Functions--
        property var fullReset: current.fullReset != undefined ? current.fullReset : undefined
    //--

    InfoPanel {
        id: info_panel
        visible: panel_area.current === this
    }

    SettingsPanel {
        id: settings_panel
        visible: panel_area.current === this
    }

    Keys.forwardTo: current

   property InfoPanel info_panel: info_panel
   property SettingsPanel settings_panel: settings_panel
}
