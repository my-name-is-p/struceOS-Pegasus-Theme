// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15


import "parts-settings"
import "../../../widgets"

Item {
    id: panel
    
    anchors.fill: parent
    anchors.margins: vpx(24)

    property Item current: panel

    property string name: "panel"

    //Functions
        function activate(){
            if(current === panel)
                current = close
        }

        function closePanel(){
                reset()
                current = panel
                resetFocus()
        }
    
        property var onUp: current != panel ? current.onUp : activate
        property var onDown: current != panel ? current.onDown : activate
        property var onLeft: current != panel ? current.onLeft : activate
        property var onRight: current != panel ? current.onRight : activate

        property var onPrevious: current != panel && current.onPrevious ? current.onPrevious : page_selection.onPrevious
        property var onNext: current != panel && current.onNext ? current.onNext : page_selection.onNext

        property var onFirst: current != panel ? current.onFirst : activate
        property var onLast: current != panel ? current.onLast : activate
        property var onDetails: current != panel ? current.onDetails : activate
        property var onSort: current != panel ? current.onSort : activate
        property var onCancel: current != panel && current.onCancel ? current.onCancel : closePanel
        
        function onAccept(){
            if(current.onAccept)
                current.onAccept()
        }
    
        function reset(){
            let c = pages.children
            for(var i = 0; i < c.length; i++){
                if(c[i].reset)
                    c[i].reset()
            }
        }

        Component.onCompleted: reset
    //--

    Item { //header_buttons
        id: header_buttons

        anchors.top: panel.top
        anchors.topMargin: vpx(-12)
        anchors.left: panel.left
        anchors.right: panel.right

        height: vpx(48)

        CloseButton { //close
            id: close

            sound: audio.toggle_down

            selected: panel.current === this

            onClicked: function(){
                panel.onCancel()
            }
            property var onAccept: onClicked

            function onDown(){
                panel.current = pages
            }
            property var onRight: onDown
        }
    }

    Item { //page_margins
        id: page_margins

        anchors.top: header_buttons.bottom
        anchors.bottom: panel.bottom
        anchors.left: panel.left
        anchors.leftMargin: panel.width * 0.25
        anchors.right: panel.right
        anchors.rightMargin: panel.width * 0.25

        Item { //page_selection
            id:page_selection

            anchors.top: parent.top

            anchors.left: parent.left

            height: vpx(48)
            width: childrenSize(this, "width", "leftMargin")

            property bool selected: false

            function onNext(){
                panel.reset()
                page_list.current.onNext()
            }
            function onPrevious(){
                panel.reset()
                page_list.current.onPrevious()
            }
            
            Item { //left_buttons_mask
                id: left_buttons_mask

                anchors.left: parent.left

                height: parent.height
                width: childrenSize(this, "width", "leftMargin")

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
            }

            Rectangle { //left_buttons_color
                id: left_buttons_color

                anchors.fill: left_buttons_mask

                color: colors.white

                visible: false
            }

            OpacityMask { //left_buttons_out
                id: left_buttons_out
                anchors.fill: left_buttons_mask
                source: left_buttons_color
                maskSource: left_buttons_mask
            }

            Item { //page_list
                id: page_list

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: left_buttons_mask.right
                anchors.leftMargin: vpx(24)

                property Item current: page_list_layout

                width: childrenSize(this, "width", "leftMargin", 0, 1)

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

                    color: colors.white
                }

                Text { //page_list_layout
                    id: page_list_layout
                    anchors.verticalCenter: parent.verticalCenter
                    text: "layout"
                    color: colors.white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    function onNext(){
                        page_list.current = page_list_colors
                        pages.current = color_settings
                    }

                    function onPrevious(){
                        page_list.current = this
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            panel.reset()
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
                    color: colors.white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    function onNext(){
                        page_list.current = page_list_audio
                        pages.current = audio_settings
                    }

                    function onPrevious(){
                        page_list.current = page_list_layout
                        pages.current = layout_settings
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            panel.reset()
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
                    color: colors.white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    function onNext(){
                        page_list.current = page_list_tools
                        pages.current = tools_settings
                    }

                    function onPrevious(){
                        page_list.current = page_list_colors
                        pages.current = color_settings
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            panel.reset()
                            page_list.current = page_list_audio
                            pages.current = audio_settings
                            audio.stopAll()
                            audio.toggle_down.play()
                        }
                    }
                }

                Text { //page_list_tools
                    id: page_list_tools
                    anchors.verticalCenter: page_list.verticalCenter
                    anchors.left: page_list_audio.right
                    anchors.leftMargin: vpx(12)
                    text: "tools"
                    color: colors.white

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(20)

                    function onNext(){
                        page_list.current = this
                    }

                    function onPrevious(){
                        page_list.current = page_list_audio
                        pages.current = audio_settings
                    }

                    MouseArea {
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent

                        onClicked: {
                            panel.reset()
                            page_list.current = page_list_tools
                            pages.current = tools_settings
                            audio.stopAll()
                            audio.toggle_down.play()
                        }
                    }
                }
            }

            Item { //right_buttons_mask
                id: right_buttons_mask
                anchors.left: page_list.right
                anchors.leftMargin: vpx(24)

                height: parent.height
                width: childrenSize(this, "width", "leftMargin")

                visible: false

                Image { //key_e
                    id: key_e
                    source: images.key_e

                    
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

            Rectangle { //right_buttons_color
                id: right_buttons_color

                anchors.fill: right_buttons_mask

                color: colors.white

                visible: false
            }

            OpacityMask { //right_buttons_out
                id: right_buttons_out
                anchors.fill: right_buttons_mask
                source: right_buttons_color
                maskSource: right_buttons_mask
            }
        }

        Item { //pages
            id: pages

            anchors.top: page_selection.bottom
            anchors.bottom: page_margins.bottom
            anchors.left: page_margins.left
            anchors.right: page_margins.right

            property bool selected: panel.current === this
            property var current: layout_settings


            //Functions--
                function onUp(){
                    if(current.onUp)
                        current.onUp()
                    else
                        panel.current = close
                }

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
            //--

            LayoutSettings { //clean
                id: layout_settings

                anchors.fill: pages

                selected: pages.selected && pages.current === this
                visible: pages.current === this
            }

            ColorSettings { //clean
                id: color_settings

                anchors.fill: pages
                
                selected: pages.selected && pages.current === this
                visible: pages.current === this
            }

            AudioSettings { //clean
                id: audio_settings

                anchors.fill: pages
                
                selected: pages.selected && pages.current === this
                visible: pages.current === this
            }

            ToolsSettings { //clean
                id: tools_settings

                anchors.fill: pages

                selected: pages.selected && pages.current === this
                visible: pages.current === this
            }
        }
    }
}