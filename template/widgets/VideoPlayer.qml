// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Item { //viewer
    id: viewer
    
    width: parent.width
    height: width / 1.778

    property bool hovered: video_hover.hovered || selected ? true : false
    property bool selected: false
    property Item current: viewer

    property Item enter: play_pause

    Rectangle { //video_select
        id: video_select

        anchors.fill: parent
        anchors.margins: vpx(-8)

        color: p.t

        radius: vpx(16)

        border.color: p.border
        border.width: parent.selected && parent.current === viewer ? vpx(12) : 0

    }

    Rectangle { //viewer_mask
        id: viewer_mask
        anchors.fill: parent
        radius: vpx(12)

        color: p.accent
    }

    Image { //video_default
        id: video_default
        anchors.fill: parent

        source: getAssets(currentGame.assets).bg != "default" ? getAssets(currentGame.assets).bg : images.noImage

        visible: false
        fillMode: Image.PreserveAspectCrop
    }


    Rectangle { //video_frame
        id: video_frame
        anchors.fill: parent
        color: p.black

        visible: false

        radius: vpx(12)


        Video { //video
            id: video
            source: currentGame.assets.video
            anchors.fill: parent

            flushMode: VideoOutput.EmptyFrame
            fillMode: VideoOutput.PreserveAspectFit

            muted: stest.videoMute
            volume: stest.videoVolume
            loops: MediaPlayer.Infinite

            onStatusChanged: {
                if(status === MediaPlayer.EndOfMedia)
                    video.seek(0)
            }

            function safePlay(){
                muted = api.memory.get("struceOS_video_videoMute") != undefined ? api.memory.get("struceOS_video_videoMute") : true
                play()
            }

        }

    }

    OpacityMask {
        anchors.fill: parent
        source: video.status != MediaPlayer.NoMedia ? video_frame : video_default
        maskSource: viewer_mask
    }

    MouseArea { //video_pause
        id: video_pause
        anchors.fill: video_frame

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if(video.playbackState != MediaPlayer.PlayingState)
                video.play()
            else
                video.pause()
        }
    }

    Item { //video_controls
        id: video_controls
        
        anchors.fill: parent

        visible: (viewer.hovered || video.selected) && video.status != MediaPlayer.NoMedia? true : false

        UIButton { //play_pause
            id: play_pause

            icon: video.playbackState != MediaPlayer.PlayingState ? images.play : images.pause
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: vpx(12)

            selected: viewer.current === this

            onClicked: function(){
                if(video.playbackState != MediaPlayer.PlayingState)
                    video.play()
                else
                    video.pause()
            }

            property var onAccept: onClicked

            property var onRight: function(){
                viewer.current = video_scrub_bar
            }

            property var onPrevious: function(){
                video.seek(video.position - 5000)
            }

            property var onNext: function(){
                video.seek(video.position + 5000)
            }
            property var onFirst: onPrevious
            property var onLast: onNext

            property var onUp: function(){
                viewer.onCancel()
            }
            property var onDown: onUp

        }

        UIButton { //loop
            id: loop

            icon: video.loops != MediaPlayer.Infinite ? images.no_loop : images.loop
            anchors.bottom: parent.bottom
            anchors.right: mute.left
            anchors.margins: vpx(12)
            anchors.rightMargin: vpx(6)

            selected: viewer.current === this

            onClicked: function(){
                if(video.loops != MediaPlayer.Infinite)
                        video.loops = MediaPlayer.Infinite
                else
                    video.loops = 1
            }

            property var onAccept: onClicked

            property var onLeft: function(){
                viewer.current = video_scrub_bar
            }

            property var onRight: function(){
                viewer.current = mute
            }

            property var onPrevious: function(){
                if(video.position - 5000 > 0)
                    video.seek(video.position - 5000)
                else
                    video.seek(0)
            }

            property var onNext: function(){
                if(video.position + 5000 < video.duration)
                    video.seek(video.position + 5000)
                else
                    video.seek(video.duration - 1)
            }

            property var onFirst: onPrevious
            property var onLast: onNext
        }

        UIButton { //mute
            id: mute

            icon: video.muted ? images.mute : images.sound
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: vpx(12)

            selected: viewer.current === this

            onClicked: function(){
                video.muted = !video.muted
                stest.videoMute = video.muted
            }
            property var onAccept: onClicked

            property var onLeft: function(){
                viewer.current = loop
            }

            property var onUp: function(){
                viewer.current = volume_slide
            }

            property var onPrevious: function(){
                if(video.position - 5000 > 0)
                    video.seek(video.position - 5000)
                else
                    video.seek(0)
            }

            property var onNext: function(){
                if(video.position + 5000 < video.duration)
                    video.seek(video.position + 5000)
                else
                    video.seek(video.duration - 1)
            }

            property var onFirst: onPrevious
            property var onLast: onNext
        }

        Item { //video_scrub_bar
            id: video_scrub_bar

            height: vpx(24)

            anchors.verticalCenter: play_pause.verticalCenter
            anchors.left: play_pause.right
            anchors.right: video_time.left
            anchors.margins: vpx(12)

            property bool selected: viewer.current === this

            property var onAccept: function(){
                viewer.current = video_scrub_handle
            }

            property var onLeft: function(){
                viewer.current = play_pause
            }
            
            property var onRight: function(){
                viewer.current = loop
            }

            property var onPrevious: function(){
                if(video.position - 5000 > 0)
                    video.seek(video.position - 5000)
                else
                    video.seek(0)
            }

            property var onNext: function(){
                if(video.position + 5000 < video.duration)
                    video.seek(video.position + 5000)
                else
                    video.seek(video.duration - 1)
            }

            property var onFirst: onPrevious
            property var onUp: onNext
            property var onDown: onPrevious
            property var onLast: onNext


            Rectangle { //video_scrub_background
                id: video_scrub_background
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: video_scrub_handle.width / 2

                height: vpx(6)
                
                color: p.slider_base

                radius: vpx(6)
            }

            Rectangle { //video_scrub_progress
                id: video_scrub_progress
                anchors.right: video_scrub_handle.right
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: video_scrub_handle.width / 2

                height: vpx(6)

                color: p.slider

                radius: vpx(6)
            }

            Rectangle { //video_scrub_handle
                id: video_scrub_handle
                width: vpx(12)
                height: width

                anchors.verticalCenter: parent.verticalCenter
                color: p.slider
                radius: vpx(12)

                property var selected: viewer.current === this

                property var onAccept: function(){
                    viewer.current = video_scrub_bar
                }
                property var onCancel: onAccept

                property var onLeft: function(){
                    if(video.position - 500 > 0)
                        video.seek(video.position - 500)
                    else
                        video.seek(0)
                }

                property var onRight: function(){
                    if(video.position + 500 < video.duration)
                        video.seek(video.position + 500)
                    else
                        video.seek(video.duration - 1)
                }

                property var onPrevious: function(){
                    if(video.position - 5000 > 0)
                        video.seek(video.position - 5000)
                    else
                        video.seek(0)
                }

                property var onNext: function(){
                    if(video.position + 5000 < video.duration)
                        video.seek(video.position + 5000)
                    else
                        video.seek(video.duration - 1)
                }

                property var onFirst: onPrevious
                property var onUp: onNext
                property var onDown: onPrevious
                property var onLast: onNext

                Rectangle { //video_scrub_handle_select
                    id: video_scrub_handle_select
                    anchors.fill: parent
                    anchors.margins: vpx(-6)
                    color: p.t

                    border.color: p.border
                    border.width: parent.selected ? vpx(6) : 0

                    radius: vpx(6)
                }

                Timer {
                    id: update_position
                    interval: 10
                    onTriggered: {
                        video_scrub_handle.updatePosition()
                    }
                    repeat: true
                    running: true
                }

                function updatePosition(){
                    x = video_scrub_background.width * (video.position/video.duration)
                }

            }

            Rectangle { //video_scrub_select
                id: video_scrub_select
                anchors.fill: parent
                color: p.t
                border.color: p.border
                border.width: parent.selected ? vpx(6) : 0

                radius: vpx(6)
            }

            MouseArea { //video_scrub_click
                id: video_scrub_click

                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor

                drag.target: video_scrub_handle
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: parent.width - video_scrub_handle.width


                onClicked: {
                    video.seek(mouseX/video_scrub_background.width * video.duration)
                }

                onPositionChanged: {
                    video.seek(video_scrub_handle.x/video_scrub_background.width * video.duration)
                }
            }
        }

        Item{ //video_time
            id: video_time
            anchors.verticalCenter: mute.verticalCenter
            anchors.right: loop.left
            anchors.rightMargin: vpx(12)

            height: video_time_text.height
            width: video_time_text.width

            Rectangle { //video_time_text_background
                id: video_time_text_background
                anchors.fill: video_time_text
                radius: vpx(6)
                anchors.margins: vpx(-3)

                color: addAlphaToHex(0.3, p.black)
            }

            Text { //video_time_text
                id: video_time_text

                text: getTime(video.position) + "/" + getTime(video.duration)

                color: p.text

                horizontalAlignment: Text.AlignRight

                function getTime(t){
                    let h = Math.floor((t / (1000 * 60 * 60)) % 24)
                    let m = Math.floor((t / (1000 * 60)) % 60)
                    let s = Math.floor((t / 1000) % 60)

                    h = (h < 10) ? "0" + h : h
                    m = (m < 10) ? "0" + m : m
                    s = (s < 10) ? "0" + s : s

                    t = parseInt(h) > 0 ? h + ":" + m + ":" + s : m + ":" + s
                    return t
                }
            }
        }

        Item { //volume_slide
            id: volume_slide

            width:vpx(24)
        
            anchors.horizontalCenter: mute.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 2
            anchors.bottom: mute.top
            anchors.bottomMargin: vpx(3)

            property bool show_value: true
            property var text_color: p.white
            property var value: stest.videoVolume

            property bool selected: viewer.current === this

            property var onDown: function(){
                viewer.current = mute
            }

            property var onNext: function(){
                let v = Math.round((stest.videoVolume * 100) % 5)
                v = (stest.videoVolume * 100) - v + 5
                stest.videoVolume = v < 100 ? v / 100 : 1
            }
            property var onRight: onNext

            property var onPrevious: function(){
                let v = Math.round((stest.videoVolume * 100) % 5)
                v = v > 0 ? (stest.videoVolume * 100) - v : (stest.videoVolume * 100) -5
                stest.videoVolume = v > 0 ? v / 100 : 0
            }
            property var onLeft: onPrevious

            property var onFirst: function(){
                stest.videoVolume = 0
            }

            property var onLast: function(){
                stest.videoVolume = 1
            }

            property var onAccept: function(){
                viewer.current = volume_slide_handle
            }

            Rectangle { //volume_slide_select
                id: volume_slide_select
                anchors.fill: parent
                color: p.t
                border.color: p.border
                border.width: parent.selected ? vpx(6) : 0

                radius: vpx(6)
            }

            Rectangle { //volume_slide_amount_background
                id: volume_slide_amount_background
                anchors.fill: volume_slide_amount
                radius: vpx(6)
                anchors.margins: vpx(-3)

                color: addAlphaToHex(0.3, p.black)
            }

            Text { //volume_slide_amount
                id: volume_slide_amount
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.top
                anchors.bottomMargin: vpx(6)

                horizontalAlignment: Text.AlignHCenter

                color: parent.text_color

                text: Math.round(parent.value * 100)

                visible: parent.show_value
            }

            Rectangle { //volume_slide_background
                id: volume_slide_background
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: volume_slide_handle.height / 2

                width: vpx(6)
                
                color: p.slider_base

                radius: vpx(6)
            }

            Rectangle { //volume_slide_progress
                id: volume_slide_progress
                anchors.top: volume_slide_handle.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: volume_slide_handle.height / 2

                width: vpx(6)

                color: p.slider

                radius: vpx(6)
            }

            Rectangle { //volume_slide_handle
                id: volume_slide_handle
                width: vpx(12)
                height: width
                y: volume_slide_background.height * (1 - stest.videoVolume)

                anchors.horizontalCenter: parent.horizontalCenter
                color: p.slider
                radius: vpx(12)

                property bool selected: viewer.current === this

                property var onNext: function(){
                    let v = Math.round((stest.videoVolume * 100) % 5)
                    v = (stest.videoVolume * 100) - v + 5
                    stest.videoVolume = v < 100 ? v / 100 : 1
                }
                property var onRight: onNext

                property var onUp: function(){
                    let v = (stest.videoVolume * 100) + 1
                    stest.videoVolume = v < 100 ? v / 100 : 1
                }
                property var onLeft: onPrevious

                property var onPrevious: function(){
                    let v = Math.round((stest.videoVolume * 100) % 5)
                    v = v > 0 ? (stest.videoVolume * 100) - v : (stest.videoVolume * 100) - 5
                    stest.videoVolume = v > 0 ? v / 100 : 0
                }

                property var onDown: function(){
                    let v = (stest.videoVolume * 100) - 1
                    stest.videoVolume = v > 0 ? v / 100 : 0
                }

                property var onFirst: function(){
                    stest.videoVolume = 0
                }

                property var onLast: function(){
                    stest.videoVolume = 1
                }

                property var onAccept: function(){
                    viewer.current = volume_slide
                }
                property var onCancel: onAccept

                Rectangle {
                    id: volume_slide_handle_select
                    anchors.fill: parent
                    anchors.margins: vpx(-6)
                    color: p.t

                    border.color: p.border
                    border.width: parent.selected ? vpx(6) : 0

                    radius: vpx(6)
                }

            }

            MouseArea { //volume_click
                id: volume_click

                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor

                drag.target: volume_slide_handle
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: parent.height - volume_slide_handle.height


                onClicked: {
                    let v = Math.round((1 - (mouseY / volume_slide_background.height)) * 100) / 100
                    v = v < 0 ? 0 : v
                    stest.videoVolume = v
                }

                onPositionChanged: {
                    stest.videoVolume = Math.round((1 - (volume_slide_handle.y / volume_slide_background.height)) * 100) / 100
                }
            }
        }
    }

    HoverHandler { //video_hover
        id: video_hover
        cursorShape: Qt.PointingHandCursor
    }


    Keys.onPressed: { //Keys
        let key = gsk(event)
        if(key != undefined){
            switch(key){
                case "up":
                    if(current.onUp != undefined)
                        current.onUp()
                    break
                case "down":
                    if(current.onDown != undefined)
                        current.onDown()
                    break
                case "left":
                    if(current.onLeft != undefined)
                        current.onLeft()
                    break
                case "right":
                    if(current.onRight != undefined)
                        current.onRight()
                    break
                case "prev":
                    if(current.onPrevious != undefined)
                        current.onPrevious()
                    break
                case "next":
                    if(current.onNext != undefined)
                        current.onNext()
                    break
                case "first":
                    if(current.onFirst != undefined)
                        current.onFirst()
                    break
                case "last":
                    if(current.onLast != undefined)
                        current.onLast()
                    break
                case "details":
                    onCancel()
                    panel_area.activePanel = panel_area.info_panel
                    f = game_layout
                    s = audio.toggle_down
                    break
                case "cancel":
                    if(current.onCancel != undefined)
                        current.onCancel()
                    else
                        onCancel()
                    s = audio.toggle_down
                    break
                case "accept":
                    current.onAccept()
                    break
                default:
                    break
            }
            event.accepted = true
            s = s != null ? s : audio.select
        }
        if(s != null){
            audio.stopAll()
            s.play()
        }
        s = null
    }

    property Video video: video
    property Image image: video_default
}