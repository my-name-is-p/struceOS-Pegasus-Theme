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


import QtQuick 2.0
import QtMultimedia 5.9

FocusScope {

    id: root

   	FontLoader { id: regular; source: settings.fontFamilyRegular }
   	FontLoader { id: bold; source: settings.fontFamilyBold }

    property int currentCollectionIndex: 0
    property var currentCollection: api.collections.get(currentCollectionIndex)
    property var currentGame: gameView.model.get(gameView.currentIndex)

//--Settings--Customize these to your liking. I would suggest backing up  this file before editing in case of issues.--//
    Item {

        id: settings

        //gameView Settings
        property int columns: 4                                             //Number of columns to display in gameView
        property var croppedThumbnails: ["windows"]                         //Array of game.shortName--banner images will be scaled to fill
        
        //Background Settings
        property bool bgOverlayOn: true                                     //Apply an overlay to the background
        property string bgOverlaySource: "assets/img/bg-gradient.png"       //Image source for the background overlay
        
        //Info Panel Settings
        property string fontFamilyRegular: 
            "assets/fonts/M_PLUS_Rounded_1c/MPLUSRounded1c-Regular.ttf"     //Font to use in the info panel
        property string fontFamilyBold: 
            "assets/fonts/M_PLUS_Rounded_1c/MPLUSRounded1c-Bold.ttf"        //Font to use in the info panel
        property bool videoMute: true                                       //Mute video by default
        property real videoVolume: 0.40                                     //Video volume 

    }
//---------------------------------------------------------------------------------------------------------------------//

//--Run on loaded--//
    Component.onCompleted: {
        currentCollectionIndex = api.memory.get('collectionIndex')
        currentCollection = api.collections.get(currentCollectionIndex) || 0;
        gameView.currentIndex = api.memory.get('gameIndex') || 0;
        updateGame();
        home.play();
    }
//

//--Custom conrols--//
    Keys.onPressed: {

        //WASD controls game selection
            if (api.keys.isNextPage(event)) {
                if(event.key != Qt.Key_D){
                    next();
                }else{
                    gameView.currentIndex = gameView.currentIndex + 1 < gameView.count ? gameView.currentIndex + 1 : gameView.currentIndex
                }
            }
            
            if (api.keys.isPrevPage(event)) {
                if(event.key != Qt.Key_A){
                    prev();
                }else{
                    gameView.currentIndex = gameView.currentIndex - 1 >= 0 ? gameView.currentIndex - 1 : gameView.currentIndex
                }
            }

            if(event.key == Qt.Key_W){
                gameView.currentIndex = gameView.currentIndex - settings.columns >= 0 ? gameView.currentIndex - settings.columns : 0
            }

            if(event.key == Qt.Key_S){
                gameView.currentIndex = gameView.currentIndex + settings.columns < gameView.count ? gameView.currentIndex + settings.columns : gameView.count - 1
            }
        //--

        //Open/close info panel with button press
        if(api.keys.isDetails(event)){
            info.state == "opened" ? hideInfo() : showInfo()
        }

        //Video controls
        if(api.keys.isFilters(event) && info.state === "opened"){
            if(event.key != Qt.Key_F){
                videoPreview.muted ? videoPreview.muted = false : videoPreview.muted = true
                select.play()
            }
        }

        if(event.key === Qt.Key_M && info.state === "opened"){
            videoPreview.muted ? videoPreview.muted = false : videoPreview.muted = true
            select.play()
        }

        if(event.key === Qt.Key_Space && info.state === "opened"){
            videoPreview.playbackState === MediaPlayer.PlayingState ? videoPreview.pause() : videoPreview.play()
            toggle.play()
        }



    }
//

//--Custom Functions--//

    //Main update function for when a game is selected. Triggered from bgFadeOut and Component.onCompleted
    function updateGame(){

        backgroundGame.source = currentGame.assets.background

        bgFadeIn.start()

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

	function prev() {
        if (currentCollectionIndex <= 0)
            currentCollectionIndex = api.collections.count - 1;
        else
            currentCollectionIndex--;
        currentCollection = api.collections.get(currentCollectionIndex)
    }

    function next() {
        if (currentCollectionIndex >= api.collections.count - 1) { 
            currentCollectionIndex = 0;
        } else {
            currentCollectionIndex++;
        }
        currentCollection = api.collections.get(currentCollectionIndex)
    }

    function showInfo(){
        infoBtnHover.state = "hover"
        info.state = "opened" 
        closeInfo.state = "opened"
        videoPreview.play()
        toggle.play();
    }

    function hideInfo(){
        infoBtnHover.state = ""
        info.state = "" 
        closeInfo.state = ""
        videoPreview.stop()
        toggle.play();
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
    //Background Outer Wrapper
	Rectangle {

		id: background
		anchors.fill: parent

        color: "black"

        //Background of the currently selected game - pulled from currentGame.assets.background
        Image {

            id: backgroundGame
            source: currentGame.assets.background
            opacity: 1

            smooth: true
            antialiasing: true

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

            //Fade out for bg change
            NumberAnimation{
                
                id: bgFadeOut
                target: backgroundGame
                
                properties: "opacity"
                from: 1.0
                to: 0
                
                duration: 500

                //Prevents the image changing before fading out - triggers updateGame() - see: Line 60
                onRunningChanged: {
                    if(!bgFadeOut.running){
                        updateGame()
                    }
                }

            }

            //Fade in for bg change
            NumberAnimation{

                id: bgFadeIn
                target: backgroundGame

                properties: "opacity"
                from: 0
                to: 1.0

                duration: 500

            }

        }
        

        //Background Overlay
        Image {

            id: backgroundOverlay
            source: settings.bgOverlaySource
            opacity: 0.75

            smooth: true
            antialiasing: true

            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop

        }

	}
//

//--Collection Label--//
    Item {

        id: collectionsTitle

        anchors {

            top: parent.top
            topMargin: vpx(24)

            left: parent.left
            leftMargin: vpx(24)
            
            right: parent.right
            rightMargin: vpx(24)

        }

        height: vpx(48)

        //Collection Image
        Image {

            id: collectionImage
            source: "assets/logos/" + currentCollection.shortName + ".svg"

            asynchronous: true
            fillMode: Image.PreserveAspectFit

            height: parent.height

        }

    }
//

//--Info Button--//
    Rectangle {

        id: infoBtn
        color: "transparent"

        anchors{
            top: parent.top
            right: parent.right
            rightMargin: vpx(24)
            topMargin: vpx(24)
        }

        width: vpx(48)
        height: vpx(48)

        border.width: vpx(4)
        border.color: "white"

        radius: vpx(100)

        Rectangle {

            id: infoBtnHover

            color: "black"
            opacity: 0

            anchors.fill: parent

            radius: vpx(100)

            states: State {
                name: "hover"
                PropertyChanges { target: infoBtnHover; opacity: 1 }
            }

            transitions: Transition {
                NumberAnimation {
                    properties: "opacity"
                    duration: 250 
                    easing.type: Easing.EaseInOut
                }
            }

        }

        Text{

            anchors{
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            text: "i"
            font.pixelSize: vpx (36)
            font.bold: true

            color: "white"

        }

        //Trigger for Info button
        MouseArea{

            id: infoBtnTrigger

            hoverEnabled: true

            anchors.fill: parent

            onClicked: {
                showInfo()
            }

            onEntered: {
                infoBtnHover.state = "hover"
            }

            onExited: {
                if(info.state != "opened")
                    infoBtnHover.state = ""
            }

        }


    }
//    

//--gameView Wrapper--//
    Rectangle {
        id: games
        anchors.top: collectionsTitle.bottom

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.rightMargin: vpx(24)
        anchors.leftMargin: vpx(24)
        anchors.topMargin: vpx(24)

        color: "transparent"

        GridView {

            id: gameView
            delegate: gameThumb
            model: currentCollection.games

            anchors.fill: parent

            interactive: true
            focus: true
            clip: true

            cellWidth: parent.width / settings.columns
            cellHeight: cellWidth * 0.6

            keyNavigationWraps: false
            highlightMoveDuration: 100
            highlightFollowsCurrentItem: true

            onCurrentIndexChanged: {
                bgFadeOut.start()
                select.play()
                gameView.forceActiveFocus()
            }

        }


        //Game Thumbnail
        Component {

            id: gameThumb

            //Game Banner Wrapper
            Item {

                width: gameView.cellWidth
                height: gameView.cellHeight

                //Game Banner Image
                Image {

                    id: banner
                    source: assets.banner != "" ? assets.banner : "assets/img/none.jpg"
                    opacity: 0

                    smooth: true
                    asynchronous: true

                    anchors{
                        fill: parent
                        margins: vpx(12)
                    }

                    fillMode: settings.croppedThumbnails.includes(currentCollection.shortName) ? Image.PreserveAspectCrop:Image.PreserveAspectFit
                    
                    scale: parent.activeFocus ? 1.03 : 1
                    Behavior on scale {NumberAnimation {duration: 100}}

                    onStatusChanged: {
                        if (banner.status === Image.Ready) { 
                            banner.state = "bannerLoaded"
                        }
                    }

                    states: State {
                        name: "bannerLoaded"
                        PropertyChanges { target: banner; opacity: 1 }
                    }

                    transitions: Transition {
                        NumberAnimation { 
                            properties: "opacity"
                            duration: 1000
                            easing.type: Easing.EaseInOut
                        }
                    }

                    //Highlight selected game
                    Rectangle {

                        id: border
                        color: "transparent"

                        anchors{
                            fill: parent
                            margins: vpx(-6)
                        }

                        border.color: Qt.hsla(1,1,1,0.6)
                        border.width: parent.parent.activeFocus ? vpx(6) : vpx(0)

                        radius: vpx(3)
                    }
                }

                //Loading Image
                Image {

                    source: "assets/img/loading.png"
                    visible: banner.status === Image.Loading

                    anchors.centerIn: parent

                    NumberAnimation on rotation {

                        from: 0
                        to: 360

                        duration: 1000

                        loops: Animation.Infinite

                    }

                }

                // Launch Game on Accept input
                Keys.onPressed: {
                    if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                        event.accepted = true;
                        currentGame.launch()
                        api.memory.set('collectionIndex', currentCollectionIndex)
                        api.memory.set('gameIndex', gameView.currentIndex)
                    }
                }
                
                // Select/launch game with mouse
                MouseArea {
                    id: gameClick

                    anchors.fill: parent
                    onClicked: {
                        gameView.currentIndex = index
                    }

                    onDoubleClicked: {
                        currentGame.launch()
                        api.memory.set('collectionIndex', currentCollectionIndex)
                        api.memory.set('gameIndex', gameView.currentIndex)
                    }

                }
            }
        }
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
                hideInfo()
            }

        }

    }
//

//--Info Panel--//
    //Outer Wrapper
    Rectangle{

        id: info

        color: Qt.hsla(0,0,0,0.45)

        anchors {

            top: parent.top

            left: parent.left
            leftMargin: parent.width

            bottom: parent.bottom

        }

        width: parent.width * 0.5

        states: State {
            name: "opened"
            PropertyChanges { target: info; anchors.leftMargin: parent.width * 0.5 }
        }

        transitions: Transition{
            NumberAnimation { 
                properties: "anchors.leftMargin"
                duration: 250 
                easing.type: Easing.EaseInOut
            }
        }

        //Prevents clicking the panel from closing the panel
        MouseArea{

            anchors.fill: parent

            onClicked: {
                mouse.accepted = true
            }

        }

        //Video Wrapper
        Rectangle{

            id: videoWrapper

            color: "transparent"

            anchors{

                top: parent.top
                topMargin: vpx(12)

                left: parent.left
                leftMargin: vpx(48)

                right: parent.right
                rightMargin: vpx(48)

            }
            
            height: videoWrapper.width / 1.778

            //Game Video
            Video{

                id: videoPreview
                source: currentGame.assets.video

                fillMode: VideoOutput.PreserveAspectCrop
                anchors.fill: parent

                muted: settings.videoMute
                volume: settings.videoVolume
                loops: MediaPlayer.Infinite

            }

            Image {

                source: "assets/img/loading.png"
                visible: videoPreview.status === MediaPlayer.Loading

                anchors.centerIn: parent

                NumberAnimation on rotation {

                    from: 0
                    to: 360

                    duration: 1000

                    loops: Animation.Infinite

                }

            }

            //Allow pausing and playing by clicking video
            MouseArea {
                id:videoControls

                anchors.fill: parent

                hoverEnabled: true

                onClicked: {
                    videoPreview.playbackState === MediaPlayer.PlayingState ? videoPreview.pause() : videoPreview.play()
                    toggle.play()
                }

                onEntered: {
                    videoSound.state = "videoHovered"
                    muteIcon.state = "videoHovered"
                }

                onExited: {
                    videoSound.state = ""
                    muteIcon.state = ""
                }
            }

            //Mute button
            MouseArea {
                id: videoSound
                enabled: false

                
                anchors {
                    bottom: parent.bottom
                    bottomMargin: vpx(12)

                    right: parent.right
                    rightMargin: vpx(12)
                }

                height: vpx(24)
                width: vpx(24)


                states: State {
                    name: "videoHovered"
                    PropertyChanges { 
                        target: videoSound;
                        enabled: true 
                    }
                }

                onClicked: {
                    videoPreview.muted ? videoPreview.muted = false : videoPreview.muted = true
                    mouse.accepted = true
                    select.play()
                }

                Image {
                    id: muteIcon
                    source: videoPreview.muted ? "assets/img/mute.png" : "assets/img/sound.png"
                    anchors.fill: parent

                    opacity: 0

                    states: State {
                        name: "videoHovered"
                        PropertyChanges { 
                            target: muteIcon;
                            opacity: 1 
                        }
                    }

                    transitions: Transition {
                        NumberAnimation {
                            properties: "opacity"
                            duration: 250 
                            easing.type: Easing.EaseInOut
                        }
                    }
                }
            }
        }

        //Info Text Wrapper
        Rectangle{
            
            id: gameInfo

            color: Qt.hsla(0,0,0,0.65)

            anchors{

                top: videoWrapper.bottom
                topMargin: vpx(12)

                left: parent.left
                leftMargin: vpx(12)

                right: parent.right
                rightMargin: vpx(12)

                bottom: parent.bottom
                bottomMargin: vpx(12)

            }

            //Game Logo Wrapper
            Item{
                
                id: gameLogoWrapper

                height: vpx(100)
                
                anchors{

                    top: parent.top
                    topMargin: vpx(6)

                    left: parent.left
                    leftMargin: vpx(6)

                    right: parent.right
                    rightMargin: vpx(6)

                }

                clip: true

                //Game Logo
                Image{

                    id: gameLogo
                    source: currentGame.assets.logo

                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit

                }

                Text {
                    id: gameTitle
                    anchors.fill: parent

                    visible: currentGame.assets.logo === ""

                    text: currentGame.title
                    color: "white"

                    font.pixelSize: vpx(48)
                    font.family: bold.name

                    horizontalAlignment: Text.AlignHCenter

                    elide: Text.ElideRight
                }
            }

            //Game Developer Textbox
            Text{

                id: gameDeveloper

                anchors{

                    top: gameLogoWrapper.bottom
                    topMargin: vpx(6)

                    left: parent.left
                    leftMargin: vpx(12)

                    right: parent.right
                    rightMargin: vpx(12)

                }

                height: vpx(36)

                text: if(currentGame.developer != "" ) {
                    if (currentGame.publisher != "" && currentGame.publisher != currentGame.developer){
                        currentGame.developer + " / " + currentGame.publisher
                    } else {
                        currentGame.developer
                    }
                } else { 
                    if(currentGame.publisher != ""){
                        currentGame.publisher
                    } else {
                        ""
                    }
                }
                
                font.family: bold.name
                font.pixelSize: vpx(24)

                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                
                color: "white"
                
                elide: Text.ElideRight

            }

            //Game Description Textbox
            Text{

                id: gameDescription

                anchors{

                    top: gameDeveloper.bottom
                    topMargin: vpx(6)

                    left: parent.left
                    leftMargin: vpx(12)

                    right: parent.right
                    rightMargin: vpx(12)

                    bottom: parent.bottom
                    bottomMargin: vpx(12)

                }

                text: currentGame.description != "" ? currentGame.description : "No information to display..."
                
                font.family: regular.name
                font.pixelSize: vpx(20)
                font.italic: currentGame.description != "" ? false : true
                
                verticalAlignment: Text.AlignTop
                
                color: "white"
                
                wrapMode: Text.WordWrap
                elide: Text.ElideRight

            }

        }
    }
//

//--Easy Logging--//
    Text{
        id: consoleLog
    }
//

    focus: true
}

