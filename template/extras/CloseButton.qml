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

Rectangle { //close button
    id: close_button
    width: vpx(48)
    height: vpx(48)

    property var test: ""

    color: "transparent"
    
    property string lastFocus
    property var  close
    property bool borderOn: false

    Rectangle {
        id: close_hover
        anchors.fill: parent

        color: settings.colors.martinique
        radius: vpx(6)
        opacity: 0

        states: State {
            name: "hover"
            PropertyChanges { target: close_hover; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation {
                properties: "opacity"
                duration: 150 
                easing.type: Easing.EaseInOut
            }
        }
    }

    Text { //close_icon
        id: close_icon
        anchors.fill: parent
        anchors.bottomMargin: (font.pixelSize / 4)

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "🗙"
        color: "#ffffff"

        font.pixelSize: vpx(24)
    }

    Rectangle { //close_border
        id:close_border
        anchors.fill: parent
        color: "transparent"

        visible: parent.borderOn

        border.color: Qt.hsla(1,1,1,0.6)
        border.width: vpx(3)
        radius: vpx(6)
    }

    MouseArea{ //close_click
        id: close_click

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: {
            close(parent.lastFocus)
            toggle_down.play()
        }

        onEntered: {
           close_hover.state = "hover"
        }

        onExited: {
            close_hover.state = ""
        }
    }
}
