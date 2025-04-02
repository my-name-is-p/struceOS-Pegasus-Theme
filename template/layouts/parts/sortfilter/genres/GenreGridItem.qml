// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Component {
    id: genre_component

    Item {
        id: genre_item
        height: text.height + vpx(24)
        width: text.width + vpx(36)

        property bool active: genreFilter.indexOf(genre) >= 0
        property bool selected: {
            if(parent){
                if(parent.parent.selected && parent.parent.currentIndex === index){
                    return true
                }
            }
            return false
        }
        property bool hovered: false

        // Component.onCompleted: {
        //     selected = parent.parent.selected && parent.parent.currentIndex === index
        // }

        Rectangle {
            id: genre_color

            anchors.fill: parent
            anchors.margins: vpx(6)

            color: genre_item.active || genre_item.hovered || genre_item.selected ? colors.accent : addAlphaToHex(0.3, colors.accent)

            radius: vpx(100)

            Rectangle {
                id: genre_selected

                anchors.fill: parent
                anchors.margins: vpx(-6)

                color: colors.t
                border.color: colors.border
                border.width: genre_item.selected ? vpx(6) : 0
                radius: vpx(6)
            }

            Text {
                id: text
                text: genre

                anchors.centerIn: parent

                color: colors.text
                font.family: regular.name
                font.pixelSize: vpx(14)
            }

            MouseArea {
                id: genre_click

                anchors.fill: parent

                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: {
                    genre_item.hovered = true
                }

                onExited: {
                    genre_item.hovered = false
                }

                onClicked: {
                    if(genreFilter.indexOf(genre) < 0){
                        genreFilter.push(genre)
                        genre_item.active = genreFilter.indexOf(genre) >= 0
                    }else{
                        genreFilter = genreFilter.filter(e => e !== genre)
                        genre_item.active = genreFilter.indexOf(genre) >= 0
                    }
                    genreFilter.sort()
                    audio.toggle_down.safePlay()
                    search.populateModel()
                    sortfilt_toolbar.genres_model.populateModel()
                    games.currentIndex = -1
                    games.currentIndex = 0
                }
            }
        }

        property string text: genre
        property var item: genre_item
    }
}
