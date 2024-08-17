// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "parts"

Item {
    id: game_layout
    
    //Functions--
        function onUp(){
            if(settings.columns - game_grid_view.currentIndex <= 0)
                game_grid_view.moveCurrentIndexUp()
            else {
                if(game_grid_view.currentIndex < settings.columns / 2){
                    resetFocus(sortfilt_toolbar)
                    s = audio.toggle_down
                }else{
                    header.current = header.search_button
                    resetFocus(header)
                    s = audio.toggle_down
                }
            }
        }

        function onDown(){
            if(game_grid_view.currentIndex + settings.columns <= game_grid_view.count - 1)
                game_grid_view.moveCurrentIndexDown()
            else 
                game_grid_view.currentIndex = game_grid_view.count - 1
        }

        function onLeft(){game_grid_view.moveCurrentIndexLeft()}
        function onRight(){game_grid_view.moveCurrentIndexRight()}
        function onFirst(){game_grid_view.currentIndex = 0}
        function onLast(){game_grid_view.currentIndex = game_grid_view.count - 1}
    //--

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

    Keys.onPressed: { 
        s = s != null ? s : audio.select
    }

    property GridView games: game_grid_view
}
