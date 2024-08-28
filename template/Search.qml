// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import SortFilterProxyModel 0.2

Item { //search
    id: search
    
    property alias model: gamesFiltered
    property string firstWordIgnoreList

    function currentGame() { 
        return currentCollection.games.get(gamesFiltered.mapToSource(games.currentIndex)) 
    }

    function populateModel(){
        gamesFiltered.clear()
    }

    SortFilterProxyModel { //gamesFiltered
        id: gamesFiltered
        sourceModel: currentCollection.games

        filters: [
            ValueFilter { 
                roleName: "screensaverhide"
                value: true
                enabled: screensaver.opacity === 1
            },
            
            RegExpFilter { 
                roleName: "title"
                pattern: search_term.text 
                caseSensitivity: Qt.CaseInsensitive;
                enabled: search_term.text != ""
            },

            ValueFilter { 
                roleName: "favorite"
                value: true
                enabled: sortfilt_menu.favorite.enabled
            },

            ExpressionFilter { 
                expression: {
                    if(genreFilter.length > 0){
                        if(genre != ""){
                            for(let i = 0; i < genreFilter.length; i++){
                                if(genre.includes(genreFilter[i]))
                                    return true
                            }
                            return false
                        }
                        return false
                    }
                    return true
                }
                enabled: true
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
