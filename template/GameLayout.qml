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

    GridView { //gameView
        id: gameView
        delegate: gameThumb
        model: search.games
        anchors.fill: parent

        interactive: true
        clip: true

        cellWidth: parent.width / settings.columns
        cellHeight: cellWidth * 0.6

        keyNavigationWraps: false
        highlightMoveDuration: 100
        highlightFollowsCurrentItem: true

        
        onCurrentIndexChanged: { // new game selected
            if(!mouseSelect)
                select.play()
            if(loadTimeout){
                U.changeGame()
                if(!settings.lastPlayed){
                    api.memory.set("collectionIndex", currentCollectionIndex)
                    api.memory.set("gameIndex", gameView.currentIndex)
                }
            }
            mouseSelect = false
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
                source: U.getAsset(gameData, assets, "banner")
                //U.getAsset(gameData, assets, "banner")
                //assets.banner != "" ? assets.banner : assets.logo != "" ? assets.logo : "../assets/img/none.jpg"
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

                    Rectangle {

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
                    U.removeButtonFocusOnClick("header")
                    if(header.searchbox.state === "opened") 
                        header.searchTerm.focus = false;
                    select.play()
                }

                onDoubleClicked: {
                    parent.gameData.launch()
                    if(settings.lastPlayed){
                        api.memory.set("collectionIndex", currentCollectionIndex)
                        api.memory.set("gameIndex", gameView.currentIndex)
                    }
                    select.play()
                }

            }
        }
    }
    property GridView gameView: gameView
}




