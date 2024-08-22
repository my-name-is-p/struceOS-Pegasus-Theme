// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Item { //devtools
    id: devtools

    width: height / 2

    visible: false

    Rectangle { //log_window
        id: log_window

        anchors.top: devtools.top
        anchors.bottom: button.top
        anchors.left: devtools.left
        anchors.right: devtools.right
        anchors.margins: vpx(12)

        color: addAlphaToHex(settings.consoleLogBackground, colors.black)

        radius: vpx(12)

        Item{ //log_clip
            id: log_clip

            anchors.fill: parent
            anchors.margins: vpx(12)

            clip: true

            TextEdit{ //log_text
                id: log_text

                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                readOnly: true
                selectByMouse: true

                color: colors.white

                selectionColor: colors.white
                selectedTextColor: colors.black

                wrapMode: TextEdit.WordWrap
            }
        }
    }

    Rectangle { //button
        id: button

        anchors.bottom: devtools.bottom
        anchors.right: devtools.right
        anchors.margins: vpx(24)

        height: vpx(48)
        width: vpx(48)

        radius: vpx(48)

        color: hovered ? colors.launch_button : colors.launch_hover

        visible: true

        property var hovered: false

        MouseArea { //button_click
            id: button_click

            enabled: true

            anchors.fill: button

            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onPositionChanged: {
                screensaver.reset()
            }

            onEntered: {
                button.hovered = true
            }

            onExited: {
                button.hovered = false
            }

            onClicked: {
                audio.stopAll()
                audio.select.play()
                log("DEV-BUTTON", true)
            }

            onDoubleClicked: {
                audio.stopAll()
                audio.select.play()
                log("DEV-BUTTON", true)
                mouse.event = accepted
            }
        }
    }

    Rectangle { //clear_mem
        id: clear_mem

        anchors.verticalCenter: button.verticalCenter
        anchors.left: devtools.left
        anchors.margins: vpx(24)

        height: clear_mem_text.height + vpx(12)
        width: clear_mem_text.width + vpx(12)

        color: hovered ? colors.launch_button : colors.launch_hover
        radius: vpx(6)

        visible: true

        property var hovered: false

        Text { //clear_mem_text
            id: clear_mem_text
            text: "clear memory"

            anchors.centerIn: clear_mem

            color: clear_mem.hovered ? colors.white : colors.black
        }

        MouseArea { //clear_mem_click
            id: clear_mem_click
            
            anchors.fill: clear_mem

            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onPositionChanged: {
                screensaver.reset()
            }

            onEntered: {
                clear_mem.hovered = true
            }

            onExited: {
                clear_mem.hovered = false
            }

            onClicked: {
                audio.stopAll()
                audio.select.play()
                clearMemory()
                colors_loader.sourceComponent = undefined
                colors_loader.sourceComponent = colors_component
                mouse.event = accepted
            }

            onDoubleClicked: {
                audio.stopAll()
                audio.select.play()
                mouse.event = accepted
            }
        }
    }

    Rectangle { //clear_log
        id: clear_log

        anchors.left: clear_mem.right
        anchors.margins: vpx(24)
        anchors.verticalCenter: button.verticalCenter

        height: clear_log_text.height + vpx(12)
        width: clear_log_text.width + vpx(12)


        color: hovered ? colors.launch_button : colors.launch_hover
        radius: vpx(6)

        visible: true

        property var hovered: false

        Text { //clear_log_text
            id: clear_log_text
            text: "clear log"
            
            anchors.centerIn: parent

            color: clear_log.hovered ? colors.white : colors.black
        }

        MouseArea { //clear_log_click
            id: clear_log_click

            anchors.fill: parent
            
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onPositionChanged: {
                screensaver.reset()
            }

            onEntered: {
                clear_log.hovered = true
            }

            onExited: {
                clear_log.hovered = false
            }

            onClicked: {
                audio.stopAll()
                audio.select.play()
                log(settings.details, true, true)
                mouse.event = accepted
            }

            onDoubleClicked: {
                audio.stopAll()
                audio.select.play()
                log(settings.details, true, true)
                mouse.event = accepted
            }
        }
    }

    property Item log_text: log_text
}