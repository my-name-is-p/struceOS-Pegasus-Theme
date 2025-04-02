// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15


Component { //collectionView_list_item
    id: collection_item

    Item {
        id: wrapper

        height: vpx(40)
        width: logoLoaded ? collectionView_list_logo.width : collectionView_list_name.width 
        
        property bool logoLoaded: collectionView_list_logo.status != Image.Error ? true : false

        Component.onCompleted: {
            anchors.verticalCenter = parent.verticalCenter
        }

        Item { //collectionView_logo_mask
            id: collectionView_logo_mask
            height: parent.height

            width: collectionView_list_logo.status != Image.Error ? collectionView_list_logo.width : collectionView_list_name.width

            visible: false

            Image { //collectionView_list_logo
                id: collectionView_list_logo
                source: "../../../../assets/logos/" + shortName + ".svg"
                height: parent.height

                fillMode: Image.PreserveAspectFit

                antialiasing: true
                smooth: true

                sourceSize.width: parent.width
                sourceSize.height: parent.height
            }

            Text { //collectionView_list_name
                id: collectionView_list_name
                text: name
                anchors.centerIn: parent

                color: colors.white
                visible: collectionView_list_logo.status === Image.Error
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                font.family: bold.name
                font.bold: true
                font.pixelSize: vpx(36)
            }
        }

        Rectangle { //collectionView_logo_color
            id: collectionView_logo_color
            anchors.fill: collectionView_logo_mask
            visible: false
            color: colors.white
        }

        OpacityMask {
            anchors.fill: collectionView_logo_mask
            source: collectionView_logo_color
            maskSource: collectionView_logo_mask
        }

        Rectangle { //collectionTitle_border
            id: collectionTitle_border

            anchors.fill: parent
            anchors.margins: vpx(-6)

            property bool selected: (collections_list.currentItem == parent && f === collection_menu) || hover

            color: colors.t

            property bool hover: false

            border.color: colors.border
            border.width: selected || hover ? vpx(6) : vpx(0)
            radius: vpx(6)

            MouseArea {
                id: collectionTitle_click

                anchors.fill: parent

                hoverEnabled: true

                cursorShape: f != collection_menu ? Qt.ArrowCursor : Qt.PointingHandCursor

                enabled: collection_menu.focus

                onPositionChanged: {
                    screensaver.reset()
                }

                onEntered: {
                    parent.hover = true
                }

                onExited: {
                    parent.hover = false
                }

                onClicked: {
                    games.currentIndex = 0
                    currentCollectionIndex = settings.allGames ? index - 1 : index
                    collection_menu.positionViewAtCurrentIndex()
                    background.refresh()

                    genreFilter = []
                    sortfilt_menu.genre_list.model.populateModel()
                    sortfilt_menu.genre_list.resetActive()
                    sortfilt_toolbar.genres_model.populateModel()
                    audio.toggle_down.safePlay()
                }
            }
        }
    }
}
