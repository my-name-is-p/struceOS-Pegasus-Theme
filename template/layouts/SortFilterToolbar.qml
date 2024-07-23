// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item { //sortfilt_toolbar_wrapper
    id: sortfilt_toolbar_wrapper


    height: sortfilt_label_wrapper.height
    
    property bool selected: focus
    property Item current: sortfilt_label

    Item {  //sortfilt_label_wrapper
        id: sortfilt_label_wrapper

        anchors.left: parent.left
        anchors.leftMargin: vpx(24) //vpx(12) when open
        height: sortfilt_label_text.contentHeight + vpx(24)
        width: {
            var sum = vpx(24);
            for (var i = 0; i < sortfilt_label.children.length; i++) {
                if (i > 0)
                    sum += sortfilt_label.children[i].anchors.leftMargin
                if(sortfilt_label.children[i].width != 0)
                    sum += sortfilt_label.children[i].width
                else
                    sum += sortfilt_label.children[i].contentWidth
            }
            return sum;
        }

        property bool hovered: false

        Item {  //sortfilt_label
            id: sortfilt_label

            anchors.verticalCenter: parent.verticalCenter

            property bool selected: sortfilt_toolbar_wrapper.current === this

            property var onDown: function(){
                games.currentIndex = 0
                f = game_layout
            }
            property var onCancel: onDown

            property var onLeft: function(){
                s = audio.toggle_down
                f = sortfilt_menu
            }
            property var onAccept: onLeft


            
            Image {
                id: sortfilt_label_icon
                source: sortfilt_menu.focus || parent.parent.hovered ? images.sortfilt_icon_filled : images.sortfilt_icon_empty

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: vpx(12)
                width: vpx(24)
                height: vpx(24)

            }

            Text {
                id: sortfilt_label_text
                text: sortfilt_menu.active_sort.text
                anchors.left: sortfilt_label_icon.right
                anchors.leftMargin: vpx(12)
                anchors.verticalCenter: parent.verticalCenter
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(16)
                color: p.white
            }

            Image {
                id: sortfilt_label_direction
                source: images.sort_direction_filled
                anchors.left: sortfilt_label_text.right
                anchors.leftMargin: vpx(3)
                anchors.verticalCenter: parent.verticalCenter

                rotation: sortfilt_menu.active_sort.asc ? 0 : 180

                width: vpx(12)
                height: vpx(12)
            }
        }

        Rectangle { //sortfilt_label_select
            id: sortfilt_label_select

            anchors.fill: parent

            border.color: p.border
            border.width: vpx(3)
            radius: vpx(6)

            color: p.t

            visible: sortfilt_toolbar_wrapper.selected && sortfilt_toolbar_wrapper.current === sortfilt_label

        }

        MouseArea { //sortfilt_label_click
            id: sortfilt_label_click
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

            hoverEnabled: true

            onEntered: {
                parent.hovered = true;
            }

            onExited: {
                parent.hovered = false;
            }

            onClicked: {
                if(!sortfilt_menu.focus)
                    f = sortfilt_menu
                else
                    f = game_layout
                audio.stopAll()
                audio.toggle_down.play()
            }
        }
    }

    Item {  //sortfilt_active_filters
        id: sortfilt_active_filters
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: sortfilt_label_wrapper.right
        anchors.right: parent.right

        clip: true

        Rectangle {
            id: sortfilt_filter_item
            height: sortfilt_filter_item_text.contentHeight + vpx(12)

            visible: sortfilt_menu.favorite.enabled
            
            width: {
                var sum = vpx(12);
                for (var i = 0; i < children.length; i++) {
                    if (i > 0)
                        sum += children[i].anchors.leftMargin
                    if(children[i].width != 0)
                        sum += children[i].width
                    else
                        sum += children[i].contentWidth
                }
                return sum;
            }

            anchors.verticalCenter: parent.verticalCenter

            color: p.accent
            radius: vpx(100)


            Item {
                id: sortfilt_filter_item_remove_wrapper
                height: parent.height
                width: parent.height

                Text {
                    anchors.centerIn: parent
                    text: "🗙"
                    color: p.text
                    font.pixelSize: vpx(12)
                }
            }
            
            Text {
                id: sortfilt_filter_item_text
                text: "favorite"
                color: p.text
                font.pixelSize: vpx(11)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: sortfilt_filter_item_remove_wrapper.right

            }
        }

        MouseArea {
            id: favorite_click

            anchors.fill: sortfilt_filter_item
            cursorShape: sortfilt_menu.favorite.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

            enabled: sortfilt_menu.favorite.enabled

            onClicked: {
                sortfilt_menu.favorite.enabled = false
                audio.stopAll()
                audio.select.play()
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
                        else
                            f = header
                            s = audio.toggle_down
                        break
                    case "down":
                        if(current.onDown != undefined)
                            current.onDown()
                        else
                            f = game_layout
                        break
                    case "left":
                        if(current.onLeft != undefined)
                            current.onLeft()
                        else
                            f = sortfilt_menu
                        break
                    case "right":
                        if(current.onRight != undefined)
                            current.onRight()
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
                        panel_area.info_panel.video.play()
                        s = audio.toggle_down
                        break
                    case "filter":
                        f = sortfilt_menu
                        break
                    case "cancel":
                        if(current.onCancel != undefined)
                            current.onCancel()
                        else
                            f = game_layout
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
}
