// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: sort_item

    property string text: "undefined"

    property bool asc: true
    property bool hovered: false
    property bool enabled: false
    property bool selected: false

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    height: text.contentHeight + vpx(18)

    Rectangle {
        id: hover
        anchors.fill: parent
        anchors.margins: vpx(6)
        color: sort_item.selected || sort_item.hovered ? addAlphaToHex(0.2, settings.color_white) : "transparent"
        radius: vpx(6)
    }

    Text {
        id: text
        text: parent.text
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: vpx(24)
        font.family: regular.name
        font.pixelSize: vpx(18)
        color: settings.color_white
    }

    Image {
        id: arrow
        source: parent.enabled ? images.sort_direction_filled : images.sort_direction_empty
        height: vpx(18)
        width: vpx(18)

        rotation: parent.asc ? 0 : 180

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)
    }

    MouseArea {
        id: click

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            parent.onEntered()
            sort_item.hovered = true
        }

        onExited: {
            parent.onExited()
            sort_item.hovered = false
        }

        onClicked: {
            parent.onClicked()
            audio.stopAll()
            audio.select.play()
        }
    }

}