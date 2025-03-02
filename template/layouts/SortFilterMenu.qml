// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "parts/sortfilter"
import "parts/sortfilter/genres"

Rectangle { //sortfilt_menu
    id: sortfilt_menu

    anchors.leftMargin: focus ? 0 : -width
    Behavior on anchors.leftMargin {NumberAnimation {duration: settings.hover_speed}}
    
    width: vpx(300)
    
    color: addAlphaToHex(0.90, colors.accent)

    property Item current: sort_item_title

    //Functions--
        function onCancel(){
            current = sort_item_title
            genre_list.currentIndex = 0
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
        anchors.bottom: parent.bottom
        anchors.margins: vpx(24)

        width: sortfilt_menu.width

        Item { //filter_section_title
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

            function onDown(){
                genre_list.currentIndex = 0
                sortfilt_menu.current = genre_filter
            }
            
            onClicked: function(){
                enabled = !enabled
                games.currentIndex = -1
                games.currentIndex = 0
            }
            property var onAccept: onClicked

        }

        Item { //genre_filer
            id: genre_filter

            anchors.top: filter_item_favorite.bottom
            anchors.topMargin: vpx(6)
            anchors.left: parent.left
            anchors.leftMargin: vpx(24)
            anchors.right: parent.right
            anchors.rightMargin: vpx(12)
            anchors.bottom: parent.bottom

            property bool selected: sortfilt_menu.current === this

            function onUp(){
                if(genre_list.currentIndex != 0)
                    genre_list.decrementCurrentIndex()
                else
                    sortfilt_menu.current = filter_item_favorite
            }

            function onDown(){
                genre_list.incrementCurrentIndex()
            }

            function onAccept(){
                let genre = genre_list.currentItem.text
                let genre_item = genre_list.currentItem.item
                if(genreFilter.indexOf(genre) < 0){
                    genreFilter.push(genre)
                    genre_item.active = genreFilter.indexOf(genre) >= 0
                }else{
                    genreFilter = genreFilter.filter(e => e !== genre)
                    genre_item.active = genreFilter.indexOf(genre) >= 0
                }
                genreFilter.sort()
                search.populateModel()
                sortfilt_toolbar.genres_model.populateModel()
                games.currentIndex = -1
                games.currentIndex = 0
            }
            
            Text {
                id: genre_label
                text: "genres:"


                color: colors.white
                font.family: regular.name
                font.pixelSize: vpx(18)
            }

            Rectangle {
                id: genre_background

                anchors.top: genre_label.bottom
                anchors.topMargin: vpx(12)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom


                color: colors.accent_light
                radius: vpx(6)

                ListView {
                    id: genre_list
                    anchors.fill: parent

                    model: GenresModel {}
                    delegate: GenreGridItem {}

                    highlightMoveDuration: 1

                    property bool selected: genre_filter.selected

                    clip: true

                    function resetActive(){
                        for(let i = 0; i < count; i++){
                            currentIndex = i
                            currentItem.active = genreFilter.indexOf(currentItem.text) >= 0
                        }
                        currentIndex = 0
                    }
                }
            }
        }

    }

    Keys.onPressed: {
        if(event.key === 1048576 && event.isAutoRepeat)
            return
        s = s != null ? s : audio.toggle_down
    }

    property ListView genre_list: genre_list
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
