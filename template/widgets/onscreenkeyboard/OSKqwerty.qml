// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: numbers

    property var keys:[
        {
            key: "q",
            shift: "Q",
            size: "single"
        },
        {
            key: "w",
            shift: "W",
            size: "single"
        },
        {
            key: "e",
            shift: "E",
            size: "single"
        },
        {
            key: "r",
            shift: "R",
            size: "single"
        },
        {
            key: "t",
            shift: "T",
            size: "single"
        },
        {
            key: "y",
            shift: "Y",
            size: "single"
        },
        {
            key: "u",
            shift: "U",
            size: "single"
        },
        {
            key: "i",
            shift: "I",
            size: "single"
        },
        {
            key: "o",
            shift: "O",
            size: "single"
        },
        {
            key: "p",
            shift: "P",
            size: "single"
        },
        {
            key: "[",
            shift: "{",
            size: "single"
        },
        {
            key: "]",
            shift: "}",
            size: "single"
        },
        {
            key: "\\",
            shift: "|",
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
