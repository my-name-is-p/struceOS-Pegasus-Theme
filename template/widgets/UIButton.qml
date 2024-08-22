// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item { //button_wrapper
    id: button_wrapper

    height: vpx(48)
    width: vpx(48)

    property var hover_color: addAlphaToHex(0.3, colors.white)
    property var background: colors.t

    property var icon: images.favorite_icon_empty
    property string icon_color: colors.white

    property var sound: null

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    property bool selected: false
    property bool hovered: false

    Item { //icon_wrapper
        id: icon_wrapper

        anchors.centerIn: button_wrapper

        height: button_wrapper.height - vpx(6)
        width: height

        Rectangle { //background
            id: background

            anchors.fill: icon_wrapper

            color: button_wrapper.background
            radius: vpx(100)
        }

        Rectangle { //hover
            id: hover

            anchors.fill: icon_wrapper

            color: button_wrapper.hover_color
            opacity: selected || hovered ? 1 : 0
            Behavior on opacity {NumberAnimation {duration: settings.hover_speed}}

            radius: vpx(100)
        }

        Image { //icon
            id: icon
            source: button_wrapper.icon

            anchors.fill: icon_wrapper
            anchors.margins: button_wrapper.height / 4

            visible: false
        }

        Rectangle { //icon_color
            id: icon_color

            anchors.fill: icon

            color: button_wrapper.icon_color

            visible: false
        }

        OpacityMask {//icon_out
            id: icon_out
            anchors.fill: icon
            source: icon_color
            maskSource: icon
        }
    }

    Rectangle { //select
        id: select

        anchors.fill: button_wrapper
        anchors.margins: vpx(-3)

        color: colors.t
        border.width: vpx(6)
        border.color: colors.border
        radius: vpx(6)

        visible: button_wrapper.selected
    }

    MouseArea{ //click
        id: click

        anchors.fill: button_wrapper

        cursorShape: Qt.PointingHandCursor
        
        hoverEnabled: true
         
        onPositionChanged: {
            screensaver.reset()
        }
         
        onEntered: {
            button_wrapper.onEntered()
            button_wrapper.hovered = true
        }

        onExited: {
            button_wrapper.onEntered()
            button_wrapper.hovered = false
        }

        onClicked: {
            button_wrapper.onClicked()
            if(button_wrapper.sound != null)
                button_wrapper.sound.play()
        }
    }
}