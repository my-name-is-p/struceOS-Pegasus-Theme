// struceOS
// Copyright (C) 2024 strucep
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import QtGraphicalEffects 1.12
import "extras"
import "../utils.js" as U

Rectangle {
    id: collectionView_outer_wrapper
    anchors.bottom: state != "opened" ? parent.top : parent.bottom
    anchors.left: parent.left

    height: parent.height
    width: parent.width

    color: "transparent"

    states: State {
        name: "opened"
    }

    MouseArea {
        id: collectionView_prevent
        anchors.fill: parent

        onClicked: {
            U.focusToggle()
            mouse.event = accept
        }

        onWheel: {
            mouse.event = accept
        }
    }

    Item {
        id: collectionView_inner_wrapper
        anchors.top: parent.top
        anchors.topMargin: header.height
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: collectionView_panel
            color: Qt.hsla(0.79, 0.2, 0.26, 0.98)

            anchors.top: parent.top
            anchors.topMargin: vpx(-6)
            anchors.left: parent.left
            anchors.leftMargin: vpx(24)

            height: {
                let x = settings.allGames ? api.collections.count + 1 : api.collections.count
                let h = vpx(60 * x)
                if(h < parent.height - vpx(12)){
                    return h
                } else {
                    return parent.height - vpx(12)
                }

            }

            width: vpx(400)

            radius: vpx(6)

            clip: true

            MouseArea {
                id: collectionView_panel_prevent
                anchors.fill: parent

                onClicked: {
                    mouse.event = accept
                }
            }

            CollectionViewList{
                id: collectionView_list
            }                            

        }
    }

    DropShadow {
        anchors.fill: collectionView_panel
        cached: true
        horizontalOffset: 6
        verticalOffset: 6
        radius: 8.0
        samples: 16
        color: "#80000000"
        source: collectionView_panel
    }
    property Rectangle collectionView_outer_wrapper: collectionView_outer_wrapper
    property CollectionViewList collectionView_list: collectionView_list
    property ListView currentItem: collectionView_list.currentItem
    property ListModel collectionsModel: collectionView_list.collectionsModel
}