// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item { //sortfilt_toolbar_wrapper
    id: toolbar_wrapper

    height: label_wrapper.height
    
    property bool selected: focus
    property Item current: label

    //Functions--
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
                function onDown(){
                    games.currentIndex = 0
                    resetFocus()
                }
                property var onCancel: onDown

                function onUp(){
                    header.current = header.collection
                    resetFocus(header)
                }

                function onLeft(){
                    s = audio.toggle_down
                    f = sortfilt_menu
                }
                property var onAccept: onLeft
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

    Item { //active_filters
        id: active_filters

        anchors.top: toolbar_wrapper.top
        anchors.bottom: toolbar_wrapper.bottom
        anchors.left: label_wrapper.right
        anchors.leftMargin: vpx(12)
        anchors.right: toolbar_wrapper.right

        clip: true

        Rectangle { //filter_item
            id: filter_item

            anchors.verticalCenter: active_filters.verticalCenter

            height: filter_item_text.height + vpx(12)
            width: childrenSize(this, "width",  "leftMargin", 12)

            color: colors.accent
            radius: vpx(100)

            visible: sortfilt_menu.favorite.enabled

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
                text: "favorite"
                color: colors.text
                font.pixelSize: vpx(11)
                anchors.verticalCenter: filter_item.verticalCenter
                anchors.left: filter_item_remove.right
            }
        }

        MouseArea { //favorite_remove
            id: favorite_remove

            anchors.fill: filter_item
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
        s = s != null ? s : audio.toggle_down
    }
}
