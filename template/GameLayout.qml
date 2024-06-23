// struceOS
// Copyright (C) 2024 strucep
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0
import "../utils.js" as U
import "extras"

Item {
    id: games

    GridView { 
        id: gameView
        delegate: gameThumb.thumb
        model: search.games
        anchors.fill: parent

        focus: parent.focus

        clip: true

        keyNavigationWraps: false

        cellWidth: parent.width / settings.columns
        cellHeight: cellWidth * 0.6
        
        Keys.forwardTo: parent

        highlightMoveDuration: 100
        highlightFollowsCurrentItem: true

        onCurrentIndexChanged: {
            g.i = currentIndex
            background.bg_refresh.restart()
        }
    }

    GameThumbnails {
        id: gameThumb
    }

    //CONTROLS
    Keys.onPressed: {
        let key = isNaN(parseInt(event.text)) ? gsk(event) : "number"
        if(key != undefined){
        //-- Get a number
            let n = parseInt(event.text)
            if(n == 0) {
                n = c.all ? 8 : 9
            } else {
                n = c.all ? n - 2 : n - 1
            }
            n = c.end < n ? c.end : n
        //--
            switch(key){
        //--- [START] CONTROLS
            //-- UP
                case "up":
                    if(g.i - g.cols >= 0) {
                        g.g.moveCurrentIndexUp()
                        s = g.i < g.cols ? toggle_down : select
                    } else {
                        //--GO UP FOCUS
                        header.focus = true
                        f = "header"
                        if(header.searchTerm.text != ""){
                            f = "search"
                        } else {
                            if(g.i < g.cols / 2 && (g.cols - g.i) > g.cols / 2){
                                header.currentItem = header.gv_up_1
                            } else {
                                header.currentItem = header.gv_up_2
                            }
                        }
                        s = toggle
                    }
                    break
            //-- DOWN
                case "down":
                    if(g.i + g.cols <= g.end)
                        g.g.moveCurrentIndexDown()
                    else 
                        g.g.currentIndex = g.end
                    s = select
                    break
            //-- LEFT
                case "left":
                    g.g.moveCurrentIndexLeft()
                    s = g.i < g.cols ? toggle_down : select
                    break
            //-- RIGHT
                case "right":
                    g.g.moveCurrentIndexRight()
                    s = g.i < g.cols ? toggle_down : select
                    break
            //-- PREVIOUS
                case "prev":
                    if(c.i === -1){
                        c.i = api.collections.count - 1
                    } else {
                        c.i <= 0 ? c.i = (c.all ? -1 : api.collections.count - 1) : c.i--
                    }

                    currentCollection = c.current = U.getCollection(c.i)
                    g.g.currentIndex = 0
                    background.bg_refresh.restart()
                    s = toggle
                    break
            //-- NEXT
                case "next":
                    if(c.i === -1){
                            c.i = 0
                    } else {
                        c.i >= api.collections.count - 1 ? (c.i = c.all ? -1 : 0) : c.i++
                    }
                    currentCollection = c.current = U.getCollection(c.i)
                    g.g.currentIndex = 0
                    background.bg_refresh.restart()
                    s = toggle
                    break
            //-- FIRST
                case "first":
                    g.g.currentIndex = 0
                    s = select
                    break
            //-- LAST
                case "last":
                    g.g.currentIndex = g.end
                    s = select
                    break
            //-- DETAILS
                case "details":
                    info.open()
                    break
            //-- FILTER
                case "filter":
                    currentGame.favorite = !currentGame.favorite
                    break
            //-- NUMBER
                case "number":
                    c.i = n
                    currentCollection = c.current = U.getCollection(n)
                    background.bg_refresh.restart()
                    g.g.currentIndex = 0
                    f = "games"
                    g.g.forceActiveFocus()

                    s = toggle
                    break
            //-- CANCEL
                case "cancel":
                    s = toggle
                    break
            //-- ACCEPT
                case "accept":
                    if(settings.lastPlayed){
                        api.memory.set("collectionIndex", c.i)
                        api.memory.set("gameIndex", g.i)
                    }
                    currentGame.launch()
                    break
                default:
                    break
            }
                if(key != "cancel")
                    event.accepted = true
                s = s != null ? s : select
        //--- [END] CONTROLS
        }
        if(s != null)
            s.play()
        s = null
    }

   property GridView gameView: gameView
}