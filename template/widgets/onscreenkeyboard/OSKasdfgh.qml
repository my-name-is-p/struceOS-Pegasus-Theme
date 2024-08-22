// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: numbers

    property var keys:[
        {
            key: "a",
            shift: "A",
            size: "single"
        },
        {
            key: "s",
            shift: "S",
            size: "single"
        },
        {
            key: "d",
            shift: "D",
            size: "single"
        },
        {
            key: "f",
            shift: "F",
            size: "single"
        },
        {
            key: "g",
            shift: "G",
            size: "single"
        },
        {
            key: "h",
            shift: "H",
            size: "single"
        },
        {
            key: "j",
            shift: "J",
            size: "single"
        },
        {
            key: "k",
            shift: "K",
            size: "single"
        },
        {
            key: "l",
            shift: "L",
            size: "single"
        },
        {
            key: ";",
            shift: ":",
            size: "single"
        },
        {
            key: "'",
            shift: "\"",
            size: "single"
        },
        {
            key: "accept",
            shift: "",
            size: "double"
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
