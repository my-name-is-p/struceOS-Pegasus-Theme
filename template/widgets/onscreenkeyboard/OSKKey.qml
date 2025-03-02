// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Component{
    id: key_component

    Item {
        id: key_wrapper

        property Item osk: parent.parent.parent.parent.parent
        property Item list_view: parent.parent
        property string icon: icon != undefined ? icon : ""

        height: vpx(48)
        width: {
            switch(size){
                case "space":
                    return osk.s_space
                case "double":
                    return osk.s_double
                default:
                    return osk.s_single
            }
        }

        //Functions--
            function onAccept(){
                screensaver.reset()
                switch(key){
                    case "accept":
                        osk.close()
                        break
                    case "backspace":
                        let pos = osk.text.cursorPosition != 0 ? osk.text.cursorPosition - 1 : 0
                        osk.linked.remove(osk.text.cursorPosition - 1, osk.text.cursorPosition)
                        osk.text.cursorPosition = pos
                        break
                    case "left":
                        osk.text.cursorPosition -= 1
                        break
                    case "right":
                        osk.text.cursorPosition += 1
                        break
                    case "shift":
                        osk.shift = !osk.shift
                        break
                    case "space":
                        osk.linked.text += " "
                        break
                    default:
                        osk.linked.text += key_text.text
                        break
                }
            }
        //--

        Rectangle {
            id: key_color

            anchors.fill: parent

            color: {
                    if(key === "shift" && osk.shift)
                        return colors.accent_light
                    else
                        return colors.white
                }
            radius: height

            visible: true

            Text {
                id: key_text

                text: {
                        if(osk.shift && shift != "")
                            return shift
                        else
                            return key
                    }

                anchors.centerIn: parent

                color: {
                    if(key === "shift" && osk.shift)
                        return colors.white
                    else
                        return colors.black
                }
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(15)

                visible: icon === ""
            }

            Image {
                source: icon != undefined ? icon : ""

                anchors.fill: parent
                anchors.margins: vpx(12)

                visible: icon != undefined
            }
        }

        DropShadow {
            id: key_shadow
            source: key_color

            anchors.fill: key_color

            color: colors.black
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8
            samples: 16
        }

        Rectangle {
            id: selected

            anchors.fill: parent
            anchors.margins: vpx(-8)

            color: colors.t
            border.color: colors.border
            border.width: vpx(6)
            radius: vpx(6)

            visible: 
                osk.current === list_view && 
                list_view.currentIndex === index
        }

        MouseArea {
            id: key_click

            anchors.fill: key_wrapper

            cursorShape: Qt.PointingHandCursor

            onClicked: {
                key_wrapper.onAccept()
                audio.toggle_down.play()
            }
        }
    }
}