// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15


Item {
    id: navigate

    height: mask.height + label.height + label.anchors.topMargin
    width: Math.max(mask.width, label.width)

    property string text: "navigate"

    Rectangle {
        id: mask_color
        anchors.fill: mask
        color: colors.white
        visible: false
    }

    Item{
        id: mask
        visible: false

        height: childrenSize(this, "height", "", 0, 0, true)
        width: childrenSize(this, "width", "leftMargin")

        Image {
            id: wsad
            source: images.wsad

            anchors.verticalCenter: parent.verticalCenter

            height: vpx(24)

            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: slash
            source: images.slash

            anchors.left: wsad.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            width: vpx(12)
            height: vpx(12)
        }

        Image {
            id: dpad
            source: images.dpad_filled

            anchors.left: slash.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            height: vpx(24)
            
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: joystick
            source: images.joystick

            anchors.left: dpad.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            height: vpx(24)
            
            fillMode: Image.PreserveAspectFit
        }
    }

    OpacityMask {
        anchors.fill: mask
        source: mask_color
        maskSource: mask
    }

    Text {
        id: label
        text: navigate.text
        color: mask_color.color

        anchors.top: mask.bottom
        anchors.topMargin: vpx(6)
        anchors.horizontalCenter: mask.horizontalCenter


        font.family: regular.name
        font.pixelSize: vpx(12)
    }
}