// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: button_wrapper
    height: vpx(48)
    width: vpx(48)

    property var hover_color: addAlphaToHex(0.3, p.white)
    property var background: p.t

    property var icon: images.favorite_icon_empty
    property string icon_color: p.white

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    property bool selected: false
    property bool hovered: false

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
            source: button_wrapper.icon
            anchors.fill: parent

            anchors.topMargin: button_wrapper.height / 4
            anchors.bottomMargin: button_wrapper.height / 4
            anchors.leftMargin: button_wrapper.width / 4
            anchors.rightMargin: button_wrapper.width / 4

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
        color: p.t
        border.width: vpx(3)
        border.color: p.border

        radius: vpx(6)

        visible: parent.selected
    }

    MouseArea{
        id: click

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        preventStealing: false
        propagateComposedEvents: true 
        onEntered: {
            parent.onEntered()
            parent.hovered = true
        }

        onExited: {
            parent.onEntered()
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