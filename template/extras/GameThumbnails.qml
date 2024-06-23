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

// Thank you to VGmove creator of EasyLaunch <https://github.com/VGmove/EasyLaunch>
// for the collection logos, images, audio, and various functionality


import QtQuick 2.0
import "../../utils.js" as U

Item {
    Component {
        id: gameThumb
        //Game Banner Wrapper
        Item {
            id: bannerWrapper
            width: gameView.cellWidth
            height: gameView.cellHeight
            property var gameData: search.currentGame(gameView.currentIndex)

            Image { //BANNER
            
                id: banner
                source: getAssets(assets).banner != "default" ? getAssets(assets).banner : "../../assets/" + settings.defaultGameImage
                opacity: 0
                smooth: true
                asynchronous: true

                anchors.fill: parent
                anchors.margins: vpx(12)

                fillMode: settings.croppedThumbnails.includes(currentCollection.shortName) ? Image.PreserveAspectCrop:Image.PreserveAspectFit
                
                scale: parent.activeFocus ? 1.03 : 1

                Behavior on scale {NumberAnimation {duration: 100}}

                onStatusChanged: {
                    if (banner.status === Image.Ready) { 
                        banner.state = "bannerLoaded"
                    }
                }

                states: State {
                    name: "bannerLoaded"
                    PropertyChanges { target: banner; opacity: 1 }
                }

                transitions: Transition {
                    NumberAnimation { 
                        properties: "opacity"
                        duration: 1000
                        easing.type: Easing.EaseInOut
                    }
                }

                Item{
                    id: game_title_text_bu
                    anchors.fill: parent
                    clip: true
                    visible: !(getAssets(assets).banner != "default")

                    Rectangle {
                        anchors.fill: game_title
                        anchors.margins: vpx(-6)
                        color: U.addAlphaToHex(0.9, p.black)
                        radius: vpx(6)
                    }

                    Text {
                        id: game_title
                        text: title
                        color: p.white

                        anchors.centerIn: parent


                        font.family: regular.name
                        font.pixelSize: vpx(24)

                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight

                        Component.onCompleted: {
                            if(game_title.width > banner - 24){
                                game_title.width = (banner - 24)
                            }
                            if(game_title.height > banner - 24){
                                game_title.height = (banner - 24)
                            }
                        }
                    }
                }

                Rectangle { //BORDER
                    id: border
                    color: "transparent"
                    height: (parent.height < banner.paintedHeight ? parent.height : banner.paintedHeight) + vpx(12)
                    width: (parent.width < banner.paintedWidth ? parent.width : banner.paintedWidth) + vpx(12)
                    anchors.centerIn: parent
                    border.color: Qt.hsla(1,1,1,0.6)
                    border.width: parent.parent.activeFocus ? vpx(6) : vpx(0)

                    radius: vpx(3)
                }

                Rectangle { //FAVORITE ICON
                    id: favorite_icon

                    anchors.right: parent.right
                    anchors.rightMargin: parent.width > parent.paintedWidth ? ((parent.width - banner.paintedWidth)/2) - vpx(6) : vpx(-6)
                    anchors.top: parent.top
                    anchors.topMargin: vpx(-6)

                    height: vpx(16)
                    width: vpx(16)

                    radius: vpx(100)
                    
                    visible: favorite

                    color: p.accent

                    Image {
                        source: "../../assets/img/heart_filled.svg"
                        anchors.fill: parent
                        anchors.margins: vpx(4)
                        fillMode: Image.PreserveAspectFit
                    }
                }

                MouseArea { //CLICK
                    id: gameClick
                    cursorShape: Qt.PointingHandCursor

                    anchors.fill: border
                    
                    onClicked: {
                        collectionsList.close()
                        g.g.currentIndex = index
                        f = "games"
                        g.g.forceActiveFocus()
                        select.play()
                    }

                    onDoubleClicked: {
                        currentGame.launch()
                        if(settings.lastPlayed){
                            api.memory.set("collectionIndex", c.i)
                            api.memory.set("gameIndex", g.i)
                        }
                        toggle_down.play()
                    }
                }
            }

            Image {//LOADING IMAGE
                source: "../../assets/img/loading.png"
                visible: banner.status != Image.Ready

                anchors.centerIn: parent

                NumberAnimation on rotation {

                    from: 0
                    to: 360

                    duration: 1000

                    loops: Animation.Infinite
                }
            }
        }
    }
    property Component thumb: gameThumb
}