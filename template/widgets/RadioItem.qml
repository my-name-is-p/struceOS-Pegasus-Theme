// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: radio_button

    anchors.verticalCenter: parent.verticalCenter
    width: radio_item.width
    height: radio_item.height

    property bool enabled: false
    property bool selected: false
    property bool hovered: hover.hovered

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

        color: addAlphaToHex(0.6, colors.white)

        radius: vpx(6)

        visible: radio_button.selected || radio_button.hovered
    }
    
    Item { //radio_item
        id: radio_item
        
        width: {
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].width + children[i].anchors.leftMargin
            }
            return sum;
        }

        height: {
            let h = 0
            for (var i = 0; i < children.length; i++) {
                h = children[i].height > h ? children[i].height : h
            }
            return h;
        }

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
        
        onClicked: {
            radio_button.resetItems()
            radio_button.onClicked()
            audio.stopAll()
            radio_button.sound.play()
        }
    }

    HoverHandler { //hover
        id: hover
    }

    function resetItems(){
        for(var i = 0; i < siblings.length; i++){
            siblings[i].enabled = false
        }
        this.enabled = true
    }
}
