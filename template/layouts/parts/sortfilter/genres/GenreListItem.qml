// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Component { //genre_item
    id: genre_item

    Rectangle { //filter_item
        id: filter_item

        anchors.verticalCenter: parent.verticalCenter

        height: sizing.height
        width: sizing.width

        color: colors.accent
        radius: vpx(100)

        property bool selected: parent.parent.selected && parent.parent.currentIndex === index

        function onAccept(){
            genreFilter = genreFilter.filter(e => e !== genre)
            sortfilt_toolbar.genres_model.populateModel()
            sortfilt_menu.genre_list.resetActive()
            search.populateModel()
            if(genreFilter.length < 1){
                resetFocus()
            }
        }

        Item { //sizing
            id: sizing

            height: filter_item_text.height + vpx(12)
            width: childrenSize(this, "width",  "leftMargin", 12)

            Item { //filter_item_remove
                id: filter_item_remove
                height: filter_item.height
                width: filter_item.height

                Text {
                    anchors.centerIn: filter_item_remove
                    text: "🗙"
                    color: colors.text
                    font.pixelSize: vpx(12)
                }
            }
            
            Text { //filter_item_text
                id: filter_item_text
                text: genre
                color: colors.text
                font.pixelSize: vpx(11)
                anchors.verticalCenter: sizing.verticalCenter
                anchors.left: filter_item_remove.right
            }
        }

        MouseArea { //filter_remove
            id: filter_remove

            anchors.fill: filter_item
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                filter_item.onAccept()
                audio.toggle_down.play()
            }
        }

        Rectangle {
            id: filter_item_select

            anchors.fill: filter_item
            anchors.margins: vpx(-6)

            color: colors.t
            border.color: colors.border
            border.width: filter_item.selected ? vpx(6) : 0
            radius: vpx(6)
        }
    }
}