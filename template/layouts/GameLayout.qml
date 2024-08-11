// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "parts"

Item {
    id: game_layout
    clip: true
    
    Item { //games
        id: games

        anchors.fill: parent

        anchors.rightMargin: vpx(24)
        anchors.leftMargin: vpx(24)

        property bool active: game_layout.focus

        GridView { //game_grid_view
            id: game_grid_view
            delegate: Thumbnail{}
            model: search.model

            anchors.fill: parent

            keyNavigationWraps: false

            property bool active: game_layout.focus

            bottomMargin: settings.buttonHints ? vpx(72) : 0

            cellWidth: parent.width / settings.columns
            cellHeight: cellWidth * 0.6
            
            highlightMoveDuration: 100
            highlightFollowsCurrentItem: true

            onCurrentIndexChanged: {
                background.refresh()
            }
        }
    }

    Keys.onPressed: { //Key Controls
        let key = gsk(event)
        if(isNaN(key)){
            if(key != undefined){
                switch(key){
                    case "up":
                        if(settings.columns - game_grid_view.currentIndex <= 0)
                            game_grid_view.moveCurrentIndexUp()
                        else {
                            if(game_grid_view.currentIndex < settings.columns / 2){
                                f = sortfilt_toolbar
                                s = audio.toggle_down
                            }else{
                                f = header
                                header.current = header.search_button
                                s = audio.toggle_down
                            }

                        }
                        break
                    case "down":
                        if(game_grid_view.currentIndex + settings.columns <= game_grid_view.count - 1)
                            game_grid_view.moveCurrentIndexDown()
                        else 
                            game_grid_view.currentIndex = game_grid_view.count - 1
                        break
                    case "left":
                        game_grid_view.moveCurrentIndexLeft()
                        break
                    case "right":
                        game_grid_view.moveCurrentIndexRight()
                        break
                    case "prev":
                        collectionPrevious()
                        break
                    case "next":
                        collectionNext()
                        break
                    case "first":
                        game_grid_view.currentIndex = 0
                        break
                    case "last":
                        game_grid_view.currentIndex = game_grid_view.count - 1
                        break
                    case "details":
                        f = panel_area
                        panel_area.current = panel_area.info_panel
                        panel_area.info_panel.video.safePlay()
                        s = audio.toggle_down
                        break
                    case "filter":
                        f = sortfilt_menu
                        break
                    case "accept":
                        launch_window.visible = true
                        if(settings.lastPlayed){
                            api.memory.set("collectionIndex", currentCollectionIndex)
                            api.memory.set("gameIndex", game_grid_view.currentIndex)
                        }
                        s = audio.toggle_down
                        currentGame.launch()
                    default:
                        break
                }
                s = s != null ? s : audio.select
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

    property GridView games: game_grid_view
}
