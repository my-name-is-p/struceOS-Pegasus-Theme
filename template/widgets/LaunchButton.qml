// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Rectangle { //launch
    id: launch
    height: vpx(48)
    color: hovered ? colors.launch_hover : colors.launch_button
    radius: vpx(100)


    width: launch_icon.width + game_launch_text.contentWidth + game_launch_text.anchors.leftMargin + vpx(24)

    property bool selected: false
    property bool hovered: false

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    Image { //launch_icon
        id: launch_icon
        height: vpx(18)
        width: vpx(18)

        source: images.play

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)

        Rectangle {
            id: launch_icon_color
            anchors.fill: parent
            color: launch.hovered ? colors.launch_button : colors.launch_hover

            visible: false
        }
        
        visible: false
    }

    OpacityMask {
        anchors.fill: launch_icon
        source: launch_icon_color
        maskSource: launch_icon
    }

    Text { //launch_text
        id: game_launch_text
        text: "launch"
        color: launch.hovered ? colors.launch_button : colors.launch_text
        font.family: regular.name
        font.pixelSize: vpx(18)

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: launch_icon.right
        anchors.leftMargin: vpx(6)
    }

    Rectangle { //launch_select
        id: launch_select

        anchors.fill: launch
        anchors.margins: vpx(-6)

        color: colors.t

        border.width: vpx(6)
        border.color: colors.border

        radius: vpx(6)

        visible: parent.selected
    }

    MouseArea {
        id: launch_click
        
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }

        onEntered: {
            parent.onEntered()
            launch.hovered = true
        }

        onExited: {
            parent.onExited()
            launch.hovered = false
        }

        onClicked: {
            parent.onClicked()
            audio.toggle_down.safePlay()
            launch_window.visible = true
            if(settings.lastPlayed){
                api.memory.set("collectionIndex", currentCollectionIndex)
                api.memory.set("gameIndex", games.currentIndex)
            }
            search.currentGame().launch()
            mouse.event = accepted
        }
    }
}
