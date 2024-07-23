// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: button_hints

    height: buttons_wrapper.height + vpx(12)
    width: buttons_wrapper.width + vpx(24)

    Rectangle {
        id: buttons_bg
        anchors.fill: parent

        color: addAlphaToHex(90, p.black)

        radius: vpx(6)

        Item {
            id:buttons_wrapper

            height: face_btn_left.height + vpx(12)
            width: {
                if(f != "games")
                    face_btn_left.width + face_btn_bottom.width + vpx(24)
                else
                    face_btn_top.width + face_btn_left.width + face_btn_bottom.width + vpx(36)
            }
            
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: vpx(12)


            Item{
                id: face_btn_top
                width: face_btn_top_icon.width + face_btn_top_text.width + vpx(12)
                height: face_btn_left_icon.height

                anchors.verticalCenter: parent.verticalCenter

                visible: f === game_layout

                Image {
                    id: face_btn_top_icon
                    source: images.face_btn_top
                    width: vpx(24)
                    height: vpx(24)
                }

                Text {
                    id: face_btn_top_text
                    text: currentGame.favorite ? "unfavorite" : "favorite"
                    color: p.white

                    anchors.left: face_btn_top_icon.right
                    anchors.leftMargin: vpx(6)
                    anchors.verticalCenter: face_btn_top_icon.verticalCenter

                    font.family: regular.name
                    font.pixelSize: vpx(14)
                }
            }

            Item{
                id: face_btn_left
                width: face_btn_left_icon.width + face_btn_left_text.width + vpx(6)
                height: face_btn_left_icon.height

                anchors.verticalCenter: parent.verticalCenter

                anchors.left: face_btn_top.visible ? face_btn_top.right : parent.left
                anchors.leftMargin: face_btn_top.visible ? vpx(12) : 0

                Image {
                    id: face_btn_left_icon
                    source: images.face_btn_left
                    width: vpx(24)
                    height: vpx(24)
                }

                Text {
                    id: face_btn_left_text
                    text: "info"
                    color: p.white

                    anchors.left: face_btn_left_icon.right
                    anchors.leftMargin: vpx(6)
                    anchors.verticalCenter: face_btn_left_icon.verticalCenter

                    font.family: regular.name
                    font.pixelSize: vpx(14)
                }
            }

            Item{
                id: face_btn_bottom
                width: face_btn_bottom_icon.width + face_btn_bottom_text.width + vpx(6)
                height: face_btn_bottom_icon.height

                anchors.verticalCenter: parent.verticalCenter

                anchors.left: face_btn_left.right
                anchors.leftMargin: vpx(12)

                Image {
                    id: face_btn_bottom_icon
                    source: images.face_btn_bottom
                    width: vpx(24)
                    height: vpx(24)
                }

                Text {
                    id: face_btn_bottom_text
                    text: {
                            switch(f){
                                case "games":
                                    return "launch"
                                    break
                                case "header":
                                    return header.currentItem.controls.name
                                    break
                                case "collections":
                                    return "select"
                                    break
                            }
                        }
                    color: p.white

                    anchors.left: face_btn_bottom_icon.right
                    anchors.leftMargin: vpx(6)
                    anchors.verticalCenter: face_btn_bottom_icon.verticalCenter

                    font.family: regular.name
                    font.pixelSize: vpx(14)
                }
            }
        }

    }
}