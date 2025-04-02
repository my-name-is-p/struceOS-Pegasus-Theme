// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: donation_button

    height: vpx(24)

    property bool selected: false
    property bool hovered: false
    property string link: "https://ko-fi.com/my_name_is_p"

    width: image.width + (image.anchors.margins * 2)


    Rectangle {
        id: select

        anchors.fill: parent
        anchors.margins:vpx(-6)

        color: addAlphaToHex(0.6, colors.white)
        radius: vpx(6)

        visible: donation_button.selected || donation_button.hovered
    }

    Rectangle {
        id: background
        anchors.fill: parent

        radius: vpx(6)

        color: !donation_button.selected && !donation_button.hovered ? "#ff5e5b" : "#ffffff"

    }

    Image {
        id: image
        source: images.kofi

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: vpx(6)

        fillMode: Image.PreserveAspectFit
        visible: false
    }

    Rectangle {
        id: image_color
        anchors.fill: image
        color: donation_button.selected || donation_button.hovered ? "#ff5e5b" : "#ffffff"

        visible: false
    }

    OpacityMask {
        anchors.fill: image
        source: image_color
        maskSource: image
    }

    MouseArea {
        id: click
        cursorShape: Qt.PointingHandCursor

        anchors.fill: parent

        hoverEnabled: true
        
        onPositionChanged: {
            screensaver.reset()
        }
        
        onEntered: {
            donation_button.hovered = true
        }

        onExited: {
            donation_button.hovered = false
        }

        onClicked: {
            Qt.openUrlExternally(donation_button.link)
            audio.toggle_down.safePlay()
        }
    }
}
