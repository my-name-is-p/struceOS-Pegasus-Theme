// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "../../../../widgets"

Item {
    id: page

    property bool selected: false
    property var current: ui_audio_settings_volume_slider

    //Functions--
        function reset(){
            page.current = ui_audio_settings_volume_slider
        }
    
        property var onUp: current.onUp
        property var onDown: current.onDown
        property var onLeft: current.onLeft
        property var onRight: current.onRight
        property var onPrevious: current.onPrevious
        property var onNext: current.onNext
        property var onFirst: current.onFirst
        property var onLast: current.onLast
        property var onDetails: current.onDetails
        property var onSort: current.onSort
        property var onCancel: current.onCancel
        property var onAccept: current.onAccept
    //

    Item { //ui_audio_settings
        id: ui_audio_settings

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Text { //ui_audio_settings_title
            id: ui_audio_settings_title
            text: "UI"

            anchors.top: parent.top

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }


        Item { //ui_audio_settings_volume
            id: ui_audio_settings_volume

            anchors.top: ui_audio_settings_title.bottom
            anchors.topMargin: vpx(12)
            anchors.left: parent.left
            anchors.right: parent.right

            Component.onCompleted: {
                height = childrenSize(this, "height", "", 0, 0, true)
            }

            Text { //ui_audio_settings_volume_text
                id: ui_audio_settings_volume_text
                text: "default volume"

                color: colors.text

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
                selected: page.selected && page.current === this
                memory: "struceOS_ui_volume"

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        page.current = ui_audio_settings_mute
                }
            }
        }

        ToggleBox { //ui_audio_settings_mute
            id: ui_audio_settings_mute
            text: "mute"

            anchors.top: ui_audio_settings_volume.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings_loader.item.uiMute

            onClicked: function(){
                settings.uiMute = !value
                api.memory.set("struceOS_ui_Mute", value)
            }
            property var onAccept: onClicked

            function onUp(){
                page.current = ui_audio_settings_volume_slider
            }

            function onDown(){
                page.current = video_audio_settings_volume_slider
            }
        }
    }

    Item { //video_audio_settings
        id: video_audio_settings

        anchors.top: ui_audio_settings.bottom
        anchors.left: page.left
        anchors.right: page.right
        anchors.margins: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Text { //video_audio_settings_title
            id: video_audio_settings_title
            text: "Video"
            color: colors.text

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

            Component.onCompleted: {
                height = childrenSize(this, "height", "", 0, 0, true)
            }

            Text { //video_audio_settings_volume_text
                id: video_audio_settings_volume_text
                text: "default volume"
                color: colors.text

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
                selected: page.selected && page.current === this
                memory: "struceOS_video_volume"

                onUp: function(){
                    if(current.onUp)
                        current.onUp()
                    else
                        page.current = ui_audio_settings_mute
                }

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        page.current = video_audio_settings_mute
                }
            }
        }

        ToggleBox { //video_audio_settings_mute
            id: video_audio_settings_mute
            text: "mute"

            anchors.top: video_audio_settings_volume.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: 
                api.memory.get("struceOS_video_videoMute") != undefined ?
                    api.memory.get("struceOS_video_videoMute") : true

            onClicked: function(){
                value = !value
                api.memory.set("struceOS_video_videoMute", value)
            }
            property var onAccept: onClicked

            function onUp(){
                page.current = video_audio_settings_volume_slider
            }
        }
    }
}