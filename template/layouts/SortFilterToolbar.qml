// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

import "parts/sortfilter/genres"

Item { //sortfilt_toolbar_wrapper
    id: toolbar_wrapper

    height: label_wrapper.height
    
    property bool selected: focus
    property Item current: label


    //Functions--
        function onUp(){
            if(current.onUp){
                current.onUp()
            }else{
                genre_list.currentIndex = 0
                current = label
                header.current = header.collection
                resetFocus(header)
            }
        }
        
        function onDown(){
            genre_list.currentIndex = 0
            games.currentIndex = 0
            current = label
            resetFocus()
        }

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

    Item {  //label_wrapper
        id: label_wrapper

        anchors.left: parent.left
        anchors.leftMargin: vpx(24)

        height: label.height + vpx(24)
        width: label.width

        property bool hovered: false

        Item {  //sortfilt_label
            id: label

            anchors.verticalCenter: parent.verticalCenter

            height: childrenSize(this, "height", "", 0, 0, true)
            width: childrenSize(this, "width", "leftMargin")

            property bool selected: sortfilt_toolbar_wrapper.current === this

            //Functions--

                function onLeft(){
                    s = audio.toggle_down
                    f = sortfilt_menu
                }
                property var onAccept: onLeft

                function onRight(){
                    toolbar_wrapper.current = 
                        sortfilt_menu.favorite.enabled ? 
                            favorite_filter : 
                                genre_list.count > 0 ? 
                                    genre_list :
                                    label
                }
            //--

            Item { //icon_mask
                id: icon_mask

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                width: vpx(24)
                height: vpx(24)

                Image { //icon
                    id: icon
                    source: sortfilt_menu.focus || label_wrapper.hovered ? images.sortfilt_icon_filled : images.sortfilt_icon_empty

                    anchors.fill: parent

                    visible: false
                }

                Rectangle { //color
                    id: icon_color

                    anchors.fill: icon

                    color: colors.white

                    visible: false
                }

                OpacityMask { //icon_out
                    id: icon_out
                    anchors.fill: icon
                    source: icon_color
                    maskSource: icon
                }
            }

            Text { //label_text
                id: label_text
                text: sortfilt_menu.active_sort.text

                anchors.left: icon_mask.right
                anchors.leftMargin: vpx(12)
                anchors.verticalCenter: parent.verticalCenter

                color: colors.white

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(16)
            }

            Item { //direction_mask
                id: direction_mask

                anchors.left: label_text.right
                anchors.leftMargin: vpx(3)
                anchors.verticalCenter: parent.verticalCenter

                width: vpx(12)
                height: vpx(12)

                Image { //direction
                    id: direction
                    source: images.sort_direction_filled

                    anchors.fill: parent

                    visible: false
                }

                Rectangle { //direction_color
                    id: direction_color
                    
                    anchors.fill: direction_mask

                    color: colors.white

                    visible: false
                }

                OpacityMask { //direction_out
                    id: direction_out
                    anchors.fill: direction
                    source: direction_color
                    maskSource: direction

                    rotation: sortfilt_menu.active_sort.asc ? 0 : 180
                }
            }
        }

        Rectangle { //label_select
            id: label_select

            anchors.fill: parent
            anchors.margins: vpx(-6)
            anchors.topMargin: vpx(-3)
            anchors.bottomMargin: vpx(-3)

            color: colors.t
            border.color: colors.border
            border.width: vpx(6)
            radius: vpx(6)

            visible: toolbar_wrapper.selected && toolbar_wrapper.current === label ? true : false
        }

        MouseArea { //sortfilt_label_click
            id: sortfilt_label_click
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true

            onPositionChanged: {
                screensaver.reset()
            }

            onEntered: {
                parent.hovered = true;
            }

            onExited: {
                parent.hovered = false;
            }

            onClicked: {
                if(!sortfilt_menu.focus)
                    resetFocus(sortfilt_menu)
                else
                    resetFocus()
                audio.stopAll()
                audio.toggle_down.play()
            }
        }
    }

    Item { //favorite_filter
        id: favorite_filter

        anchors.top: toolbar_wrapper.top
        anchors.bottom: toolbar_wrapper.bottom
        anchors.left: label_wrapper.right
        anchors.leftMargin: vpx(12)
        anchors.right: favorite_item.right

        width: sortfilt_menu.favorite.enabled ? favorite_item.width : 0

        property bool selected: toolbar_wrapper.current === this
    
        function onLeft(){
            toolbar_wrapper.current = label
        }

        function onRight(){
            toolbar_wrapper.current = genre_list.count > 0 ? genre_list : favorite_filter
        }

        function onAccept(){
            sortfilt_menu.favorite.enabled = false
            toolbar_wrapper.current = label
        }

        Rectangle { //filter_item
            id: favorite_item

            anchors.verticalCenter: favorite_filter.verticalCenter

            height: favorite_item_text.height + vpx(12)
            width: childrenSize(this, "width",  "leftMargin", 12)

            color: colors.accent
            radius: vpx(100)

            visible: sortfilt_menu.favorite.enabled

            Item { //filter_item_remove
                id: favorite_item_remove
                height: favorite_item.height
                width: favorite_item.height

                Text {
                    anchors.centerIn: favorite_item_remove
                    text: "🗙"
                    color: colors.text
                    font.pixelSize: vpx(12)
                }
            }
            
            Text { //filter_item_text
                id: favorite_item_text
                text: "favorite"
                color: colors.text
                font.pixelSize: vpx(11)
                anchors.verticalCenter: favorite_item.verticalCenter
                anchors.left: favorite_item_remove.right
            }
        }

        MouseArea { //favorite_remove
            id: favorite_remove

            anchors.fill: favorite_item
            cursorShape: sortfilt_menu.favorite.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            enabled: sortfilt_menu.favorite.enabled

            onClicked: {
                sortfilt_menu.favorite.enabled = false
                audio.stopAll()
                audio.toggle_down.play()
            }
        }

        Rectangle {
            id: favorite_item_selected

            anchors.fill: favorite_item
            anchors.margins: vpx(-6)

            color: colors.t
            border.color: colors.border
            border.width: favorite_filter.selected ? vpx(6) : 0
            radius: vpx(6)
        }
    }

    ListModel {
        id: genres_model

        function populateModel() {
            clear()
            genreFilter.forEach(function(genre){
                append({genre: genre})
            })
        }

        Component.onCompleted: {
            populateModel()
        }
    }

    ListView {
        id: genre_list

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: favorite_filter.right
        anchors.leftMargin: sortfilt_menu.favorite.enabled ? vpx(12) : 0
        anchors.right: parent.right

        model: genres_model
        delegate: GenreListItem {}

        highlightMoveDuration: 1

        leftMargin: vpx(12)
        rightMargin: vpx(12)

        spacing: vpx(12)
        orientation: ListView.Horizontal

        property bool selected: toolbar_wrapper.current === this

        clip: true

        function onUp(){
            let w = favorite_filter.width + label_wrapper.width
            if(currentItem.x + w > toolbar_wrapper.width / 2)
                root.header.current = root.header.search_button
            else
                root.header.current = root.header.collection
            resetFocus(root.header)
            toolbar_wrapper.current = label
            genre_list.currentIndex = 0
        }

        function onLeft(){
            if(currentIndex > 0){
                decrementCurrentIndex()
            }else{
                toolbar_wrapper.current = 
                    sortfilt_menu.favorite.enabled ? 
                        favorite_filter : label
            }
        }

        function onRight(){
            incrementCurrentIndex()
        }

        function onAccept(){
            currentItem.onAccept()
            if(genreFilter.length < 1){
                toolbar_wrapper.current = label
            }
        }
    }

    Keys.onPressed: {
        if(event.key === 1048576 && event.isAutoRepeat)
            return
        s = s != null ? s : audio.toggle_down
    }

    property Item label: label
    property ListModel genres_model: genres_model
    property ListView genre_list: genre_list
}
