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
import "../utils.js" as U
import "extras"

Rectangle { //games
    id: games
    anchors.top: header.bottom

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    anchors.rightMargin: vpx(24)
    anchors.leftMargin: vpx(24)

    color: "transparent"

    MouseArea {
        id: gameView_scrollwheel
        anchors.fill: parent
        onWheel: {
            let speed = 12
                speed = speed / 1000
            let scrollDelta = wheel.angleDelta.y / 4;

            // Estimate vertical velocity (adjust time interval as needed)
            let yVelocity = scrollDelta / speed;

            // Call flick with estimated velocity (no horizontal velocity)
            gameView.flick(0.0, yVelocity);
        }
    }

    GridView { //gameView
        id: gameView
        delegate: gameThumb
        model: search.games
        anchors.fill: parent

        interactive: false
        clip: true

        keyNavigationWraps: false

        cellWidth: parent.width / settings.columns
        cellHeight: cellWidth * 0.6

        highlightMoveDuration: 100
        highlightFollowsCurrentItem: true

        
        onCurrentIndexChanged: { // new game selected
            if(loadTimeout){
                U.changeGame()
                if(!settings.lastPlayed){
                    api.memory.set("collectionIndex", currentCollectionIndex)
                    api.memory.set("gameIndex", gameView.currentIndex)
                }
            }
        }
    }

    Component {
        id: gameThumb
        //Game Banner Wrapper
        Item {
            id: bannerWrapper
            width: gameView.cellWidth
            height: gameView.cellHeight
            property var gameData: search.currentGame(gameView.currentIndex)

            //Game Banner Image
            Image {

                id: banner
                source: U.getAsset(gameData, assets, "banner").source
                opacity: 0

                smooth: true
                asynchronous: true

                anchors{
                    fill: parent
                    margins: vpx(12)
                }

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
                    visible: U.getAsset(gameData, assets, "banner").default

                    Rectangle {
                        anchors.fill: game_title
                        anchors.margins: vpx(-6)
                        color: settings.colors.black90
                        radius: vpx(6)
                    }

                    Text {
                        id: game_title
                        text: title
                        color: settings.colors.white

                        anchors.centerIn: parent


                        font.family: regular.name
                        font.pixelSize: vpx(24)

                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight

                        Component.onCompleted: {
                            if(game_title.width > banner.paintedWidth - 24){
                                game_title.width = (banner.paintedWidth - 24)
                            }
                        }
                    }
                }

                Item { //Highlight selected game
                    anchors{
                        top: parent.top
                        topMargin: parent.height > banner.paintedHeight ? (parent.height - banner.paintedHeight) / 2 : 0

                        right: parent.right
                        rightMargin: parent.width > banner.paintedWidth ? (parent.width - banner.paintedWidth) / 2 : 0

                        bottom: parent.bottom
                        bottomMargin: parent.height > banner.paintedHeight ? (parent.height - banner.paintedHeight) / 2 : 0

                        left: parent.left
                        leftMargin: parent.width > banner.paintedWidth ? (parent.width - banner.paintedWidth) / 2 : 0
                    }

                    Rectangle { //border

                        id: border
                        color: "transparent"

                        anchors{
                            fill: parent
                            margins: vpx(-6)
                        }

                        border.color: Qt.hsla(1,1,1,0.6)
                        border.width: parent.parent.parent.activeFocus ? vpx(6) : vpx(0)

                        radius: vpx(3)
                    }
                }

                Rectangle { //favorite_icon
                    id: favorite_icon

                    anchors.right: parent.right
                    anchors.rightMargin: parent.width > parent.paintedWidth ? ((parent.width - banner.paintedWidth)/2) - vpx(6) : vpx(-6)
                    anchors.top: parent.top
                    anchors.topMargin: vpx(-6)

                    height: vpx(24)
                    width: vpx(24)

                    radius: vpx(24)
                    
                    visible: favorite

                    color: Qt.hsla(0.79, 0.2, 0.26, 1.0)

                    Image {
                        source: "../assets/img/heart_filled.svg"
                        anchors.centerIn: parent
                        fillMode: Image.PreserveAspectFit
                        height: vpx(12)
                    }
                }

            }


            //Loading Image
            Image {

                source: "assets/img/loading.png"
                visible: banner.status === Image.Loading

                anchors.centerIn: parent

                NumberAnimation on rotation {

                    from: 0
                    to: 360

                    duration: 1000

                    loops: Animation.Infinite
                }
            }

            // Launch Game on Accept input
            Keys.onPressed: {
                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                    gameData.launch()
                    if(settings.lastPlayed){
                        api.memory.set("collectionIndex", currentCollectionIndex)
                        api.memory.set("gameIndex", gameView.currentIndex)
                    }
                    event.accepted = true;
                    toggle_down.play()
                }
            }
            
            // Select/launch game with mouse
            MouseArea {
                id: gameClick
                cursorShape: Qt.PointingHandCursor

                anchors{
                    top: parent.top
                    topMargin: parent.height > banner.paintedHeight ? (parent.height - banner.paintedHeight) / 2 : 0

                    right: parent.right
                    rightMargin: parent.width > banner.paintedWidth ? (parent.width - banner.paintedWidth) / 2 : 0

                    bottom: parent.bottom
                    bottomMargin: parent.height > banner.paintedHeight ? (parent.height - banner.paintedHeight) / 2 : 0

                    left: parent.left
                    leftMargin: parent.width > banner.paintedWidth ? (parent.width - banner.paintedWidth) / 2 : 0
                }

                onClicked: {
                    gameView.focus = true
                    gameView.currentIndex = index
                    mouseSelect = true
                    if(header.searchbox.state === "opened") 
                        header.searchTerm.focus = false;
                    select.play()
                }

                onDoubleClicked: {
                    currentGame.launch()
                    if(settings.lastPlayed){
                        api.memory.set("collectionIndex", currentCollectionIndex)
                        api.memory.set("gameIndex", gameView.currentIndex)
                    }
                    toggle_down.play()
                }

            }
        }

    }
    property GridView gameView: gameView
}



