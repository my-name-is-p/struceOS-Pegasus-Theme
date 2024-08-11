// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15


    Item {  //search_bar
        id: search_bar

        property bool selected: false

        Rectangle {
            id: search_box

            anchors.left: parent.left
            anchors.leftMargin: search_text.text != "" || search_bar.selected ? vpx(24) : parent.width
            anchors.right: parent.right
            anchors.rightMargin: vpx(24)
            anchors.verticalCenter: parent.verticalCenter

            height: vpx(48)

            color: addAlphaToHex(0.25, colors.black)
            opacity: search_text.text != "" || search_bar.selected ? 1 : 0

            border.width: vpx(3)
            border.color: colors.border
            radius: vpx(100)

            Behavior on anchors.leftMargin {NumberAnimation{duration: 125}}
            Behavior on opacity {NumberAnimation{duration: 125}}


            Item {
                anchors.fill: parent
                anchors.leftMargin: vpx(24)
                anchors.rightMargin: vpx(24)
                clip: true
                enabled: search_bar.selected

                TextInput {
                    id: search_text
                    color: colors.white
                    text: ""
                    anchors.fill: parent
                    selectByMouse: true

                    focus: search_bar.selected

                    wrapMode: TextInput.NoWrap
                    verticalAlignment: TextInput.AlignVCenter

                    font.family: regular.name
                    font.pixelSize: vpx(24)

                    Keys.onPressed: {
                        s = audio.select
                        audio.stopAll()
                        s.play()
                    }
                }
            }
        }

        MouseArea {
            id: search_click
            anchors.fill: parent

            enabled: !search_text.focus && search_text.text != ""

            onClicked: {
                f = header
                header.current = search_bar
                audio.stopAll()
                audio.toggle_down.play()
            }
        }


        property Item search_term: search_text
    }
