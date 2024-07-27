// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: button_wrapper
    height: vpx(48)
    width: vpx(48)

    property bool selected: false
    property bool hovered: false
    property var hover_color: addAlphaToHex(0.3, settings.color_white)
    property var background: settings.color_t

    property string icon_color: settings.color_white

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    Item {
        id: icon_wrapper
        height: parent.height - vpx(6)
        width: height

        anchors.centerIn: parent

        Rectangle {
            id: background
            anchors.fill: parent
            color: button_wrapper.background
            radius: vpx(100)
        }

        Rectangle {
            id: hover
            anchors.fill: parent
            color: button_wrapper.hover_color
            radius: vpx(100)

            opacity: selected || hovered ? 1 : 0

            Behavior on opacity {NumberAnimation {duration: settings.hover_speed}}
        }

        Image { 
            id: icon
            source: images.cross
            anchors.fill: parent

            anchors.margins: vpx(12)

            visible: false
        }

        Rectangle {
            id: icon_color
            anchors.fill: icon
            color: button_wrapper.icon_color

            visible: false
        }

        OpacityMask {
            anchors.fill: icon
            source: icon_color
            maskSource: icon
        }


    }

    Rectangle {
        id: select
        anchors.fill: parent
        anchors.margins: vpx(-3)
        color: settings.color_t
        border.width: vpx(6)
        border.color: settings.color_border

        radius: vpx(6)

        visible: parent.selected
    }

    MouseArea{
        id: click

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            parent.onEntered()
            parent.hovered = true
        }

        onExited: {
            parent.onExited()
            parent.hovered = false
        }

        onClicked: {
            parent.onClicked()
            audio.stopAll()
            audio.toggle_down.play()
            mouse.event = accept
        }
    }
}