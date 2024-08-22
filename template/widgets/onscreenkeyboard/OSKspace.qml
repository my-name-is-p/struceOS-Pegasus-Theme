// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: numbers

    property var keys:[
        {
            key: "shift",
            shift: "",
            size: "double"
        },
        {
            key: "space",
            shift: "",
            size: "space",
        },
        {
            key: "left",
            shift: "",
            size: "single",
            icon: images.arrow_l_filled,
        },
        {
            key: "right",
            shift: "",
            size: "single",
            icon: images.arrow_r_filled,
        },
    ]

    function populateModel() {
        for(var i=0; i<keys.length; i++) {
            append(keys[i])
        }
    }
    
    Component.onCompleted: {
        populateModel()
    }
}
