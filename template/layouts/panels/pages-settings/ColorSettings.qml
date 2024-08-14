// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

import "../../../widgets"
import "colors"
import "radio"

Item {
    id: page

    property bool selected: false
    property var current: background_settings

    property var exitMenu: function(){}
    property var onCancel: function(){}

    function reset(){
        page.current = background_settings
        background_settings.current = background_settings_overlay_on
        color_settings.current = color_settings_title
        color_options.currentIndex = 0
        color_options.model.populateModel()
    }

    Item { //background_settings
        id: background_settings

        property bool selected: page.selected && page.current === this
        property var current: background_settings_overlay_on

        anchors.top: parent.top
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else{
                    page.exitMenu()
                }
            }
            property var onDown: function(){
                if(current.onDown)
                    current.onDown()
            }
            property var onLeft: function(){
                if(current.onLeft)
                    current.current.onLeft()
                else
                    page.exitMenu()
            }
            property var onRight: function(){
                if(current.onRight)
                    current.onRight()
            }
            property var onAccept: function(){
                if(current.onAccept)
                    current.onAccept()
            }

            property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
            property var onNext: current.onNext != undefined ? current.onNext : undefined
            property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
            property var onLast: current.onLast != undefined ? current.onLast : undefined
            property var onDetails: current.onRight != undefined ? current.onRight : undefined
            property var onSort: current.onRight != undefined ? current.onRight : undefined
            property var onCancel: current.onCancel != undefined ? current.onCancel : undefined
        //--

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

        Text { //background_settings_title
            id: background_settings_title
            text: "Background"
            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            anchors.top: parent.top
        }

        ToggleBox { //background_settings_overlay_on
            id: background_settings_overlay_on
            text: "overlay on"

            anchors.top: background_settings_title.bottom
            anchors.topMargin: vpx(12)

            selected: background_settings.selected && background_settings.current === this
            value: settings.bgOverlayOn

            onClicked: function(){
                settings.bgOverlayOn = !value
                api.memory.set("struceOS_background_overlayOn", settings.bgOverlayOn)
            }
            property var onAccept: onClicked

            property var onDown: function(){
                background_settings.current = background_settings_overlay_opacity_slider
            }
        }

        Item { //background_settings_overlay_opacity
            id: background_settings_overlay_opacity

            anchors.top: background_settings_overlay_on.bottom
            anchors.topMargin: vpx(12)
            anchors.left: parent.left
            anchors.right: parent.right

            height: { //height
                let h = 0
                for (var i = 0; i < children.length; i++) {
                    h = children[i].height > h ? children[i].height : h
                }
                return h;
            }

            Text { //background_settings_overlay_opacity_text
                id: background_settings_overlay_opacity_text
                text: "overlay opacity"
                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //background_settings_overlay_opacity_slider
                id: background_settings_overlay_opacity_slider

                anchors.left: background_settings_overlay_opacity_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: parent.right

                min: 1
                max: 100

                value: (settings.bgOverlayOpacity*100)
                percent: true
                selected: background_settings.selected && background_settings.current === this
                memory: "struceOS_background_overlayOpacity"

                property var onUp: function(){
                    if(current.onUp)
                        current.onUp()
                    else
                        background_settings.current = background_settings_overlay_on
                }

                property var onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        background_settings.current = background_settings_overlay_style_radio
                }
            }
        }

        Item { //background_settings_overlay_style
            id: background_settings_overlay_style

            anchors.top: background_settings_overlay_opacity.bottom
            anchors.topMargin: vpx(12)
            anchors.left: parent.left
            anchors.right: parent.right

            height: { //height
                let h = 0
                for (var i = 0; i < children.length; i++) {
                    h = children[i].height > h ? children[i].height : h
                }
                return h;
            }

            Text { //background_settings_overlay_style_text
                id: background_settings_overlay_style_text
                text: "overlay style"
                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            OverlayStyleRadio {
                id: background_settings_overlay_style_radio

                selected: background_settings.selected && background_settings.current === this
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter

                property var onUp: function(){
                    if(current.onUp)
                        current.onUp()
                    else
                        background_settings.current = background_settings_overlay_opacity_slider
                }

                property var onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        page.current = color_settings
                }
            }
        }
    }

    Item { //color_settings
        id: color_settings

        property bool selected: page.selected && page.current === this
        property var current: color_settings_title

        anchors.top: background_settings.bottom
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        anchors.bottom: parent.bottom

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else{
                    page.current = background_settings
                }
            }
            property var onDown: function(){
                if(current.onDown)
                    current.onDown()
            }
            property var onLeft: function(){
                if(current.onLeft)
                    current.onLeft()
                else
                    page.exitMenu()
            }
            property var onRight: function(){
                if(current.onRight)
                    current.onRight()
            }
            property var onAccept: function(){
                if(current.onAccept)
                    current.onAccept()
            }

            property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
            property var onNext: current.onNext != undefined ? current.onNext : undefined
            property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
            property var onLast: current.onLast != undefined ? current.onLast : undefined
            property var onDetails: current.onRight != undefined ? current.onRight : undefined
            property var onSort: current.onRight != undefined ? current.onRight : undefined
            property var onCancel: current.onCancel != undefined ? current.onCancel : undefined
        //--

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

        Text { //color_settings_title
            id: color_settings_title
            text: "Colors"
            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            anchors.top: parent.top

            property bool selected: color_settings.selected && color_settings.current === this

            property var onUp: function(){
                page.current = background_settings
            }

            property var onAccept: function(){
                settings.theme = JSON.parse(JSON.stringify(settings.default_theme))
                api.memory.unset("struceOS_theme_colors")
                colors_loader.sourceComponent = undefined
                colors_loader.sourceComponent = colors_component
                color_options.model.populateModel()
            }

            property var onDown: function(){
                color_options.currentIndex = 0
                color_settings.current = color_options
            }

            UIButton { //reset_button
                id: reset_button
                anchors.left: parent.right
                anchors.leftMargin: vpx(6)
                anchors.verticalCenter: parent.verticalCenter

                icon: images.refresh
                icon_color: colors.text

                selected: color_settings_title.selected

                onClicked: function(){
                    settings.theme = JSON.parse(JSON.stringify(settings.default_theme))
                    api.memory.unset("struceOS_theme_colors")
                    colors_loader.sourceComponent = undefined
                    colors_loader.sourceComponent = colors_component
                    color_options.model.populateModel()
                }
            }
        }

        GridView {
            id: color_options

            anchors.top: color_settings_title.bottom
            anchors.topMargin: vpx(16)
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            cellWidth: width / 2
            cellHeight: vpx(36)

            model: ColorsModel{}
            delegate: ColorsGridItem{}

            flow: GridView.FlowTopToBottom

            Component.onCompleted: {
                model.populateModel()
            }

            property bool selected: color_settings.selected && color_settings.current === this

            property var onUp: function(){
                if(currentIndex <= 0)
                    color_settings.current = color_settings_title
                else{
                    moveCurrentIndexUp()
                    // resetFocus()
                }
            }

            property var onDown: function(){
                moveCurrentIndexDown()
                // resetFocus()
            }
            property var onLeft: function(){
                moveCurrentIndexLeft()
                // resetFocus()
            }
            property var onRight: function(){
                moveCurrentIndexRight()
                // resetFocus()
            }

            property var onAccept: currentItem.onAccept
        }
    }

    Keys.onPressed: { //Keys
        let key = gsk(event)
        if(key != undefined){
            switch (key){
                case "up":
                    if(current.onUp != undefined){
                        current.onUp()
                    }
                    event.accepted = true
                    break
                case "down":
                    if(current.onDown != undefined)
                        current.onDown()
                    event.accepted = true
                    break
                case "left":
                    if(current.onLeft != undefined)
                        current.onLeft()
                    event.accepted = true
                    break
                case "right":
                    if(current.onRight != undefined)
                        current.onRight()
                    event.accepted = true
                    break
                case "prev":
                    if(current.onPrevious != undefined){
                        current.onPrevious()
                        event.accepted = true
                    }else{
                        reset()
                    }
                    break
                case "next":
                    if(current.onNext != undefined){
                        current.onNext()
                        event.accepted = true
                    }else{
                        reset()
                    }
                    break
                case "first":
                    if(current.onFirst != undefined)
                        current.onFirst()
                    event.accepted = true
                    break
                case "last":
                    if(current.onLast != undefined)
                        current.onLast()
                    event.accepted = true
                    break
                case "details":
                    break
                case "filter":
                    break
                case "cancel":
                    if(current.onCancel != undefined){
                        current.onCancel()
                        event.accepted = true
                    }
                    break
                case "accept":
                    if(current.onAccept)
                        current.onAccept()
                    event.accepted = true
                    break
                default:
                    break
            }
            s = s != null ? s : audio.toggle_down
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }

    property ListModel color_model: color_options.model
}