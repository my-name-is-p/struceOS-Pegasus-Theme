// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: numbers

    property var keys:[
        {
            key: "z",
            shift: "Z",
            size: "single"
        },
        {
            key: "x",
            shift: "X",
            size: "single"
        },
        {
            key: "c",
            shift: "C",
            size: "single"
        },
        {
            key: "v",
            shift: "V",
            size: "single"
        },
        {
            key: "b",
            shift: "B",
            size: "single"
        },
        {
            key: "n",
            shift: "N",
            size: "single"
        },
        {
            key: "m",
            shift: "M",
            size: "single"
        },
        {
            key: ",",
            shift: "<",
            size: "single"
        },
        {
            key: ".",
            shift: ">",
            size: "single"
        },
        {
            key: "/",
            shift: "?",
            size: "single"
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
