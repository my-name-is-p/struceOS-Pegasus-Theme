// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "../../../widgets"

Component {
    Item {
        id: thumb

        property GridView games: undefined

        width: games.cellWidth
        height: games.cellHeight

        property bool active: index === games.currentIndex && games.active ? true : false
        property bool hovered: false

        property real radius: vpx(10) 
        property int transition_speed: 100

        property string name: title

        Component.onCompleted: {
            games = parent.parent
        }

        Item { //thumb_padding
            id: thumb_padding

            anchors.fill: thumb
            anchors.margins: vpx(12)

            scale: thumb.active ? 1.05 : 1
            Behavior on scale {NumberAnimation {duration: thumb.transition_speed}}

            Rectangle { //thumb_border
                id: thumb_border

                anchors.fill: thumb_padding
                anchors.margins: thumb.active ? vpx(-8) : vpx(0)
                Behavior on anchors.margins {NumberAnimation {duration: thumb.transition_speed}}

                color: addAlphaToHex(0.4, colors.black)

                radius: vpx(10)
                border.color: colors.border
                border.width: thumb.active ? vpx(10) : 0
                Behavior on border.width {NumberAnimation {duration: thumb.transition_speed}}
            }

            Rectangle { //mask
                id: mask

                anchors.fill: thumb_padding
                
                radius: vpx(6)

                visible: false
            }

            Item { //to_mask
                id: to_mask
                anchors.fill: thumb_padding
                visible: false

                Image { //thumb_bg
                    id: thumb_bg
                    source: {
                        if(!settings.showThumbs)
                            return ""
                        else
                            return getAssets(assets).bg != "default" ? getAssets(assets).bg : images.noImage
                    }
                    
                    anchors.fill: to_mask

                    asynchronous: true
                    smooth: true

                    sourceSize.width: games.cellWidth
                    sourceSize.height: games.cellHeight

                    fillMode: Image.PreserveAspectCrop

                    scale: thumb.hovered || thumb.active ? 1 : 1.3
                    Behavior on scale {NumberAnimation {duration: thumb.transition_speed * 1.25}}
                }

                GaussianBlur { //thumb_blur
                    id: thumb_blur
                    
                    anchors.fill: thumb_bg
                    source: thumb_bg

                    opacity: thumb.hovered || thumb.active ? 0 : 1
                    Behavior on opacity {NumberAnimation {duration: thumb.transition_speed * 1.25}}

                    radius: 8
                    samples: 16
                    scale: thumb.hovered || thumb.active ? 1 : 1.3
                    Behavior on scale {NumberAnimation {duration: thumb.transition_speed * 1.25}}
                }

                Item { //favorite_icon
                    id: favorite_icon

                    anchors.top: thumb_bg.top
                    anchors.right: thumb_bg.right
                    anchors.margins: vpx(6)

                    height: vpx(16)
                    width: vpx(16)

                    Image { //icon
                        id: icon
                        source: images.favorite_icon_filled

                        anchors.fill: favorite_icon

                        fillMode: Image.PreserveAspectFit
                        
                        visible: false
                    }

                    DropShadow { //icon_shadow
                        id: icon_shadow
                        anchors.fill: favorite_icon
                        source: icon

                        color: addAlphaToHex(0.4, colors.black)
                        horizontalOffset: 0
                        verticalOffset: 0
                        radius: 8.0
                        samples: 17

                        visible: favorite
                    }
                }

                Item { //logo_wrapper
                    id: logo_wrapper

                    anchors.fill: to_mask
                    anchors.margins: vpx(6)

                    Image { //logo
                        id: logo
                        source: getAssets(assets).logo != "default" ? getAssets(assets).logo : ""

                        anchors.centerIn: logo_wrapper

                        width: logo_wrapper.width
                        height: logo_wrapper.height/1.25

                        asynchronous: true
                        smooth: true

                        sourceSize.width: parent.width
                        sourceSize.height: parent.height

                        fillMode: Image.PreserveAspectFit

                        visible: false
                    }

                    Rectangle { //logo_text_backup
                        id: logo_text_backup
                        anchors.centerIn: logo_wrapper

                        width: logo_wrapper.width
                        height: logo_text.height

                        color: colors.black

                        visible: logo.source == ""

                        Text { //logo_text_backup
                            id: logo_text
                            text: title
                            color: colors.white

                            font.family: bold.name
                            font.bold: true
                            anchors.centerIn: logo_text_backup
                        }
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

                        scale: thumb.hovered || thumb.active ? 1.0 : 0.8
                        Behavior on scale {NumberAnimation {duration: thumb.transition_speed * 2}}
                    }
                }
            }

            OpacityMask { //thumb_out
                id: thumb_out
                anchors.fill: thumb_padding

                source: to_mask
                maskSource: mask

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
                Behavior on opacity {NumberAnimation {duration: 200}}
            }

            Rectangle { //sort_info
                id: sort_info

                anchors.bottom: thumb_padding.bottom
                anchors.right: thumb_padding.right
                anchors.margins: vpx(6)

                width: sort_info_text.width + vpx(6)
                height: sort_info_text.height + vpx(6)

                color: addAlphaToHex(0.8, colors.black)
                radius: vpx(6)

                visible: sortfilt_menu.last_played.enabled || sortfilt_menu.play_time.enabled

                Text { //sort_info_text
                    id: sort_info_text
                    text: {
                        if(sortfilt_menu.last_played.enabled){
                            return "last played: " + 
                                (lastPlayed.toLocaleDateString(Locale.LongFormat) != "" ? 
                                    lastPlayed.toLocaleDateString(Locale.LongFormat) : "never")
                        }if(sortfilt_menu.play_time.enabled){
                            return "play time: " + getTime(playTime)
                        }else{
                            return ""
                        }
                    }

                    anchors.centerIn: sort_info

                    color: colors.white
                    font.family: regular.name
                    font.pixelSize: vpx(12)

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

                anchors.fill: thumb_padding

                hoverEnabled: true

                cursorShape: Qt.PointingHandCursor

                onPositionChanged: {
                    screensaver.reset()
                }

                onEntered: {
                    thumb.hovered = true
                }

                onExited: {
                    thumb.hovered = false
                }

                onClicked: {
                    resetFocus()
                    games.currentIndex = index
                    audio.stopAll()
                    audio.select.play()
                }

                onDoubleClicked: {
                    launchGame()
                    audio.stopAll()
                    audio.toggle_down.play()
                }
            }
        }

        LoadingGraphic { //thumb_load
            id: thumb_load
            anchors.centerIn: thumb
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
        }
    }
}
