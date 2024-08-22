// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtMultimedia 5.9

Rectangle {
    id: screensaver

    color: colors.accent

    opacity: 0
    Behavior on opacity {NumberAnimation {duration: screensaver.fadeTime * 1000}}

    property int timeout: 3
    property int fadeTime: 3

    Image {
        id: image
        source: getAssets(currentGame.assets).bg

        anchors.fill: parent

        opacity: 1
        Behavior on opacity {NumberAnimation {duration: 1000}}

        fillMode: Image.PreserveAspectCrop

        Image {
            id: logo
            source: getAssets(currentGame.assets).logo

            anchors.top: image.top
            anchors.left: image.left

            anchors.margins: vpx(48)
            height: vpx(200)
            width: vpx(400)

            fillMode: Image.PreserveAspectFit

            horizontalAlignment: Image.AlignLeft
            verticalAlignment: Image.AlignTop

            visible: false
        }

        DropShadow { //logo_shadow
            id: logo_shadow
            source: logo

            anchors.fill: logo

            color: colors.black
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8
            samples: 16
        }

        Timer {
            id: image_fade
            interval: 1000
            onTriggered: {
                let r = Math.floor(Math.random() * api.allGames.count)
                image.source = getAssets(api.allGames.get(r).assets).bg
                logo.source = getAssets(api.allGames.get(r).assets).logo
                image.opacity = 1
            }
        }

        Timer {
            id: image_change
            interval: 30000
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: image.changeImage()
        }

        function changeImage(){
            opacity = 0
            image_fade.restart()
        }
    }

    Timer{
        id: timeout
        interval: 1000 * screensaver.timeout
        onTriggered: {
            if(video.playbackState != MediaPlayer.PlayingState)
                screensaver.opacity = 1
            else
                restart()
        }
    }

    function reset(){
        let f = fadeTime
        timeout.restart()
        fadeTime = 0
        opacity = 0
        fadeTime = f
    }
}
