// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: loader
    height: vpx(48)
    width: height

    Rectangle{
        anchors.fill: parent
        radius: 100
        color: p.t
        border.width: vpx(12)
        border.color: addAlphaToHex(0.3, p.white)

    }

    Rectangle {
        color: p.white
        height: vpx(12)
        width: height

        radius: vpx(6)

        anchors.horizontalCenter: parent.horizontalCenter
    }

    NumberAnimation on rotation {

        from: 0
        to: 360

        duration: 750

        easing.type: Easing.InOutSine

        loops: Animation.Infinite
    }
}