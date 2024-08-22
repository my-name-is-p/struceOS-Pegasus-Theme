// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Component {
    id: color_option_component

    Item { //color_option
        id: color_option

        height: parent.parent.cellHeight
        width: parent.parent.cellWidth

        property GridView color_options: parent.parent

        property bool selected: false
        property bool active: color_options.selected && index === color_options.currentIndex ? true : false
        property bool hovered: false

        property var text: value

        Rectangle { //color_option_select
            id: color_option_select

            anchors.fill: parent
            anchors.margins: vpx(3)

            color: addAlphaToHex(0.3, colors.white)

            radius: vpx(6)

            visible: color_option.active || color_option.hovered 
        }

        function onAccept(){
            if(settings.osk){
                osk.validate_hex = true
                osk.open(value, panel_area)
            }else{
                value.forceActiveFocus()
            }
        }


        Item {  //padding
            id: padding
            anchors.fill: parent
            anchors.margins: vpx(6)


            Rectangle { //color_select
                id: color_select

                height: parent.height
                width: childrenSize(this, "width", "leftMargin", 6)

                radius: vpx(24)

                Rectangle { //swatch
                    id: swatch

                    color: color_value
                    height: parent.height - vpx(6)
                    width: parent.height - vpx(6)

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: vpx(6)

                    radius: vpx(24)
                    border.width: vpx(2)
                    border.color: colors.black
                }

                TextInput { //value
                    id: value

                    anchors.verticalCenter: parent.verticalCenter

                    text: color_value
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: swatch.right
                    anchors.leftMargin: vpx(3)

                    verticalAlignment: TextInput.AlignVCenter

                    font.family: regular.name
                    font.pixelSize: vpx(12)

                    color: colors.text_invert

                    onEditingFinished: {
                        if(!settings.osk){
                            while(!validateHex(text))
                                undo()
                            if(text.indexOf("#") < 0){
                                text = "#" + text
                            }
                        }
                        settings.theme[color_name] = text
                        colors[color_name] = text
                        api.memory.set("struceOS_theme_colors", settings.theme)
                        swatch.color = text
                        colors_loader.sourceComponent = undefined
                        colors_loader.sourceComponent = colors_component
                    }

                    Keys.onPressed: {
                        if(event.key === 1048576 && event.isAutoRepeat)
                            return
                        s = audio.toggle_down
                        let key = isNaN(parseInt(event.text)) ? gsk(event) : "number"
                        if(isNaN(key)){
                            if(key != undefined){
                                switch(key){
                                    case "up":
                                        if(event. key!= Qt.Key_W){
                                            cursorPosition = 0
                                            event.accepted = true
                                        }
                                        break
                                    case "down":
                                        if(event.key != Qt.Key_S){
                                            cursorPosition = length
                                            event.accepted = true
                                        }
                                        break
                                    case "accept":
                                        focus = false
                                        resetFocus(panel_area)
                                        event.accepted = true
                                        break
                                    case "cancel":
                                        if(event.key != Qt.Key_Backspace){
                                            undo()
                                            focus = false
                                            resetFocus(panel_area)
                                            event.accepted = true
                                        }
                                        break
                                    default:
                                        break
                                }
                            }
                        }else{
                        }
                        if(s != null){
                            audio.stopAll()
                            s.play()
                        }
                        s = null
                    }
                }

            }

            Text {
                id: label
                text: color_name.replace("_", " ")

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: color_select.right
                anchors.leftMargin: vpx(12)
                
                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

        }

        MouseArea {
            id: color_option_click
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true

            onPositionChanged: {
                screensaver.reset()
            }

            onEntered: {
                parent.hovered = true
            }

            onExited: {
                parent.hovered = false
            }

            onClicked: {
                if(settings.osk){
                    osk.validate_hex = true
                    osk.open(value, panel_area)
                }else{
                    value.forceActiveFocus()
                }
                audio.stopAll()
                audio.select.play()
            }
        }
    }
}
