// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "parts/collections"

Item {
    id: collection_menu

    height: vpx(120)

    property bool opened: focus

    property ListView list: collections_list
    property ListModel model: collections_list.model
    
    clip: true

    //Functions--
        function positionViewAtCurrentIndex(){
            collections_list.currentIndex = settings.allGames ? currentCollectionIndex + 1 : currentCollectionIndex
            collections_list.positionViewAtIndex(collections_list.currentIndex, ListView.Center)
        }

        function onUp(){
            header.current = header.collection
            resetFocus(header)
        }

        function onDown(){
            games.currentIndex = 0
            resetFocus()
        }
        property var onCancel: onDown
        property var onAccept: onDown
        
        function onPrevious(){
            if(collections_list.currentIndex != 0)
                collectionPrevious()
        }
        property var onLeft: onPrevious

        function onNext(){
            if(collections_list.currentIndex != collections_list.count - 1)
                collectionNext()
        }
        property var onRight: onNext

        function onFirst(){
            currentCollectionIndex = settings.allGames ? -1 : 0
            positionViewAtCurrentIndex()
        }

        function onLast(){
            currentCollectionIndex = api.collections.count - 1
            positionViewAtCurrentIndex()
        }
    //--

    MouseArea { //collections_list_scroll
        id: collections_list_scroll
        anchors.fill: collections_list

        enabled: collection_menu.focus

        onWheel: {
            if(wheel.angleDelta.y < 0){
                if(collections_list.currentIndex != collections_list.count - 1)
                    collectionNext()
            }else{
                if(collections_list.currentIndex != 0)
                    collectionPrevious()
            }
            audio.toggle_down.safePlay()
        }
    }
    
    ListView { //collections_list
        id: collections_list

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.left: parent.left

        leftMargin: vpx(48)
        rightMargin: vpx(48)
        
        height: parent.height

        currentIndex: settings.allGames ? currentCollectionIndex + 1 : currentCollectionIndex

        model: CollectionModel{}
        delegate: CollectionItem{}
        orientation: ListView.Horizontal

        spacing: vpx(36)

        highlightFollowsCurrentItem: false
        highlightMoveDuration: 1
    }
    
    Keys.onPressed: {
        if(event.key === 1048576 && event.isAutoRepeat)
            return
        s = s != null ? s : audio.toggle_down
    }
}
