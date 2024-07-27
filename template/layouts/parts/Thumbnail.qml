// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "../../widgets"

Component {
    Item {
        id: thumb

        property GridView games: parent.parent

        width: games.cellWidth
        height: games.cellHeight

        property bool active: index === games.currentIndex && games.active ? true : false
        property bool hovered: false

        property real radius: vpx(10) 
        property int transition_speed: 100

        property string name: title


        Item {
            id: thumb_padding
            anchors.fill: parent
            anchors.margins: vpx(12)

            scale: thumb.active ? 1.05 : 1

            Behavior on scale {NumberAnimation {duration: thumb.transition_speed}}

            Rectangle { //thumb_border
                id: thumb_border
                anchors.fill: parent
                anchors.margins: thumb.active ? vpx(-8) : vpx(0)

                color: addAlphaToHex(0.4, colors.black)

                radius: vpx(10)
                border.color: colors.border
                border.width: thumb.active ? vpx(10) : 0

                Behavior on border.width {NumberAnimation {duration: thumb.transition_speed}}
                Behavior on anchors.margins {NumberAnimation {duration: thumb.transition_speed}}
            }


            Rectangle { //mask
                id: mask
                anchors.fill: parent
                radius: vpx(6)

                visible: false
            }

            Item { //to_mask
                id: to_mask
                anchors.fill: parent
                visible: false

                Image { //thumb_bg
                    id: thumb_bg
                    anchors.fill: parent
                    source: {
                        if(!settings.showThumbs)
                            return ""
                        else
                            return getAssets(assets).bg != "default" ? getAssets(assets).bg : images.noImage
                    }

                    asynchronous: true
                    smooth: true

                    fillMode: Image.PreserveAspectCrop

                    scale: thumb.hovered || thumb.active ? 1 : 1.3

                    Behavior on scale {NumberAnimation {duration: thumb.transition_speed * 1.25}}

                }

                GaussianBlur { //thumb_blur
                    id: thumb_blur

                    anchors.fill: thumb_bg
                    source: thumb_bg

                    opacity: thumb.hovered || thumb.active ? 0 : 1

                    radius: 8
                    samples: 16
                    scale: thumb.hovered || thumb.active ? 1 : 1.3

                    Behavior on opacity {NumberAnimation {duration: thumb.transition_speed * 1.25}}
                    Behavior on scale {NumberAnimation {duration: thumb.transition_speed * 1.25}}
                }

                Item { //FAVORITE ICON
                    id: favorite_icon

                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: vpx(6)

                    height: vpx(16)
                    width: vpx(16)


                    Image {
                        id: icon
                        source: images.favorite_icon_filled
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        
                        visible: false
                    }

                    DropShadow {
                        anchors.fill: parent
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 17
                        color: addAlphaToHex(0.4, colors.black)
                        source: icon

                        visible: favorite
                    }

                }

                Item { //logo_wrapper
                    id: logo_wrapper

                    anchors.fill: parent
                    anchors.margins: vpx(6)

                    Image { //logo
                        id: logo
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height/1.25
                        source: getAssets(assets).logo != "default" ? getAssets(assets).logo : ""

                        asynchronous: true
                        smooth: true

                        fillMode: Image.PreserveAspectFit

                        visible: false
                    }

                    Rectangle {
                        width: parent.width
                        height: logo_text.height
                        color: colors.black

                        visible: logo.source == ""

                        anchors.centerIn: parent

                        Text {
                            id: logo_text
                            text: title
                            color: colors.white

                            font.family: bold.name
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }

                    DropShadow { //logo_shadow
                        id: logo_shadow

                        anchors.fill: logo
                        horizontalOffset: 3
                        verticalOffset: 3
                        radius: 8
                        samples: 16
                        color: colors.black
                        source: logo

                        scale: thumb.hovered || thumb.active ? 1.0 : 0.8

                        Behavior on scale {NumberAnimation {duration: thumb.transition_speed * 2}}
                    }
                }
            }

            OpacityMask {
                anchors.fill: parent
                opacity: {
                    if(settings.showThumbs){
                        if(logo.source != "")
                            return thumb_bg.status === Image.Ready && logo.status === Image.Ready ? 1 : 0
                        else 
                            return thumb_bg.status === Image.Ready ? 1 : 0
                    }else{
                        if(logo.source != "")
                            return logo.status === Image.Ready ? 1 : 0
                    }
                }
                source: to_mask
                maskSource: mask

                Behavior on opacity {NumberAnimation {duration: f_speed}}
            }

            Rectangle { //last_played
                id: last_played

                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: vpx(6)

                width: last_played_text.width + vpx(6)
                height: last_played_text.height + vpx(6)
                color: addAlphaToHex(0.8, colors.black)

                radius: vpx(6)

                visible: sortfilt_menu.last_played.enabled

                Text {
                    id: last_played_text
                    text: "last played: " + (lastPlayed.toLocaleDateString(Locale.LongFormat) != "" ? lastPlayed.toLocaleDateString(Locale.LongFormat) : "never")
                    font.family: regular.name
                    font.pixelSize: vpx(12)
                    color: colors.white
                    anchors.centerIn: parent
                }
            }

            Rectangle { //play_time
                id: play_time

                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: vpx(6)

                width: play_time_text.width + vpx(6)
                height: play_time_text.height + vpx(6)
                color: addAlphaToHex(0.8, colors.black)

                radius: vpx(6)

                visible: sortfilt_menu.play_time.enabled

                Text {
                    id: play_time_text
                    text: "play time: " + getTime(playTime)
                    font.family: regular.name
                    font.pixelSize: vpx(12)
                    color: colors.white
                    anchors.centerIn: parent

                    function getTime(t){
                        let h = Math.floor((t / (60 * 60)) % 24)
                        let m = Math.floor((t / 60) % 60)
                        let s = Math.floor(t % 60)

                        h = (h < 10) ? "0" + h : h
                        m = (m < 10) ? "0" + m : m
                        s = (s < 10) ? "0" + s : s
                        t = h + "hr " + m + "m " + s + "s"
                        return t
                    }
                }

            }

            MouseArea { //thumb_mouse
                id: thumb_mouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: {
                    thumb.hovered = true
                }

                onExited: {
                    thumb.hovered = false
                }

                onClicked: {
                    f = header
                    f = game_layout
                    header.current = header.collection
                    games.currentIndex = index
                    audio.stopAll()
                    audio.select.play()
                    mouse.event = accept
                }

                onDoubleClicked: {
                    audio.stopAll()
                    audio.toggle_down.play()
                    launch_window.visible = true
                    if(settings.lastPlayed){
                        api.memory.set("collectionIndex", currentCollectionIndex)
                        api.memory.set("gameIndex", games.currentIndex)
                    }
                    currentGame.launch()
                    mouse.event = accept
                }
            }
        }

        LoadingGraphic {
            anchors.centerIn: parent
            opacity: {
                if(settings.showThumbs){
                    if(logo.source != "")
                        return thumb_bg.status === Image.Ready && logo.status === Image.Ready ? 0 : 0.8
                    else 
                        return thumb_bg.status === Image.Ready ? 0 : 0.8
                }else{
                    if(logo.source != "")
                        return logo.status === Image.Ready ? 0 : 0.8
                    else
                        return 0
                }
            }
            
            // thumb_bg.status != Image.Ready || (logo.status != Image.Ready && logo.source != "") ? 0.8 : 0
            
        }
    }
}
