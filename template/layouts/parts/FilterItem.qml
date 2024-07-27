// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: filter_item

    property string text: "undefined"
    property string icon

    property bool asc: true
    property bool hovered: false
    property bool enabled: false
    property bool selected: false

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    height: text.contentHeight + vpx(12)

    Rectangle {
        id: hover
        anchors.fill: parent
        anchors.margins: vpx(6)
        color: filter_item.selected || filter_item.hovered ? addAlphaToHex(0.2, colors.white) : "transparent"
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
        color: colors.white
    }

    Image {
        id: icon
        source: parent.icon
        height: vpx(18)
        width: vpx(18)
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
            filter_item.hovered = true
        }

        onExited: {
            parent.onExited()
            filter_item.hovered = false
        }

        onClicked: {
            parent.onClicked()
            audio.stopAll()
            audio.select.play()
        }
    }

}