// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "../../../../widgets"

Item { //header_settings_size_radio
    id: header_settings_size_radio

    property bool selected
    property var current: header_settings_size_small

    //Functions--
        property var onUp: current.onUp != undefined ? current.onUp : undefined
        property var onDown: current.onDown != undefined ? current.onDown : undefined
        property var onLeft: current.onLeft != undefined ? current.onLeft : undefined
        property var onRight: current.onRight != undefined ? current.onRight : undefined
        property var onPrevious: current.onPrevious != undefined ? current.onPrevious : undefined
        property var onNext: current.onNext != undefined ? current.onNext : undefined
        property var onFirst: current.onFirst != undefined ? current.onFirst : undefined
        property var onLast: current.onLast != undefined ? current.onLast : undefined
        property var onDetails: current.onDetails != undefined ? current.onDetails : undefined
        property var onSort: current.onSort != undefined ? current.onSort : undefined
        property var onCancel: current.onCancel != undefined ? current.onCancel : undefined
        property var onAccept: current.onAccept != undefined ? current.onAccept : undefined
    //--

    height: { //height
        let h = 0
        for (var i = 0; i < children.length; i++) {
            h = children[i].height > h ? children[i].height : h
        }
        return h;
    }

    width: { //width
        let sum = 0
        for (var i = 0; i < children.length; i++) {
            sum += children[i].width + children[i].anchors.rightMargin
        }
        return sum;
    }

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
