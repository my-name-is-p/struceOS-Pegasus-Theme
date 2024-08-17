// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Rectangle { //background
    id: background

    anchors.fill: parent

    color: colors.black

    property int fade_time: 200

    //Functions--
        function refresh(){
            fade_out.restart()
        }
    //--

    Image { //bg_image
        id: bg_image
        source: bg

        anchors.fill: parent

        property real opacity_level: 0
        Behavior on opacity_level {NumberAnimation {duration: background.fade_time}}

        opacity: search_term.focus ? 0 : opacity_level
        Behavior on opacity {NumberAnimation {duration: background.fade_time}}

        fillMode: Image.PreserveAspectCrop

        smooth: true
        antialiasing: true

        NumberAnimation { //fade_out
            id: fade_out
            target: bg_image
            property: "opacity_level"
            to: 0
            duration: background.fade_time
            onFinished: {
                fade_in.repeat = true
                fade_in.start()
            } 
        }

        Timer { //fade_in
            id: fade_in
            interval: background.fade_time
            repeat: false
            onTriggered: {
                bg = getAssets(currentGame.assets).bg
                if(bg_image.status === Image.Ready)
                    repeat = false
                if(!repeat)
                    bg_image.opacity_level = 1
            }
        }
    }

    Image { //background_overlay
        id: background_overlay
        source: settings.bgOverlay

        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop

        opacity: {
            if(!settings.bgOverlayOn || settings.bgOverlayOpacity * 100 < 1)
                return 0
            else
                return settings.bgOverlayOpacity >= 1 ? 1 : settings.bgOverlayOpacity
        }
        Behavior on opacity {NumberAnimation {duration: background.fade_time}}

        smooth: true
        antialiasing: true
    }
}
