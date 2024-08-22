// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

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

    Item { //icon_mask
        id: icon_mask

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        height: vpx(18)
        width: vpx(18)

        Image { //icon
            id: icon
            source: filter_item.icon
            anchors.fill: parent

            visible: false
        }

        Rectangle { //icon_color
            id: icon_color
            anchors.fill: icon
            visible: false
            color: colors.white
        }

        OpacityMask {
            anchors.fill: icon
            source: icon_color
            maskSource: icon
        }
    }

    MouseArea {
        id: click

        anchors.fill: parent
        
        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }

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