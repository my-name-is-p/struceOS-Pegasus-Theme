// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Rectangle {
    id: background
    anchors.fill: parent
    color: p.black

    property int fade_time: 200

    Image {
        id:bg_back

        smooth: true
        antialiasing: true

        property real opacity_level: 0
        opacity: header.search_term.focus ? 0 : opacity_level

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        source: bg

        Behavior on opacity_level {NumberAnimation {duration: background.fade_time}}
        Behavior on opacity {NumberAnimation {duration: background.fade_time}}


        NumberAnimation {
            id: fade_out
            target: bg_back
            property: "opacity_level"
            to: 0
            duration: background.fade_time
            onFinished: {
                fade_in.repeat = true
                fade_in.start()
            } 
        }

        Timer {
            id: fade_in
            interval: background.fade_time
            repeat: false
            onTriggered: {
                bg = getAssets(currentGame.assets).bg
                if(bg_back.status === Image.Ready)
                    repeat = false
                if(!repeat)
                    bg_back.opacity_level = 1
            }
        }


    }

    property var refresh: function(){
        fade_out.restart()
    }
    
    //Background Overlay
    Image {
        id: backgroundOverlay
        source: images.overlay
        opacity: {
            if(!settings.bgOverlayOn || settings.bgOverlayOpacity * 100 < 1)
                return 0
            else
                return settings.bgOverlayOpacity >= 1 ? 1 : settings.bgOverlayOpacity
        }

        smooth: true
        antialiasing: true

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        Behavior on opacity {NumberAnimation {duration: background.fade_time}}
    }

    property Item image: bg_back
    property Image overlay: backgroundOverlay
}
