// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15


import "../../widgets"

Item {
    id: panel
    anchors.fill: parent
    anchors.margins: vpx(24)

    property Item current: panel

    Item {  //header_buttons
        id: header_buttons
        anchors.top: parent.top
        anchors.topMargin: vpx(-12)
        anchors.left: parent.left
        anchors.right: parent.right

        height: vpx(48)

        CloseButton { //close
            id: close

            icon_color: p.text
            selected: panel.current === this

            onClicked: function(){
                panel.onCancel()
            }

            property var onAccept: function(){
                panel.onCancel()
                s = audio.toggle_down
            }

            
            property var onRight: function(){
                panel.current = favorite
            }

            property var onDown: function(){
                panel.current = video
            }

            property var onUp: function(){
                header.current = header.collection
                f = header
                panel.current = panel
            }
        }

        UIButton { //favorite
            id: favorite
            anchors.right: parent.right

            icon: currentGame.favorite ? images.favorite_icon_filled : images.favorite_icon_empty
            icon_color: p.text

            selected: panel.current === this

            onClicked: function(){
                currentGame.favorite = !currentGame.favorite
                search.populateModel()
            }

            property var onAccept: function(){
                onClicked()
                s = audio.toggle_down
            }

            property var onLeft: function(){
                panel.current = close
            }

            property var onDown: function(){
                panel.current = video
            }

            property var onUp: function(){
                header.current = header.search_button
                f = header
                panel.current = panel
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

        Item { //gallery_wrapper
            id: gallery_wrapper
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * (9 / 16)

            Item { //gallery
                id: gallery

                width: parent.width
                height: video.height + launch.height + launch.anchors.topMargin

                anchors.centerIn: parent

                VideoPlayer { //video
                    id: video

                    width: gallery.width

                    height: {
                        if(gallery.height > gallery_wrapper.height){
                            let r = gallery_wrapper.height - launch.height - launch.anchors.topMargin
                            return r
                        }else{
                            return width / 1.778
                        }
                    }

                    selected: panel.current === this
                    
                    property var onAccept: function(){
                        video.current = enter
                        panel.Keys.forwardTo = this
                    }

                    property var onCancel: function(){
                        if(video.current != this){
                            video.current = this
                            panel.Keys.forwardTo = panel
                        }else{
                            panel.onCancel()
                        }
                    }


                    property var onUp: function(){
                        panel.current = close
                    }

                    property var onDown: function(){
                        panel.current = launch
                    }

                    property var onRight: function(){
                        panel.current = favorite
                    }
                }

                LaunchButton { //launch
                    id: launch

                    anchors.top: video.bottom
                    anchors.topMargin: vpx(24)

                    selected: panel.current === this

                    property var onRight: function(){
                        panel.current = favorite
                    }

                    property var onUp: function(){
                        panel.current = video
                    }

                    property var onDown: function(){
                        panel.onCancel()
                        s = audio.toggle_down 
                    }
                }

                Item { //details
                    id: details
                    height: launch.height
                    anchors.top: launch.top
                    anchors.left: launch.right
                    anchors.right: parent.right
                    anchors.leftMargin: vpx(12)

                    clip: true

                    Rectangle { //released_detail
                        id: released_detail

                        anchors.verticalCenter: parent.verticalCenter

                        visible: currentGame.releaseYear != 0
                        width: visible ? released_label.contentWidth : 0

                        Text {
                            id: released_label
                            text: "released: " + currentGame.releaseYear
                            font.family: regular.name
                            font.pixelSize: vpx(14)
                            color: p.text

                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle { //players_detail
                        id: players_detail

                        anchors.verticalCenter: parent.verticalCenter

                        anchors.left: released_detail.right
                        anchors.leftMargin: vpx(12)

                        visible: currentGame.players > 0
                        width: !visible ? 0 : players_label.contentWidth + players_icon.width + players_icon.anchors.leftMargin

                        Text { //players_label
                            id: players_label
                            text: "players:"
                            font.family: regular.name
                            font.pixelSize: vpx(14)
                            color: p.text

                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image { //players_icon
                            id: players_icon
                            width: 16 * Math.min(currentGame.players, 5)
                            height: 16

                            source: images.players
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: players_label.right
                            anchors.leftMargin: vpx(6)

                            fillMode: Image.PreserveAspectCrop
                            horizontalAlignment: Image.AlignLeft
                        }
                    }

                    Rectangle { //genres_detail
                        id: genres_detail

                        anchors.verticalCenter: parent.verticalCenter

                        anchors.left: players_detail.right
                        anchors.leftMargin: vpx(12)

                        visible: currentGame.genre != ""
                        width: visible ? genres_label.contentWidth : 0

                        Text {
                            id: genres_label
                            text: "genres: " + currentGame.genre
                            font.family: regular.name
                            font.pixelSize: vpx(14)
                            color: p.text

                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }
                }
            }

        }

        Item { //text
            id: text
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: gallery_wrapper.right
            anchors.leftMargin: vpx(24)
            anchors.right: parent.right

            Image { //logo
                id: logo
                source: getAssets(currentGame.assets).logo
                fillMode: Image.PreserveAspectFit

                width: parent.width
                height: parent.width / 4

                anchors.top: parent.top
                anchors.left: parent.left

                Text {  //game title backup
                    text: currentGame.title
                    color: p.text
                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(24)
                    anchors.centerIn: parent
                    elide: Text.ElideRight
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter

                    wrapMode: Text.WordWrap

                    visible: logo.status != Image.Ready
                }
            }

            Item { //raiting
                id: rating
                anchors.top: logo.bottom
                anchors.topMargin: vpx(6)
                anchors.left: parent.left
                anchors.right: parent.right
                height: vpx(24)
                Item {
                    id: stars
                    width: vpx(144)
                    height: vpx(24)
                    anchors.horizontalCenter: parent.horizontalCenter

                    visible: false

                    Image { //empty
                        id: empty
                        source: images.stars_empty
                        fillMode: Image.PreserveAspectFit
                        
                        anchors.fill: parent
                    }

                    Image { //filled
                        id: filled
                        anchors.fill: empty
                        anchors.rightMargin: stars.width - (stars.width * currentGame.rating)
                        source: images.stars_filled
                        fillMode: Image.PreserveAspectCrop
                        horizontalAlignment: Image.AlignLeft
                    }
                }

                Rectangle { //stars_color
                    id: stars_color
                    anchors.fill: stars
                    color: p.text

                    visible: false
                }

                OpacityMask {
                    anchors.fill: stars
                    source: stars_color
                    maskSource: stars
                }
            }

            Rectangle { //developer
                id: developer

                anchors.top: rating.bottom
                anchors.topMargin: vpx(12)
                anchors.left: parent.left
                anchors.right: parent.right

                color: p.accent_light

                height: developer_text.height + vpx(24)

                Rectangle { //developer_color
                    id: developer_color
                    height: parent.height
                    anchors.right: parent.right
                    width: developer_text.contentWidth + vpx(48)
                    color: p.accent
                }

                Rectangle { //developer_decor
                    id: developer_decor

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: developer_color.left
                    anchors.left: parent.left

                    anchors.margins: vpx(2)
                    anchors.rightMargin: vpx(0)

                    color: p.t

                    border.width: vpx(4)
                    border.color: p.accent
                    
                }

                Text { //developer_text
                    id: developer_text
                    text: currentGame.developer
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: vpx(24)
                    anchors.leftMargin: vpx(12)
                    color: p.text

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(16)

                    elide: Text.ElideRight

                    horizontalAlignment: Text.AlignRight
                }

                Rectangle { //developer_border
                    id: developer_border
                    height: parent.height
                    width: parent.width

                    color: p.t

                    border.width: vpx(4)
                    border.color: p.accent_light
                }
            }

            Rectangle { //publisher
                id: publisher

                anchors.top: developer.bottom
                anchors.topMargin: vpx(-3)
                anchors.left: parent.left
                anchors.right: parent.right

                color: p.accent_light

                height: publisher_text.height + vpx(24)

                Rectangle {
                    id: publisher_color
                    height: parent.height
                    width: publisher_text.contentWidth + vpx(48)
                    color: p.accent
                }

                Rectangle {
                    id: publisher_decor

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: publisher_color.right
                    anchors.right: parent.right

                    anchors.margins: vpx(2)
                    anchors.leftMargin: vpx(0)

                    color: p.t

                    border.width: vpx(4)
                    border.color: p.accent
                    
                }

                Text {
                    id: publisher_text
                    text: currentGame.publisher
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: vpx(24)
                    anchors.rightMargin: vpx(12)
                    color: p.text

                    font.family: bold.name
                    font.bold: true
                    font.pixelSize: vpx(16)

                    elide: Text.ElideRight
                }

                Rectangle {
                    id: publisher_border
                    height: parent.height
                    width: parent.width

                    color: p.t

                    border.width: vpx(4)
                    border.color: p.accent_light
                }
            }

            Text { //summary
                id: summary
                text: currentGame.summary != "" ? 
                        currentGame.summary : 
                        currentGame.description != "" ? 
                            currentGame.description : 
                            "No description..."
                wrapMode: Text.WordWrap
                anchors.top: publisher.bottom
                anchors.topMargin: vpx(12)
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                font.family: regular.name
                font.pixelSize: vpx(14)
                elide: Text.ElideRight
                color: p.text
            }
        }
    }

    property var onCancel: function(){
        current = panel
        settings.videoMute = api.memory.get("struceOS_video_videoMute")
        video.video.stop()
        f = game_layout
    }

    property var onAccept: function(){
        launch_window.visible = true
        if(settings.lastPlayed){
            api.memory.set("collectionIndex", currentCollectionIndex)
            api.memory.set("gameIndex", games.currentIndex)
        }
        s = audio.toggle_down
        currentGame.launch()
    }

    property var onPrevious: function(){
        settings.videoMute = api.memory.get("struceOS_video_videoMute")
        games.moveCurrentIndexLeft()
        video.video.play()
    }

    property var onNext: function(){
        settings.videoMute = api.memory.get("struceOS_video_videoMute")
        games.moveCurrentIndexRight()
        video.video.play()
    }

    property var onFirst: function(){
        settings.videoMute = api.memory.get("struceOS_video_videoMute")
        games.currentIndex = 0
        video.video.play()
    }

    property var onLast: function(){
        settings.videoMute = api.memory.get("struceOS_video_videoMute")
        games.currentIndex = games.count - 1
        video.video.play()
    }

    Keys.onPressed: {
        let key = gsk(event)
        if(key != undefined){
            switch (key){
                case "up":
                    if(current.onUp != undefined)
                        current.onUp()
                    else
                        current = launch
                    break
                case "down":
                    if(current.onDown != undefined)
                        current.onDown()
                    else
                        current = launch
                    break
                case "left":
                    if(current.onLeft != undefined)
                        current.onLeft()
                    else
                        current = launch
                    break
                case "right":
                    if(current.onRight != undefined)
                        current.onRight()
                    else
                        current = launch
                    break
                case "prev":
                    if(games.currentIndex === 0)
                        s = audio.toggle_down
                    if(current.onPrevious != undefined)
                        current.onPrevious()
                    else
                        onPrevious()
                    break
                case "next":
                    if(games.currentIndex === games.count - 1)
                        s = audio.toggle_down
                    if(current.onNext != undefined)
                        current.onNext()
                    else
                        onNext()
                    break
                case "first":
                    if(current.onFirst != undefined)
                        current.onFirst()
                    else
                        onFirst()
                    break
                case "last":
                    if(current.onLast != undefined)
                        current.onLast()
                    else
                        onLast()
                    break
                case "details":
                    s = audio.toggle_down
                    onCancel()
                    break
                case "filter":
                    currentGame.favorite = !currentGame.favorite
                    search.populateModel()
                    break
                case "cancel":
                    if(current.onCancel != undefined)
                        current.onCancel()
                    else
                        onCancel()
                    s = audio.toggle_down
                    event.accepted = true
                    break
                case "accept":
                    if(current.onAccept != undefined){
                        current.onAccept()
                    }else{
                        launch_window.visible = true
                        if(settings.lastPlayed){
                            api.memory.set("collectionIndex", currentCollectionIndex)
                            api.memory.set("gameIndex", games.currentIndex)
                        }
                        s = audio.toggle_down
                        currentGame.launch()
                    }
                    event.accepted = true
                    break
                default:
                    break
            }
            s = s != null ? s : audio.select
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }

    property Video video: video.video
    property Image image: video.image
}