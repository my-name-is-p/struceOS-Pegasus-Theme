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
// #1.5.1
//      1. Added button hints
//      2. Added color options to settings

// #1.5.0 
//      1. Moved panel items to new window
//      2. Added sort/filter menu
//      3. Added navigation for controllers/kb to all menus
//      4. Removed old code
//      5. Finished rewrite to simplify for now

// #1.4.1 - Unreleased
//      1. Moved sort/filter to top of gameView
//      2. Changed thumbnails to gameOS style
//      3. Continue rewrite to simplify

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
// 1. Add button hints
// 2. Add genre filters
// 3. Add on screen keyboard
// --------------------------------------------------------------------------------------------

import QtQuick 2.15
import QtMultimedia 5.9

import "template"
import "template/layouts"
import "template/widgets"

import "utils.js" as U

FocusScope {
    id: root

    property int currentCollectionIndex: 0
    property var currentCollection: {
        if(currentCollectionIndex >= 0)
            return api.collections.get(currentCollectionIndex)
        else{
            return {
                name: "All games",
                shortName: "allgames",
                games: api.allGames
            }
        }
    }
    property GridView games: game_layout.games
    property var currentGame: search.currentGame(games.currentIndex)

    property Item f: game_layout
    property string bg: getAssets(currentGame.assets).bg
    property string bgOverlay: images.overlay_0002    
    property var palette: settings.theme
    property var s: null
    
    // property var c_test: settings.theme.accent.toString()


    //--FUNCTIONS--//
        //GetSimpleKeys
        property var gsk: U.gsk
        //Log
        property var log: U.log
        //getAssets
        property var getAssets: U.getAssets
        //alphaDecToHex
        property var alphaDecToHex: U.alphaDecToHex
        //alphaDecToHex
        property var addAlphaToHex: U.addAlphaToHex
        //validateHex
        property var validateHex: U.validateHex
        //collectionNext
        property var collectionNext: U.collectionNext
        //collectionPrevious
        property var collectionPrevious: U.collectionPrevious
        //resetFocus
        property var resetFocus: U.resetFocus
        //clearMemory
        property var clearMemory: U.clearMemory
        //checkSettings
        property var checkSettings: U.checkSettings
    //--

   	FontLoader { id: regular; source: settings.fontFamilyRegular }
   	FontLoader { id: bold; source: settings.fontFamilyBold }


    Search {
        id: search
    }

    Audio {
        id: audio
    }

    Images {
        id: images
    }

    Background {
        id: background
        fade_time: 200
    }
    
    Header {
        id: header

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        focus: f === this
    }

    CollectionMenu {
        id: collections_menu

        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        focus: f === this
    }

    PanelArea {
        id: panel_area

        anchors.right: parent.right
        anchors.left: sortfilt_menu.right
        anchors.top: collections_menu.bottom

        focus: f === this
    }

    SortFilterToolbar{
        id: sortfilt_toolbar

        anchors.left: sortfilt_menu.right
        anchors.right: parent.right
        anchors.top: panel_area.bottom

        focus: f === this

    }

    SortFilterMenu {
        id: sortfilt_menu

        anchors.left: parent.left
        anchors.top: collections_menu.bottom
        anchors.bottom: parent.bottom

        focus: f === this
    }

    GameLayout {
        id: game_layout

        anchors.top: sortfilt_toolbar.bottom
        anchors.left: sortfilt_menu.right
        anchors.bottom: parent.bottom

        width: parent.width

        focus: f === this
    }

    ButtonHints {
        id: button_hints

        anchors.bottom: parent.bottom
        anchors.bottomMargin: settings.buttonHints ? 0 : -(parent.height - parent.height * 0.95)
        anchors.left: sortfilt_menu.right
        anchors.right: parent.right

        Behavior on anchors.bottomMargin {NumberAnimation{duration: 125}}

        opacity: settings.buttonHints ? 1 : 0

        Behavior on opacity {NumberAnimation{duration: 125}}
    }

    LaunchWindow {
        id:launch_window

        anchors.fill: parent

        visible: false
    }

    DevTools{
        id: devtools
    }

    Component.onCompleted: {
        currentCollectionIndex = api.memory.get("collectionIndex") || 0
        games.currentIndex = api.memory.get("gameIndex") || 0
        if(currentCollectionIndex < 0 && !settings.allGames){
            currentCollectionIndex = 0
            games.currentIndex = 0
        }
        bg = getAssets(currentGame.assets).bg

        if(settings.enableDevTools)
            log(settings.details)

        audio.stopAll()
        audio.home.play()
    }

    property string test: settings.enableDevTools ? "test" : undefined

    focus: true

    Loader { //settings_loader
        id: settings_loader
        sourceComponent: settings_component
    }

    Component { //settings_component
        id: settings_component
        Settings{}
    }
    property Item settings: settings_loader.item
}
