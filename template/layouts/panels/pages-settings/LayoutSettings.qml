// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import "../../../widgets"

Item { //page
    id: page

    property bool selected: false
    property var current: header_settings

    property var exitMenu: function(){}
    property var onCancel: function(){}

    //Functions--
        function reset(){
            page.current = header_settings
            header_settings.current = header_settings_size_small
            game_layout_settings.current = game_layout_settings_columns_slider
            background_settings.current = background_settings_overlay_on
        }
    //--

    Item { //header_settings
        id: header_settings

        anchors.top: parent.top
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        property bool selected: page.selected && page.current === this
        property var current: header_settings_size_small

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

        Text { //header_settings_title
            id: header_settings_title
            text: "Header"
            color: p.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            anchors.top: parent.top
        }

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else{
                    current = header_settings_size_small
                    page.exitMenu()
                }
            }
            property var onDown: function(){
                if(current.onDown)
                    current.onDown()
                else{
                    page.current = game_layout_settings
                    current = header_settings_size_small
                }
            }
            property var onLeft: function(){
                if(current.onLeft)
                    current.onLeft()
                else
                    page.exitMenu()
            }

            property var onRight: current.onRight != undefined ? current.onRight : undefined
            property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
            property var onNext: current.onNext != undefined ? current.onNext : undefined
            property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
            property var onLast: current.onLast != undefined ? current.onLast : undefined
            property var onDetails: current.onRight != undefined ? current.onRight : undefined
            property var onSort: current.onSort != undefined ? current.onSort : undefined
            property var onCancel: current.onCancel != undefined ? current.onCancel : undefined
            property var onAccept: current.onAccept != undefined ? current.onAccept : undefined
        //--

        Item { //header_settings_size
            id: header_settings_size

            anchors.top: header_settings_title.bottom
            anchors.topMargin: vpx(6)
            anchors.left: parent.left
            anchors.right: parent.right

            height: { //height
                let sum = 0
                for (var i = 0; i < children.length; i++) {
                    sum = children[i].height > sum ? children[i].height : sum
                }
                return sum;
            }

            Text { //header_settings_size_text
                id: header_settings_size_text
                text: "size"
                color: p.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            Item { //header_settings_size_radio
                id: header_settings_size_radio
                anchors.right: parent.right

                height: { //height
                    let sum = 0
                    for (var i = 0; i < children.length; i++) {
                        sum = children[i].height > sum ? children[i].height : sum
                    }
                    return sum;
                }

                width: { //width
                    let sum = 0
                    for (var i = 0; i < children.length; i++) {
                        sum += children[i].width + children[i].anchors.rightMargin
                    }
                    return sum;
                }

                RadioItem { //header_settings_size_small
                    id: header_settings_size_small
                    text: "small"

                    anchors.right: header_settings_size_medium.left
                    anchors.rightMargin: vpx(12)

                    siblings: parent.children

                    enabled: stest.headerSize === "s"

                    selected: header_settings.selected && header_settings.current === this

                    onClicked: function(){
                        resetItems()
                        stest.headerSize = "s"
                        api.memory.set("struceOS_ui_headerSize", stest.headerSize)
                    }
                    property var onAccept: onClicked

                    onRight: function(){
                        header_settings.current = header_settings_size_medium
                    }
                }

                RadioItem { //header_settings_size_medium
                    id: header_settings_size_medium
                    text: "medium"

                    anchors.right: header_settings_size_large.left
                    anchors.rightMargin: vpx(12)

                    siblings: parent.children

                    enabled: stest.headerSize === "m"

                    selected: header_settings.selected && header_settings.current === this

                    onClicked: function(){
                        resetItems()
                        stest.headerSize = "m"
                        api.memory.set("struceOS_ui_headerSize", stest.headerSize)
                    }
                    property var onAccept: onClicked

                    onLeft: function(){
                        header_settings.current = header_settings_size_small
                    }

                    onRight: function(){
                        header_settings.current = header_settings_size_large
                    }
                }

                RadioItem { //header_settings_size_large
                    id: header_settings_size_large
                    text: "large"

                    anchors.right: parent.right

                    siblings: parent.children

                    enabled: stest.headerSize === "l"

                    selected: header_settings.selected && header_settings.current === this

                    onClicked: function(){
                        resetItems()
                        stest.headerSize = "l"
                        api.memory.set("struceOS_ui_headerSize", stest.headerSize)
                    }
                    property var onAccept: onClicked

                    onLeft: function(){
                        header_settings.current = header_settings_size_medium
                    }
                }
            }
        }
    }

    Item { //game_layout_settings
        id: game_layout_settings

        anchors.top: header_settings.bottom
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        property bool selected: page.selected && page.current === this
        property var current: game_layout_settings_columns_slider

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else
                    page.current = header_settings
            }

            property var onLeft: function(){
                if(current.onLeft)
                    current.current.onLeft()
                else
                    page.exitMenu()
            }

            property var onDown: current.onDown != undefined ? current.onDown : undefined
            property var onRight: current.onRight != undefined ? current.onRight : undefined
            property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
            property var onNext: current.onNext != undefined ? current.onNext : undefined
            property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
            property var onLast: current.onLast != undefined ? current.onLast : undefined
            property var onDetails: current.onRight != undefined ? current.onRight : undefined
            property var onSort: current.onRight != undefined ? current.onRight : undefined
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

        Text { //game_layout_settings_title
            id: game_layout_settings_title
            text: "Game Layout"
            color: p.text

            anchors.top: parent.top

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }

        Item { //game_layout_settings_columns
            id: game_layout_settings_columns

            anchors.top: game_layout_settings_title.bottom
            anchors.topMargin: vpx(6)
            anchors.left: parent.left
            anchors.right: parent.right

            height: { //height
                let sum = 0
                for (var i = 0; i < children.length; i++) {
                    sum = children[i].height > sum ? children[i].height : sum
                }
                return sum;
            }

            Text { //game_layout_settings_columns_text
                id: game_layout_settings_columns_text
                text: "columns"
                color: p.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //game_layout_settings_columns_slider
                id: game_layout_settings_columns_slider

                property string name: "game_layout_settings_columns_slider"

                anchors.left: game_layout_settings_columns_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: parent.right

                min: 3
                max: 10

                value: stest.columns
                memory: "struceOS_gameLayout_columns"

                selected: game_layout_settings.selected && game_layout_settings.current === this

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        game_layout_settings.current = game_layout_settings_thumbnails
                }
            }
        }

        ToggleBox { //game_layout_settings_thumbnails
            id: game_layout_settings_thumbnails
            text: "show thumbnail backgrounds"

            anchors.top: game_layout_settings_columns.bottom
            anchors.topMargin: vpx(12)

            selected: game_layout_settings.selected && game_layout_settings.current === this
            value: stest.showThumbs

            onClicked: function(){
                stest.showThumbs = !value
                api.memory.set("struceOS_gameLayout_thumbnails", value)
            }
            property var onAccept: onClicked

            property var onUp: function(){
                game_layout_settings.current = game_layout_settings_columns_slider
            }

            property var onDown: function(){
                game_layout_settings.current = game_layout_settings_last_played
            }
        }

        ToggleBox { //game_layout_settings_last_played
            id: game_layout_settings_last_played
            text: "open to last played"

            anchors.top: game_layout_settings_thumbnails.bottom
            anchors.topMargin: vpx(12)

            selected: game_layout_settings.selected && game_layout_settings.current === this
            value: stest.lastPlayed

            onClicked: function(){
                stest.lastPlayed = !value
                api.memory.set("struceOS_gameLayout_lastPlayed", value)
            }
            property var onAccept: onClicked

            property var onUp: function(){
                game_layout_settings.current = game_layout_settings_thumbnails
            }

            property var onDown: function(){
                game_layout_settings.current = game_layout_settings_all_games
            }
        }

        ToggleBox { //game_layout_settings_all_games
            id: game_layout_settings_all_games
            text: "show all games"

            anchors.top: game_layout_settings_last_played.bottom
            anchors.topMargin: vpx(12)

            selected: game_layout_settings.selected && game_layout_settings.current === this
            value: stest.allGames

            onClicked: function(){
                if(currentCollectionIndex === -1){
                    currentCollectionIndex = 0
                    games.currentIndex = 0
                }
                stest.allGames = !value
                api.memory.set("struceOS_gameLayout_allGames", stest.allGames)
                collections_menu.model.populateModel()
            }
            property var onAccept: onClicked

            property var onUp: function(){
                game_layout_settings.current = game_layout_settings_last_played
            }

            property var onDown: function(){
                page.current = background_settings
            }
        }
    }

    Item { //background_settings
        id: background_settings

        property bool selected: page.selected && page.current === this
        property var current: background_settings_overlay_on

        anchors.top: game_layout_settings.bottom
        anchors.topMargin: vpx(12)
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: parent.right
        anchors.rightMargin: vpx(12)

        //Functions--
            property var onUp: function(){
                if(current.onUp)
                    current.onUp()
                else
                    page.current = game_layout_settings
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
            color: p.text

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
            value: stest.bgOverlayOn

            onClicked: function(){
                stest.bgOverlayOn = !value
                api.memory.set("struceOS_background_overlayOn", stest.bgOverlayOn)
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
                let sum = 0
                for (var i = 0; i < children.length; i++) {
                    sum = children[i].height > sum ? children[i].height : sum
                }
                return sum;
            }

            Text { //background_settings_overlay_opacity_text
                id: background_settings_overlay_opacity_text
                text: "overlay opacity"
                color: p.text

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

                value: (stest.bgOverlayOpacity*100)
                percent: true
                selected: background_settings.selected && background_settings.current === this
                memory: "struceOS_background_overlayOpacity"

                property var onUp: function(){
                    if(current.onUp)
                        current.onUp()
                    else
                        background_settings.current = background_settings_overlay_on
                }
            }
        }
    }

    Keys.onPressed: { //Keys
        let key = gsk(event)
        if(key != undefined){
            switch (key){
                case "up":
                    if(current.onUp != undefined)
                        current.onUp()
                    else
                        exitMenu()
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
                    else
                        exitMenu()
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

//Background
    //overlay source
        //5 default
        //1 custom
