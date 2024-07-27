// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import "../../../widgets"

Item {
    id: page

    property bool selected: false
    property var current: ui_audio_settings

    property var exitMenu: function(){}
    property var onCancel: function(){}

    function reset(){
        page.current = ui_audio_settings
        ui_audio_settings.current = ui_audio_settings_volume_slider
        video_audio_settings.current = video_audio_settings_volume_slider
    }

    Item { //ui_audio_settings
        id: ui_audio_settings

        anchors.top: parent.top
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        property bool selected: page.selected && page.current === this
        property var current: ui_audio_settings_volume_slider

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else{
                    current = ui_audio_settings_volume_slider
                    page.exitMenu()
                }
            }
            property var onDown: function(){
                if(current.onDown)
                    current.onDown()
            }
            property var onLeft: function(){
                if(current.onLeft)
                    current.onLeft()
            }

            property var onRight: current.onRight != undefined ? current.onRight : undefined
            property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
            property var onNext: current.onNext != undefined ? current.onNext : undefined
            property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
            property var onLast: current.onLast != undefined ? current.onLast : undefined
            property var onDetails: current.onDetails != undefined ? current.onDetails : undefined
            property var onSort: current.onSort != undefined ? current.onSort : undefined
            property var onCancel: current.onCancel != undefined ? current.onCancel : undefined
            property var onAccept: current.onAccept != undefined ? current.onAccept : undefined
        //--

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

        Text { //ui_audio_settings_title
            id: ui_audio_settings_title
            text: "UI"
            color: settings.color_text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            anchors.top: parent.top
        }


        Item { //ui_audio_settings_volume
            id: ui_audio_settings_volume

            anchors.top: ui_audio_settings_title.bottom
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

            Text { //ui_audio_settings_volume_text
                id: ui_audio_settings_volume_text
                text: "default volume"
                color: settings.color_text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //ui_audio_settings_volume_slider
                id: ui_audio_settings_volume_slider

                anchors.left: ui_audio_settings_volume_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: parent.right

                min: 1
                max: 100

                value: (settings.uiVolume*100)
                percent: true
                selected: ui_audio_settings.selected && ui_audio_settings.current === this
                memory: "struceOS_ui_volume"

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        ui_audio_settings.current = ui_audio_settings_mute
                }
            }
        }

        ToggleBox { //ui_audio_settings_mute
            id: ui_audio_settings_mute
            text: "mute"

            anchors.top: ui_audio_settings_volume.bottom
            anchors.topMargin: vpx(12)

            selected: ui_audio_settings.selected && ui_audio_settings.current === this
            value: settings_loader.item.uiMute

            onClicked: function(){
                settings.uiMute = !value
                api.memory.set("struceOS_ui_Mute", value)
            }
            property var onAccept: onClicked

            property var onUp: function(){
                ui_audio_settings.current = ui_audio_settings_volume_slider
            }

            property var onDown: function(){
                audio_settings.current = video_audio_settings
            }
        }
    }

    Item { //video_audio_settings
        id: video_audio_settings

        anchors.top: ui_audio_settings.bottom
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        property bool selected: page.selected && page.current === this
        property var current: video_audio_settings_volume_slider

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
            }
            property var onDown: function(){
                if(current.onDown)
                    current.onDown()
            }
            property var onLeft: function(){
                if(current.onLeft)
                    current.onLeft()
            }

            property var onRight: current.onRight != undefined ? current.onRight : undefined
            property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
            property var onNext: current.onNext != undefined ? current.onNext : undefined
            property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
            property var onLast: current.onLast != undefined ? current.onLast : undefined
            property var onDetails: current.onDetails != undefined ? current.onDetails : undefined
            property var onSort: current.onSort != undefined ? current.onSort : undefined
            property var onCancel: current.onCancel != undefined ? current.onCancel : undefined
            property var onAccept: current.onAccept != undefined ? current.onAccept : undefined
        //--

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

        Text { //video_audio_settings_title
            id: video_audio_settings_title
            text: "Video"
            color: settings.color_text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            anchors.top: parent.top
        }


        Item { //video_audio_settings_volume
            id: video_audio_settings_volume

            anchors.top: video_audio_settings_title.bottom
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

            Text { //video_audio_settings_volume_text
                id: video_audio_settings_volume_text
                text: "default volume"
                color: settings.color_text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //video_audio_settings_volume_slider
                id: video_audio_settings_volume_slider

                anchors.left: video_audio_settings_volume_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: parent.right

                min: 1
                max: 100

                value: (settings.videoVolume*100)
                percent: true
                selected: video_audio_settings.selected && video_audio_settings.current === this
                memory: "struceOS_video_volume"

                onUp: function(){
                    if(current.onUp)
                        current.onUp()
                    else
                    audio_settings.current = ui_audio_settings
                }

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        video_audio_settings.current = video_audio_settings_mute
                }
            }
        }

        ToggleBox { //video_audio_settings_mute
            id: video_audio_settings_mute
            text: "mute"

            anchors.top: video_audio_settings_volume.bottom
            anchors.topMargin: vpx(12)

            selected: video_audio_settings.selected && video_audio_settings.current === this
            value: 
                api.memory.get("struceOS_video_videoMute") != undefined ?
                    api.memory.get("struceOS_video_videoMute") : true

            onClicked: function(){
                value = !value
                api.memory.set("struceOS_video_videoMute", value)
            }
            property var onAccept: onClicked

            property var onUp: function(){
                video_audio_settings.current = video_audio_settings_volume_slider
            }

            property var onDown: function(){
                video_audio_settings.current = this
            }
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
}