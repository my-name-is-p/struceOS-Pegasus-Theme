// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Item {
    id: radio_button

    anchors.verticalCenter: parent.verticalCenter
    width: radio_item.width
    height: radio_item.height

    property bool enabled: false
    property bool selected: false
    property bool hovered: false

    property var sound: audio.toggle_down
    property string text: "text"

    property var siblings: []

    property var onClicked: function(){}
    property var onEntered: function(){}
    property var onExited: function(){}

    property var onLeft: function(){}
    property var onRight: function(){}

    Rectangle {
        id: radio_item_select

        anchors.fill: parent
        anchors.margins: vpx(-6)

        color: addAlphaToHex(0.3, colors.white)

        radius: vpx(6)

        visible: radio_button.selected || radio_button.hovered
    }
    
    Item { //radio_item
        id: radio_item

        height: childrenSize(this, "height", "", 0, 0, true)
        width: childrenSize(this, "width", "leftMargin")

        Rectangle { //radio_button_outline
            id: radio_button_outline

            anchors.verticalCenter: radio_item.verticalCenter
            anchors.left: radio_item.left

            height: vpx(12)
            width: height

            radius: vpx(3)

            color: colors.t

            border.width: vpx(2)
            border.color: colors.text

            Rectangle { //radio_button_fill
                id: radio_button_fill

                anchors.centerIn: radio_button_outline

                height: radio_button.enabled ? vpx(12) : 0
                width: height

                Behavior on height {NumberAnimation{duration: 100}}

                radius: vpx(3)

                color: colors.text
            }
        }

        Text { //text
            id: text
            text: radio_button.text
            color: colors.text

            anchors.verticalCenter: radio_item.verticalCenter
            anchors.left: radio_button_outline.right
            anchors.leftMargin: vpx(6)

            verticalAlignment: Text.AlignVCenter

            font.pixelSize: vpx(16)
        }
    }

    MouseArea { //button
        id: button

        anchors.fill: radio_button

        cursorShape: Qt.PointingHandCursor

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }

        onEntered: {
            radio_button.hovered = true
        }

        onExited: {
            radio_button.hovered = false
        }
        
        onClicked: {
            radio_button.resetItems()
            radio_button.onClicked()
            radio_button.sound.play()
        }
    }

    function resetItems(){
        for(var i = 0; i < siblings.length; i++){
            siblings[i].enabled = false
        }
        this.enabled = true
    }
}
