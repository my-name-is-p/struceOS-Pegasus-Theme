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
Item{
    anchors.fill: parent
    ListModel {
        id: detailsModel
        property var details: ["title","developer","publisher","release","players"]
        property var currentGame: root.currentGame

        property var test: settings.bgOverlayOpacity
        Component.onCompleted: {
            populateModel()
        }

        function populateModel() {
            detailsModel.clear() // Clear existing entries
            for(var i=0; i < details.length; i++) {
                if(currentGame[details[i]] != ""){
                    if(details[i] != "release" || validateDate(currentGame.release)){
                        append(createListElement(details[i]))
                    }
                }
            }
        }

        function validateDate(d) {
            if (Object.prototype.toString.call(d) === "[object Date]") {
            // it is a date
                if (isNaN(d)) { // d.getTime() or d.valueOf() will also work
                    // date object is not valid
                    return false
                } else {
                    // date object is valid
                    return true
                }
            } else {
            // not a date object
                return false
            }
        }
        
        function createListElement(e) {
            switch(e){
                case "release":
                    return {
                        label: e,
                        value: currentGame.releaseYear.toString(),
                    }
                default:
                    return {
                        label: e,
                        value: currentGame[e].toString(),
                    }
                    break
            }
        }
    }

    ListView {
        id: details_list

        anchors.fill: parent
        spacing: vpx(12)
        interactive: true
        clip: true

        delegate: details_list_item
        model: detailsModel
        pixelAligned: true
    }

    Component {
        id: details_list_item
        Row {
            width: parent.width
            height: vpx(14)
            Text {
                id: detail_label
                text: label + ": "
                font.family: regular.name
                font.pixelSize: vpx(14)
                color: "#ffffff"
            }

            Text {
                id: detail_value
                text: value
                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(14)
                color: "#ffffff"
                elide: Text.ElideRight
                anchors.right: parent.right
                anchors.left: detail_label.right


            }
        }
    }
    property ListModel detailsModel: detailsModel

    property int items: details_list.count
}

