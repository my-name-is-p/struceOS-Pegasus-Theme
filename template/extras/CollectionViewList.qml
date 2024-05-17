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

// Thank you to VGmove creator of EasyLaunch <https://github.com/VGmove/EasyLaunch>
// for the collection logos, images, audio, and various functionality


import QtQuick 2.0
import "../../utils.js" as U
import "../../controls/CollectionControls.js" as COLLECTION_controls


Item {
    anchors.fill: parent
    anchors.margins: vpx(12)

    ListView {
        id: collectionView_list
        anchors.fill: parent
        spacing: vpx(24)


        delegate: collectionView_list_item
        model: api.collections
        highlightFollowsCurrentItem: true
        highlightMoveDuration : 1
        highlightMoveVelocity : 1000

    }

    Component {
        id: collectionView_list_item
        Item {
            height: vpx(36)
            width: parent.width

            Image {
                id: collectionView_list_logo
                source: "../../assets/logos/" + shortName + ".svg"

                anchors.fill: parent

                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.alignLeft
            }

            Text {
                id: collectionView_list_name
                text: name
                anchors.centerIn: parent

                color: "#ffffff"
                opacity: collectionView_list_logo.status != 3 ? 0 : 1

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(36)
                fontSizeMode: Text.fit
            }

            Rectangle { //collectionTitle_border
                id: collectionTitle_border

                width: collectionView_list_logo.status != 3 ? collectionView_list_logo.paintedWidth + vpx(12) : collectionView_list_name.width + 12
                height: collectionView_list_logo.status != 3 ? collectionView_list_logo.paintedHeight + vpx(12) : collectionView_list_name.height + 12

                anchors.centerIn: parent
                anchors.margins: vpx(-6)
                color: "transparent"

                border.color: Qt.hsla(1,1,1,0.6)
                border.width: parent.focus ? vpx(3) : vpx(0)
                radius: vpx(6)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onEntered: {
                        parent.parent.focus = true
                        collectionView_list.currentIndex = index
                    }

                    onExited: {
                        parent.parent.focus = false
                    }

                    onClicked: {
                        COLLECTION_controls.accept()
                    }
                }
            }
        }
    }
    property ListView currentItem: collectionView_list
}


