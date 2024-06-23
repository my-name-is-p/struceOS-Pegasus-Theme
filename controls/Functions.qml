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

// Thank you to VGmove creator of EasyLaunch <https://github.com/VGmove/EasyLaunch>
// for the collection logos, images, audio, and various functionality


import QtQuick 2.15

Item {
    id: functions

    // GetSimpleKeys
    // returns a simplfied control set
    function gsk(event) {
        let key = event.key
        if(key == Qt.Key_Left || key == Qt.Key_A)
            return "left"
        if(key == Qt.Key_Right || key == Qt.Key_D)
            return "right"
        if(key == Qt.Key_Up || key == Qt.Key_W)
            return "up"
        if(key == Qt.Key_Down || key == Qt.Key_S)
            return "down"
        if(api.keys.isNextPage(event) || key == Qt.Key_Equal)
            return "next"
        if(api.keys.isPrevPage(event) || key == Qt.Key_Minus)
            return "prev"
        if(api.keys.isPageUp(event))
            return "first"
        if(api.keys.isPageDown(event))
            return "last"
        if(api.keys.isFilters(event))
            return "filter"
        if(api.keys.isDetails(event))
            return "details"
        if((api.keys.isAccept(event) || key == Qt.Key_Space) && !event.isAutoRepeat)
            return "accept"
        if(api.keys.isCancel(event))
            return "cancel"
    }

    //GetCurrentGame
    function gcg(){
        return search.currentGame(g.i)
    }

    function getAssets(assets){
        let random = assets.screenshots.length > 1 ? Math.floor(Math.random() * assets.screenshots.length) : 0
        let gotAssets = {}

        // Background
        gotAssets.bg = 
            assets.screenshots[random] != undefined ?
            assets.screenshots[random] :
                assets.screenshot != "" ?
                assets.screenshot :
                    assets.background != "" ? 
                    assets.background : 
                        "default"

        // Banner
        gotAssets.banner = 
            assets.steam != "" ? 
            assets.steam : 
                assets.banner != "" ? 
                assets.banner : 
                    assets.boxFront != "" ? 
                    assets.boxFront : 
                        assets.logo != "" ? 
                        assets.logo :
                            "default"

        // Logo
        gotAssets.logo = 
            assets.logo != "" ? 
            assets.logo : 
                assets.wheel != "" ?
                assets.wheel :
                    "default"

        // Video
        gotAssets.video = 
            assets.video != "" ?
            assets.video :
                "default"
        return gotAssets
    }

    //log
    function log(str = "", tag = "", clear = false){
        let temp = consoleLog.text
        let s = "\n"
        if(!clear){
            if( tag != ""){
                temp = consoleLog.text + s + "[>--" + str + "--<]" 
            } else {
                temp = consoleLog.text + s + str
            }
        } else {
            if( tag != ""){
                temp = "[>--" + str + "--<]" 
            } else {
                temp = str
            }
        }
        consoleLog.text = temp
    }
}