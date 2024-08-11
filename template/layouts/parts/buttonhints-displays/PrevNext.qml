// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15


Item {
    id: prevnext

    height: mask.height + label.height + label.anchors.topMargin
    width: Math.max(mask.width, label.width)

    property string text: "- collection +"

    Rectangle {
        id: mask_color
        anchors.fill: mask
        color: colors.text
        visible: false
    }

    Item{
        id: mask
        visible: false

        height: { //height
            let h = 0
            for (var i = 0; i < children.length; i++) {
                h = children[i].height > h ? children[i].height : h
            }
            return h;
        }

        width: { //width
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].width + children[i].anchors.leftMargin
            }
            return sum;
        }

        Image {
            id: key_q
            source: images.key_q

            anchors.verticalCenter: parent.verticalCenter

            height: vpx(24)

            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: key_e
            source: images.key_e

            anchors.left: key_q.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            height: vpx(24)

            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: slash
            source: images.slash

            anchors.left: key_e.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            width: vpx(12)
            height: vpx(12)
        }

        Image {
            id: leftBumper
            source: images.leftBumper

            anchors.left: slash.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            height: vpx(24)
            
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: rightBumper
            source: images.rightBumper

            anchors.left: leftBumper.right
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
        text: prevnext.text
        color: mask_color.color

        anchors.top: mask.bottom
        anchors.topMargin: vpx(6)
        anchors.horizontalCenter: mask.horizontalCenter


        font.family: regular.name
        font.pixelSize: vpx(12)

    }
}