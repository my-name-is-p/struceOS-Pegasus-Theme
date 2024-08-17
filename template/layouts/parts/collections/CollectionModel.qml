// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: collections_model

    Component.onCompleted: {
        populateModel()
    }

    function populateModel() {
        collections_model.clear() // Clear existing entries
        if(settings.allGames){
            append({ name: "All Games", shortName: "allgames" })
        }
        for(var i=0; i<api.collections.count; i++) {
            append(createListElement(i))
        }
    }
    
    function createListElement(i) {
        return {
            name: api.collections.get(i).name,
            shortName: api.collections.get(i).shortName,
        }
    }
}
