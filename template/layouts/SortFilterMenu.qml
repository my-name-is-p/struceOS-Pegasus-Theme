// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "parts/sortfilter"

Rectangle { //sortfilt_menu
    id: sortfilt_menu

    anchors.leftMargin: focus ? 0 : -width
    Behavior on anchors.leftMargin {NumberAnimation {duration: settings.hover_speed}}
    
    width: vpx(300)
    
    color: addAlphaToHex(0.90, colors.accent)

    property Item current: sort_item_title

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

    Item { //sort_section
        id: sort_section

        anchors.top: sortfilt_menu.top
        anchors.topMargin: vpx(24)
        
        height: childrenSize(this, "height", "topMargin")
        width: sortfilt_menu.width

        //Functions--
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
        //--

        Item { //sort_section_title
            id: sort_section_title

            width: sort_section.width
            height: sort_section_title_text.contentHeight + vpx(12)

            Text {
                id: sort_section_title_text
                text: "Sort"

                anchors.left: sort_section_title.left
                anchors.leftMargin: vpx(24)
                anchors.verticalCenter: sort_section_title.verticalCenter

                color: colors.white

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(18)
            }
        }

        SortItem { //sort_item_title
            id: sort_item_title
            text: "title"
            
            anchors.top: sort_section_title.bottom
            anchors.left: sort_section.left
            anchors.right: sort_section.right

            selected: sortfilt_menu.current === this
            
            enabled: true

            role: "sortBy"
            order: asc ? Qt.AscendingOrder : Qt.DescendingOrder

            function onAccept(){
                sortfilt_menu.current = this
                sort_section.resetSort(sort_item_title)
            }
            onClicked: onAccept

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

            anchors.top: sort_item_title.bottom
            anchors.left: sort_section.left
            anchors.right: sort_section.right

            selected: sortfilt_menu.current === this

            role: "lastPlayed"
            order: asc ? Qt.DescendingOrder : Qt.AscendingOrder

            function onAccept(){
                sortfilt_menu.current = this
                sort_section.resetSort(sort_item_last_played)
            }
            onClicked: onAccept

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

            anchors.top: sort_item_last_played.bottom
            anchors.left: sort_section.left
            anchors.right: sort_section.right

            asc: false

            selected: sortfilt_menu.current === this
            enabled: false

            role: "playTime"
            order: asc ? Qt.AscendingOrder : Qt.DescendingOrder

            function onAccept(){
                sortfilt_menu.current = this
                sort_section.resetSort(sort_item_play_time)
            }
            onClicked: onAccept

            function onUp(){
                sortfilt_menu.current = sort_item_last_played
            }

            function onDown(){
                sortfilt_menu.current = filter_item_favorite
            }
        }
    }

    Item { //filter_section
        id: filter_section

        anchors.top: sort_section.bottom
        anchors.topMargin: vpx(12)

        height: childrenSize(this, "height", "topMargin")
        width: sortfilt_menu.width

        Item { //sort_section_title
            id: filter_section_title

            width: filter_section.width
            height: filter_section_title_text.contentHeight + vpx(6)

            Text { //filter_section_title_text
                id: filter_section_title_text
                text: "Filter"

                anchors.left: filter_section_title.left
                anchors.leftMargin: vpx(24)
                anchors.verticalCenter: filter_section_title.verticalCenter

                color: colors.white

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(18)
            }
        }

        FilterItem { //filter_item_favorite
            id: filter_item_favorite
            text: "favorite"

            anchors.left: filter_section.left
            anchors.right: filter_section.right
            anchors.top: filter_section_title.bottom

            selected: sortfilt_menu.current === this

            icon: enabled ? images.favorite_icon_filled : images.favorite_icon_empty

            function onUp(){
                sortfilt_menu.current = sort_item_play_time
            }
            
            onClicked: function(){
                sortfilt_menu.current = this
                enabled = !enabled
                games.currentIndex = -1
                games.currentIndex = 0
            }
            property var onAccept: onClicked

        }
    }

    Keys.onPressed: {
        if(event.key === 1048576 && event.isAutoRepeat)
            return
        s = s != null ? s : audio.toggle_down
    }


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
