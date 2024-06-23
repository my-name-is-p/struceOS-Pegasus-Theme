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

Rectangle {
    id: collectionsList

    height: opened ?  vpx(120) : 0

    color: p.accent

    property bool opened: false

    Behavior on height {NumberAnimation {duration: 150}}


    property ListView list: collection_list
    property ListModel model: collections_model
    clip: true

    ListModel {
        id: collections_model

        property bool showAllGames: c.all // Bound to settings.allGames

        Component.onCompleted: {
            populateModel()
        }

        function populateModel() {
            collections_model.clear() // Clear existing entries
            if(showAllGames){
                append({ name: "All Games", shortName: "allgames" })
            }
            for(var i=0; i<api.collections.count; i++) {
                append(createListElement(i))
            }
        }
        
        function createListElement(i) {
            return {
                name:       api.collections.get(i).name,
                shortName:  api.collections.get(i).shortName,
            }
        }
    }
    
    MouseArea {
        id: collection_list_scroll
        anchors.fill: collection_list
        onWheel: {
            let sound = toggle
            if(wheel.angleDelta.y < 0){
                collection_list.incrementCurrentIndex()
                if(collection_list.currentIndex <= c.end)
                sound = select
            } else {
                collection_list.decrementCurrentIndex()
                if(collection_list.currentIndex > c.start)
                sound = select
            }
            collection_list.positionViewAtIndex(collection_list.currentIndex, ListView.Beginning)
            c.i = c.all ? collection_list.currentIndex - 1 : collection_list.currentIndex
            currentCollection = c.current = U.getCollection(c.i)
            sound.play()
            g.g.currentIndex = 0
            background.bg_refresh.restart()
        }
    }
    
    ListView {
        id: collection_list

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: vpx(24)



        model: collections_model
        delegate: collectionView_list_item
        orientation: ListView.Horizontal
        leftMargin: vpx(48)
        rightMargin: vpx(48)
        height: parent.height

        spacing: vpx(36)

        highlightFollowsCurrentItem: true
        highlightMoveDuration : 0
        highlightMoveVelocity : 1000
    }

    Component {
        id: collectionView_list_item
        Item {
            height: vpx(40)
            width: logoLoaded ? collectionView_list_logo.width : collectionView_list_name.width 
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: logoLoaded ? collectionView_list_logo.horizontalCenter : collectionView_list_name.horizontalCenter

            property bool logoLoaded: collectionView_list_logo.status != Image.Error ? true : false

            Image {
                id: collectionView_list_logo
                source: "../assets/logos/" + shortName + ".svg"
                height: parent.height

                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.center

                antialiasing: true
                smooth: true
            }

            Text {
                id: collectionView_list_name
                text: name
                anchors.centerIn: parent

                color: settings.colors.white
                visible: collectionView_list_logo.status === Image.Error
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(36)
                fontSizeMode: Text.fit
            }

            Rectangle { //collectionTitle_border
                id: collectionTitle_border

                anchors.fill: parent
                anchors.margins: vpx(-12)

                color: "transparent"

                property bool hover: false

                border.color: settings.colors.border
                border.width: (collection_list.currentItem == parent && f === "collections") || hover ? vpx(3) : vpx(0)
                radius: vpx(6)

                MouseArea {
                    id: collectionTitle_click
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: {
                        parent.hover = true
                    }

                    onExited: {
                        parent.hover = false
                    }

                    onClicked: {
                        collection_list.currentIndex = index
                        c.i = c.all ? collection_list.currentIndex - 1 : collection_list.currentIndex
                        currentCollection = c.current = U.getCollection(c.i)
                        g.g.currentIndex = 0
                        f = "games"

                        collectionsList.opened = false

                        toggle_down.play()
                    }
                }
            }
        }
    }

    //CONTROLS
    Keys.onPressed: {
        let key = isNaN(parseInt(event.text)) ? gsk(event) : "number"
        if(key != undefined){
        //-- Get a number
            let n = parseInt(event.text)
            if(n == 0) {
                n = c.all ? 8 : 9
            } else {
                n = c.all ? n - 2 : n - 1
            }
            n = c.end < n ? c.end : n
        //--
            switch(key){
        //--- [START] CONTROLS
            //-- UP
                case "up":
                    header.focus = true
                    f = "header"
                    header.currentItem = header.gv_up_1
                    s = toggle
                    break
            //-- DOWN
                case "down":
                    close()
                    break
            //-- LEFT / PREVIOUS
                case "prev":
                case "left":
                    if(collection_list.currentIndex > c.start){
                        collection_list.decrementCurrentIndex()
                        g.g.currentIndex = 0
                        s = select
                    } else {
                        s = toggle
                    }
                    collection_list.positionViewAtIndex(collection_list.currentIndex, ListView.Beginning)
                    c.i = c.all ? collection_list.currentIndex - 1 : collection_list.currentIndex
                    currentCollection = c.current = U.getCollection(c.i)
                    background.bg_refresh.restart()
                    break
            //-- RIGHT / NEXT
                case "next":
                case "right":
                    if(collection_list.currentIndex < (c.all ? c.end + 1 : c.end)){
                        collection_list.incrementCurrentIndex()
                        g.g.currentIndex = 0
                        s = select
                    } else {
                        s = toggle
                    }
                    collection_list.positionViewAtIndex(collection_list.currentIndex, ListView.Beginning)
                    c.i = c.all ? collection_list.currentIndex - 1 : collection_list.currentIndex
                    currentCollection = c.current = U.getCollection(c.i)
                    background.bg_refresh.restart()
                    break
            //-- FIRST
                case "first":
                    collection_list.currentIndex = 0
                    collection_list.positionViewAtIndex(collection_list.currentIndex, ListView.Beginning)
                    c.i = c.all ? collection_list.currentIndex - 1 : collection_list.currentIndex
                    currentCollection = c.current = U.getCollection(c.i)
                    g.g.currentIndex = 0
                    break
            //-- LAST
                case "last":
                    collection_list.currentIndex = c.all ? c.end + 1 : c.end
                    collection_list.positionViewAtIndex(collection_list.currentIndex, ListView.Beginning)
                    c.i = c.all ? collection_list.currentIndex - 1 : collection_list.currentIndex
                    currentCollection = c.current = U.getCollection(c.i)
                    g.g.currentIndex = 0
                    break
            //-- DETAILS
                case "details":
                    break
            //-- FILTER
                case "filter":
                    break
            //-- NUMBER
                case "number":
                    break
            //-- CANCEL
                case "cancel":
                    close()
                    break
            //-- ACCEPT
                case "accept":
                    close()
                    break
                default:
                    break
            }
            event.accepted = true
            s = s != null ? s : select
        //--- [END] CONTROLS
        }
        if(s != null)
            s.play()
        s = null
    }

    function open() {
        collectionsList.opened = true

        f = "collections"
        collection_list.currentIndex = c.all ? c.i + 1 : c.i
        collection_list.positionViewAtIndex(collection_list.currentIndex, ListView.Beginning)
        collectionsList.forceActiveFocus()

        s = toggle
    }

    function close() {
        collectionsList.opened = false
        if(f === "collections") {
            f = "games"
            g.g.forceActiveFocus()
        }

        s = toggle_down
    }
}
