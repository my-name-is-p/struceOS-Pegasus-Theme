// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: numbers

    property var keys:[
        {
            key: "`",
            shift: "~",
            size: "single"
        },
        {
            key: "1",
            shift: "!",
            size: "single"
        },
        {
            key: "2",
            shift: "@",
            size: "single"
        },
        {
            key: "3",
            shift: "#",
            size: "single"
        },
        {
            key: "4",
            shift: "$",
            size: "single"
        },
        {
            key: "5",
            shift: "%",
            size: "single"
        },
        {
            key: "6",
            shift: "^",
            size: "single"
        },
        {
            key: "7",
            shift: "&",
            size: "single"
        },
        {
            key: "8",
            shift: "*",
            size: "single"
        },
        {
            key: "9",
            shift: "(",
            size: "single"
        },
        {
            key: "0",
            shift: ")",
            size: "single"
        },
        {
            key: "-",
            shift: "_",
            size: "single"
        },
        {
            key: "=",
            shift: "+",
            size: "single"
        },
        {
            key: "backspace",
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
