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

Rectangle {
    id: plusButton
    
    border.color: "#ffffff"
    border.width: vpx(2)
    radius: vpx(6)

    width: vpx(24)
    height: vpx(24)

    color: this.state === "hovered" ? "#ffffff" : this.state === "clicked" ? Qt.hsla(0.79, 0.2, 0.26, 0.85) : "transparent"

    state: plusClick.pressed ? "clicked" : ""

    anchors.verticalCenter: parent.verticalCenter

    states: [
        State {
            name: "hovered"
        },
        State {
            name: "clicked"
        }
    ]

    Text {
        text: "+"
        color: parent.state === "hovered" ? "#000000" : "#ffffff"
        anchors.fill: parent
        anchors.bottomMargin: (font.pixelSize / 10)

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pixelSize: vpx(16)
        font.family: bold.name
    }

    MouseArea {
        id: plusClick
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        property var currentState: ""

        onClicked: {
            U.settingsUpdate(parent.name, parent.currentValue)
        }

        onPressed: {
            currentState = parent.state
            parent.state = "clicked"
        }

        onReleased: {
            parent.state = currentState
            currentState = ""
        }

        onEntered: {
            currentState = "hovered"
            parent.state = "hovered"
        }

        onExited: {
            currentState = ""
            parent.state = ""
        }
    }
}