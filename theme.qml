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

// Thank you to PlayingKarrde creator of clearOS <https://github.com/PlayingKarrde/clearOS>
// for the search logic and all games collection


// Changelogs

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
// 2. Add collection selection list from collection logo
// 3. Rework info panel
// --------------------------------------------------------------------------------------------

import QtQuick 2.0
import QtMultimedia 5.9
import "template"
import "template/extras"

import "utils.js" as U
import "controls/GameViewControls.js" as GV_controls
import "controls/HeaderControls.js" as HEADER_controls

FocusScope {
    id: root

   	FontLoader { id: regular; source: settings.fontFamilyRegular }
   	FontLoader { id: bold; source: settings.fontFamilyBold }

    property bool loadTimeout: false

    property int currentCollectionIndex: 4
    property var currentCollection: U.getCollection(currentCollectionIndex)
    property var currentGame: currentCollection.games.get(games.gameView.currentIndex)
    property string currentBG: U.getAsset(currentGame, currentGame.assets, "bg")
    property bool mouseSelect: false
    property int allGames: settings.allGames ? -1 : 0

//--Settings--Customize these to your liking. Now found in template/Settings. Default settings: <https://github.com/strucep/struceOS-Pegasus-Theme?tab=readme-ov-file#customizable-settings> --//
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
    currentBG = U.getAsset(currentGame, currentGame.assets, "bg")
    loadTimeout = true
    home.play()
    games.gameView.focus = true
    U.clog("struceOS v" + settings.version + (settings.working ? "-working" : ""))
}

//--Custom controls--//
    Keys.onPressed: {

        //--Dev Keys--//
        //--END Dev Keys--//

        //--START Collection Quick Change
        if(event.key != Qt.Key_A && event.key != Qt.Key_D){
            if (api.keys.isNextPage(event) || api.keys.isPrevPage(event)) {
                GV_controls.changeCollection(event, currentCollectionIndex)
            }
        }
        //--END Collection Quick Change

        //--START gameView Controls
            if(games.gameView.focus){
                //Up
                if(
                    event.key == Qt.Key_W || 
                    event.key == Qt.Key_Up
                ){
                    GV_controls.up()
                }
                //Down
                if(
                    event.key == Qt.Key_S || 
                    event.key == Qt.Key_Down
                ){
                    GV_controls.down()
                }
                //left
                if(
                    event.key == Qt.Key_A || 
                    event.key == Qt.Key_Left
                ){
                    GV_controls.left()
                }
                //Right
                if(
                    event.key == Qt.Key_D || 
                    event.key == Qt.Key_Right
                ){
                    GV_controls.right()
                }
                //First
                if(api.keys.isPageUp(event)){
                    GV_controls.first()
                }
                //Last
                if(api.keys.isPageDown(event)){
                    GV_controls.last()
                }
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
                }
            }
        //--END header controls

        //--START searchbox Controls
            if(header.searchTerm.focus){
                if ((api.keys.isCancel(event) && !event.isAutoRepeat) || event.key == Qt.Key_Down ) {
                    event.accepted = true;
                    if(header.searchTerm.text != ""){
                        U.toggleSearch("gameView")
                    } else {
                        header.lastFocus = header.utilitiesSearch
                        header.utilitiesSearch.selected = true
                        U.toggleSearch("header")
                    }
                }
            }
        //--END searchbox controls

        //Open/close info panel with button press
        if(api.keys.isDetails(event)){
            U.toggleInfo()
        }

        if(info.focus){
                if (api.keys.isCancel(event) && !event.isAutoRepeat){
                    U.toggleInfo()
                    event.accepted = true
                }
        }

        //Video controls
        if(api.keys.isFilters(event) && info.state === "opened"){
            if(event.key != Qt.Key_F){
                if(info.state === "opened"){
                    info.video.muted ? info.video.muted = false : info.video.muted = true
                    select.play()
                }
            }
        }

        if(event.key === Qt.Key_M && info.state === "opened"){
            info.video.muted ? info.video.muted = false : info.video.muted = true
            select.play()
        }

        if(event.key === Qt.Key_Space && info.state === "opened"){
            info.video.playbackState === MediaPlayer.PlayingState ? info.video.pause() : info.video.play()
            toggle.play()
        }
    }
//

//--Custom Functions--//

    //Main update function for when a game is selected. Triggered from bgFadeOut and Component.onCompleted
    function updateGame(){
        if (currentGame.assets.video === ""){
            videoWrapper.height = vpx(0)
            videoWrapper.anchors.topMargin = vpx(0)
        } else {
            videoWrapper.height = videoWrapper.width / 1.778
            videoWrapper.anchors.topMargin = vpx(12)
        }

        videoPreview.stop()
        if(info.state == "opened")
            videoPreview.play();

        if (currentGame.assets.logo === ""){
            gameLogoWrapper.height = vpx(60)
        } else {
            gameLogoWrapper.height = vpx(100)
        }

        if (currentGame.developer === "" && currentGame.publisher === ""){
            gameDeveloper.height = vpx(0)
        } else {
            gameDeveloper.height = vpx(36)
        }
    }
//

//--Audio--//
    MediaPlayer {
		id: select
		source: "assets/sounds/select.wav"
		volume: 1
		loops : 1
	}

    MediaPlayer {
		id: toggle
		source: "assets/sounds/toggle.wav"
		volume: 1
		loops : 1
	}

    MediaPlayer {
		id: home
		source: "assets/sounds/home.wav"
		volume: 1
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

//--Info Close Button--//
    Rectangle {

        id: closeInfo

        anchors{
            fill: parent
            topMargin: parent.parent.height
        }

        color: "transparent"

        states: State {
            name: "opened"
            PropertyChanges { target: closeInfo; anchors.topMargin: 0 }
        }

        MouseArea{

            anchors.fill: parent

            onClicked: {
                U.toggleInfo()
            }

        }
    }
//

//--Info Panel--//
    InfoPanel {
        id: info
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
                color: "white"
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
        color: "lightblue"
        visible: testButtonMouse.enabled

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: vpx(12)
        }

        states: [
            State{
                name: "hovered"
                PropertyChanges{target: testButton; color: "black"}
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

                api.memory.unset("struceOS_background_overlayOpacity")
                select.play()
                U.clog("--dev button clicked--")
                mouse.event = accepted
            }
        }
    }
//
    focus: true
}
