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
// and PlayingKarrde creator of clearOS <https://github.com/PlayingKarrde/clearOS>
// for easy to read code

// Changelogs
// #1.4.0
//      1. Start of rewrite to simplify logic and improve modularity
//      2. Added a clock
//      3. Redesigned collection list

// #1.3.2
//      1. Added UI Mute setting
//      2. Updated getAsset() function to getAssets()
//      3. Reworked asset usage to better fit Skyscraper output
//      4. Changed Search to match any title containing the search term

// #1.3.1
//      1. Added favorite toggle to gameView
//      2. Fixed favorite icon placement in gameView
//      3. Added text labels to games with default banner image
//      4. Changed game count to update with filters
//      5. Updated gameView controls to use built in functions


// #1.3.0
//      1. Updated some collection logos
//      2. Simplified toggling panels
//      3. Fixed background images when searching
//      4. Changed audio files for UI sounds
//      5. Updated header layout and functions
//      6. Updated info panel layout and functions

// #1.2.1
//      1. Added "All Games" to the collection dropdown menu
//      2. Collection dropdown resizes to list length if shorter than the full window
//      3. Removed clog statements from testing

// #1.2.0
//      1. Added game count to collection title
//      2. Added collection dropdown menu

// #1.1.0
//      1. Split theme.qml into separate files for easier editing
//      2. Moved common functions to js
//      2. Updated header logic
//      3. Added Search functionality
//      4. Added an in app Settings panel
//      5. Added an All Games collection 
//      6. Fixed GoG and Steam collections

// #1.0.1
//      1. Fixed audio discrepancies in button presses
//      2. Fixed unused settings properties
//      3. Added additional settings to the customizable settings

// #1.0.0
//      1. Initial release

// TO DO --------------------------------------------------------------------------------------
// 1. Add Gamepad controls to Settings and Info panels
// --------------------------------------------------------------------------------------------

import QtQuick 2.15
import QtMultimedia 5.9


import "template"
import "template/extras"
import "controls"

import "utils.js" as U

FocusScope {
    id: root
    //Keys.forwardTo: custom_keys

    //--Settings--Customize these to your liking. Now found in template/Settings.qml. Default settings: <https://github.com/strucep/struceOS-Pegasus-Theme?tab=readme-ov-file#customizable-settings> --//
    Settings {
        id: settings
    }
    //---------------------------------------------------------------------------------------------------------------------//

   	FontLoader { id: regular; source: settings.fontFamilyRegular }
   	FontLoader { id: bold; source: settings.fontFamilyBold }

    //property bool loadTimeout: false

    property int currentCollectionIndex: 4
    property var currentCollection: U.getCollection(currentCollectionIndex)
    property var currentGame: search.currentGame(games.gameView.currentIndex)

    property bool fade_block: false

    //Quick access variables (QAV)
    property string bg
    property var p: settings.theme          //theme palette
    property var s: null                    //key sound
    property string f: "games"                 //current focus
    property var g: {                       //gameView Details
        "g": games.gameView,                    //gameView GridView
        "i": games.gameView.currentIndex,       //gameView GridView - current index
        "start": 0,                             //gameView GridView - first index
        "end": games.gameView.count - 1,        //gameView GridView - final index
        "cols": settings.columns,               //gameView GridView - column count
        "current": search.currentGame(games.gameView.currentIndex)
    }
    property var c: {                       //collections Details
        "c": api.collections,                   //all collections
        "i": 0,                                 //current collection index
        "start": 0,                             //fist collection
        "end": api.collections.count - 1,       //last collection
        "all": settings.allGames,               //all games toggle
        "current": U.getCollection(0),          //current collection
    }


Search {
    id: search
}
//--Run on loaded--//
Component.onCompleted: {
    c.i = 
        api.memory.get("collectionIndex") != undefined ? 
        api.memory.get("collectionIndex") : 
        0;
    currentCollection = c.current = U.getCollection(c.i) || 0
    g.g.currentIndex = g.i = api.memory.get("gameIndex") || 0
    bg = getAssets(currentGame.assets).bg
    home.play()
    log("struceOS v" + settings.version + (settings.working ? "-working" : ""))
}


//--Audio--//
    MediaPlayer {
		id: select
		source: "assets/sounds/lc.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}

    MediaPlayer {
		id: toggle
		source: "assets/sounds/hc_down.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}

    MediaPlayer {
		id: toggle_down
		source: "assets/sounds/hc_up.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}

    MediaPlayer {
		id: home
		source: "assets/sounds/home.mp3"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}
//


//[>--\/-MAIN-\/--<]
    //--Background--//
        Background {
            id: background
            Keys.forwardTo: parent
        }
    //
    //--Header--//
        Header {
            id: header
            Keys.forwardTo: parent

            focus: f === "header"
        }
    //
    //--CollectionsList--//
        CollectionsView {
            id: collectionsList
            Keys.forwardTo: parent

            focus: f === "collections"

            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
    //
    //--GameLayout--//
        GameLayout{
            id: games
            Keys.forwardTo: parent

            focus: f === "games"

            anchors.top: collectionsList.bottom

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            anchors.rightMargin: vpx(24)
            anchors.leftMargin: vpx(24)
        }
    //
    //--Info Panel--//
        InfoPanel {
            id: info
            Keys.forwardTo: parent

            focus: f === "info"
            state: f === "info" ? "opened" : ""
        }
    //
    //-- Settings Panel--//
        SettingsPanel{
            id: settingsPanel
            Keys.forwardTo: parent

            focus: f === "settings"
            state: f === "settings" ? "opened" : ""
        }
    //
    //--Dev Tools--//
        Rectangle{
            id:clog_window
            width: parent.width / 3
            visible: settings.enableDevTools
            anchors{
                top: parent.top
                right: parent.right
                bottom: devButton.top
                bottomMargin: vpx(12)
            }

            color: U.addAlphaToHex(settings.consoleLogBackground,p.black)

            clip: true

            Item{
                    anchors.fill: parent
                    anchors.margins: vpx(12)
                    clip: true
                TextEdit{
                    id: consoleLog
                    color: p.white
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    wrapMode: TextEdit.WordWrap
                }
            }
        }

        Rectangle {
            id: devButton
            height: vpx(48)
            width: vpx(48)
            radius: vpx(48)
            color: p.white
            visible: devButtonMouse.enabled

            anchors {
                bottom: parent.bottom
                right: parent.right
                margins: vpx(12)
            }

            states: [
                State{
                    name: "hovered"
                    PropertyChanges{target: devButton; color: p.black}
                }
            ]

            MouseArea {
                id: devButtonMouse
                enabled: settings.enableDevTools
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    devButton.state = "hovered"
                }

                onExited: {
                    devButton.state = ""
                }

                onClicked: {
                    select.play()
                    log("DEV-BUTTON", true)
                    mouse.event = accepted
                }
            }
        }
    //
    //--FUNCTIONS--//
        Functions {
        id: functions 
        }
        //GetSimpleKeys
        property var gsk: functions.gsk
        //GetCurrentGame
        property var gcg: functions.gcg
        //Log
        property var log: functions.log
        //getAssets
        property var getAssets: functions.getAssets
    //
//[>--/\-MAIN-/\--<]



    focus: true
}
