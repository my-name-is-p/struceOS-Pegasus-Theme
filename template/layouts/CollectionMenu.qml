// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Rectangle {
    id: collections_menu
    height: focus ?  vpx(120) : 0
    color: addAlphaToHex(0.85, p.accent)
    property bool opened: focus

    Behavior on height {NumberAnimation {duration: 75}}

    property ListView list: collection_list
    property ListModel model: collections_model
    
    clip: true

    ListModel {
        id: collections_model

        Component.onCompleted: {
            populateModel()
        }

        function populateModel() {
            collections_model.clear() // Clear existing entries
            if(settings.allGames){
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
    
    MouseArea {
        id: collection_list_scroll
        anchors.fill: collection_list
        onWheel: {
            if(wheel.angleDelta.y < 0){
                if(collection_list.currentIndex != collection_list.count - 1)
                    collectionNext()
            }else{
                if(collection_list.currentIndex != 0)
                    collectionPrevious()
            }
            audio.stopAll()
            audio.toggle_down.play()
        }
    }
    
    ListView {
        id: collection_list

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: vpx(24)

        currentIndex: settings.allGames ? currentCollectionIndex + 1 : currentCollectionIndex

        model: collections_model
        delegate: collectionView_list_item
        orientation: ListView.Horizontal
        leftMargin: vpx(48)
        rightMargin: vpx(48)
        height: parent.height

        spacing: vpx(36)

        highlightFollowsCurrentItem: true
        highlightMoveDuration : 0
        highlightMoveVelocity : 1000
    }

    Component {
        id: collectionView_list_item
        Item {
            height: vpx(40)
            width: logoLoaded ? collectionView_list_logo.width : collectionView_list_name.width 
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: logoLoaded ? collectionView_list_logo.horizontalCenter : collectionView_list_name.horizontalCenter

            property bool logoLoaded: collectionView_list_logo.status != Image.Error ? true : false

            Image {
                id: collectionView_list_logo
                source: "../../assets/logos/" + shortName + ".svg"
                height: parent.height

                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.center

                antialiasing: true
                smooth: true
            }

            Text {
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
                anchors.margins: vpx(-12)

                color: p.t

                property bool hover: false

                border.color: p.border
                border.width: (collection_list.currentItem == parent && f === collections_menu) || hover ? vpx(3) : vpx(0)
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
                        currentCollectionIndex = settings.allGames ? index - 1 : index
                        audio.stopAll()
                        audio.toggle_down.play()
                    }
                }
            }
        }
    }

    //CONTROLS
    Keys.onPressed: {
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
                        if(collection_list.currentIndex != 0){
                            collectionPrevious()
                        }
                        break
                    case "next":
                    case "right":
                        if(collection_list.currentIndex != collection_list.count - 1){
                            collectionNext()
                        }
                        break
                    case "first":
                        currentCollectionIndex = settings.allGames ? -1 : 0
                        break
                    case "last":
                        currentCollectionIndex = api.collections.count - 1
                        break
                    case "details":
                        panel_area.current = panel_area.info_panel
                        f = panel_area
                        panel_area.info_panel.video.play()
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
}
