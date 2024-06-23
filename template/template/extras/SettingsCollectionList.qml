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

Item {
    ListView {
        id: settings_collection_list

        delegate: settings_collection_list_item
        model: api.collections
        anchors.fill: parent

        spacing: vpx(36)
        interactive: true
        clip: true

        snapMode: ListView.SnapToItem
    }

    Component {
        id: settings_collection_list_item

        Row { 

            anchors.right: parent.right
            anchors.left: parent.left
            Text {
                id: label
                text: name
                color: "#ffffff"

                anchors.verticalCenter: checkbox.verticalCenter

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            CustomCheckbox {
                id: checkbox

                state: settings.croppedThumbnails.includes(shortName) ? "checked" : ""

                anchors.right: parent.right

                MouseArea { //checkbox_click
                    id: checkbox_click
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        select.play()
                        if(checkbox.state != "checked"){
                            settings.croppedThumbnails.push(shortName)
                            parent.state = "checked"
                        } else {
                            settings.croppedThumbnails.pop(shortName)
                            parent.state = ""
                        }
                        api.memory.set("struceOS_gameView_croppedThumbnails", settings.croppedThumbnails)
                        games.gameView.forceLayout()
                    }
                }
            }
        }
    }
    property ListView settings_collection_list: settings_collection_list
}


