// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Item { //slider
    id: slider

    anchors.top: parent.top
    anchors.bottom: parent.bottom

    property string memory: ""
    property real value: min
    property bool percent: false

    property real min: 1
    property real max: 10
    property real increment: 1
    property real stop: base.width / ((max - min) / increment)

    property bool selected: false
    property var current: base

    //Functions--
        function updateX(position, mute = false){ //updateX
            if(0 >= position)
                position = 0

            let current_stop = slider.stop
            let i = slider.min
            if(current_stop / 2 > position){
                position = 0
            }else{
                while(current_stop < position){
                    current_stop += slider.stop
                    i++
                }
                if(current_stop - (slider.stop / 2) > position){
                    position = current_stop - slider.stop
                }else{
                    position = current_stop
                    i++
                }
            }

            slider.value = Math.min(i, slider.max)

            if(position > base.width)
                position = base.width

            position = Math.round(position - handle.width / 2)

            if(position != handle.x && !mute){
                audio.select.safePlay()
            }
            return position
        }

        function onAccept (){
            if(current.onAccept){
                current.onAccept()
            }else{
                if(current != handle)
                    current = handle
                else
                    current = base
            }
        }

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
    //--

    Rectangle { //base
        id: base
        color: colors.slider_base

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: vpx(12)
        anchors.right: value.left
        anchors.rightMargin: vpx(12)

        height: vpx(6)
        radius: vpx(6)


        Rectangle { //progress
            id: progress
            color: colors.slider

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: handle.right

            radius: vpx(6)
        }

        Rectangle { //handle
            id: handle
            color: colors.slider

            anchors.verticalCenter: parent.verticalCenter

            width: vpx(12)
            height: width

            radius: vpx(12)

            x: 0

            property bool selected: current === this

            Component.onCompleted: {
                x = slider.updateX((slider.value - min) * slider.stop, true)
            }

            function onCancel(){
                slider.current = base
            }

            function onLeft(){
                slider.value = slider.value - slider.increment >= min ? slider.value - slider.increment : slider.value
                x = slider.updateX((slider.value - min) * slider.stop, true)
                let v = slider.percent ? slider.value / 100 : slider.value
                api.memory.set(slider.memory, v)
            }
            property var onPrevious: onLeft

            function onRight(){
                slider.value = slider.value + slider.increment <= max ? slider.value + slider.increment : slider.value
                x = slider.updateX((slider.value - min) * slider.stop, true)
                let v = slider.percent ? slider.value / 100 : slider.value
                api.memory.set(slider.memory, v)
            }
            property var onNext: onRight

            function onUp(){
                x = slider.updateX(base.width, true)
                let v = slider.percent ? slider.value / 100 : slider.value
                api.memory.set(slider.memory, v)
            }
            property var onLast: onUp

            function onDown(){
                x = slider.updateX(0, true)
                let v = slider.percent ? slider.value / 100 : slider.value
                v = v <= 0 ? 0 : v
                api.memory.set(slider.memory, v)
            }
            property var onFirst: onDown

            Rectangle { //handle_select
                id: handle_select

                anchors.fill: parent
                anchors.margins: vpx(-6)

                color: colors.t

                radius: vpx(6)

                border.width: vpx(6)
                border.color: colors.border

                visible: handle.selected
            }
        }

        Rectangle { //select
            id: select

            anchors.top: handle.top
            anchors.bottom: handle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: vpx(-6)

            color: colors.t

            radius: vpx(6)

            border.width: vpx(6)
            border.color: colors.border

            visible: slider.selected && !handle.selected
        }
    }

    Rectangle { //value_background
        id: value_background

        anchors.fill: value
        anchors.margins: vpx(-3)

        color: addAlphaToHex(0.7, colors.black)

        radius: vpx(6)
    }

    Text { //value
        id: value
        text: slider.value
        color: colors.text

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right

        width: vpx(60)

        font.family: bold.name
        font.bold: true
        font.pixelSize: vpx(16)

        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea { //slider_click
        id: slider_click

        anchors.fill: parent

        property var margin: base.anchors.leftMargin

        cursorShape: Qt.PointingHandCursor

        onPositionChanged: {
            handle.x = slider.updateX(mouse.x - margin)
            let v = slider.percent ? slider.value / 100 : slider.value
            api.memory.set(slider.memory, v)
        }

        onPressed: {
            handle.x = slider.updateX(mouse.x - margin)
            audio.select.safePlay()
        }

        onReleased: {
            let v = slider.percent ? slider.value / 100 : slider.value
            api.memory.set(slider.memory, v)
        }
    }
}
