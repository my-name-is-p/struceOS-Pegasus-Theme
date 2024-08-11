// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "../../../../widgets"

Item { //overlay_style_radio
    id: overlay_style_radio
    anchors.right: parent.right

    property bool selected
    property var current: overlay_style_0001

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

    RadioItem { //overlay_style_0001
        id: overlay_style_0001
        text: "1"

        anchors.right: overlay_style_0002.left
        anchors.rightMargin: vpx(18)

        siblings: parent.children

        enabled: settings.bgOverlay === images.overlay_0001

        selected: overlay_style_radio.selected && overlay_style_radio.current === this

        onClicked: function(){
            resetItems()
            settings.bgOverlay = images.overlay_0001
            api.memory.set("struceOS_background_overlaySource", images.overlay_0001)
        }
        property var onAccept: onClicked

        onRight: function(){
            overlay_style_radio.current = overlay_style_0002
        }
    }

    RadioItem { //overlay_style_0002
        id: overlay_style_0002
        text: "2"

        anchors.right: overlay_style_0003.left
        anchors.rightMargin: vpx(18)

        siblings: parent.children

        enabled: settings.bgOverlay === images.overlay_0002

        selected: overlay_style_radio.selected && overlay_style_radio.current === this

        onClicked: function(){
            resetItems()
            settings.bgOverlay = images.overlay_0002
            api.memory.set("struceOS_background_overlaySource", images.overlay_0002)
        }
        property var onAccept: onClicked

        onLeft: function(){
            overlay_style_radio.current = overlay_style_0001
        }

        onRight: function(){
            overlay_style_radio.current = overlay_style_0003
        }
    }

    RadioItem { //overlay_style_0002
        id: overlay_style_0003
        text: "3"

        anchors.right: overlay_style_0004.left
        anchors.rightMargin: vpx(18)

        siblings: parent.children

        enabled: settings.bgOverlay === images.overlay_0003

        selected: overlay_style_radio.selected && overlay_style_radio.current === this

        onClicked: function(){
            resetItems()
            settings.bgOverlay = images.overlay_0003
            api.memory.set("struceOS_background_overlaySource", images.overlay_0003)
        }
        property var onAccept: onClicked

        onLeft: function(){
            overlay_style_radio.current = overlay_style_0002
        }

        onRight: function(){
            overlay_style_radio.current = overlay_style_0004
        }
    }

    RadioItem { //overlay_style_0002
        id: overlay_style_0004
        text: "4"

        anchors.right: overlay_style_0005.left
        anchors.rightMargin: vpx(18)

        siblings: parent.children

        enabled: settings.bgOverlay === images.overlay_0004

        selected: overlay_style_radio.selected && overlay_style_radio.current === this

        onClicked: function(){
            resetItems()
            settings.bgOverlay = images.overlay_0004
            api.memory.set("struceOS_background_overlaySource", images.overlay_0004)
        }
        property var onAccept: onClicked

        onLeft: function(){
            overlay_style_radio.current = overlay_style_0003
        }

        onRight: function(){
            overlay_style_radio.current = overlay_style_0005
        }
    }

    RadioItem { //overlay_style_0005
        id: overlay_style_0005
        text: "5"

        anchors.right: parent.right

        siblings: parent.children

        enabled: settings.bgOverlay === images.overlay_0005

        selected: overlay_style_radio.selected && overlay_style_radio.current === this

        onClicked: function(){
            resetItems()
            settings.bgOverlay = images.overlay_0005
            api.memory.set("struceOS_background_overlaySource", images.overlay_0005)
        }
        property var onAccept: onClicked

        onLeft: function(){
            overlay_style_radio.current = overlay_style_0004
        }
    }
}
