// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item { //sort_item
    id: sort_item

    height: text.contentHeight + vpx(18)

    property string text: "undefined"

    property bool asc: true
    property bool hovered: false
    property bool enabled: false
    property bool selected: false

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    property string role
    property var order

    Rectangle { //hover
        id: hover
        anchors.fill: parent
        anchors.margins: vpx(6)
        color: sort_item.selected || sort_item.hovered ? addAlphaToHex(0.2, colors.white) : "transparent"
        radius: vpx(6)
    }

    Text { //text
        id: text
        text: parent.text
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: vpx(24)
        font.family: regular.name
        font.pixelSize: vpx(18)
        color: colors.white
    }


    Item { //arrow_mask
        id: arrow_mask

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        height: vpx(18)
        width: vpx(18)

        Image { //arrow
            id: arrow
            anchors.fill: parent
            source: sort_item.enabled ? images.sort_direction_filled : images.sort_direction_empty

            visible: false
        }

        Rectangle { //arrow_color
            id: arrow_color
            anchors.fill: arrow
            visible: false
            color: colors.white
        }

        OpacityMask {
            anchors.fill: arrow
            source: arrow_color
            maskSource: arrow

            rotation: sort_item.asc ? 0 : 180
        }
    }

    MouseArea { //click
        id: click

        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }

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