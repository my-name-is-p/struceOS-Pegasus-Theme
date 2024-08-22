// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

import "../widgets"
import "parts/header"

Item { //header
    id: header

    property Item current: collection

    height: { //height
        switch(settings.headerSize){
            case "l":
                return vpx(96)
            case "s":
                return vpx(64)
            default:
                return vpx(82)
        }
    }

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

    Collection { //collection
        id: collection

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: header.height / 4

        selected: header.focus && header.current === this

        //--Functions
            function toggle(){
                header.current = collection
                if(collection_menu.focus){
                    resetFocus()
                }else{
                    collection_menu.positionViewAtCurrentIndex()
                    resetFocus(collection_menu)
                }
                s = audio.toggle_down
            }

            onClicked: function(){
                toggle()
                s.play()
                s = null
            }

            property var onAccept: toggle

            function onDown(){
                resetFocus(sortfilt_toolbar)
            }

            function onLeft(){
                header.current = clock
            }

            function onRight(){
                header.current = search_term.text != "" ? search_bar : search_button
            }
        //--
    }

    SearchBar { //search_bar
        id: search_bar

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: collection.right
        anchors.right: search_button.left

        selected: (f === header || (osk.visible && osk.last_focus === this)) && header.current === this

        //--Functions
            onClicked: function(){
                resetFocus(header)
                header.current = search_bar
                if(settings.osk){
                    osk.open(search_term, search_bar)
                }
                audio.stopAll()
                audio.toggle_down.play()
            }

            function onAccept(){
                if(settings.osk && !osk.visible){
                    osk.open(search_term, search_bar)
                }else{
                    games.currentIndex = 0
                    resetFocus()
                }
            }

            function onLeft(){
                header.current = collection
                resetFocus(header)
            }

            function onRight(){
                header.current = search_button
                resetFocus(header)
            }

            function onDown(){
                resetFocus()
            }
            property var onCancel: onDown
        //--
    }

    UIButton { //search_button
        id: search_button
        icon: images.search_icon
        background: addAlphaToHex(0.3, colors.black)
        hover_color: colors.black
        sound: audio.toggle_down

        anchors.right: settings_button.left
        anchors.rightMargin: vpx(24)
        anchors.verticalCenter: parent.verticalCenter

        height: header.height / 1.5
        width: header.height / 1.5

        selected: header.focus && header.current === this

        //Functions--
            function onAccept(){
                header.current = search_bar
                resetFocus(header)
                if(settings.osk){
                    osk.open(search_term, search_bar)
                }
            }
            onClicked: onAccept

            function onLeft(){
                header.current = search_term.text != "" ? search_bar : collection
            }

            function onRight(){
                header.current = settings_button
            }

            function onDown(){
                games.currentIndex = settings.columns - 1
                resetFocus()
            }
        //--
    }

    UIButton { //settings_button
        id: settings_button
        icon: images.settings_icon
        background: addAlphaToHex(0.3, colors.black)
        hover_color: colors.black
        sound: audio.toggle_down
        
        anchors.right: info_button.left
        anchors.rightMargin: vpx(24)
        anchors.verticalCenter: parent.verticalCenter
        
        height: header.height / 1.5
        width: header.height / 1.5

        selected: header.focus && header.current === this

        //Functions--
            function toggle(){
                if(!panel_area.focus || panel_area.current_s != "settings")
                    panel_area.open("settings")
                else
                    resetFocus()
            }
        
            function onAccept(){
                toggle()
            }
            onClicked: onAccept

            function onLeft(){
                header.current = search_button
            }

            function onRight(){
                header.current = info_button
            }

            function onDown(){
                games.currentIndex = settings.columns - 1
                resetFocus()
            }
        //--
    }

    UIButton { //info_button
        id: info_button
        icon: images.info_icon
        background: addAlphaToHex(0.3, colors.black)
        hover_color: colors.black
        sound: audio.toggle_down

        anchors.right: clock.left
        anchors.rightMargin: vpx(24)
        anchors.verticalCenter: parent.verticalCenter

        height: header.height / 1.5
        width: header.height / 1.5

        selected: header.focus && header.current === this

        //Functions--
            function toggle(){
                if(!panel_area.focus || panel_area.current_s != "info")
                    panel_area.open()
                else
                    resetFocus()
            }

            function onAccept(){
                toggle()
            }
            onClicked: onAccept

            function onLeft(){
                header.current = settings_button
            }

            function onRight(){
                header.current = clock
            }

            function onDown(){
                games.currentIndex = settings.columns - 1
                resetFocus()
            }
        //--
    }

    Clock{ //clock
        id: clock

        anchors.right: parent.right
        anchors.rightMargin: vpx(24)
        anchors.verticalCenter: parent.verticalCenter

        selected: header.focus && header.current === this

        //--Functions
            function onAccept(){
                settings.twelvehour = !settings.twelvehour
                clock.clock.set()
                api.memory.set("struceOS_ui_twelvehour", settings.twelvehour)
            }

            function onLeft(){
                header.current = info_button
            }

            function onRight(){
                header.current = collection
            }

            function onDown(){
                games.currentIndex = settings.columns - 1
                resetFocus()
            }
        //--
    }

    Keys.onPressed: { 
        if(event.key === 1048576 && event.isAutoRepeat)
            return
        s = s != null ? s : audio.toggle_down
    }

    property SearchBar search_bar: search_bar
    property TextInput search_term: search_bar.search_term
    property Item search_button: search_button
    property Item collection: collection
}
