// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: toggle

    anchors.left: parent.left
    anchors.right: parent.right

    property bool selected: toggle === this
    property bool showText: true
    property string text: "text"
    property string boxAlign: "right"

    property bool value: false

    property var onClicked: function(){}

    height: { //height
        let sum = 0
        for (var i = 0; i < children.length; i++) {
            sum = children[i].height > sum ? children[i].height : sum
        }
        return sum;
    }

    Rectangle {
        id: toggle_select

        anchors.fill: parent
        anchors.margins: vpx(-6)

        color: addAlphaToHex(0.2, p.white)

        radius: vpx(6)

        visible: toggle.selected

    }

    Text { //game_layout_settings_columns_text
        id: toggle_text
        text: toggle.text
        color: p.text

        anchors.verticalCenter: parent.verticalCenter

        font.family: regular.name
        font.pixelSize: vpx(16)

        width: toggle.showText ? contentWidth : 0
    }

    Rectangle {
        id: toggle_box

        anchors.right: toggle.boxAlign === "left" ? toggle_text.right : parent.right
        anchors.verticalCenter: parent.verticalCenter

        height: vpx(24)
        width: height

        color: p.t

        border.width: vpx(3)
        border.color: p.text

        radius: vpx(6)

        Rectangle {
            id: toggle_box_enabled
            anchors.centerIn: parent

            height: toggle.value ? toggle_box.height : 0
            width: height

            Behavior on height {NumberAnimation{duration: 100}}
            
            color: p.text

            radius: vpx(6)

            clip: true

            Text {
                id: toggle_box_check
                anchors.centerIn: parent
                text: "✓"

                color: p.accent
            }
        }
    }

    MouseArea {
        id: toggle_click
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            toggle.onClicked()
            audio.stopAll()
            audio.toggle_down.play()
        }
    }
}
