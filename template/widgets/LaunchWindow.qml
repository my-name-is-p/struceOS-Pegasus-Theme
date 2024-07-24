// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import "../widgets"

Item {
    id: launcher

    Rectangle {
        anchors.fill: parent

        color: addAlphaToHex(0.95, p.black)
    }
    Item {
        id: launch_info
        width: launch_image.width + launch_text.width
        height: launch_image.height
        anchors.centerIn: parent
        Image {
            id: launch_image
            source: getAssets(currentGame.assets).logo
            width: vpx(200)
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: launch_text
            text: "Launching: " + currentGame.title
            color: p.white
            font.family: regular.name
            font.pixelSize: vpx(24)

            anchors.left: launch_image.right

            anchors.verticalCenter: launch_image.verticalCenter
        }
    }

    LoadingGraphic {
        anchors.top: launch_info.bottom
        anchors.horizontalCenter: launch_info.horizontalCenter
        anchors.margins: vpx(24)
    }
}