// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

Item { //details
    id: details

    clip: true

    Rectangle { //release
        id: release

        anchors.verticalCenter: details.verticalCenter

        visible: search.currentGame() ? search.currentGame().releaseYear != 0 : false
        width: visible ? release_label.contentWidth : 0

        Text { //release_label
            id: release_label
            text: "released: " + (search.currentGame() ? search.currentGame().releaseYear : "")

            anchors.verticalCenter: parent.verticalCenter

            color: colors.text

            font.family: regular.name
            font.pixelSize: vpx(14)

        }
    }

    Rectangle { //players
        id: players

        anchors.left: release.right
        anchors.leftMargin: release.visible ? vpx(12) : 0
        anchors.verticalCenter: parent.verticalCenter

        width: childrenSize(this, "width", "leftMargin")

        visible: search.currentGame() ? search.currentGame().players > 0 : false

        Text { //players_label
            id: players_label
            text: "players:"

            anchors.verticalCenter: parent.verticalCenter

            color: colors.text

            font.family: regular.name
            font.pixelSize: vpx(14)
        }

        Item { //players_icon_mask
            id: players_icon_mask

            anchors.left: players_label.right
            anchors.leftMargin: vpx(6)
            anchors.verticalCenter: parent.verticalCenter

            width: vpx(16) * Math.min(search.currentGame() ? search.currentGame().players : 0, 5)
            height: vpx(16)

            Image { //players_icon
                id: players_icon
                source: images.players

                anchors.fill: parent

                fillMode: Image.PreserveAspectCrop
                horizontalAlignment: Image.AlignLeft

                visible: false
            }

            Rectangle { //players_icon_color
                id: players_icon_color

                anchors.fill: players_icon

                color: colors.text

                visible: false
            }

            OpacityMask { //players_icon_out
                id: players_icon_out
                anchors.fill: players_icon
                source: players_icon_color
                maskSource: players_icon
            }
        }
    }

    Rectangle { //genres_detail
        id: genres_detail

        anchors.left: players.right
        anchors.leftMargin: vpx(12)
        anchors.verticalCenter: parent.verticalCenter

        visible: search.currentGame() ? search.currentGame().genre != "" : false
        width: visible ? genres_label.contentWidth : 0

        Text {
            id: genres_label
            text: "genres: " + (search.currentGame() ? search.currentGame().genre : "")

            anchors.verticalCenter: parent.verticalCenter

            color: colors.text

            font.family: regular.name
            font.pixelSize: vpx(14)
        }
    }
}
