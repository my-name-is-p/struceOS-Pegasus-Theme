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
    
    Rectangle { 
        anchors.centerIn: parent
        height: parent.width
        width: parent.width

        color: parent.filterEnabled ? settings.colors.martinique : "transparent"

        border.width: parent.filterEnabled ? 0 : vpx(4)
        border.color: settings.colors.white

        radius: vpx(100)

        Rectangle {
            id: hover
            anchors.fill: parent
            color: settings.colors.black
            opacity: 0

            radius: vpx(100)
            states: State {
                        name: "hover"
                        PropertyChanges { target: hover; opacity: 1 }
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
                hover.state = "hover"
            }

            onExited: {
                hover.state = ""
            }

            onClicked: {
                if(target != "favorite"){
                    U.focusToggle(parent.parent.target)
                } else {
                    parent.parent.filterEnabled = !parent.parent.filterEnabled
                    games.gameView.currentIndex = 0
                    toggle_up.play()
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: vpx(-6)
            color: "transparent"

            border.color: Qt.hsla(1,1,1,0.6)
            border.width: vpx(3)
            radius: vpx(6)

            visible: header.focus && header.currentItem == parent.parent
        }
}
}