// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Item {  //search_bar
    id: search_bar

    property bool selected: false
    property var onClicked: function(){}

    Rectangle { //search_box
        id: search_box

        anchors.left: parent.left
        anchors.leftMargin: search_text.text != "" || search_bar.selected ? vpx(24) : parent.width
        Behavior on anchors.leftMargin {NumberAnimation{duration: 125}}
        
        anchors.right: parent.right
        anchors.rightMargin: vpx(24)
        anchors.verticalCenter: parent.verticalCenter

        height: vpx(48)

        color: addAlphaToHex(0.25, colors.black)
        opacity: search_text.text != "" || search_bar.selected ? 1 : 0
        Behavior on opacity {NumberAnimation{duration: 125}}

        border.width: vpx(3)
        border.color: colors.border
        radius: vpx(100)

        TextInput { //search_text
            id: search_text

            anchors.fill: parent
            anchors.leftMargin: vpx(24)
            anchors.rightMargin: vpx(24)

            verticalAlignment: TextInput.AlignVCenter
            wrapMode: TextInput.NoWrap

            selectByMouse: true

            focus: search_bar.selected
            
            color: colors.white
            font.family: regular.name
            font.pixelSize: vpx(24)

            clip: true

            Keys.onPressed: {
                if(event.key === 1048576 && event.isAutoRepeat)
                    return
                s = audio.select
                s.safePlay()
            }

            MouseArea { //search_click
                id: search_click
                anchors.fill: parent

                enabled: search_text.focus || search_text.text != ""

                cursorShape: Qt.IBeamCursor

                onClicked: {
                    search_bar.onClicked()
                }
            }
        }
    }
    property Item search_term: search_text
}
