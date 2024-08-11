// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.0

    Item { //clock_container
        id: clock_container

        width: clock_color.width
        opacity: 1

        property bool hover: select_border.visible

        property bool selected: false

        Rectangle{
            id: clock_color
            anchors.fill: clock
            anchors.margins: vpx(-6)

            color: addAlphaToHex(0.3, colors.black)

            radius: vpx(6)


            Rectangle {
                id: hover
                anchors.fill: parent
                color: colors.black
                opacity: clock_container.hover || clock_container.selected ? 1 : 0
                radius: vpx(6)

                Behavior on opacity {NumberAnimation {duration: settings.hover_speed}}
            }
        }


        Text {
            id: clock
            anchors.centerIn: parent

            font.pixelSize: settings.headerSize != "s" ? vpx(24) : vpx(16)
            font.family: bold.name
            font.bold: true

            color: colors.white
            smooth: true
            antialiasing: true

            property int seconds: 0

            function set() {
                let d = new Date()
                clock.text = Qt.formatTime(d, settings.twelvehour ? "hh:mm a" : "hh:mm")
                seconds =  Qt.formatTime(d, "ss")
            }

            Timer {
                id: clockTimer
                interval: 60000 - (seconds * 1000) // Run the timer every minute
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
                audio.stopAll()
                audio.select.play()
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
            color: colors.t

            border.color: colors.border
            border.width: vpx(6)
            radius: vpx(6)

            visible: clock_container.selected
        }
    property Item clock: clock
    }
