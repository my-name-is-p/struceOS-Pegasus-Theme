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
    id: header_button
    height: parent.height
    width: vpx(48)

    property string source
    property string target

    property bool hover: false

    Rectangle { 
        anchors.centerIn: parent
        height: parent.width
        width: parent.width

        color: U.addAlphaToHex(0.3, p.accent)

        radius: vpx(100)

        Rectangle {
            id: hover
            anchors.fill: parent
            color: p.black
            opacity: header_button.hover || (header.focus && header.currentItem == parent.parent) ? 1 : 0
            radius: vpx(100)

            Behavior on opacity {NumberAnimation {duration: 150}}
        }

        Image {
            anchors.fill: parent
            anchors.margins: vpx(12)
            source: "../../assets/img/" + parent.parent.source.toString()


            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: {
                header_button.hover = true
            }

            onExited: {
                header_button.hover = false
            }

            onClicked: {
                if(target != "favorite"){
                    switch(parent.parent.target){
                        case "info":
                            info.open()
                            collectionsList.close()
                            break
                        case "settings":
                            settingsPanel.open()
                            collectionsList.close()
                            break
                        default:
                            f = parent.parent.target
                            break
                    }
                    toggle_down.play()
                } else {
                    parent.parent.filterEnabled = !parent.parent.filterEnabled
                    games.gameView.currentIndex = 0
                    header.currentItem = header_button
                    toggle_down.play()
                }
            }
        }

        Rectangle {
            id: select_border
            anchors.fill: parent
            anchors.margins: vpx(-6)
            color: p.t

            border.color: p.border
            border.width: vpx(3)
            radius: vpx(6)

            visible: header.focus && header.currentItem == parent.parent
        }
    }
}