// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "parts"

Rectangle { //sortfilt_menu
    id: sortfilt_menu

    color: addAlphaToHex(0.90, colors.accent)

    property Item current: sort_item_title

    width: vpx(300)
    anchors.leftMargin: focus ? 0 : -width

    //Functions--
        function onCancel(){
            resetFocus()
        }
        property var onRight: onCancel

        property var onUp: current.onUp
        property var onDown: current.onDown
        property var onLeft: current.onLeft
        property var onPrevious: current.onPrevious
        property var onNext: current.onNext
        property var onFirst: current.onFirst
        property var onLast: current.onLast
        property var onDetails: current.onDetails
        property var onSort: current.onSort
        property var onAccept: current.onAccept
    //--

    Rectangle {
        id: sort_section
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: vpx(24)
        color: "transparent"

        height: childrenSize(this, "height", "topMargin")

        Item { //sort_section_title
            id: sort_section_title

            width: parent.width
            height: sort_section_title_text.contentHeight + vpx(12)

            Text {
                id: sort_section_title_text
                text: "Sort"
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(18)

                anchors.left: parent.left
                anchors.leftMargin: vpx(24)
                anchors.verticalCenter: parent.verticalCenter

                color: colors.white
            }
        }

        SortItem { //sort_item_title
            id: sort_item_title
            text: "title"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: sort_section_title.bottom

            selected: sortfilt_menu.current === this

            enabled: true

            function onAccept(){
                sort_section.resetSort(sort_item_title)
            }
            onClicked: onAccept

            onEntered: function(){
                sortfilt_menu.current = this
            }

            function onUp(){
                f = header
            }

            function onDown(){
                sortfilt_menu.current = sort_item_last_played
            }
        }

        SortItem { //sort_item_last_played
            id: sort_item_last_played
            text: "last played"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: sort_item_title.bottom

            selected: sortfilt_menu.current === this

            function onAccept(){
                sort_section.resetSort(sort_item_last_played)
            }
            onClicked: onAccept

            onEntered: function(){
                sortfilt_menu.current = this
            }

            function onUp(){
                sortfilt_menu.current = sort_item_title
            }

            function onDown(){
                sortfilt_menu.current = sort_item_play_time
            }
        }

        SortItem { //sort_item_play_time
            id: sort_item_play_time
            text: "play time"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: sort_item_last_played.bottom

            asc: false

            selected: sortfilt_menu.current === this

            enabled: false

            function onAccept(){
                sort_section.resetSort(sort_item_play_time)
            }
            onClicked: onAccept

            onEntered: function(){
                sortfilt_menu.current = this
            }

            function onUp(){
                sortfilt_menu.current = sort_item_last_played
            }

            function onDown(){
                sortfilt_menu.current = filter_item_favorite
            }
        }

        function resetSort(item) {
            if(item.enabled){
                item.asc = !item.asc
            }else{
                sort_item_title.enabled = false
                sort_item_last_played.enabled = false
                sort_item_play_time.enabled = false
                item.enabled = true
            }
            games.currentIndex = -1
            games.currentIndex = 0
        }
    }

    Rectangle { //filter_section
        id: filter_section
        width: parent.width
        color: "transparent"
        anchors.top: sort_section.bottom
        anchors.topMargin: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Item { //sort_section_title
            id: filter_section_title
            width: parent.width
            height: filter_section_title_text.contentHeight + vpx(6)
            Text {
                id: filter_section_title_text
                text: "Filter"
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(18)

                anchors.left: parent.left
                anchors.leftMargin: vpx(24)
                anchors.verticalCenter: parent.verticalCenter

                color: colors.white
            }
        }

        FilterItem {
            id: filter_item_favorite
            text: "favorite"

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: filter_section_title.bottom

            selected: sortfilt_menu.current === this

            icon: enabled ? images.favorite_icon_filled : images.favorite_icon_empty

            function onUp(){
                sortfilt_menu.current = sort_item_play_time
            }
            
            onClicked: function(){
                enabled = !enabled
                games.currentIndex = -1
                games.currentIndex = 0
            }
            property var onAccept: onClicked

            onEntered: function(){
                sortfilt_menu.current = this
            }
        }
    }

    Keys.onPressed: {
        s = s != null ? s : audio.toggle_down
    }

    Behavior on anchors.leftMargin {NumberAnimation {duration: settings.hover_speed}}

    property FilterItem favorite: filter_item_favorite
    property SortItem title: sort_item_title
    property SortItem last_played: sort_item_last_played
    property SortItem play_time: sort_item_play_time
    property SortItem active_sort: {
        switch(true){
            case sort_item_last_played.enabled:
                return sort_item_last_played
            case play_time.enabled:
                return sort_item_play_time
            default:
                return sort_item_title
        }
    }
}
