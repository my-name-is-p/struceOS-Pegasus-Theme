// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "../widgets"

Item {
    id: launcher

    Rectangle {
        anchors.fill: parent

        color: addAlphaToHex(0.95, colors.black)
    }

    Item {
        id: launch_info

        anchors.centerIn: parent

        width: launch_image.width + launch_text.width
        height: launch_image.height

        Image {
            id: launch_image
            source: getAssets(currentGame.assets).logo
            width: vpx(200)
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: launch_text
            text: "Launching: " + currentGame.title

            anchors.left: launch_image.right
            anchors.verticalCenter: launch_image.verticalCenter

            color: colors.white
            font.family: regular.name
            font.pixelSize: vpx(24)
        }
    }

    LoadingGraphic {
        anchors.top: launch_info.bottom
        anchors.horizontalCenter: launch_info.horizontalCenter
        anchors.margins: vpx(24)
    }
}