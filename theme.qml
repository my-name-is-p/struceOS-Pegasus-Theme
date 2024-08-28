// struceOS
// Copyright (C) 2024 my_name_is_p
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
// #1.6.1
//      1. VideoPlayer hotfix
//      2. Added screensaver timeout to settings
//      3. Sped up screensaver transition
//      4. Screensaver now clears the game layout to save on memory

// #1.6.0
//      1. OSK bugfixes
//      2. Screensaver improvements
//      3. Added genre filters
//      4. Moved button hints setting to Settings > Tools > General

// #1.5.3
//      1. Code cleanup and refactoring
//      2. Added screensaver
//      3. Added onscreen keyboard

// #1.5.2
//      1. Code cleanup and refactoring

// #1.5.1
//      1. Added button hints
//      2. Added color options to settings
//      3. Updated icons to change with color settings

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
// 1. 
// --------------------------------------------------------------------------------------------

import QtQuick 2.15
import QtMultimedia 5.9


import "template"
import "template/layouts"
import "template/widgets"

import "template/layouts/parts/collections"

import "utils.js" as U

FocusScope {
    id: root

    property string test: settings.enableDevTools ? "test" : undefined

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

    property var genreFilter: []

    property string bg: getAssets(search.currentGame().assets).bg
    property var s: null

    property Item f: game_layout
    
    //--Functions
        //launchGame
        property var launchGame: U.launchGame
        //GetSimpleKeys
        property var gsk: U.gsk
        //childrenSize
        property var childrenSize: U.childrenSize
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
        //logKeys
        property var logKeys: U.logKeys
    //--

   	FontLoader { id: regular; source: settings.fontFamilyRegular }
   	FontLoader { id: bold; source: settings.fontFamilyBold }

    MouseArea {
        id: mouse_track
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }
    }

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
    property TextInput search_term: header.search_term
    property Header header: header

    Rectangle{ //dropdown
        id: dropdown

        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        color: addAlphaToHex(0.95, colors.accent)

        clip: true

        height: {
            for(const [key, child] of Object.entries(children)){
                if(f === child || (osk.visible && osk.last_focus === child))
                    return child.height
            }
            return 0
        }
        Behavior on height {NumberAnimation {duration: settings.hover_speed}}

        PanelArea {
            id: panel_area

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left

            focus: f === this
            visible: (f === this || (osk.visible && osk.last_focus === this))
        }
        property Video video: panel_area.video

        CollectionMenu {
            id: collection_menu

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            focus: f === this
            visible: f === this
        }
        property CollectionMenu collection_menu: collection_menu
        property PanelArea panel_area: panel_area
    }
    property Video video: dropdown.video
    property PanelArea panel_area: dropdown.panel_area
    property CollectionMenu collection_menu: dropdown.collection_menu

    SortFilterMenu {
        id: sortfilt_menu

        anchors.top: dropdown.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        focus: f === this
    }

    SortFilterToolbar{
        id: sortfilt_toolbar

        anchors.top: dropdown.bottom
        anchors.left: sortfilt_menu.right
        anchors.right: parent.right

        focus: f === this
    }

    GameLayout {
        id: game_layout

        anchors.top: sortfilt_toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.left: sortfilt_menu.right

        width: parent.width

        focus: f === this
    }

    ButtonHints {
        id: button_hints

        anchors.bottom: parent.bottom
        anchors.bottomMargin: settings.buttonHints ? 0 : -height
        Behavior on anchors.bottomMargin {NumberAnimation{duration: 125}}
        
        anchors.left: sortfilt_menu.right
        anchors.right: parent.right

        opacity: settings.buttonHints ? 1 : 0
        Behavior on opacity {NumberAnimation{duration: 125}}
    }

    LaunchWindow {
        id:launch_window

        anchors.fill: parent
    }

    OnscreenKeyboard{
        id: osk

        anchors.fill: parent

        focus: f === this
    }

    ScreenSaver {
        id: screensaver

        anchors.fill: parent

        timeout: settings.screensaverTimeout
    }


    DevTools{
        id: devtools

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        visible: settings.enableDevTools
    }

    Component.onCompleted: {
        currentCollectionIndex = api.memory.get("collectionIndex") || 0
        games.currentIndex = api.memory.get("gameIndex") || 0
        if(currentCollectionIndex < 0 && !settings.allGames){
            currentCollectionIndex = 0
            games.currentIndex = 0
        }
        bg = getAssets(search.currentGame().assets).bg


        games.positionViewAtIndex(games.currentIndex, GridView.End)
        resetFocus(game_layout)
        screensaver.reset()

        if(settings.enableDevTools)
            log(settings.details)

        audio.stopAll()
        audio.home.play()

    }

    Loader { //settings_loader
        id: settings_loader
        sourceComponent: settings_component
    }

    Component { //settings_component
        id: settings_component
        Settings{}
    }
    property Item settings: settings_loader.item

    Loader { //colors_loader
        id: colors_loader
        sourceComponent: colors_component
    }

    Component { //settings_component
        id: colors_component
        Colors{}
    }
    property Item colors: colors_loader.item

    Keys.onPressed: { //Keys
        screensaver.reset()
        let key = gsk(event)
        if(isNaN(key)){
            if(key != undefined){
                switch (key){
                    case "up":
                        if(f.onUp)
                            f.onUp()
                        break
                    case "down":
                        if(f.onDown)
                            f.onDown()
                        break
                    case "left":
                        if(f.onLeft)
                            f.onLeft()
                        break
                    case "right":
                        if(f.onRight)
                            f.onRight()
                        break
                    case "prev":
                        if(f.onPrevious){
                            f.onPrevious()
                        }else{
                            s = audio.toggle_down
                            collectionPrevious()
                        }
                        break
                    case "next":
                        if(f.onNext){
                            f.onNext()
                        }else{
                            s = audio.toggle_down
                            collectionNext()
                        }
                        break
                    case "first":
                        if(f.onFirst)
                            f.onFirst()
                        break
                    case "last":
                        if(f.onLast)
                            f.onLast()
                        break
                    case "details":
                        s = audio.toggle_down
                        if(f.onDetails){
                            f.onDetails()
                        }else{
                            if(!panel_area.focus){
                                panel_area.open()
                                resetFocus(panel_area)
                            }
                        }
                        break
                    case "sort":
                        s = audio.toggle_down
                        if(f.onSort){
                            f.onSort()
                        }else{
                            if(f != sortfilt_menu)
                                resetFocus(sortfilt_menu)
                            else
                                resetFocus()
                        }
                        break
                    case "cancel":
                        if(f.onCancel){
                            f.onCancel()
                            event.accepted = true
                        }
                        break
                    case "accept":
                        if(f.onAccept){
                            if(f === osk)
                                f.onAccept()
                            else
                                if(!event.isAutoRepeat)
                                    f.onAccept()
                        }else{
                            if(!event.isAutoRepeat)
                                launchGame()
                        }
                        break
                    default:
                        break
                }
            }
        }else{
            if(
                header.focus ||
                collection_menu.focus ||
                game_layout.focus
            ){
                if(key == 0) {
                    currentCollectionIndex = settings.allGames ? 8 : 9
                } else {
                    currentCollectionIndex = settings.allGames ? key - 2 : key - 1
                }
                collection_menu.positionViewAtCurrentIndex()
                s = audio.toggle_down
                genreFilter = []
                sortfilt_menu.genre_list.model.populateModel()
                sortfilt_menu.genre_list.resetActive()
                sortfilt_toolbar.genres_model.populateModel()
            }
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }

    focus: true
}
