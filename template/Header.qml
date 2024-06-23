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

Item {
    id: header
    anchors{ 
        top: parent.top
        left: parent.left
        right: parent.right
    }

    property var currentItem: collection_title_wrapper

    height: vpx(96)

    Item {  //COLLECTION TITLE GROUP
        id: collection_title_wrapper
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: collection_logo.status != Image.Error ? collection_logo.width : collectionTitle_text.width
        anchors.margins: vpx(24)

        property var controls: {
            "name": "collections",
            "right": search_button,
            "left": null,
        }

        Image { //COLLECTION LOGO
            id: collection_logo
            visible: status != Image.Error
            source: "../assets/logos/" + currentCollection.shortName + ".svg"

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            fillMode: Image.PreserveAspectFit

            antialiasing: true
            smooth: true
        }

        Text {  //BACKUP TEXT COLLECTION TITLE
            id: collectionTitle_text

            anchors.left: parent.left
            anchors.top: parent.top

            text: currentCollection.name
            color: "white"

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(36)

            visible: collection_logo.status === Image.Error
        }

        Rectangle { //GAME COUNT
            id: gameCount_wrapper
            color: p.accent
            width: gameCount_text.width + vpx(12) < vpx(24) ? vpx(24) : gameCount_text.width + vpx(12)
            height: vpx(24)
            anchors.top: collection_logo.top
            anchors.left: collection_title_wrapper.right
            anchors.leftMargin: vpx(6)
            radius: vpx(6)

            Text { //gameCount_text
                id: gameCount_text
                text: g.end + 1
                color: p.white
                anchors.centerIn: parent

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(12)
            }
        }

        Rectangle { //SELECTION BORDER
            id: collectionTitle_border

            anchors.fill: parent
            anchors.margins:vpx(-6)
            color: "transparent"

            visible: header.focus && header.currentItem == parent

            border.color: p.border
            border.width: vpx(3)
            radius: vpx(6)
        }

        MouseArea { //CLICK AREA
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                if(!collectionsList.opened){
                    collectionsList.open()
                }else{
                    collectionsList.close()
                }
                toggle.play()
            }
        }
    }

    Item {  //SEARCH BAR
        id: search_bar_wrapper

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: collection_title_wrapper.right
        anchors.leftMargin: gameCount_wrapper.width + vpx(6)
        anchors.right: search_button.left

        Rectangle {
            id: searchbox
            opacity: searchTerm.text != "" ? 1 : 0
            anchors{
                left: parent.left
                leftMargin: searchTerm.text != "" ? vpx(24) : parent.width
                right: parent.right
                rightMargin: vpx(24)
                verticalCenter: parent.verticalCenter
            }

            height: vpx(48)

            color: Qt.hsla(0,0,0,0.25)
            border.width: p.outline_width
            border.color: settings.theme.border
            radius: vpx(100)

            property bool opened: state === "opened"

            state: f != "search" ? "" : "opened"

            states: State {
                name: "opened"
                PropertyChanges{ target: searchbox; anchors.leftMargin: vpx(24); opacity: 1}
            }

            transitions: Transition {
                NumberAnimation {
                    properties: "anchors.leftMargin, opacity"
                    duration: 150 
                    easing.type: Easing.EaseInOut
                }
            }


            Item {
                anchors.fill: parent
                anchors.leftMargin: vpx(24)
                anchors.rightMargin: vpx(24)
                clip: true
                enabled: searchbox.opacity

                TextInput {
                    id: searchTerm
                    color: settings.theme.white
                    text: ""
                    anchors.fill: parent
                    selectByMouse: false

                    focus: f === "search"

                    wrapMode: TextInput.NoWrap
                    verticalAlignment: TextInput.AlignVCenter

                    font.family: regular.name
                    font.pixelSize: vpx(24)

                    property var controls: {
                        "name": "searchTerm",
                        "right": search_button,
                        "left": collection_title_wrapper,
                    }
                }

                MouseArea {
                    id: searchSelect
                    anchors.fill: parent
                    cursorShape: Qt.IBeamCursor
                    onClicked: {
                        f === "search"
                        searchTerm.forceActiveFocus()
                        toggle.play()
                    }
                }

                Keys.onPressed: {
                    let key = isNaN(parseInt(event.text)) ? gsk(event) : "number"
                    if(key != undefined){
                        switch(key){
                            case "up":
                            case "cancel":
                                header.currentItem = searchTerm.controls.right
                                f = "header"
                                header.focus = true
                                event.accepted = true
                                toggle_down.play()
                                break
                            case "down":
                                f = "games"
                                g.g.forceActiveFocus()
                                break
                            case "left":
                                header.currentItem = searchTerm.controls.left
                                f = "header"
                                header.focus = true
                                event.accepted = true
                                toggle_down.play()
                                break
                            case "right":
                                header.currentItem = searchTerm.controls.right
                                f = "header"
                                header.focus = true
                                event.accepted = true
                                toggle_down.play()
                                break
                            default:
                                break
                        }
                    }
                }
            }
        }
    }

    HeaderButton{   //SEARCH BUTTON
        id: search_button

        anchors.right: favorite_button.left
        anchors.rightMargin: vpx(24)

        source: "search.png"
        target: searchbox.opacity ? "" : "search"

        property string name: "search"

        property var controls: {
            "name": "search",
            "right": favorite_button,
            "left": collection_title_wrapper,
        }
    }

    HeaderButton{   //FAVORITE BUTTON
        id: favorite_button

        anchors.right: settings_button.left
        anchors.rightMargin: vpx(24)

        source: filterEnabled ? "heart_filled" : "heart_empty.svg"
        target: "favorite"

        property string name: "favorite"

        property var filterEnabled: false

        property var controls: {
            "name": "favorite",
            "right": settings_button,
            "left": search_button,
        }
    }

    HeaderButton{   //SETTINGS BUTTON
        id: settings_button

        anchors.right: info_button.left
        anchors.rightMargin: vpx(24)

        source: "settings.png"
        target: "settings"

        property string name: "settings"

        property var controls: {
            "name": "settings",
            "right": info_button,
            "left": favorite_button,
        }
    }

    HeaderButton{   //INFO BUTTON
        id: info_button

        anchors.right: clock.left
        anchors.rightMargin: vpx(24)

        source: "info.svg"
        target: "info"

        property string name: "info"

        property var controls: {
            "name": "info",
            "right": clock,
            "left": settings_button,
        }
    }

    Clock {
        id: clock
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: vpx(24)
        anchors.bottom: parent.bottom

        property var controls: {
            "name": "clock",
            "right": null,
            "left": info_button,
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
            //-- DOWN
                case "down":
                    if(collectionsList.opened){
                        collectionsList.open()
                    } else {
                        switch(header.currentItem.controls.name) {
                            case "collections":
                                g.g.currentIndex = 0
                                break
                            default:
                                g.g.currentIndex = g.cols - 1
                                break
                        }
                        f = "games"
                        g.g.focus = true
                        s = toggle_down
                    }
                    break
            //-- LEFT / PREVIOUS
                case "left":
                case "prev":
                    if(header.currentItem.controls.left != null)
                        header.currentItem = header.currentItem.controls.left
                    s = toggle
                    break
            //-- RIGHT / NEXT
                case "next":
                case "right":
                    if(header.currentItem.controls.right != null)
                        header.currentItem = header.currentItem.controls.right
                    s = toggle
                    break
            //-- FIRST
                case "first":
                    break
            //-- LAST
                case "last":
                    break
            //-- DETAILS
                case "details":
                    info.open()
                    s = toggle
                    break
            //-- FILTER
                case "filter":
                    header.favorite.filterEnabled = !header.favorite.filterEnabled
                    games.gameView.currentIndex = 0
                    s = toggle
                    break
            //-- NUMBER
                case "number":
                    c.i = n
                    currentCollection = c.current = U.getCollection(n)
                    background.bg_refresh.restart()
                    g.g.currentIndex = 0
                    f = "games"
                    g.g.forceActiveFocus()
                    s = toggle
                    break
            //-- CANCEL
                case "cancel":
                    collectionsList.close()
                    if(header.currentItem.controls.name != "search"){
                        switch(header.currentItem.controls.name) {
                            case "collections":
                                g.g.currentIndex = 0
                                break
                            default:
                                g.g.currentIndex = g.cols - 1
                                break
                        }
                    } else {
                        f = "header"
                    }
                    s = toggle_down
                    break
            //-- ACCEPT
                case "up":
                case "accept":
                    if(!event.isAutoRepeat){
                        switch(header.currentItem.controls.name) {
                            case "favorite":
                                header.favorite.filterEnabled = !header.favorite.filterEnabled
                                games.gameView.currentIndex = 0
                                s = toggle
                                break;
                            case "clock":
                                settings.twelvehour = !settings.twelvehour
                                header.clock.set()
                                api.memory.set("struceOS_ui_twelvehour", settings.twelvehour)
                                s = select
                                break
                            case "collections":
                                if(!collectionsList.opened){
                                    collectionsList.open()
                                }else{
                                    collectionsList.close("header")
                                }
                                s = toggle
                                break
                            case "search":
                                f = "search"
                                s = toggle
                                break
                            case "info":
                                info.open()
                                s = toggle
                            case "settings":
                                settingsPanel.open()
                                s = toggle
                            default:
                                collectionsList.close("header")
                                f = header.currentItem.controls.name
                                s = toggle
                                break
                        }
                    }
            }
            event.accepted = true
        //--- [END] CONTROLS
        }
        if(s != null)
            s.play()
        s = null
    }

    property Item gv_up_1: collection_title_wrapper
    property HeaderButton gv_up_2: search_button
    property HeaderButton gv_up_3: settings_button
    property HeaderButton gv_up_4: info_button
    property HeaderButton favorite: favorite_button
    property Rectangle searchbox: searchbox
    property TextInput searchTerm: searchTerm

    property Item clock: clock.clock
}