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

Rectangle { //header
    id: header
    color: "transparent"

    property Rectangle lastFocus: utilitiesSearch

    anchors{ 
        top: parent.top
        left: parent.left
        right: parent.right
    }

    height: vpx(96)
    property var headerSpacing: headerColumns.spacing / 2

    Row { //headerColumns
        id: headerColumns
        spacing: 12
        anchors.fill: parent
        
        Rectangle {     //collectionTitle
            id: collectionTitle
            color: "transparent"
            width: vpx(300) - headerSpacing
            height: parent.height

            property bool selected: false
            property Rectangle next: utilitiesSearch
            property Rectangle prev: collectionTitle
            property string curr: "collectionTitle"

            MouseArea {
                anchors.fill: collectionImage
                anchors.margins: vpx(-6)

                onClicked:{
                    header.lastFocus = collectionTitle
                }
            }

            Image {
                id: collectionImage
                source: "../assets/logos/" + currentCollection.shortName + ".svg"
                asynchronous: true

                anchors{
                    fill: parent
                    margins: vpx(24)
                }
                fillMode: Image.PreserveAspectFit

                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignVCenter
            }

            Rectangle { //gameCount_wrapper
                id: gameCount_wrapper

                color: Qt.hsla(0.79, 0.2, 0.26, 0.85)
                width: gameCount_text.width + vpx(12) < vpx(24) ? vpx(24) : gameCount_text.width + vpx(12)
                height: vpx(24)

                anchors.top: collectionImage.top
                anchors.left: collectionTitle_border.right
                anchors.leftMargin: vpx(6)

                radius: vpx(6)

                Text { //gameCount_text
                    id: gameCount_text

                    text: currentCollection.games.count
                    color: "#ffffff"

                    //anchors.fill: parent

                    anchors.centerIn: parent

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(12)

                }

            }

            Text { //collectionTitle_text
                id: collectionTitle_text
                anchors{
                    left: parent.left
                    top: parent.top
                    margins: vpx(24)
                }
                text: currentCollection.name
                color: "#ffffff"
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(36)

                visible: collectionImage.status === Image.Error
            }

            Rectangle { //collectionTitle_border
                id: collectionTitle_border

                width: collectionImage.status != 3 ? collectionImage.paintedWidth + vpx(12) : collectionTitle_text.width + 12
                height: collectionImage.status != 3 ? collectionImage.paintedHeight + vpx(12) : collectionTitle_text.height + 12

                anchors.top: collectionImage.top
                anchors.left: collectionImage.left
                anchors.margins: vpx(-6)
                color: "transparent"

                border.color: Qt.hsla(1,1,1,0.6)
                border.width: parent.selected ? vpx(3) : vpx(0)
                radius: vpx(6)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        U.toggleCollections()
                    }

                }
            }
        }

        Rectangle {     //searchBar
            id: searchBar
            color: "transparent"
            width: parent.width - vpx(600) - headerSpacing
            height: parent.height

            Rectangle {
                id: searchbox
                opacity: 0
                anchors{
                    left: parent.left
                    leftMargin: parent.width
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
                }

                Item {
                    anchors.fill: parent
                    anchors.leftMargin: vpx(24)
                    anchors.rightMargin: vpx(24)
                    clip: true
                    enabled: searchbox.state === "opened"

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

        Rectangle {     //utilities
            id: utilities
            color: "transparent"
            width: vpx(300) - headerSpacing
            height: parent.height

            Row {
                anchors.fill: parent
                spacing: 0

                Rectangle {     //utilitiesSearch
                    id: utilitiesSearch
                    color: "transparent"

                    width: parent.width / 3
                    height: parent.height

                    property bool selected: false
                    property Rectangle next: utilitiesSettings
                    property Rectangle prev: collectionTitle
                    property string curr: "utilitiesSearch"

                    MouseArea{
                        id: searchClick
                        hoverEnabled: true
                        anchors.centerIn: parent
                        width: vpx(48)
                        height: vpx(48)

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            header.lastFocus = utilitiesSearch
                            U.removeButtonFocusOnClick()
                            U.toggleSearch("searchBar")
                        }

                        onEntered: {
                            searchHover.state = "hover"
                        }

                        onExited: {
                            searchHover.state = ""
                        }

                        Rectangle {
                            id: searchIcon
                            color: "transparent"
                            anchors.fill: parent

                            border.width: vpx(4)
                            border.color: "white"
                            radius: vpx(100)

                            Rectangle {
                                id: searchHover
                                color: "#000000"
                                anchors.fill: parent
                                radius: vpx(100)

                                opacity: searchbox.state != "opened" ? 0 : 1

                                states: State {
                                    name: "hover"
                                    PropertyChanges { target: searchHover; opacity: 1 }
                                }

                                transitions: Transition {
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: 150 
                                        easing.type: Easing.EaseInOut
                                    }
                                }
                            }

                            Image {
                                source: "../assets/img/search.png"
                                anchors.fill: parent
                                anchors.margins: vpx(12)
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: vpx(-6)
                                color: "transparent"

                                border.color: Qt.hsla(1,1,1,0.6)
                                border.width: parent.parent.parent.selected ? vpx(3) : vpx(0)
                                radius: vpx(6)
                            }
                        }
                    }
                }

                Rectangle {     //utilitiesSettings
                    id: utilitiesSettings
                    color: "transparent"

                    width: parent.width / 3
                    height: parent.height

                    property bool selected: false
                    property Rectangle next: utilitiesInfo
                    property Rectangle prev: utilitiesSearch
                    property string curr: "utilitiesSettings"

                    MouseArea{
                        id: settingsClick
                        hoverEnabled: true
                        anchors.centerIn: parent
                        width: vpx(48)
                        height: vpx(48)

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            header.lastFocus = utilitiesSettings
                            U.removeButtonFocusOnClick()
                            U.toggleSettings("settings")
                        }

                        onEntered: {
                            settingsHover.state = "hover"
                        }

                        onExited: {
                            settingsHover.state = ""
                        }

                        Rectangle {
                            id: settingsIcon
                            color: "transparent"
                            anchors.fill: parent

                            border.width: vpx(4)
                            border.color: "white"
                            radius: vpx(100)

                            Rectangle {
                                id: settingsHover
                                color: "#000000"
                                anchors.fill: parent
                                radius: vpx(100)

                                opacity: 0

                                states: State {
                                    name: "hover"
                                    PropertyChanges { target: settingsHover; opacity: 1 }
                                }

                                transitions: Transition {
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: 150 
                                        easing.type: Easing.EaseInOut
                                    }
                                }
                            }

                            Image {
                                source: "../assets/img/settings.png"
                                anchors.fill: parent
                                anchors.margins: vpx(12)
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: vpx(-6)
                                color: "transparent"

                                border.color: Qt.hsla(1,1,1,0.6)
                                border.width: parent.parent.parent.selected ? vpx(3) : vpx(0)
                                radius: vpx(6)
                            }
                        }
                    }
                }

                Rectangle {     //utilitiesInfo
                    id: utilitiesInfo
                    color: "transparent"

                    width: parent.width / 3
                    height: parent.height

                    property bool selected: false
                    property Rectangle next: utilitiesInfo
                    property Rectangle prev: utilitiesSettings
                    property string curr: "utilitiesInfo"

                    MouseArea{
                        id: infoClick
                        hoverEnabled: true
                        anchors.centerIn: parent
                        width: vpx(48)
                        height: vpx(48)

                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            header.lastFocus = utilitiesInfo
                            U.removeButtonFocusOnClick()
                            U.toggleInfo("info")
                        }

                        onEntered: {
                            infoHover.state = "hover"
                        }

                        onExited: {
                            infoHover.state = ""
                        }

                        Rectangle {
                            id: infoIcon
                            color: "transparent"
                            anchors.fill: parent

                            border.width: vpx(4)
                            border.color: "white"
                            radius: vpx(100)

                            Rectangle {
                                id: infoHover
                                color: "#000000"
                                anchors.fill: parent
                                radius: vpx(100)

                                opacity: info.info.state != "opened" ? 0 : 1

                                states: State {
                                    name: "hover"
                                    PropertyChanges { target: infoHover; opacity: 1 }
                                }

                                transitions: Transition {
                                    NumberAnimation {
                                        properties: "opacity"
                                        duration: 150 
                                        easing.type: Easing.EaseInOut
                                    }
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "i"
                                font.pixelSize: vpx (36)
                                font.bold: true
                                color: "white"
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: vpx(-6)
                                color: "transparent"

                                border.color: Qt.hsla(1,1,1,0.6)
                                border.width: parent.parent.parent.selected ? vpx(3) : vpx(0)
                                radius: vpx(6)
                            }
                        }
                    }
                }
            }
        }
    }
    property Rectangle infoHover: infoHover
    property Rectangle searchbox: searchbox
    property TextInput searchTerm: searchTerm
    property Rectangle utilitiesSearch: utilitiesSearch
    property Rectangle utilitiesSettings: utilitiesSettings
    property Rectangle utilitiesInfo: utilitiesInfo
    property Rectangle collectionTitle: collectionTitle
}