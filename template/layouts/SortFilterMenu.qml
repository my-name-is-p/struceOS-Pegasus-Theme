// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import "parts"

Rectangle { //sortfilt_menu
    id: sortfilt_menu

    color: addAlphaToHex(0.90, settings.color_accent)

    property Item current: sort_item_title

    width: vpx(300)
    anchors.leftMargin: focus ? 0 : -width

    Rectangle {
        id: sort_section
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: vpx(24)
        color: "transparent"

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

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

                color: settings.color_white
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

            onClicked: function(){
                parent.resetSort(this)
            }
            property var onAccept: onClicked

            onEntered: function(){
                sortfilt_menu.current = this
            }

            property var onUp: function(){
                f = header
            }

            property var onDown: function(){
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

            onClicked: function(){
                parent.resetSort(this)
            }
            property var onAccept: onClicked

            onEntered: function(){
                sortfilt_menu.current = this
            }

            property var onUp: function(){
                sortfilt_menu.current = sort_item_title
            }

            property var onDown: function(){
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

            onClicked: function(){
                parent.resetSort(this)
            }
            property var onAccept: onClicked

            onEntered: function(){
                sortfilt_menu.current = this
            }

            property var onUp: function(){
                sortfilt_menu.current = sort_item_last_played
            }

            property var onDown: function(){
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

        height: { //height
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].height + children[i].anchors.topMargin
            }
            return sum;
        }

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

                color: settings.color_white
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

            property var onUp: function(){
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
        let key = gsk(event)
        if(isNaN(key)){
            if(key != undefined){
                switch(key){
                    case "up":
                        if(current.onUp != undefined)
                            current.onUp()
                        break
                    case "down":
                        if(current.onDown != undefined)
                            current.onDown()
                        break
                    case "left":
                        if(current.onLeft != undefined)
                            current.onLeft()
                        else
                            s = audio.toggle_down
                            f = sortfilt_toolbar
                        break
                    case "right":
                        if(current.onRight != undefined)
                            current.onRight()
                        else
                            s = audio.toggle_down
                            f = sortfilt_toolbar
                        break
                    case "prev":
                        if(current.onPrevious != undefined)
                            current.onPrevious()
                        else
                            collectionPrevious()
                        break
                    case "next":
                        if(current.onNext != undefined)
                            current.onNext()
                        else
                            collectionNext()
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
                        f = panel_area
                        panel_area.info_panel.video.safePlay()
                        s = audio.toggle_down
                        break
                    case "filter":
                    case "cancel":
                        if(current.onCancel != undefined)
                            current.onCancel()
                        else
                            f = sortfilt_toolbar
                        s = audio.toggle_down
                        break
                    case "accept":
                        current.onAccept()
                        break
                    default:
                        break
                }
                event.accepted = true
                s = s != null ? s : audio.select
            }
        }else{
            if(key == 0) {
                currentCollectionIndex = settings.allGames ? 8 : 9
            } else {
                currentCollectionIndex = settings.allGames ? key - 2 : key - 1
            }
            s = audio.toggle_down
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }

    Behavior on anchors.leftMargin {NumberAnimation {duration: 100}}

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
