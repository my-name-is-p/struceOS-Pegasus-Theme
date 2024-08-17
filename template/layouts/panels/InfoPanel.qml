// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

import "parts-info"
import "../../widgets"

Item {
    id: panel
    anchors.fill: parent
    anchors.margins: vpx(24)

    property Item current: panel

    //Functions
        function activate(){
            if(current === panel)
                current = launch
        }

        function closePanel(){
                current = panel
                video.reset()
                resetFocus()
        }

        property var onUp: current != panel ? current.onUp : activate
        property var onDown: current != panel ? current.onDown : activate
        property var onLeft: current != panel ? current.onLeft : activate
        property var onRight: current != panel ? current.onRight : activate

        function onPrevious(){
            if(current != panel){
                if(!current.onPrevious){
                    games.moveCurrentIndexLeft()
                    video.reset()
                    if(video.status === MediaPlayer.NoMedia && current === video_player){
                        video_player.current = video_player
                        current = launch
                    }
                }else{
                    current.onPrevious()
                }
            }else{
                games.moveCurrentIndexLeft()
                video.reset()
            }
        }

        function onNext(){
            if(current != panel){
                if(current != panel && !current.onNext){
                    games.moveCurrentIndexRight()
                    video.reset()
                    if(video.status === MediaPlayer.NoMedia && current === video_player){
                        video_player.current = video_player
                        current = launch
                    }
                }else{
                    current.onNext()
                }
            }else{
                games.moveCurrentIndexRight()
                video.reset()
            }
        }

        function onFirst(){
            if(current != panel){
                if(!current.onFirst){
                    games.currentIndex = 0
                    video.reset()
                    if(video.status === MediaPlayer.NoMedia && current === video_player){
                        video_player.current = video_player
                        current = launch
                    }
                }else{
                    current.onFirst()
                }
            }else{
                games.currentIndex = 0
                video.reset()
            }
        }

        function onLast(){
            if(current != panel){
                if(!current.onLast){
                    games.currentIndex = games.count - 1
                    video.reset()
                    if(video.status === MediaPlayer.NoMedia && current === video_player){
                        video_player.current = video_player
                        current = launch
                    }
                }else{
                    current.onLast()
                }
            }else{
                games.currentIndex = games.count - 1
                video.reset()
            }
        }

        function onSort(){
            currentGame.favorite = !currentGame.favorite
            search.populateModel()
        }

        property var onCancel: current != panel && current.onCancel ? current.onCancel : closePanel
        property var onDetails: closePanel
        property var onAccept: current.onAccept ? current.onAccept : launchGame
    //--

    Item {  //header_buttons
        id: header_buttons
        
        anchors.top: parent.top
        anchors.topMargin: vpx(-12)
        anchors.left: parent.left
        anchors.right: parent.right

        height: vpx(48)

        CloseButton { //close
            id: close

            sound: audio.toggle_down
            selected: panel.current === this

            function onAccept(){
                panel.onCancel()
            }
            onClicked: panel.closePanel

            function onRight(){
                panel.current = favorite
            }

            function onDown(){
                panel.current = video.status != MediaPlayer.NoMedia ? video_player : launch
            }
        }

        UIButton { //favorite
            id: favorite
            anchors.right: parent.right

            icon: currentGame.favorite ? images.favorite_icon_filled : images.favorite_icon_empty
            sound: audio.toggle_down
            
            selected: panel.current === this

            onClicked: function(){
                currentGame.favorite = !currentGame.favorite
                search.populateModel()
            }

            function onAccept(){
                onClicked()
                s = audio.toggle_down
            }

            function onLeft(){
                panel.current = close
            }

            function onDown(){
                panel.current = video_player
            }
        }
    }

    Item {  //content
        id: content

        anchors.top: header_buttons.bottom
        anchors.topMargin: vpx(12)
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        Item { //left_panel
            id: left_panel
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * (9 / 16)

            Item { //gallery
                id: gallery

                anchors.centerIn: parent

                width: parent.width
                height: video_player.height + launch.height + launch.anchors.topMargin

                VideoPlayer { //video_player
                    id: video_player

                    width: gallery.width
                    height: { //height
                        if(gallery.height > left_panel.height){
                            let r = left_panel.height - launch.height - launch.anchors.topMargin
                            return r
                        }else{
                            return width / 1.778
                        }
                    }

                    selected: panel.current === this

                    function onCancel(){
                        if(video_player.current != video_player && current.onCancel)
                            current.onCancel()
                        else if(video_player.current != video_player)
                            video_player.current = video_player
                        else
                            panel.closePanel()
                    }

                    function onUp(){
                        if(video_player.current != video_player && current.onUp)
                            current.onUp()
                        else if(video_player.current != video_player)
                            video_player.current = video_player
                        else
                            panel.current = close
                    }

                    function onDown(){
                        if(video_player.current != video_player && current.onDown)
                            current.onDown()
                        else if(video_player.current != video_player)
                            video_player.current = video_player
                        else
                            panel.current = launch
                    }

                    function onLeft(){
                        if(video_player.current != video_player && current.onLeft)
                            current.onLeft() 
                    }

                    function onRight(){
                        if(video_player.current != video_player && current.onRight)
                            current.onRight() 
                        else if(video_player.current === video_player)
                            panel.current = favorite
                    }
                }

                LaunchButton { //launch
                    id: launch

                    anchors.top: video_player.bottom
                    anchors.topMargin: vpx(24)

                    selected: panel.current === this

                    function onRight(){
                        panel.current = favorite
                    }

                    function onUp(){
                        panel.current = video.status != MediaPlayer.NoMedia ? video_player : close
                    }

                    function onDown(){
                        panel.onCancel()
                        s = audio.toggle_down 
                    }
                }

                Details { //details
                    id: details

                    anchors.top: launch.top
                    anchors.left: launch.right
                    anchors.right: parent.right
                    anchors.leftMargin: vpx(12)

                    height: launch.height
                }
            }

        }

        Item { //right_panel
            id: right_panel
            anchors.top: content.top
            anchors.bottom: content.bottom
            anchors.left: left_panel.right
            anchors.leftMargin: vpx(24)
            anchors.right: content.right

            Image { //logo
                id: logo
                source: getAssets(currentGame.assets).logo

                anchors.top: right_panel.top
                anchors.left: right_panel.left

                width: right_panel.width
                height: right_panel.width / 4

                fillMode: Image.PreserveAspectFit

                Text {  //game title backup
                    text: currentGame.title

                    anchors.centerIn: logo

                    width: logo.width

                    color: colors.text
                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(24)

                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter

                    visible: logo.status != Image.Ready
                }
            }

            Rating { //rating
                id: rating

                anchors.top: logo.bottom
                anchors.topMargin: vpx(6)
                anchors.left: right_panel.left
                anchors.right: right_panel.right
            }

            DeveloperPublisher { //developer_publisher
                id: developer_publisher

                anchors.top: rating.bottom
                anchors.topMargin: vpx(12)
                anchors.left: right_panel.left
                anchors.right: right_panel.right
            }

            Text { //summary
                id: summary
                text: currentGame.summary != "" ? 
                        currentGame.summary : 
                        currentGame.description != "" ? 
                            currentGame.description : 
                            "No description..."

                anchors.top: developer_publisher.bottom
                anchors.topMargin: vpx(12)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(14)

                wrapMode: Text.WordWrap
                elide: Text.ElideRight
            }
        }
    }

    property Video video: video_player.video
}