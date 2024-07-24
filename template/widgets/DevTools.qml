// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item { //devtools
    id: devtools

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right

    width: parent.width / 3

    visible: stest.enableDevTools

    Rectangle { //log_window
        id: log_window

        anchors.top: parent.top
        anchors.bottom: button.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: vpx(12)

        color: addAlphaToHex(stest.consoleLogBackground,p.black)

        radius: vpx(12)

        Item{ //log_clip
            id: log_clip

            anchors.fill: parent
            anchors.margins: vpx(12)

            clip: true

            TextEdit{ //log_text
                id: log_text

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                readOnly: true
                selectByMouse: true

                color: p.white

                selectionColor: p.white
                selectedTextColor: p.black

                wrapMode: TextEdit.WordWrap

                Keys.onPressed: { //Keys
                    let key = gsk(event)
                    if(key != undefined){
                        switch (key){
                            case "up":
                            case "down":
                            case "left":
                            case "right":
                            case "prev":
                            case "next":
                            case "first":
                            case "last":
                            case "cancel":
                            case "accept":
                                f = header
                                f = game_layout
                                event.accepted = true
                                break
                            case "details":
                                f = panel_area
                                panel_area.current = panel_area.info_panel
                                panel_area.info_panel.video.safePlay()
                                event.accepted = true
                                break
                            case "filter":
                                f = sortfilt_menu
                                event.accepted = true
                                break
                            default:
                                break
                        }
                        s = s != null ? s : audio.toggle_down
                        if(s != null){
                            audio.stopAll()
                            s.play()
                        }
                        s = null
                    }
                }
            }
        }
    }

    Rectangle { //button
        id: button

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: vpx(24)

        height: vpx(48)
        width: vpx(48)

        radius: vpx(48)

        color: hovered ? p.launch : p.launch_hover

        visible: true

        property var hovered: false

        MouseArea { //button_click
            id: button_click
            enabled: true
            anchors.fill: parent
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

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
                collections_menu.positionViewAtCurrentIndex()
                mouse.event = accepted
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
        anchors.left: parent.left
        anchors.margins: vpx(24)

        height: clear_mem_text.height + vpx(12)
        width: clear_mem_text.width + vpx(12)

        radius: vpx(6)

        color: hovered ? p.launch : p.launch_hover

        visible: true

        property var hovered: false

        Text { //clear_mem_text
            id: clear_mem_text
            anchors.centerIn: parent
            text: "clear memory"

            color: clear_mem.hovered ? p.white : p.black
        }

        MouseArea { //clear_mem_click
            id: clear_mem_click
            enabled: true
            anchors.fill: parent
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

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
                settings_loader.sourceComponent = undefined
                settings_loader.sourceComponent = settings_component
                mouse.event = accepted
            }

            onDoubleClicked: {
                audio.stopAll()
                audio.select.play()
                clearMemory()
                settings_loader.sourceComponent = undefined
                settings_loader.sourceComponent = settings_component
                mouse.event = accepted
            }
        }
    }

    Rectangle { //clear_log
        id: clear_log

        anchors.verticalCenter: button.verticalCenter
        anchors.left: clear_mem.right
        anchors.margins: vpx(24)

        height: clear_log_text.height + vpx(12)
        width: clear_log_text.width + vpx(12)

        radius: vpx(6)

        color: hovered ? p.launch : p.launch_hover

        visible: true

        property var hovered: false

        Text { //clear_log_text
            id: clear_log_text
            anchors.centerIn: parent
            text: "clear log"

            color: clear_log.hovered ? p.white : p.black
        }

        MouseArea { //clear_log_click
            id: clear_log_click
            enabled: true
            anchors.fill: parent
            hoverEnabled: true

            cursorShape: Qt.PointingHandCursor

            onEntered: {
                clear_log.hovered = true
            }

            onExited: {
                clear_log.hovered = false
            }

            onClicked: {
                audio.stopAll()
                audio.select.play()
                log(stest.details, true, true)
                mouse.event = accepted
            }

            onDoubleClicked: {
                audio.stopAll()
                audio.select.play()
                log(stest.details, true, true)
                mouse.event = accepted
            }
        }
    }

    property Item log_text: log_text
}