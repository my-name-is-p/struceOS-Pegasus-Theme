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

Item {

    id: settings

    //Colors
    property var colors: {
        "martinique" : "#392e4a",
        "green" : "#1ba39c",
        "border": Qt.rgba(1,1,1,0.6),
        "white": Qt.rgba(1,1,1,1),
        "black": Qt.rgba(0,0,0,1),
        "black90": Qt.rgba(0,0,0,0.90),
        "black75": Qt.rgba(0,0,0,0.75)
    }

    //Fonts
    property string fontFamilyRegular: 
        "assets/fonts/Open Sans/OpenSans-Regular.ttf"
    property string fontFamilyBold: 
        "assets/fonts/Open Sans/OpenSans-Bold.ttf"

    //gameView Settings
    property int columns:                                               //Number of columns to display in gameView
        api.memory.get("struceOS_gameView_columns") != undefined ?
        api.memory.get("struceOS_gameView_columns") :
        4
    property int columnsMax: 10                                         //Maximum columns in gameView
    property int columnsMin: 3                                          //Minimum columns in gameView
    property var croppedThumbnails:                                     //Array of game.shortName--banner images will be scaled to fill
        api.memory.get("struceOS_gameView_croppedThumbnails") != undefined ? 
        api.memory.get("struceOS_gameView_croppedThumbnails") :
        []                                                     
    property bool lastPlayed:                                           //Open to last game played--otherwise opens to last selected
        api.memory.get("struceOS_gameView_lastPlayed") != undefined ? 
        api.memory.get("struceOS_gameView_lastPlayed") :
        true
    property bool allGames: 
    api.memory.get("struceOS_gameView_allGames") != undefined ?
    api.memory.get("struceOS_gameView_allGames") :
    true                                        //Turns on the All Games Category (Unde Development)
                                                                        //currently doubles up if games are contained in two collections (windows/pc)
    property string defaultGameImage: "img/no_image.png"                    //Image source for default game image (will only look in assets)

    //Background Settings
    property bool bgOverlayOn:                                          //Apply an overlay to the background
        api.memory.get("struceOS_background_overlayOn") != undefined ?
        api.memory.get("struceOS_background_overlayOn") :
        true
    property real bgOverlayOpacity:                                     //Overlay opacity 
        api.memory.get("struceOS_background_overlayOpacity") != undefined ?
        api.memory.get("struceOS_background_overlayOpacity") :
        0.75
    property string bgOverlaySource: "img/bg-gradient.png"              //Image source for the background overlay (will only look in assets)
    
    //Video Settings
    property bool videoMute:                                            //Mute video by default
        api.memory.get("struceOS_video_videoMute") != undefined ?
        api.memory.get("struceOS_video_videoMute") : 
        true
    property real videoVolume:                                          //Video volume
        api.memory.get("struceOS_video_volume") != undefined ?
        api.memory.get("struceOS_video_volume") :
        0.40

    //Search Settings
    property var firstWordIgnore: ["the","the legend of", "lego"]          //Words to ignore in search as the first word

    //DevTools
    property bool enableDevTools:                                        //Dispalys "console" and a button for testing purposes 
        api.memory.get("struceOS_dev_enableDevTools") != undefined ?
        api.memory.get("struceOS_dev_enableDevTools") :
        false
    property real consoleLogBackground:                                 //clog background opacity
        api.memory.get("struceOS_dev_log_opacity") != undefined ?
        api.memory.get("struceOS_dev_log_opacity") :
        0.5
    property string version: "1.3.1"                                    //struceOS version
    property bool working: false
}