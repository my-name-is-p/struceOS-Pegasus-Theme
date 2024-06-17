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
// 2. Rework info panel
// --------------------------------------------------------------------------------------------

import QtQuick 2.0
import QtMultimedia 5.9
import "template"
import "template/extras"

import "utils.js" as U
import "controls/GameViewControls.js" as GV_controls
import "controls/HeaderControls.js" as HEADER_controls
import "controls/CollectionControls.js" as COLLECTION_controls
import "controls/InfoControls.js" as INFO_controls

FocusScope {
    id: root

   	FontLoader { id: regular; source: settings.fontFamilyRegular }
   	FontLoader { id: bold; source: settings.fontFamilyBold }

    //property bool loadTimeout: false

    property int currentCollectionIndex: 4
    property var currentCollection: U.getCollection(currentCollectionIndex)
    property var currentGame: search.currentGame(games.gameView.currentIndex)
    property string currentBG
    property bool mouseSelect: false
    property int allGames: settings.allGames ? -1 : 0

//--Settings--Customize these to your liking. Now found in template/Settings.qml. Default settings: <https://github.com/strucep/struceOS-Pegasus-Theme?tab=readme-ov-file#customizable-settings> --//
Settings {
    id: settings
}
//---------------------------------------------------------------------------------------------------------------------//

Search {
    id: search
}

//--Run on loaded--//
Component.onCompleted: {
    currentCollectionIndex = 
        api.memory.get("collectionIndex") != undefined ? 
        api.memory.get("collectionIndex") : 
        0;
    currentCollection = U.getCollection(currentCollectionIndex) || 0
    games.gameView.currentIndex = api.memory.get("gameIndex") || 0
    games.gameView.focus = true
    collectionsView.collectionView_list.currentItem.currentIndex = settings.allGames ? currentCollectionIndex + 1 : currentCollectionIndex
    currentBG = U.getAssets(currentGame.assets).bg
    home.play()
    U.clog("struceOS v" + settings.version + (settings.working ? "-working" : ""))
}

//--Custom controls--//
    Keys.onPressed: {
        //--Dev Keys--//
        //--END Dev Keys--//
        if(games.gameView.focus || header.focus || collectionsView.collectionView_list.focus){
        //--START Collection Quick Change
            if(event.key != Qt.Key_A && event.key != Qt.Key_D){
                if (api.keys.isNextPage(event) || api.keys.isPrevPage(event)) {
                    COLLECTION_controls.changeCollection(event, currentCollectionIndex)
                }
            }
        //--END Collection Quick Change
        }

        //--START gameView Controls
            if(games.gameView.focus){
                let sound = null
                //Up
                if(
                    event.key == Qt.Key_W || 
                    event.key == Qt.Key_Up
                ){
                    sound = games.gameView.currentIndex + 1 - settings.columns > 0 ? select : toggle_up
                    GV_controls.up()
                }
                //Down
                if(
                    event.key == Qt.Key_S || 
                    event.key == Qt.Key_Down
                ){
                    sound = select
                    GV_controls.down()
                }
                //left
                if(
                    event.key == Qt.Key_A || 
                    event.key == Qt.Key_Left
                ){
                    sound = select
                    GV_controls.left()
                }
                //Right
                if(
                    event.key == Qt.Key_D || 
                    event.key == Qt.Key_Right
                ){
                    sound = select
                    GV_controls.right()
                }
                //First
                if(api.keys.isPageUp(event)){
                    sound = select
                    GV_controls.first()
                }
                //Last
                if(api.keys.isPageDown(event)){
                    sound = select
                    GV_controls.last()
                }

                if(api.keys.isFilters(event)){
                    currentGame.favorite = !currentGame.favorite
                    sound = toggle_up
                }
                if(sound != null)
                    sound.play()
            }
        //--END gameView Controls

        //--START header Controls
            if(header.focus){
                //Down
                if(event.key == Qt.Key_S || event.key == Qt.Key_Down){
                    HEADER_controls.down()
                }
                //Left
                if(event.key == Qt.Key_A || event.key == Qt.Key_Left){
                    HEADER_controls.left()
                }
                //Right
                if(event.key == Qt.Key_D || event.key == Qt.Key_Right){
                    HEADER_controls.right()
                }
                //Accept
                if ((api.keys.isAccept(event) && !event.isAutoRepeat) || event.key == Qt.Key_Space) {
                    HEADER_controls.accept()
                    event.accepted = true
                }
            }
        //--END header controls

        //--START searchbox Controls
            if(header.searchTerm.focus){
                if ((api.keys.isCancel(event) && !event.isAutoRepeat) || event.key == Qt.Key_Down ) {
                    event.accepted = true;
                    U.focusToggle()
                }
            }
        //--END searchbox controls
        
        //--START settings panel controls--//
            if(settingsPanel.focus){
                if (api.keys.isCancel(event) && !event.isAutoRepeat){
                    U.focusToggle()
                    event.accepted = true
                }
            }
        //--END settings panel controls--//

        //--START collections panel controls--//
            if(collectionsView.collectionView_list.focus){
                //down
                if(
                    event.key == Qt.Key_S || 
                    event.key == Qt.Key_Down
                ){
                    COLLECTION_controls.down()
                    select.play()
                }
                //up
                if(
                    event.key == Qt.Key_W || 
                    event.key == Qt.Key_Up
                ){
                    COLLECTION_controls.up()
                    select.play()
                }
                //Left
                if(event.key == Qt.Key_A || event.key == Qt.Key_Left){
                    COLLECTION_controls.left()
                    select.play()
                }
                //Right
                if(event.key == Qt.Key_D || event.key == Qt.Key_Right){
                    COLLECTION_controls.right()
                    select.play()
                }
                //accept
                if (
                    ((api.keys.isAccept(event) && 
                    !event.isAutoRepeat) || 
                    event.key == Qt.Key_Space) && 
                    event.accepted != true
                ){
                    COLLECTION_controls.accept()
                    collectionsView.currentItem.currentIndex = 0
                    event.accepted = true
                }
                if (api.keys.isCancel(event) && !event.isAutoRepeat){
                    U.focusToggle()
                    collectionsView.currentItem.currentIndex = 0
                    event.accepted = true
                }
            }
        //--END collections panel controls--//

        //Open/close info panel with button press
        if(api.keys.isDetails(event)){
            if(info.state != "opened"){
                U.focusToggle("info")
            } else {
                U.focusToggle()
            }
        }
        //--START info panel controls--//
            if(info.focus){
                //Up
                if(
                    event.key == Qt.Key_W || 
                    event.key == Qt.Key_Up
                ){
                    INFO_controls.up()
                }

                //Down
                if(
                    event.key == Qt.Key_S || 
                    event.key == Qt.Key_Down
                ){
                    INFO_controls.down()
                }

                //left
                if(
                    event.key == Qt.Key_A || 
                    event.key == Qt.Key_Left
                ){
                    INFO_controls.left()
                }

                //Right
                if(
                    event.key == Qt.Key_D || 
                    event.key == Qt.Key_Right
                ){
                    INFO_controls.right()
                }

                if (
                    ((api.keys.isAccept(event) && 
                    !event.isAutoRepeat) || 
                    event.key == Qt.Key_Space) && 
                    event.accepted != true
                ){
                    INFO_controls.accept()
                    event.accepted = true
                }

                if(api.keys.isFilters(event)){
                    currentGame.favorite = !currentGame.favorite
                    toggle_up.play()
                }

                if (api.keys.isCancel(event) && !event.isAutoRepeat){
                    U.focusToggle()
                    event.accepted = true
                }
            }
        //--END info panel controls--//
    }
//

//--Audio--//
    MediaPlayer {
		id: select
		source: "assets/sounds/lc.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}

    MediaPlayer {
		id: toggle_up
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

//--Background--//
    Background {
        id: background
    }
//

//--Header--//
    Header {
        id: header
    }
//

//--GameLayout--//
    GameLayout{
        id: games
        //visible: false
    }
//

//--Info Panel--//
    InfoPanel {
        id: info
    }
//

//--CollectionsView--//
    CollectionsView{
        id: collectionsView
    }
//

//-- Settings Panel--//
    SettingsPanel{
        id: settingsPanel
    }
//

//--Dev Tools--//
    Rectangle{
        width: parent.width / 3
        visible: settings.enableDevTools
        anchors{
            top: parent.top
            right: parent.right
            bottom: testButton.top
            bottomMargin: vpx(12)
        }

        color: Qt.rgba (0,0,0, settings.consoleLogBackground)

        clip: true

        Item{
                anchors.fill: parent
                anchors.margins: vpx(12)
                clip: true
            TextEdit{
                id: consoleLog
                color: settings.colors.white
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                wrapMode: TextEdit.WordWrap
            }
        }
    }


    Rectangle {
        id: testButton
        height: vpx(48)
        width: vpx(48)
        radius: vpx(48)
        color: settings.colors.white
        visible: testButtonMouse.enabled

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: vpx(12)
        }

        states: [
            State{
                name: "hovered"
                PropertyChanges{target: testButton; color: settings.colors.black}
            }
        ]

        MouseArea {
            id: testButtonMouse
            enabled: settings.enableDevTools
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                testButton.state = "hovered"
            }

            onExited: {
                testButton.state = ""
            }

            onClicked: {
                select.play()
                U.clog("--dev button clicked--")
                mouse.event = accepted
            }
        }
    }
//
    focus: true
}
