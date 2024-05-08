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
import SortFilterProxyModel 0.2

Item {
id: root
    readonly property alias games: gamesFiltered
    property string firstWordIgnoreList
    function currentGame(index) { return currentCollection.games.get(gamesFiltered.mapToSource(index)) }
    function firstWordIgnore(list) {
        let temp = ""
        for(var i = 0; i < list.length; i++){
            if(i < list.length - 1){
                temp = temp + list[i] + " |"
            } else {
                temp = temp + list[i] + " "
            }
        }
        return temp
    }
    Component.onCompleted: {
        firstWordIgnoreList = "^(" + firstWordIgnore(settings.firstWordIgnore) + ")?"
    }

    SortFilterProxyModel {
        id: gamesFiltered
            sourceModel: currentCollection.games
            filters: RegExpFilter { 
                roleName: "title"; 
                pattern: firstWordIgnoreList + header.searchTerm.text; 
                caseSensitivity: Qt.CaseInsensitive;
                enabled: header.searchTerm.text != "" && header.searchbox.state === "opened"
            }
    }
}


