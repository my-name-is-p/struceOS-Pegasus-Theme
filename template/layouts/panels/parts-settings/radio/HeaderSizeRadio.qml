// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "../../../../widgets"

Item { //header_settings_size_radio
    id: header_settings_size_radio

    property bool selected
    property var current: header_settings_size_small

    //Functions--
        property var onUp: current.onUp
        property var onDown: current.onDown
        property var onLeft: current.onLeft
        property var onRight: current.onRight
        property var onPrevious: current.onPrevious
        property var onNext: current.onNext
        property var onFirst: current.onFirst
        property var onLast: current.onLast
        property var onDetails: current.onDetails
        property var onSort: current.onSort
        property var onCancel: current.onCancel
        property var onAccept: current.onAccept
    //--

    height: childrenSize(this, "height", "", 0, 0, true)
    width: childrenSize(this, "width", "rightMargin")

    RadioItem { //header_settings_size_small
        id: header_settings_size_small
        text: "small"

        anchors.right: header_settings_size_medium.left
        anchors.rightMargin: vpx(18)

        siblings: parent.children

        enabled: settings.headerSize === "s"

        selected: header_settings_size_radio.selected && header_settings_size_radio.current === this

        onClicked: function(){
            resetItems()
            settings.headerSize = "s"
            api.memory.set("struceOS_ui_headerSize", settings.headerSize)
        }
        property var onAccept: onClicked

        onRight: function(){
            header_settings_size_radio.current = header_settings_size_medium
        }
    }

    RadioItem { //header_settings_size_medium
        id: header_settings_size_medium
        text: "medium"

        anchors.right: header_settings_size_large.left
        anchors.rightMargin: vpx(18)

        siblings: parent.children

        enabled: settings.headerSize === "m"

        selected: header_settings_size_radio.selected && header_settings_size_radio.current === this

        onClicked: function(){
            resetItems()
            settings.headerSize = "m"
            api.memory.set("struceOS_ui_headerSize", settings.headerSize)
        }
        property var onAccept: onClicked

        onLeft: function(){
            header_settings_size_radio.current = header_settings_size_small
        }

        onRight: function(){
            header_settings_size_radio.current = header_settings_size_large
        }
    }

    RadioItem { //header_settings_size_large
        id: header_settings_size_large
        text: "large"

        anchors.right: parent.right

        siblings: parent.children

        enabled: settings.headerSize === "l"

        selected: header_settings_size_radio.selected && header_settings_size_radio.current === this

        onClicked: function(){
            resetItems()
            settings.headerSize = "l"
            api.memory.set("struceOS_ui_headerSize", settings.headerSize)
        }
        property var onAccept: onClicked

        onLeft: function(){
            header_settings_size_radio.current = header_settings_size_medium
        }
    }
}
