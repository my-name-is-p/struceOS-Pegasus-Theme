// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import SortFilterProxyModel 0.2

Item { //search
    id: search
    
    property alias model: gamesFiltered
    property string firstWordIgnoreList

    function currentGame(index) { 
        return currentCollection.games.get(gamesFiltered.mapToSource(index)) 
    }

    function populateModel(){
        gamesFiltered.clear()
    }

    SortFilterProxyModel { //gamesFiltered
        id: gamesFiltered
        sourceModel: currentCollection.games

        filters: [
            RegExpFilter { 
                roleName: "title"; 
                pattern: search_term.text 
                caseSensitivity: Qt.CaseInsensitive;
                enabled: search_term.text != ""
            },

            ValueFilter { 
                roleName: "favorite"; 
                value: true;
                enabled: sortfilt_menu.favorite.enabled
            }
        ]

        sorters: 
            RoleSorter { 
                roleName: sortfilt_menu.active_sort.role
                sortOrder: sortfilt_menu.active_sort.order
                enabled: sortfilt_menu.active_sort.enabled
            }
    }
}
