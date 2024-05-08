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

Item {

    id: info
    width: parent.width
    height: parent.height

    anchors.bottom: parent.top

    states: State {
        name: "opened"
        PropertyChanges{target: info; anchors.bottom: parent.bottom}
    }


    MouseArea {
        id: info_panel_prevent
        anchors.fill: parent

        enabled: parent.state === "opened"

        onClicked: {
            U.toggleInfo("gameView")
        }

        onWheel: {
            mouse.event = accept
        }
    }

    Rectangle{

        id: infoWrapper

        color: Qt.hsla(0,0,0,0.45)

        anchors {

            top: parent.top
            left: parent.left
            leftMargin: parent.width
            bottom: parent.bottom

        }

        width: parent.width * 0.5

        state: parent.state

        states: State {
            name: "opened"
            PropertyChanges { target: infoWrapper; anchors.leftMargin: parent.width * 0.5 }
        }

        transitions: Transition{
            NumberAnimation { 
                properties: "anchors.leftMargin"
                duration: 150 
                easing.type: Easing.EaseInOut
            }
        }

        property Video video: videoWrapper.video
        property Rectangle videoWrapper: videoWrapper

        //Prevents clicking the panel from closing the panel
        MouseArea{

            anchors.fill: parent

            onClicked: {
                mouse.accepted = true
            }

        }
        
        //Video Wrapper
        Rectangle{

            id: videoWrapper

            color: "transparent"

            anchors{

                top: parent.top
                topMargin: vpx(12)

                left: parent.left
                leftMargin: vpx(48)

                right: parent.right
                rightMargin: vpx(48)

            }

            property Video video: videoPreview
            
            height: videoPreview.source != "" ? videoWrapper.width / 1.778 : 0
            //Game Video
            Video{

                id: videoPreview
                source: currentGame.assets.video

                fillMode: VideoOutput.PreserveAspectCrop
                anchors.fill: parent

                muted: settings.videoMute
                volume: settings.videoVolume
                loops: MediaPlayer.Infinite

            }
            
            Image {

                source: "assets/img/loading.png"
                visible: videoPreview.status === MediaPlayer.Loading

                anchors.centerIn: parent

                NumberAnimation on rotation {

                    from: 0
                    to: 360

                    duration: 1000

                    loops: Animation.Infinite

                }

            }

            //Allow pausing and playing by clicking video
            MouseArea {
                id:videoControls

                anchors.fill: parent

                hoverEnabled: true

                onClicked: {
                    videoPreview.playbackState === MediaPlayer.PlayingState ? videoPreview.pause() : videoPreview.play()
                    toggle.play()
                }

                onEntered: {
                    videoSound.state = "videoHovered"
                    muteIcon.state = "videoHovered"
                }

                onExited: {
                    videoSound.state = ""
                    muteIcon.state = ""
                }
            }

            //Mute button
            MouseArea {
                id: videoSound
                enabled: false

                
                anchors {
                    bottom: parent.bottom
                    bottomMargin: vpx(12)

                    right: parent.right
                    rightMargin: vpx(12)
                }

                height: vpx(24)
                width: vpx(24)


                states: State {
                    name: "videoHovered"
                    PropertyChanges { 
                        target: videoSound;
                        enabled: true 
                    }
                }

                onClicked: {
                    videoPreview.muted ? videoPreview.muted = false : videoPreview.muted = true
                    mouse.accepted = true
                    select.play()
                }

                Image {
                    id: muteIcon
                    source: videoPreview.muted ? "../assets/img/mute.png" : "../assets/img/sound.png"
                    anchors.fill: parent

                    opacity: 0

                    states: State {
                        name: "videoHovered"
                        PropertyChanges { 
                            target: muteIcon;
                            opacity: 1 
                        }
                    }

                    transitions: Transition {
                        NumberAnimation {
                            properties: "opacity"
                            duration: 250 
                            easing.type: Easing.EaseInOut
                        }
                    }
                }
            }
        }
        //Info Text Wrapper
        Rectangle{
            
            id: gameInfo

            color: Qt.hsla(0,0,0,0.65)

            anchors{

                top: videoWrapper.bottom
                topMargin: vpx(12)

                left: parent.left
                leftMargin: vpx(12)

                right: parent.right
                rightMargin: vpx(12)

                bottom: parent.bottom
                bottomMargin: vpx(12)

            }

            //Game Logo Wrapper
            Item{
                
                id: gameLogoWrapper

                height: gameLogo.source != "" ? vpx(100) : vpx(65)
                
                anchors{

                    top: parent.top
                    topMargin: vpx(6)

                    left: parent.left
                    leftMargin: vpx(6)

                    right: parent.right
                    rightMargin: vpx(6)

                }

                clip: true

                //Game Logo
                Image{

                    id: gameLogo
                    source: currentGame.assets.logo

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit

                }

                Text {
                    id: gameTitle
                    anchors.fill: parent

                    visible: currentGame.assets.logo === ""

                    text: currentGame.title
                    color: "white"

                    font.pixelSize: vpx(48)
                    font.family: bold.name

                    horizontalAlignment: Text.AlignHCenter

                    elide: Text.ElideRight
                }
            }

            //Game Developer Textbox
            Text{

                id: gameDeveloper

                anchors{

                    top: gameLogoWrapper.bottom
                    topMargin: vpx(6)

                    left: parent.left
                    leftMargin: vpx(12)

                    right: parent.right
                    rightMargin: vpx(12)

                }

                height: text != "" ? vpx(36) : 0

                text: if(currentGame.developer != "" ) {
                    if (currentGame.publisher != "" && currentGame.publisher != currentGame.developer){
                        currentGame.developer + " / " + currentGame.publisher
                    } else {
                        currentGame.developer
                    }
                } else { 
                    if(currentGame.publisher != ""){
                        currentGame.publisher
                    } else {
                        ""
                    }
                }
                
                

                font.family: bold.name
                font.pixelSize: vpx(24)

                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                
                color: "white"
                
                elide: Text.ElideRight

            }

            //Game Description Textbox
            Text{

                id: gameDescription

                anchors{

                    top: gameDeveloper.bottom
                    topMargin: vpx(6)

                    left: parent.left
                    leftMargin: vpx(12)

                    right: parent.right
                    rightMargin: vpx(12)

                    bottom: parent.bottom
                    bottomMargin: vpx(12)

                }

                text: currentGame.description != "" ? currentGame.description : "No information to display..."
                
                font.family: regular.name
                font.pixelSize: vpx(20)
                font.italic: currentGame.description != "" ? false : true
                
                verticalAlignment: Text.AlignTop
                
                color: "white"
                
                wrapMode: Text.WordWrap
                elide: Text.ElideRight

            }

        }
    }
    property Rectangle info: infoWrapper
    property Rectangle videoWrapper: infoWrapper.videoWrapper
    property Video video: infoWrapper.videoWrapper.video
}