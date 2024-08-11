// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import SortFilterProxyModel 0.2

Item {
    id: search
    property alias model: gamesFiltered
    property string firstWordIgnoreList

    function currentGame(index) { 
        return currentCollection.games.get(gamesFiltered.mapToSource(index)) 
    }

    function populateModel(){
        gamesFiltered.clear() // Clear existing entries
    }

    SortFilterProxyModel {
        id: gamesFiltered
        sourceModel: currentCollection.games
        filters: [
            RegExpFilter { 
                roleName: "title"; 
                pattern: header.search_term.text 
                caseSensitivity: Qt.CaseInsensitive;
                enabled: header.search_term.text != ""
            },

            ValueFilter { 
                roleName: "favorite"; 
                value: true;
                enabled: sortfilt_menu.favorite.enabled
            }
        ]
        sorters: [
            RoleSorter { 
                roleName: "sortBy" 
                sortOrder: sortfilt_menu.title.asc ? Qt.AscendingOrder : Qt.DescendingOrder
                enabled: sortfilt_menu.title.enabled
            },
            RoleSorter { 
                roleName: "lastPlayed" 
                sortOrder: sortfilt_menu.last_played.asc ? Qt.DescendingOrder : Qt.AscendingOrder
                enabled: sortfilt_menu.last_played.enabled
            },

            RoleSorter { 
                roleName: "playTime" 
                sortOrder: sortfilt_menu.play_time.asc ? Qt.AscendingOrder : Qt.DescendingOrder
                enabled: sortfilt_menu.play_time.enabled
            }
        ]
    }
}


