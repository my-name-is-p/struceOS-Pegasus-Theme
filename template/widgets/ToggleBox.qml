// struceOS
// Copyright (C) 2024 my_name_is_p

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

    height: childrenSize(this, "height", "", 0, 0, true)

    Rectangle {
        id: toggle_select

        anchors.fill: parent
        anchors.margins: vpx(-6)

        color: addAlphaToHex(0.3, colors.white)

        radius: vpx(6)

        visible: toggle.selected

    }

    Text { //game_layout_settings_columns_text
        id: toggle_text
        text: toggle.text
        color: colors.text

        anchors.verticalCenter: parent.verticalCenter

        font.family: regular.name
        font.pixelSize: vpx(16)

        width: toggle.showText ? contentWidth : 0
    }

    Rectangle { //toggle_box
        id: toggle_box

        anchors.right: toggle.boxAlign === "left" ? toggle_text.right : parent.right
        anchors.verticalCenter: parent.verticalCenter

        height: vpx(24)
        width: height

        color: colors.t

        border.width: vpx(3)
        border.color: colors.text

        radius: vpx(6)

        Rectangle {
            id: toggle_box_enabled
            anchors.centerIn: parent

            height: toggle.value ? toggle_box.height : 0
            width: height

            Behavior on height {NumberAnimation{duration: 100}}
            
            color: colors.text

            radius: vpx(6)

            clip: true

            Text {
                id: toggle_box_check
                anchors.centerIn: parent
                text: "✓"

                color: colors.accent
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
