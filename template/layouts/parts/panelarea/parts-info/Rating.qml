// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item { //raiting
    id: rating

    height: {
        var h = 0
        if(search.currentGame()){
                h = search.currentGame().rating > 0.0 ? vpx(24) : 0
        }
        return h
    }

    visible: search.currentGame() ? search.currentGame().rating > 0.0 : false

    Item { //stars
        id: stars

        anchors.horizontalCenter: rating.horizontalCenter

        width: vpx(144)
        height: vpx(24)

        visible: false

        Image { //empty
            id: empty
            source: images.stars_empty

            anchors.fill: stars
            
            fillMode: Image.PreserveAspectFit
        }

        Image { //filled
            id: filled
            source: images.stars_filled

            anchors.fill: empty
            anchors.rightMargin: search.currentGame() ? stars.width - (stars.width * search.currentGame().rating) : stars.width

            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignLeft
        }
    }

    Rectangle { //stars_color
        id: stars_color

        anchors.fill: stars

        color: colors.text

        visible: false
    }

    OpacityMask { //starts_out
        id: starts_out
        anchors.fill: stars
        source: stars_color
        maskSource: stars
    }
}
