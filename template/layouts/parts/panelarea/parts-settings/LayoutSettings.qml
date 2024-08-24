// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "../../../../widgets"
import "radio"

Item { //page
    id: page

    property bool selected: false
    property var current: header_settings_size_radio

    //Functions--
        function reset(){
            page.current = header_settings_size_radio
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
    //--

    Item { //header_settings
        id: header_settings

        anchors.top: page.top
        anchors.topMargin: vpx(12)
        anchors.left: page.left
        anchors.leftMargin: vpx(12)
        anchors.right: page.right
        anchors.rightMargin: vpx(12)

        property var current: header_settings_size_radio

        height: childrenSize(this, "height", "topMargin")

        Text { //header_settings_title
            id: header_settings_title
            text: "Header"

            anchors.top: header_settings.top

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }

        Item { //header_settings_size
            id: header_settings_size

            anchors.top: header_settings_title.bottom
            anchors.topMargin: vpx(6)
            anchors.left: header_settings.left
            anchors.right: header_settings.right

            height: childrenSize(this, "height", "", 0, 0, true)

            Text { //header_settings_size_text
                id: header_settings_size_text
                text: "size"

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            HeaderSizeRadio { //header_settings_size_radio
                id: header_settings_size_radio

                selected: page.selected && page.current === this
                anchors.right: header_settings_size.right

                function onDown(){
                    if(current.onDown)
                        current.onDown()
                    else
                        page.current = game_layout_settings_columns_slider
                }
            }
        }
    }

    Item { //game_layout_settings
        id: game_layout_settings

        anchors.top: header_settings.bottom
        anchors.topMargin: vpx(12)
        anchors.left: page.left
        anchors.leftMargin: vpx(12)
        anchors.right: page.right
        anchors.rightMargin: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        property bool selected: page.selected && page.current === this
        property var current: game_layout_settings_columns_slider

        Text { //game_layout_settings_title
            id: game_layout_settings_title
            text: "Game Layout"

            anchors.top: game_layout_settings.top

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }

        Item { //game_layout_settings_columns
            id: game_layout_settings_columns

            anchors.top: game_layout_settings_title.bottom
            anchors.topMargin: vpx(6)
            anchors.left: game_layout_settings.left
            anchors.right: game_layout_settings.right

            height: childrenSize(this, "height", "", 0, 0, true)

            Text { //game_layout_settings_columns_text
                id: game_layout_settings_columns_text
                text: "columns"

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //game_layout_settings_columns_slider
                id: game_layout_settings_columns_slider

                anchors.left: game_layout_settings_columns_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: game_layout_settings_columns.right

                min: 3
                max: 10

                value: settings.columns
                memory: "struceOS_gameLayout_columns"

                selected: page.selected && page.current === this

                function onUp(){
                    if(current.onUp)
                        current.onUp()
                    else
                        page.current = header_settings_size_radio
                }

                onDown: function(){
                    if(current.onDown)
                        current.onDown()
                    else
                        page.current = game_layout_settings_thumbnails
                }
            }
        }

        ToggleBox { //game_layout_settings_thumbnails
            id: game_layout_settings_thumbnails
            text: "show thumbnail backgrounds"

            anchors.top: game_layout_settings_columns.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.showThumbs

            onClicked: function(){
                settings.showThumbs = !value
                api.memory.set("struceOS_gameLayout_thumbnails", value)
            }
            property var onAccept: onClicked

            function onUp(){
                page.current = game_layout_settings_columns_slider
            }

            function onDown(){
                page.current = game_layout_settings_last_played
            }
        }

        ToggleBox { //game_layout_settings_last_played
            id: game_layout_settings_last_played
            text: "open to last played"

            anchors.top: game_layout_settings_thumbnails.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.lastPlayed

            onClicked: function(){
                settings.lastPlayed = !value
                api.memory.set("struceOS_gameLayout_lastPlayed", value)
            }
            property var onAccept: onClicked

            function onUp(){
                page.current = game_layout_settings_thumbnails
            }

            function onDown(){
                page.current = game_layout_settings_all_games
            }
        }

        ToggleBox { //game_layout_settings_all_games
            id: game_layout_settings_all_games
            text: "show all games"

            anchors.top: game_layout_settings_last_played.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.allGames

            onClicked: function(){
                if(currentCollectionIndex === -1){
                    currentCollectionIndex = 0
                    games.currentIndex = 0
                }
                settings.allGames = !value
                api.memory.set("struceOS_gameLayout_allGames", settings.allGames)
                collection_menu.model.populateModel()
            }
            property var onAccept: onClicked

            function onUp(){
                page.current = game_layout_settings_last_played
            }
        }
    }
}
