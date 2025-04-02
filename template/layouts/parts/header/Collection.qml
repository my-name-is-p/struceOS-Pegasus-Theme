// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item { //collection
    id: collection
    
    width: logo_mask.width + game_count.width + game_count.anchors.leftMargin

    property bool selected: false
    property var onClicked: function(){}

    Item { //logo_mask
        id: logo_mask

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        width: logo.status != Image.Error ? logo.width : logo_text.width

        visible: false

        Image { //logo
            id: logo
            source: images.current_collection

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            fillMode: Image.PreserveAspectFit

            sourceSize.width: parent.width
            sourceSize.height: parent.height


            antialiasing: true
            smooth: true

            visible: status != Image.Error
        }

        Text {  //logo_text
            id: logo_text

            anchors.top: parent.top
            anchors.left: parent.left

            color: colors.white

            text: currentCollection.name
            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(36)

            visible: logo.status === Image.Error
        }

        Rectangle { //logo_color
            id: logo_color

            anchors.fill: parent

            color: colors.white

            visible: false
        }
    }

    OpacityMask { //logo_out
        id: logo_out
        anchors.fill: logo_mask
        source: logo_color
        maskSource: logo_mask
    }

    Rectangle { //game_count
        id: game_count
        color: colors.accent
        width: game_count_text.width + vpx(12) < vpx(24) ? vpx(24) : game_count_text.width + vpx(12)
        height: vpx(24)
        anchors.top: logo_mask.top
        anchors.left: logo_mask.right
        anchors.leftMargin: vpx(6)
        radius: vpx(6)

        Text { //game_count_text
            id: game_count_text
            text: games.count

            anchors.centerIn: parent

            color: colors.text
            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(12)
        }
    }

    Rectangle { //collection_select
        id: collection_select
        anchors.fill: parent
        anchors.margins:vpx(-6)
        color: colors.t

        visible: collection.selected

        border.color: colors.border
        border.width: vpx(6)
        radius: vpx(6)
    }

    MouseArea { //collection_click
        id: collection_click
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if(collection.onClicked)
                collection.onClicked()
        }
    }
}
