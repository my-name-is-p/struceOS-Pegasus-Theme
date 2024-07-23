// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "../../../widgets"

Item {
    id: page

    property bool selected: false
    property var current: theme_info

    property var exitMenu: function(){}
    property var onCancel: function(){}

    function reset(){
        page.current = theme_info
        theme_info.current = theme_info_donation_link
        devtools_settings.current = devtools_settings_opacity_slider
    }

    Item { //theme_info
        id: theme_info

        anchors.top: parent.top
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        property bool selected: page.selected && page.current === this
        property var current: theme_info_donation_link

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else{
                    current = theme_info_donation_link
                    page.exitMenu()
                }
            }

            property var onDown: current.onDown != undefined ? current.onDown : undefined
            property var onLeft: current.onLeft != undefined ? current.onLeft : undefined
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

        Text { //theme_info_name
            id: theme_info_name
            text: "name: " + settings.name
            color: p.text

            font.family: regular.name
            font.pixelSize: vpx(10)
        }

        Text { //theme_info_version
            id: theme_info_version
            text: "version: " + settings.version  + (settings.working ? "-working" : "")
            color: p.text

            anchors.top: theme_info_name.bottom

            font.family: regular.name
            font.pixelSize: vpx(10)
        }

        DonationButton { //theme_info_donation_link
            id: theme_info_donation_link

            anchors.top: theme_info_version.bottom
            anchors.topMargin: vpx(6)
            property var onDown: function(){
                page.current = devtools_settings
            }
            selected: theme_info.selected && theme_info.current === this

            property var onAccept: function(){
                Qt.openUrlExternally(theme_info_donation_link.link)
            }
        }
    }

    Item { //devtools_settings
        id: devtools_settings

        anchors.top: theme_info.bottom
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        property bool selected: page.selected && page.current === this
        property var current: devtools_settings_opacity_slider

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else
                    page.current = theme_info
            }

            property var onDown: current.onDown != undefined ? current.onDown : undefined
            property var onLeft: current.onLeft != undefined ? current.onLeft : undefined
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

        Text { //devtools_settings_title
            id: devtools_settings_title
            text: "Devtools"
            color: p.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            anchors.top: parent.top
        }


        Item { //devtools_settings_opacity
            id: devtools_settings_opacity

            anchors.top: devtools_settings_title.bottom
            anchors.topMargin: vpx(12)
            anchors.left: parent.left
            anchors.right: parent.right

            height: { //height
                let sum = 0
                for (var i = 0; i < children.length; i++) {
                    sum = children[i].height > sum ? children[i].height : sum
                }
                return sum;
            }

            Text { //devtools_settings_opacity_text
                id: devtools_settings_opacity_text
                text: "opacity"
                color: p.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //devtools_settings_opacity_slider
                id: devtools_settings_opacity_slider

                anchors.left: devtools_settings_opacity_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: parent.right

                min: 1
                max: 100

                value: (settings.consoleLogBackground*100)
                percent: true
                selected: devtools_settings.selected && devtools_settings.current === this
                memory: "struceOS_dev_log_opacity"

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        devtools_settings.current = devtools_settings_on
                }
            }
        }

        ToggleBox { //devtools_settings_on
            id: devtools_settings_on
            text: "show log"

            anchors.top: devtools_settings_opacity.bottom
            anchors.topMargin: vpx(12)

            selected: devtools_settings.selected && devtools_settings.current === this
            value: settings.enableDevTools

            onClicked: function(){
                settings.enableDevTools = !value
                api.memory.set("struceOS_dev_enableDevTools", settings.enableDevTools)
                if(settings.enableDevTools)
                    log("struceOS v" + settings.version + (settings.working ? "-working" : ""), false, true)
                
            }
            property var onAccept: onClicked

            property var onUp: function(){
                devtools_settings.current = devtools_settings_opacity_slider
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