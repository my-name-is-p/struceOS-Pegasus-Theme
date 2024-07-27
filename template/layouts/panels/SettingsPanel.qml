// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15


import "pages-settings"
import "../../widgets"

Item {
    id: panel
    
    anchors.fill: parent
    anchors.margins: vpx(24)

    property Item current: panel

    property string name: "panel"

    //Functions
        property var onCancel: function(){
            current = panel
            f = game_layout
        }

        function fullReset(){
            if(pages.current.reset)
                pages.current.reset()
            panel.current = panel
            panel.Keys.forwardTo = panel
        }
    //--

    Item { //header_buttons
        id: header_buttons

        anchors.top: parent.top
        anchors.topMargin: vpx(-12)
        anchors.left: parent.left
        anchors.right: parent.right

        height: vpx(48)

        CloseButton { //settings_close
            id: settings_close

            icon_color: settings.color_text

            selected: panel.current === this

            onClicked: function(){
                panel.onCancel()
            }
            property var onAccept: onClicked

            property var onUp: function(){
                panel.current = panel
                header.current = header.collection
                f = header
            }

            property var onDown: function(){
                panel.current = pages
                panel.Keys.forwardTo = pages
            }
            property var onRight: onDown
        }
    }

    Item { //page_margins
        id: page_margins

        anchors.top: header_buttons.bottom
        anchors.left: parent.left
        anchors.leftMargin: panel.width * 0.25
        anchors.right: parent.right
        anchors.rightMargin: panel.width * 0.25
        anchors.bottom: parent.bottom

        Item { //page_selection
            id:page_selection

            anchors.top: parent.top

            Component.onCompleted: {
                if(width > parent.width)
                    anchors.horizontalCenter = parent.horizontalCenter
                else
                    anchors.left = parent.left
            }

            height: vpx(48)

            width: { //width
                let sum = 0
                for (var i = 0; i < children.length; i++) {
                    sum += children[i].width + children[i].anchors.leftMargin
                }
                return sum;
            }

            property bool selected: false

            property var onNext: page_list.current.onNext
            property var onPrevious: page_list.current.onPrevious
            
            Image { //leftBumper
                id: leftBumper
                source: images.leftBumper

                width: vpx(32)
                height: vpx(32)

                anchors.verticalCenter: parent.verticalCenter
            }

            Image { //leftSlash
                id: leftSlash
                source: images.slash

                anchors.left: leftBumper.right
                anchors.leftMargin: vpx(6)

                width: vpx(12)
                height: vpx(12)
                

                anchors.verticalCenter: parent.verticalCenter
            }

            Image { //key_q
                id: key_q
                source: images.key_q

                anchors.left: leftSlash.right
                anchors.leftMargin: vpx(6)
                
                width: vpx(24)
                height: vpx(24)

                anchors.verticalCenter: parent.verticalCenter
            }

            Item { //page_list
                id: page_list

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: key_q.right
                anchors.leftMargin: vpx(24)

                property Item current: page_list_layout

                width: { //width
                    let sum = 0
                    for (var i = 1; i < children.length; i++) {
                        sum += children[i].width + children[i].anchors.leftMargin
                    }
                    return sum;
                }

                Rectangle { //page_list_select
                    id: page_list_select

                    anchors.top: parent.top
                    anchors.topMargin: page_selection.selected ? vpx(6) : (parent.height - vpx(6)) * 0.95
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: vpx(6)
                    anchors.left: parent.current.left
                    anchors.leftMargin: vpx(-6)
                    anchors.right: parent.current.right
                    anchors.rightMargin: vpx(-6)

                    radius: vpx(6)
                }

                Text { //page_list_layout
                    id: page_list_layout
                    anchors.verticalCenter: parent.verticalCenter
                    text: "layout"
                    color: page_selection.selected && parent.current === this ? settings.color_text_invert : settings.color_white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    property var onNext: function(){
                        page_list.current = page_list_colors
                        pages.current = color_settings
                    }

                    property var onPrevious: function(){
                        page_list.current = this
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            page_list.current = page_list_layout
                            pages.current = layout_settings
                            audio.stopAll()
                            audio.toggle_down.play()
                        }

                    }
                }

                Text { //page_list_colors
                    id: page_list_colors
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: page_list_layout.right
                    anchors.leftMargin: vpx(12)
                    text: "colors"
                    color: page_selection.selected && parent.current === this ? settings.color_text_invert : settings.color_white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    property var onNext: function(){
                        page_list.current = page_list_audio
                        pages.current = audio_settings
                    }

                    property var onPrevious: function(){
                        page_list.current = page_list_layout
                        pages.current = layout_settings
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            page_list.current = page_list_colors
                            pages.current = color_settings
                            audio.stopAll()
                            audio.toggle_down.play()
                        }

                    }
                }

                Text { //page_list_audio
                    id: page_list_audio
                    anchors.verticalCenter: page_list.verticalCenter
                    anchors.left: page_list_colors.right
                    anchors.leftMargin: vpx(12)
                    text: "audio"
                    color: page_selection.selected && page_list.current === this ? settings.color_text_invert : settings.color_white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    property var onNext: function(){
                        page_list.current = page_list_devtools
                        pages.current = devtools_settings
                    }

                    property var onPrevious: function(){
                        page_list.current = page_list_colors
                        pages.current = color_settings
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            page_list.current = page_list_audio
                            pages.current = audio_settings
                            audio.stopAll()
                            audio.toggle_down.play()
                        }
                    }
                }

                Text { //page_list_devtools
                    id: page_list_devtools
                    anchors.verticalCenter: page_list.verticalCenter
                    anchors.left: page_list_audio.right
                    anchors.leftMargin: vpx(12)
                    text: "devtools"
                    color: page_selection.selected && parent.current === this ? settings.color_text_invert : settings.color_white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    property var onNext: function(){
                        page_list.current = this
                    }

                    property var onPrevious: function(){
                        page_list.current = page_list_audio
                        pages.current = audio_settings
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            page_list.current = page_list_devtools
                            pages.current = devtools_settings
                            audio.stopAll()
                            audio.toggle_down.play()
                        }
                    }
                }
            }

            Image { //key_e
                id: key_e
                source: images.key_e

                anchors.left: page_list.right
                anchors.leftMargin: vpx(24)
                
                width: vpx(24)
                height: vpx(24)

                anchors.verticalCenter: parent.verticalCenter
            }

            Image { //rightSlash
                id: rightSlash
                source: images.slash

                anchors.left: key_e.right
                anchors.leftMargin: vpx(6)

                width: vpx(12)
                height: vpx(12)
                

                anchors.verticalCenter: parent.verticalCenter
            }

            Image { //rightBumper
                id: rightBumper
                source: images.rightBumper

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: rightSlash.right
                anchors.leftMargin: vpx(6)

                width: vpx(32)
                height: vpx(32)


            }
        }

        Item { //pages
            id: pages

            anchors.top: page_selection.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            property bool selected: panel.current === this
            property var current: layout_settings


            //Functions--
                property var onUp: current.onUp != undefined ? current.onUp : undefined
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

            LayoutSettings { //layout_settings
                id: layout_settings

                anchors.fill: parent

                property string name: "layout_settings"

                selected: pages.selected && pages.current === this
                visible: pages.current === this

                exitMenu: function(){
                    reset()
                    panel.current = settings_close
                    panel.Keys.forwardTo = panel
                }
            }

            ColorSettings {
                id: color_settings
                anchors.fill: parent
                
                selected: pages.selected && pages.current === this
                visible: pages.current === this

                exitMenu: function(){
                    reset()
                    panel.current = settings_close
                    panel.Keys.forwardTo = panel
                }

                onCancel: function(){
                    reset()
                    panel.current = settings_close
                    panel.Keys.forwardTo = panel
                    panel.onCancel()
                }
            }

            AudioSettings {
                id: audio_settings

                anchors.fill: parent
                
                selected: pages.selected && pages.current === this
                visible: pages.current === this

                exitMenu: function(){
                    reset()
                    panel.current = settings_close
                    panel.Keys.forwardTo = panel
                }

                onCancel: function(){
                    reset()
                    panel.current = settings_close
                    panel.Keys.forwardTo = panel
                    panel.onCancel()
                }
            }

            DevtoolsSettings {
                id: devtools_settings

                anchors.fill: parent

                selected: pages.selected && pages.current === this
                visible: pages.current === this

                exitMenu: function(){
                    reset()
                    panel.current = settings_close
                    panel.Keys.forwardTo = panel
                }
            }

            Keys.forwardTo: current
        }
    }
    //TO DO--
        //Background
            //overlay source
                //5 default
                //custom file path
        //Colors
            //accent
            //accent_light
            //scrub_bar
            //launch
            //launch_hover
            //border
            //text
            //text_invert
            //black
            //white
    //--

    Keys.onPressed: {
        let key = gsk(event)
        if(key != undefined){
            switch (key){
                case "up":
                    if(current.onUp != undefined)
                        current.onUp()
                    else
                        current = settings_close
                    break
                case "down":
                    if(current.onDown != undefined)
                        current.onDown()
                    else
                        current = settings_close
                    break
                case "left":
                    if(current.onLeft != undefined)
                        current.onLeft()
                    else
                        current = settings_close
                    break
                case "right":
                    if(current.onRight != undefined)
                        current.onRight()
                    else
                        current = settings_close
                    break
                case "prev":
                    if(current.onPrevious != undefined)
                        current.onPrevious()
                    else
                        page_selection.onPrevious()
                    break
                case "next":
                    if(current.onNext != undefined)
                        current.onNext()
                    else
                        page_selection.onNext()
                    break
                case "first":
                    if(current.onFirst != undefined)
                        current.onFirst()
                    break
                case "last":
                    if(current.onLast != undefined)
                        current.onLast()
                    break
                case "details":
                    panel_area.current = panel_area.info_panel
                    panel_area.info_panel.video.safePlay()
                    break
                case "filter":
                    f = sortfilt_menu
                    current = panel
                    break
                case "cancel":
                    if(current.onCancel != undefined)
                        current.onCancel()
                    onCancel()
                    event.accepted = true
                    break
                case "accept":
                    if(current.onAccept != undefined)
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

    property ListModel color_model: color_settings.color_model
}