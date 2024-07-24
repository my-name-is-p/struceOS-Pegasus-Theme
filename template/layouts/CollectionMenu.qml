// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Rectangle {
    id: collections_menu
    height: focus ?  vpx(120) : 0
    color: addAlphaToHex(0.85, p.accent)
    property bool opened: focus

    Behavior on height {NumberAnimation {duration: 75}}

    property ListView list: collections_list
    property ListModel model: collections_model
    
    clip: true

    function positionViewAtCurrentIndex(){
        collections_list.currentIndex = stest.allGames ? currentCollectionIndex + 1 : currentCollectionIndex
        collections_list.positionViewAtIndex(collections_list.currentIndex, ListView.Center)
    }

    ListModel {
        id: collections_model

        Component.onCompleted: {
            populateModel()
        }

        function populateModel() {
            collections_model.clear() // Clear existing entries
            if(stest.allGames){
                append({ name: "All Games", shortName: "allgames" })
            }
            for(var i=0; i<api.collections.count; i++) {
                append(createListElement(i))
            }
        }
        
        function createListElement(i) {
            return {
                name: api.collections.get(i).name,
                shortName: api.collections.get(i).shortName,
            }
        }
    }
    
    MouseArea { //collections_list_scroll
        id: collections_list_scroll
        anchors.fill: collections_list
        onWheel: {
            if(wheel.angleDelta.y < 0){
                if(collections_list.currentIndex != collections_list.count - 1)
                    collectionNext()
            }else{
                if(collections_list.currentIndex != 0)
                    collectionPrevious()
            }
            audio.stopAll()
            audio.toggle_down.play()
        }
    }
    
    ListView { //collections_list
        id: collections_list

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: vpx(24)

        leftMargin: vpx(48)
        rightMargin: vpx(48)
        
        height: parent.height

        currentIndex: stest.allGames ? currentCollectionIndex + 1 : currentCollectionIndex

        model: collections_model
        delegate: collectionView_list_item
        orientation: ListView.Horizontal

        spacing: vpx(36)

        highlightFollowsCurrentItem: false
        highlightMoveDuration : 1
    }

    Component { //collectionView_list_item
        id: collectionView_list_item

        Item {

            height: vpx(40)
            width: logoLoaded ? collectionView_list_logo.width : collectionView_list_name.width 
            
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: logoLoaded ? collectionView_list_logo.horizontalCenter : collectionView_list_name.horizontalCenter

            property bool logoLoaded: collectionView_list_logo.status != Image.Error ? true : false

            Image { //collectionView_list_logo
                id: collectionView_list_logo
                source: "../../assets/logos/" + shortName + ".svg"
                height: parent.height

                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.center

                antialiasing: true
                smooth: true
            }

            Text { //collectionView_list_name
                id: collectionView_list_name
                text: name
                anchors.centerIn: parent

                color: p.white
                visible: collectionView_list_logo.status === Image.Error
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(36)
                fontSizeMode: Text.fit
            }

            Rectangle { //collectionTitle_border
                id: collectionTitle_border

                anchors.fill: parent
                anchors.margins: vpx(-6)

                property bool selected: (collections_list.currentItem == parent && f === collections_menu) || hover

                color: p.t

                property bool hover: false

                border.color: p.border
                border.width: selected || hover ? vpx(6) : vpx(0)
                radius: vpx(6)

                MouseArea {
                    id: collectionTitle_click
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: f != collections_menu ? Qt.ArrowCursor : Qt.PointingHandCursor

                    enabled: f === collections_menu

                    onEntered: {
                        parent.hover = true
                    }

                    onExited: {
                        parent.hover = false
                    }

                    onClicked: {
                        games.currentIndex = 0
                        currentCollectionIndex = stest.allGames ? index - 1 : index
                        collections_menu.positionViewAtCurrentIndex()
                        background.refresh()
                        audio.stopAll()
                        audio.toggle_down.play()
                    }
                }
            }
        }
    }

    Keys.onPressed: { //Keys
        let key = isNaN(parseInt(event.text)) ? gsk(event) : "number"
        if(isNaN(key)){
            if(key != undefined){
                switch(key){
                    case "up":
                        f = header
                        break
                    case "down":
                        f = game_layout
                        break
                    case "prev":
                    case "left":
                        if(collections_list.currentIndex != 0){
                            collectionPrevious()
                        }
                        break
                    case "next":
                    case "right":
                        if(collections_list.currentIndex != collections_list.count - 1){
                            collectionNext()
                        }
                        break
                    case "first":
                        currentCollectionIndex = stest.allGames ? -1 : 0
                        positionViewAtCurrentIndex()
                        break
                    case "last":
                        currentCollectionIndex = api.collections.count - 1
                        positionViewAtCurrentIndex()
                        break
                    case "details":
                        panel_area.current = panel_area.info_panel
                        f = panel_area
                        panel_area.info_panel.video.safePlay()
                        break
                    case "filter":
                        f = sortfilt_menu
                        break
                    case "cancel":
                        f = game_layout
                        break
                    case "accept":
                        f = game_layout
                        break
                    default:
                        break
                }
                event.accepted = true
                s = s != null ? s : audio.toggle_down
            }
        }else{
            if(key == 0) {
                currentCollectionIndex = stest.allGames ? 8 : 9
            } else {
                currentCollectionIndex = stest.allGames ? key - 2 : key - 1
            }
            s = audio.toggle_down
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }
}
