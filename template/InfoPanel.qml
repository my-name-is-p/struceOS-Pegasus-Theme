// struceOS
// Copyright (C) 2024 strucep
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import QtMultimedia 5.9
import "../utils.js" as U
import "extras"

Rectangle {
    id: info_outer_wrapper
    height: parent.height
    width: parent.width
    anchors.bottom: parent.top
    color: settings.colors.black75

    property var currentItem: play_button

    states: State {
        name: "opened"
        PropertyChanges{target: info; anchors.bottom: parent.bottom}
    }

    MouseArea {
        id: info_panel_prevent
        anchors.fill: parent

        onClicked: {
            mouse.event = accept
        }

        onWheel: {
            mouse.event = accept
        }
    }

    Rectangle {
        id: info_inner_wrapper
        height: parent.height - vpx(48)
        width: video.source != "" ? parent.width - vpx(48) : vpx(548)
        anchors.centerIn: parent
        color: settings.colors.black90
        
        radius: vpx(6)

        CloseButton {
            id: info_panel_close

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: vpx(12)

            borderOn: !(info_outer_wrapper.currentItem != this)

            property var controls: {
                "name" : "close",
                "up" : null,
                "down" : play_button,
                "left" : null,
                "right" : favorite_button
            }
        }

        Rectangle { //favorite_button
            id: favorite_button

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: vpx(12)

            height: vpx(48)
            width: vpx(48)

            radius: vpx(48)

            color: "transparent"

            border.width: vpx(4)
            border.color: currentGame.favorite ? "transparent" : settings.colors.white

            property var controls: {
                "name" : "favorite",
                "up" : null,
                "down" : video_wrapper.visible ? video : play_button,
                "left" : info_panel_close,
                "right" : null
            }

            Rectangle { 
                id: favorite_border
                anchors.fill: parent
                anchors.margins: vpx(-3)
                color: "transparent"

                visible: !(info_outer_wrapper.currentItem != parent)

                border.color: Qt.hsla(1,1,1,0.6)
                border.width: vpx(3)
                radius: vpx(6)
            }

            Rectangle {
                id: favorite_button_hover
                color: settings.colors.martinique
                anchors.fill: favorite_button
                radius: vpx(100)

                opacity: currentGame.favorite ? 1 : 0

                transitions: Transition {
                    NumberAnimation {
                        properties: "opacity"
                        duration: 150 
                        easing.type: Easing.EaseInOut
                    }
                }
            }

            Image {
                source: currentGame.favorite ? "../assets/img/heart_filled.svg" : "../assets/img/heart_empty.svg"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                height: vpx(20)
            }



            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    currentGame.favorite = !currentGame.favorite
                    toggle_up.play()
                }
            }

        }

        Item {  //info_safe_area
            id: info_safe_area
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: play_button.top
            anchors.margins: vpx(48)
            anchors.bottomMargin: vpx(24)


            Item { //text_info_wrapper
                id: text_info_wrapper

                height: parent.height
                width: vpx(452)

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: video.source != "" ? vpx(24) : 0

                Item{
                    id: logo_rating
                    width: parent.width
                    height: vpx(176)


                    Image { //logo
                        id: logo
                        source: currentGame.assets.logo
                        fillMode: Image.PreserveAspectFit

                        height: vpx(140)
                        width: parent.width

                        anchors.top: parent.top
                        anchors.left: parent.left

                        Text {
                            text: currentGame.title
                            color: "#ffffff"
                            font.family: bold.name
                            font.bold: true
                            font.pixelSize: vpx(36)
                            anchors.centerIn: parent
                            elide: Text.ElideRight
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter

                            wrapMode: Text.WordWrap

                            visible: currentGame.assets.logo === ""
                        }
                    }

                    Image {
                        id: stars_empty
                        width: vpx(144)
                        height: vpx(24)
                        source: "../assets/img/star_empty.svg"
                        fillMode: Image.PreserveAspectFit
                        
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Image {
                        id: stars_filled
                        width: currentGame.rating * vpx(144)
                        height: vpx(24)
                        source: "../assets/img/star_filled.svg"
                        fillMode: Image.PreserveAspectCrop
                        horizontalAlignment: Image.AlignLeft
                        
                        anchors.bottom: parent.bottom
                        anchors.left: stars_empty.left
                    }

                }

                Rectangle { //separator
                    color: Qt.rgba(255, 255, 255, 0.5)
                    width: parent.width
                    height: vpx(2)
                    anchors.top: logo_rating.bottom
                    anchors.topMargin: vpx(9)
                }
            
                Rectangle {
                    id: details_wrapper
                    color: "transparent"
                    width: parent.width
                    height: infoDetails_list.items * 26 > 48 ? vpx(infoDetails_list.items * 26) : vpx(48)

                    anchors.top: logo_rating.bottom
                    anchors.topMargin: vpx(20)

                    Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: parent.height

                        InfoDetailsList {
                            id: infoDetails_list
                        }
                    }
                }

                Rectangle { //separator
                    color: Qt.rgba(255, 255, 255, 0.5)
                    width: parent.width
                    height: vpx(2)
                    anchors.top: details_wrapper.bottom
                    anchors.topMargin: vpx(9)
                }

                Rectangle { //summary
                    id: summary_wrapper
                    color: "transparent"
                    width: parent.width

                    anchors.top: details_wrapper.bottom
                    anchors.topMargin: vpx(20)
                    anchors.bottom: parent.bottom

                    clip: true

                    Text {
                        id: summary
                        text: currentGame.summary != "" ? 
                                currentGame.summary : 
                                currentGame.description != "" ? 
                                    currentGame.description : 
                                    "No description..."
                        wrapMode: Text.WordWrap
                        width: parent.width
                        height: parent.height

                        font.family: regular.name
                        font.pixelSize: vpx(18)
                        elide: Text.ElideRight
                        color: "#ffffff"
                    }
                }
            }

            Item { //video_wrapper
                id: video_wrapper

                anchors.top: parent.top
                anchors.left: text_info_wrapper.right
                anchors.leftMargin: vpx(24)
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                visible: video.source != "" ? true : false

                Video{ //video
                    id: video
                    source: currentGame.assets.video
                    width: parent.width
                    height: video.width / 1.778
                    fillMode: VideoOutput.PreserveAspectFit
                    anchors.centerIn: parent

                    muted: settings.videoMute
                    volume: settings.videoVolume
                    loops: MediaPlayer.Infinite

                    property var controls: {
                        "name" : "video",
                        "up" : favorite_button,
                        "down" : play_button,
                        "left" : info_panel_close,
                        "right" : mute_button
                    }

                    Rectangle { 
                        id: video_border
                        anchors.fill: parent
                        anchors.margins: vpx(-6)
                        color: "transparent"

                        visible: !(info_outer_wrapper.currentItem != parent)

                        border.color: settings.colors.border
                        border.width: vpx(6)
                        radius: vpx(6)
                    }


                    Image {
                        anchors.fill: parent

                        source: "../assets/img/no_image.png"
                        fillMode: Image.PreserveAspectFit

                        visible: video.error != MediaPlayer.NoError ? 
                            true : 
                            false
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            video.playbackState === 1 ? video.pause() : video.play()
                            toggle_up.play()
                        }

                        onEntered: {
                            video_play_icon.hovered = true
                        }

                        onExited: {
                            video_play_icon.hovered = false
                        }

                        Image { //video_play_icon
                            id: video_play_icon
                            anchors.centerIn: parent
                            source: video.playbackState === 1 ? "../assets/img/pause.svg" : "../assets/img/play.svg"
                            width: vpx(96)
                            height: width
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            antialiasing: true

                            opacity: 0

                            property bool hovered: false

                            states: State{
                                name: "hover"
                                PropertyChanges{target: video_play_icon; opacity: 0.9}
                            }
                            
                            state: {
                                if(info_outer_wrapper.currentItem != video && info_outer_wrapper.currentItem != mute_button){ 
                                    return video_play_icon.hovered ? "hover" : ""
                                 } else {
                                    return "hover"
                                 }
                            }


                            transitions: Transition {
                                NumberAnimation {
                                    properties: "opacity"
                                    duration: 150 
                                    easing.type: Easing.EaseInOut
                                }
                            }

                        }

                        MouseArea {
                            id: mute_button

                            width: vpx(24)
                            height: width
                            cursorShape: Qt.PointingHandCursor

                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: vpx(12)

                            property var controls: {
                                "name" : "mute",
                                "up" : video,
                                "down" : play_button,
                                "left" : video,
                                "right" : null
                            }

                            onClicked: {
                                video.muted = !video.muted
                                toggle_up.play()
                            }

                            Rectangle { 
                                id: mute_border
                                anchors.fill: parent
                                anchors.margins: vpx(-3)
                                color: "transparent"

                                visible: !(info_outer_wrapper.currentItem != parent)

                                border.color: Qt.hsla(1,1,1,0.6)
                                border.width: vpx(3)
                                radius: vpx(6)
                            }


                            Image {
                                id: mute_icon
                                anchors.fill: parent
                                source: video.muted ? "../assets/img/mute.png" : "../assets/img/sound.png"

                                opacity: 0
                                states: State{
                                    name: "hover"
                                    PropertyChanges{target: mute_icon; opacity: 0.9}
                                }
                                
                                state: video_play_icon.state 

                                transitions: Transition {
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: 150 
                                        easing.type: Easing.EaseInOut
                                    }
                                }
                                

                            }
                        }
                    }
                }
            }
        }

        Rectangle { //play_button
            id: play_button
            color: settings.colors.green
            height: vpx(48)

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: vpx(24)

            radius: vpx(6)

            state: hovered ? 
                    "selected" :
                    info_outer_wrapper.currentItem != this ? 
                        "" : 
                        "selected"

            property bool hovered: false

            states: [
                State {
                    name: "selected"
                    PropertyChanges{target: play_button; color: "#1e824c"}
                }
            ]

            property var controls: {
                "name" : "play",
                "up" : video_wrapper.visible ? video : info_panel_close,
                "down" : null,
                "left" : info_panel_close,
                "right" : video_wrapper.visible ? video : favorite_button
            }


            Rectangle {
                id: button_label
                anchors.centerIn: parent

                width: game_launch_icon.width + game_launch_text.width + vpx(6)
                Image {
                    id: game_launch_icon
                    height: vpx(24)
                    width: vpx(24)

                    source: play_button.state != "selected" ? "../assets/img/play_alt.svg" : "../assets/img/play_alt_filled.svg"

                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    id: game_launch_text
                    text: "launch"
                    color: "#ffffff"
                    font.family: regular.name
                    font.pixelSize: vpx(24)

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: game_launch_icon.right
                    anchors.leftMargin: vpx(6)
                }
            }

            Rectangle { //game_launch_border
                id: game_launch_border
                anchors.fill: parent
                color: "transparent"

                visible: parent.state != "selected" ? false : true

                border.color: settings.colors.border
                border.width: vpx(3)
                radius: vpx(6)
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                hoverEnabled: true

                onClicked: {
                    toggle_down.play()
                    if(settings.lastPlayed){
                        api.memory.set("collectionIndex", currentCollectionIndex)
                        api.memory.set("gameIndex", games.gameView.currentIndex)
                    }
                    currentGame.launch()
                }

                onEntered: {
                    play_button.hovered = true
                }

                onExited: {
                    play_button.hovered = false
                }
            }
        }
    }
    property Rectangle play_button: play_button 
    property ListModel detailsModel: infoDetails_list.detailsModel
    property Video video: video
}