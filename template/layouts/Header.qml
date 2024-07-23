// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import "../widgets"

Item {
    id: header

    property Item current: collection

    height: {
        switch(settings.headerSize){
            case "l":
                return vpx(96)
            case "s":
                return vpx(64)
            default:
                return vpx(82)
        }
    }

    Item { //collection
        id: collection

        property string name: "collection"

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        width: collection_logo.status != Image.Error ? collection_logo.width : collection_logo_text.width
        anchors.margins: header.height / 4

        property bool selected: f === header && header.current === this

        Image { //collection_logo
            id: collection_logo
            visible: status != Image.Error
            source: images.current_collection

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left

            fillMode: Image.PreserveAspectFit

            antialiasing: true
            smooth: true
        }

        Text {  //collection_logo_text
            id: collection_logo_text

            anchors.left: parent.left
            anchors.top: parent.top

            text: currentCollection.name
            color: p.white

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(36)

            visible: collection_logo.status === Image.Error
        }

        Rectangle { //game_count
            id: game_count
            color: p.accent
            width: game_count_text.width + vpx(12) < vpx(24) ? vpx(24) : game_count_text.width + vpx(12)
            height: vpx(24)
            anchors.top: collection_logo.top
            anchors.left: collection.right
            anchors.leftMargin: vpx(6)
            radius: vpx(6)

            Text { //game_count_text
                id: game_count_text
                text: games.count
                color: p.text
                anchors.centerIn: parent

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(12)
            }
        }

        Rectangle { //collection_select
            id: collection_select
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: game_count.right
            anchors.margins:vpx(-6)
            color: p.t

            visible: collection.selected

            border.color: p.border
            border.width: vpx(3)
            radius: vpx(6)
        }

        MouseArea {
            id: collection_click
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

            onClicked: {
                header.current = collection
                if(f != collections_menu)
                    f = collections_menu
                else
                    f = game_layout
                audio.stopAll()
                audio.toggle_down.play()
            }
        }

        property var onAccept: function(){
            f = collections_menu
        }

        property var onDown: function(){
            f = sortfilt_toolbar
        }

        property var onLeft: function(){
            header.current = clock
        }


        property var onRight: function(){
            if(header.search_term.text != "")
                header.current = search_bar
            else
                header.current = search_button
        }

    }

    SearchBar { //search_bar
        id: search_bar

        property string name: "search_bar"

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: collection.right
        anchors.leftMargin: game_count.width + game_count.anchors.leftMargin
        anchors.right: search_button.left

        selected: f === header && header.current === this ? true : false

        property var onLeft: function(){
            header.current = collection
            f = background
            f = header
        }

        property var onRight: function(){
            header.current = search_button
            f = background
            f = header
        }

        property var onDown: function(){
            header.current = collection
            f = game_layout
        }
        property var onCanceled: onDown
    }

    UIButton {
        id: search_button
        anchors.right: settings_button.left

        icon: images.search_icon
        icon_color: p.text

        height: header.height / 1.5
        width: header.height / 1.5

        selected: f === header && header.current === this

        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: vpx(24)

        background: addAlphaToHex(0.3, p.black)
        hover_color: p.black

        onClicked: function(){
            f = header
            header.current = search_bar
            panel_area.info_panel.video.stop()
        }

        property var onAccept: function(){
            onClicked()
        }

        property var onLeft: function(){
            if(header.search_term.text != "")
                header.current = search_bar
            else
                header.current = collection
        }

        property var onRight: function(){
            header.current = settings_button
        }
    }

    UIButton {
        id: settings_button
        anchors.right: info_button.left

        icon: images.settings_icon
        icon_color: p.text

        height: header.height / 1.5
        width: header.height / 1.5

        selected: f === header && header.current === this

        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: vpx(24)

        background: addAlphaToHex(0.3, p.black)
        hover_color: p.black

        onClicked: function(){
            if(f != panel_area || panel_area.current != panel_area.settings_panel){
                f = panel_area
                panel_area.current = panel_area.settings_panel
                header.current = collection
            }else{
                panel_area.settings_panel.onCancel() 
                f = game_layout
            }
            panel_area.info_panel.video.stop()
        }

        property var onAccept: function(){
            onClicked()
        }

        property var onLeft: function(){
            header.current = search_button
        }

        property var onRight: function(){
            header.current = info_button
        }
    }

    UIButton {
        id: info_button

        anchors.right: clock.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: vpx(24)

        icon: images.info_icon
        icon_color: p.text

        height: header.height / 1.5
        width: header.height / 1.5

        selected: f === header && header.current === this


        background: addAlphaToHex(0.3, p.black)
        hover_color: p.black

        onClicked: function(){
            if(f != panel_area || panel_area.current != panel_area.info_panel){
                f = panel_area
                panel_area.current = panel_area.info_panel
                panel_area.info_panel.video.play()
                header.current = collection
            }else{
                panel_area.info_panel.onCancel() 
                f = game_layout
            }
        }

        property var onAccept: function(){
            onClicked()
        }

        property var onLeft: function(){
            header.current = settings_button
        }

        property var onRight: function(){
            header.current = clock
        }
    }

    Clock{
        id: clock
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: vpx(24)

        selected: header.current === this

        property var onAccept: function(){
            settings.twelvehour = !settings.twelvehour
            clock.clock.set()
            api.memory.set("struceOS_ui_twelvehour", settings.twelvehour)
        }

        property var onLeft: function(){
            header.current = info_button
        }

        property var onRight: function(){
            header.current = collection
        }
    }

    //onCancel - default
    property var onCancel: function(){
        header.current = collection
        f = game_layout
    }

    Keys.onPressed: { //Keys
        let key = gsk(event)
        if(isNaN(key)){
            if(key != undefined){
                switch (key){
                    case "up":
                        if(current.onUp != undefined)
                            current.onUp()
                        break
                    case "down":
                        if(current.onDown != undefined){
                            current.onDown()
                        }else{
                            if(games.currentIndex < games.columns / 2){
                                games.currentIndex = games.columns - 1
                            }
                            onCancel()
                        }
                        break
                    case "left":
                        if(current.onLeft != undefined)
                            current.onLeft()
                        break
                    case "right":
                        if(current.onRight != undefined)
                            current.onRight()
                        break
                    case "prev":
                        if(current.onPrevious != undefined)
                            current.onPrevious()
                        else
                            collectionPrevious()
                        break
                    case "next":
                        if(current.onNext != undefined)
                            current.onNext()
                        else
                            collectionNext()
                        break
                    case "first":
                        if(current.onFirst != undefined)
                            current.onFirst()
                        else
                            onFirst()
                        break
                    case "last":
                        if(current.onLast != undefined)
                            current.onLast()
                        else
                            onLast()
                        break
                    case "details":
                        header.current = collection
                        panel_area.current = panel_area.info_panel
                        f = panel_area
                        panel_area.info_panel.video.play()
                        break
                    case "filter":
                        header.current = collection
                        f = sortfilt_menu
                        break
                    case "cancel":
                        if(current === collection)
                            games.currentIndex = 0
                        if(current.onCancel != undefined)
                            current.onCancel()
                        else
                            onCancel()
                        event.accepted = true
                        break
                    case "accept":
                        if(current.onAccept != undefined)
                            current.onAccept()
                    default:
                        break
                }
                s = s != null ? s : audio.toggle_down
            }
        }else{
            if(key == 0) {
                currentCollectionIndex = settings.allGames ? 8 : 9
            } else {
                currentCollectionIndex = settings.allGames ? key - 2 : key - 1
            }
            s = audio.toggle_down
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }

    //Check if needed
    property Item collection: collection
    property Item search_bar: search_bar

    //Needed
    property TextInput search_term: search_bar.search_term
    property Item search_button: search_button
    property Item settings_button: settings_button
    property Item info_button: info_button
}