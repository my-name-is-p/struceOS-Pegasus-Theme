// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: colors_model

    function populateModel() {
        clear()
        for (let key in settings.theme) {
            if(
                key != "t" && 
                key != "border" &&
                key != "undefined"
            ){
                append(createListElement(key, settings.theme[key]))
            }
        }
        resetFocus()
    }
    
    function createListElement(key, value) {
        return {
            color_name: key,
            color_value: value
        }
    }
}
