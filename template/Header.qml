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
    
    Item { //collection_title_wrapper
        id: collection_title_wrapper
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: collection_logo.status != Image.Error ? collection_logo.width : collectionTitle_text.width
        anchors.margins: vpx(24)

        property var controls: {
            "name": "collections",
            "next": search_button,
            "previous": null,
        }

        Image {
            id: collection_logo
            visible: currentCollection.shortName != ""
            source: "../assets/logos/" + currentCollection.shortName + ".svg"
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            fillMode: Image.PreserveAspectFit

            antialiasing: true
            smooth: true

            Text {
                id: collectionTitle_text
                anchors{
                    left: parent.left
                    top: parent.top
                }
                text: currentCollection.name
                color: "#ffffff"
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(36)

                visible: collection_logo.status === Image.Error
            }
        }

        Rectangle { //gameCount_wrapper
            id: gameCount_wrapper
            color: settings.colors.martinique
            width: gameCount_text.width + vpx(12) < vpx(24) ? vpx(24) : gameCount_text.width + vpx(12)
            height: vpx(24)
            anchors.top: collection_logo.top
            anchors.left: collection_logo.status != Image.Error ? collection_logo.right : collection_title_wrapper.right
            anchors.leftMargin: vpx(6)
            radius: vpx(6)

            Text { //gameCount_text
                id: gameCount_text
                text: games.gameView.count
                color: settings.colors.white
                anchors.centerIn: parent

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(12)
            }
        }

        Rectangle { //collectionTitle_border
            id: collectionTitle_border

            anchors.fill: parent
            anchors.margins:vpx(-6)
            color: "transparent"

            visible: header.focus && header.currentItem == parent

            border.color: Qt.hsla(1,1,1,0.6)
            border.width: vpx(3)
            radius: vpx(6)
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                U.focusToggle("collections")
            }
        }
    }

    Item { //search_bar_wrapper
        id: search_bar_wrapper

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: collection_title_wrapper.right
        anchors.leftMargin: gameCount_wrapper.width
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
            border.width: vpx(4)
            border.color: Qt.hsla(0,0,1,0.60)
            radius: vpx(100)

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

            MouseArea {
                id: searchSelect
                anchors.fill: parent
                cursorShape: Qt.IBeamCursor
                onClicked: {
                    U.focusToggle("search")
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
                    color: "#ffffff"
                    text: ""
                    anchors.fill: parent
                    selectByMouse: true

                    wrapMode: TextInput.NoWrap
                    verticalAlignment: TextInput.AlignVCenter

                    font.family: regular.name
                    font.pixelSize: vpx(24)
                }
            }
        }
    }


    HeaderButton{   //info_button
        id: info_button

        anchors.right: parent.right
        anchors.rightMargin: vpx(24)

        source: "info.svg"
        target: "info"

        property var controls: {
            "name": "info",
            "next": null,
            "prev": settings_button,
        }

    }

    HeaderButton{   //setting_button
        id: settings_button

        anchors.right: info_button.left
        anchors.rightMargin: vpx(24)

        source: "settings.png"
        target: "settings"

        property var controls: {
            "name": "settings",
            "next": info_button,
            "prev": favorite_button,
        }
    }

    HeaderButton{   //favorite_button
        id: favorite_button

        anchors.right: settings_button.left
        anchors.rightMargin: vpx(24)

        source: filterEnabled ? "heart_filled" : "heart_empty.svg"
        target: "favorite"

        property var filterEnabled: false

        property var controls: {
            "name": "favorite",
            "next": settings_button,
            "prev": search_button,
        }
    }


    HeaderButton{   //search_button
        id: search_button

        anchors.right: favorite_button.left
        anchors.rightMargin: vpx(24)

        source: "search.png"
        target: searchbox.opacity ? "" : "search"

        property var controls: {
            "name": "search",
            "next": favorite_button,
            "prev": collection_title_wrapper,
        }
    }

    property Item gv_up_1: collection_title_wrapper
    property HeaderButton gv_up_2: search_button
    property HeaderButton gv_up_3: settings_button
    property HeaderButton favorite: favorite_button
    property Rectangle searchbox: searchbox
    property TextInput searchTerm: searchTerm
}