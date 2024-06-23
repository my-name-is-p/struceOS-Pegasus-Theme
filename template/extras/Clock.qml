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

    Item { //CLOCK
        id: clock_container

        width: clock_color.width
        opacity: 1

        property bool hover: select_border.visible

        Rectangle{
            id: clock_color
            anchors.fill: clock
            anchors.margins: vpx(-12)

            color: U.addAlphaToHex(0.3, p.accent)

            radius: vpx(100)


            Rectangle {
                id: hover
                anchors.fill: parent
                color: p.black
                opacity: clock_container.hover || (header.focus && header.currentItem == parent.parent) ? 1 : 0
                radius: vpx(100)

                Behavior on opacity {NumberAnimation {duration: 150}}
            }
        }


        Text {
            id: clock
            anchors.centerIn: parent

            font.pixelSize: vpx(24)
            font.family: bold.name
            font.bold: true

            color: p.white
            smooth: true
            antialiasing: true    

            function set() {
                let d = new Date()
                clock.text = Qt.formatTime(d, settings.twelvehour ? "hh:mm a" : "hh:mm")
                settings.seconds =  Qt.formatTime(d, "ss")
            }

            Timer {
                id: clockTimer
                interval: 60000 - (settings.seconds * 1000) // Run the timer every minute
                repeat: true
                running: true
                triggeredOnStart: true
                onTriggered: clock.set()
            }
        }

        MouseArea {
            id: clock_click

            anchors.fill: clock_color
            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true

            onClicked: {
                header.currentItem = parent
                select.play()
                settings.twelvehour = !settings.twelvehour
                clock.set()
                api.memory.set("struceOS_ui_twelvehour", settings.twelvehour)
            }

            onEntered: {
                clock_container.hover = true
            }

            onExited: {
                clock_container.hover = false
            }
        }

        Rectangle {
            id: select_border
            anchors.fill: clock_color
            anchors.margins: vpx(-6)
            color: p.t

            border.color: p.border
            border.width: vpx(3)
            radius: vpx(6)

            visible: header.focus && header.currentItem == parent
        }
    property Item clock: clock
    }
