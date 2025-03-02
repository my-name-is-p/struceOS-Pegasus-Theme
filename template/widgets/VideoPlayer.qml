// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Item { //viewer
    id: viewer
    
    width: parent.width
    height: parent.width / 1.778

    property bool hovered: false
    property bool selected: false
    property Item current: viewer

    property Item enter: play_pause

    //Functions--
        property var onUp: current != viewer ? current.onUp : undefined
        property var onDown: current != viewer ? current.onDown : undefined
        property var onLeft: current != viewer ? current.onLeft : undefined
        property var onRight: current != viewer ? current.onRight : undefined
        property var onPrevious: current != viewer ? current.onPrevious : undefined
        property var onNext: current != viewer ? current.onNext : undefined
        property var onFirst: current != viewer ? current.onFirst : undefined
        property var onLast: current != viewer ? current.onLast : undefined
        property var onDetails: current != viewer ? current.onDetails : undefined
        property var onSort: current != viewer ? current.onSort : undefined
        property var onCancel: current != viewer ? current.onCancel : undefined
        function onAccept(){
            if(current != viewer)
                current.onAccept()
            else
                current = play_pause
        }
    //--

    Rectangle { //select
        id: select

        anchors.fill: viewer
        anchors.margins: vpx(-8)

        color: colors.t
        border.color: colors.border
        border.width: viewer.selected && viewer.current === viewer ? vpx(12) : 0
        radius: vpx(16)
    }

    Rectangle { //player_mask
        id: player_mask

        anchors.fill: viewer

        color: colors.accent
        radius: vpx(12)
    }

    Rectangle { //player
        id: player

        anchors.fill: viewer

        color: colors.black
        radius: vpx(12)

        visible: false
        
        Video { //video
            id: video
            source: search.currentGame().assets.video
            anchors.fill: player

            fillMode: VideoOutput.PreserveAspectFit

            muted: settings.videoMute
            volume: settings.videoVolume
            loops: MediaPlayer.Infinite

            onStatusChanged: {
                if(status === MediaPlayer.EndOfMedia)
                    video.seek(0)
            }

            //Functions--
                function reset(){
                    stop()
                    source = ""
                    source = search.currentGame().assets.video
                    muted = settings.videoMute = 
                        api.memory.get("struceOS_video_videoMute") != undefined ? 
                            api.memory.get("struceOS_video_videoMute") : true
                    volume = settings.videoVolume = api.memory.get("struceOS_video_volume") || 0.40
                    volume_handle.y = volume_background.height - (volume_background.height * volume)

                }
            //--
        }

        Image { //frame
            id: frame
            anchors.fill: player

            source: search.currentGame() ? (getAssets(search.currentGame().assets).bg != "default" ? getAssets(search.currentGame().assets).bg : images.noImage) : images.noImage

            fillMode: Image.PreserveAspectCrop

            opacity: video.status === MediaPlayer.NoMedia ? 
                1 : video.playbackState != MediaPlayer.StoppedState ? 
                    0 : 0.3
            Behavior on opacity{NumberAnimation{ duration: settings.hover_speed}}
        }
    }

    OpacityMask { //player_out
        id: player_out
        anchors.fill: viewer
        source: player
        maskSource: player_mask
    }

    MouseArea { //video_pause
        id: video_pause

        anchors.fill: viewer

        cursorShape: video.status != MediaPlayer.NoMedia ? Qt.PointingHandCursor : Qt.ArrowCursor

        enabled: video.status != MediaPlayer.NoMedia

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }

        onEntered: {
            viewer.hovered = true
        }

        onExited: {
            viewer.hovered = false
        }

        onClicked: {
            if(video.playbackState != MediaPlayer.PlayingState)
                video.play()
            else
                video.pause()
        }
    }

    Item { //video_controls
        id: video_controls
        
        anchors.fill: viewer

        visible: video.status === MediaPlayer.NoMedia ? 
            false :
            (
                viewer.hovered || 
                viewer.selected 
            ) 
                ?
                    true : 
                    false

        UIButton { //play_pause
            id: play_pause
            icon: video.playbackState != MediaPlayer.PlayingState ? images.play : images.pause

            anchors.bottom: video_controls.bottom
            anchors.left: video_controls.left
            anchors.margins: vpx(12)

            selected: viewer.selected && viewer.current === this

            onClicked: function(){
                if(video.playbackState != MediaPlayer.PlayingState)
                    video.play()
                else
                    video.pause()
            }
            property var onAccept: onClicked

            function onRight(){
                viewer.current = scrub_bar
            }

            onEntered: function(){
                viewer.hovered = true
            }

            onExited: function(){
                viewer.hovered = false
            }
        }

        Item { //scrub_bar
            id: scrub_bar

            anchors.verticalCenter: play_pause.verticalCenter
            anchors.left: play_pause.right
            anchors.right: time.left
            anchors.margins: vpx(12)

            height: vpx(24)

            property bool selected: viewer.current === this

            //Functions--
                function onAccept(){
                    viewer.current = scrub_handle
                }

                function onLeft(){
                    viewer.current = play_pause
                }
                
                function onRight(){
                    viewer.current = loop
                }

                function onPrevious(){
                    if(video.position - 5000 > 0)
                        video.seek(video.position - 5000)
                    else
                        video.seek(0)
                }
                property var onFirst: onPrevious
                property var onDown: onPrevious

                function onNext(){
                    if(video.position + 5000 < video.duration)
                        video.seek(video.position + 5000)
                    else
                        video.seek(video.duration - 1)
                }
                property var onUp: onNext
                property var onLast: onNext
            //--

            Rectangle { //scrub_background
                id: scrub_background

                anchors.left: scrub_bar.left
                anchors.right: scrub_bar.right
                anchors.verticalCenter: scrub_bar.verticalCenter
                anchors.margins: scrub_handle.width / 2

                height: vpx(6)
                
                color: colors.slider_base
                radius: vpx(6)
            }

            Rectangle { //scrub_progress
                id: scrub_progress

                anchors.right: scrub_handle.right
                anchors.left: scrub_bar.left
                anchors.verticalCenter: scrub_bar.verticalCenter
                anchors.margins: scrub_handle.width / 2

                height: vpx(6)

                color: colors.slider
                radius: vpx(6)
            }

            Rectangle { //scrub_handle
                id: scrub_handle

                anchors.verticalCenter: scrub_bar.verticalCenter

                width: vpx(12)
                height: vpx(12)

                color: colors.slider
                radius: vpx(12)

                property var selected: viewer.current === this

                //Functions--
                    function onAccept(){
                        viewer.current = scrub_bar
                    }
                    property var onCancel: onAccept

                    function onLeft(){
                        if(video.position - 500 > 0)
                            video.seek(video.position - 500)
                        else
                            video.seek(0)
                    }

                    function onRight(){
                        if(video.position + 500 < video.duration)
                            video.seek(video.position + 500)
                        else
                            video.seek(video.duration - 1)
                    }

                    function onPrevious(){
                        if(video.position - 5000 > 0)
                            video.seek(video.position - 5000)
                        else
                            video.seek(0)
                    }
                    property var onFirst: onPrevious
                    property var onDown: onPrevious

                    function onNext(){
                        if(video.position + 5000 < video.duration)
                            video.seek(video.position + 5000)
                        else
                            video.seek(video.duration - 1)
                    }
                    property var onUp: onNext
                    property var onLast: onNext
                //--

                Rectangle { //scrub_handle_select
                    id: scrub_handle_select

                    anchors.fill: scrub_handle
                    anchors.margins: vpx(-6)

                    color: colors.t
                    border.color: colors.border
                    border.width: scrub_handle.selected ? vpx(6) : 0
                    radius: vpx(6)
                }

                Timer { //update_position
                    id: update_position
                    interval: 10
                    onTriggered: {
                        scrub_handle.updatePosition()
                    }
                    repeat: true
                    running: true
                }

                function updatePosition(){ //updatePosition
                    x = scrub_background.width * (video.position/video.duration)
                }
            }

            Rectangle { //scrub_select
                id: scrub_select

                anchors.fill: scrub_bar

                color: colors.t
                border.color: colors.border
                border.width: scrub_bar.selected ? vpx(6) : 0
                radius: vpx(6)
            }

            MouseArea { //scrub_click
                id: scrub_click

                anchors.fill: scrub_bar

                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    video.seek(mouseX/scrub_background.width * video.duration)
                }

                onPositionChanged: {
                    video.seek(mouseX/scrub_background.width * video.duration)
                }
            }
        }

        UIButton { //loop
            id: loop
            icon: video.loops != MediaPlayer.Infinite ? images.no_loop : images.loop

            anchors.bottom: video_controls.bottom
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

            function onLeft(){
                viewer.current = scrub_bar
            }

            function onRight(){
                viewer.current = mute
            }

            onEntered: function(){
                viewer.hovered = true
            }

            onExited: function(){
                viewer.hovered = false
            }
        }

        UIButton { //mute
            id: mute
            icon: video.muted ? images.mute : images.sound

            anchors.bottom: video_controls.bottom
            anchors.right: video_controls.right
            anchors.margins: vpx(12)

            selected: viewer.current === this

            onClicked: function(){
                video.muted = !video.muted
                settings.videoMute = video.muted
            }
            property var onAccept: onClicked

            function onLeft(){
                viewer.current = loop
            }

            function onUp(){
                viewer.current = volume_scrub
            }

            onEntered: function(){
                viewer.hovered = true
            }

            onExited: function(){
                viewer.hovered = false
            }
        }

        Item{ //time
            id: time

            anchors.verticalCenter: mute.verticalCenter
            anchors.right: loop.left
            anchors.rightMargin: vpx(12)

            height: time_text.height
            width: time_text.width

            Rectangle { //time_text_background
                id: time_text_background

                anchors.fill: time_text
                anchors.margins: vpx(-3)

                color: addAlphaToHex(0.3, colors.black)
                radius: vpx(6)
            }

            Text { //time_text
                id: time_text

                text: getTime(video.position) + "/" + getTime(video.duration)
                horizontalAlignment: Text.AlignRight

                color: colors.text

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

        Item { //volume_scrub
            id: volume_scrub

            anchors.top: video_controls.top
            anchors.topMargin: video_controls.height / 2
            anchors.bottom: mute.top
            anchors.bottomMargin: vpx(3)
            anchors.horizontalCenter: mute.horizontalCenter

            width: vpx(24)

            property bool selected: viewer.current === this

            //Functions--
            function updateX(position, mute = false){ //updateX
                if(0 >= position)
                    position = 0

                let current_stop = slider.stop
                let i = slider.min
                if(current_stop / 2 > position){
                    position = 0
                }else{
                    while(current_stop < position){
                        current_stop += slider.stop
                        i++
                    }
                    if(current_stop - (slider.stop / 2) > position){
                        position = current_stop - slider.stop
                    }else{
                        position = current_stop
                        i++
                    }
                }

                slider.value = Math.min(i, slider.max)

                if(position > base.width)
                    position = base.width

                position = Math.round(position - handle.width / 2)

                if(position != handle.x && !mute){
                    audio.stopAll()
                    audio.select.play()
                }
                return position
            }
            
                function onDown(){
                    viewer.current = mute
                }

                function onNext(){
                    let v = Math.round((settings.videoVolume * 100) % 5)
                    v = (settings.videoVolume * 100) - v + 5
                    settings.videoVolume = v < 100 ? v / 100 : 1
                }
                property var onRight: onNext

                function onPrevious(){
                    let v = Math.round((settings.videoVolume * 100) % 5)
                    v = v > 0 ? (settings.videoVolume * 100) - v : (settings.videoVolume * 100) -5
                    settings.videoVolume = v > 0 ? v / 100 : 0
                }
                property var onLeft: onPrevious

                function onFirst(){
                    settings.videoVolume = 0
                }

                function onLast(){
                    settings.videoVolume = 1
                }

                function onAccept(){
                    viewer.current = volume_handle
                }
            //--

            Rectangle { //volume_select
                id: volume_select

                anchors.fill: volume_scrub

                color: colors.t
                border.color: colors.border
                border.width: volume_scrub.selected ? vpx(6) : 0
                radius: vpx(6)
            }

            Rectangle { //volume_amount_background
                id: volume_amount_background

                anchors.fill: volume_amount
                anchors.margins: vpx(-3)

                color: addAlphaToHex(0.3, colors.black)
                radius: vpx(6)
            }

            Text { //volume_amount
                id: volume_amount

                anchors.horizontalCenter: volume_scrub.horizontalCenter
                anchors.bottom: volume_scrub.top
                anchors.bottomMargin: vpx(6)

                text: Math.round(settings.videoVolume * 100)
                horizontalAlignment: Text.AlignHCenter

                color: colors.white
            }

            Rectangle { //volume_background
                id: volume_background

                anchors.top: volume_scrub.top
                anchors.bottom: volume_scrub.bottom
                anchors.margins: volume_handle.height / 2
                anchors.horizontalCenter: volume_scrub.horizontalCenter

                width: vpx(6)
                
                color: colors.slider_base
                radius: vpx(6)
            }

            Rectangle { //volume_progress
                id: volume_progress

                anchors.top: volume_handle.top
                anchors.bottom: volume_scrub.bottom
                anchors.horizontalCenter: volume_scrub.horizontalCenter
                anchors.margins: volume_handle.height / 2

                width: vpx(6)

                color: colors.slider
                radius: vpx(6)
            }

            Rectangle { //volume_handle
                id: volume_handle

                anchors.horizontalCenter: volume_scrub.horizontalCenter

                width: vpx(12)
                height: vpx(12)

                color: colors.slider
                radius: vpx(12)

                y: volume_background.height - (volume_background.height * video.volume)

                property bool selected: viewer.current === this

                //Functions--
                    function onUp(){
                        let v = (settings.videoVolume * 100) + 1
                        video.volume = settings.videoVolume = v < 100 ? v / 100 : 1
                        y = volume_background.height - (volume_background.height * video.volume)
                    }

                    function onDown(){
                        let v = (settings.videoVolume * 100) - 1
                        video.volume = video.volume = settings.videoVolume = v > 0 ? v / 100 : 0
                        y = volume_background.height - (volume_background.height * video.volume)
                    }

                    function onNext(){
                        let v = Math.round((settings.videoVolume * 100) % 5)
                        v = (settings.videoVolume * 100) - v + 5
                        video.volume = settings.videoVolume = v < 100 ? v / 100 : 1
                        y = volume_background.height - (volume_background.height * video.volume)
                    }
                    property var onRight: onNext

                    function onPrevious(){
                        let v = Math.round((settings.videoVolume * 100) % 5)
                        v = v > 0 ? (settings.videoVolume * 100) - v : (settings.videoVolume * 100) - 5
                        video.volume = settings.videoVolume = v > 0 ? v / 100 : 0
                        y = volume_background.height - (volume_background.height * video.volume)
                    }
                    property var onLeft: onPrevious

                    function onFirst(){
                        video.volume = settings.videoVolume = 0
                        y = volume_background.height - (volume_background.height * video.volume)
                    }

                    function onLast(){
                        video.volume = settings.videoVolume = 1
                        y = volume_background.height - (volume_background.height * video.volume)
                    }

                    function onAccept(){
                        viewer.current = volume_scrub
                    }
                    property var onCancel: onAccept
                //--

                Rectangle { //volume_handle_select
                    id: volume_handle_select

                    anchors.fill: volume_handle
                    anchors.margins: vpx(-6)

                    color: colors.t
                    border.color: colors.border
                    border.width: volume_handle.selected ? vpx(6) : 0
                    radius: vpx(6)
                }
            }

            MouseArea { //volume_click
                id: volume_click

                anchors.fill: volume_scrub

                cursorShape: Qt.PointingHandCursor


                onPressed: {
                    if(mouseY < 0){
                        volume_handle.y = 0
                    }else if(mouseY > volume_background.height){
                        volume_handle.y = volume_background.height
                    }else{
                        volume_handle.y = mouseY
                    }
                    let v = Math.round((1 - (mouseY / volume_background.height)) * 100) / 100
                    v = v < 0 ? 0 : v
                    video.volume = settings.videoVolume = v
                }

                onPositionChanged: {
                    if(mouseY < 0){
                        volume_handle.y = 0
                    }else if(mouseY > volume_background.height){
                        volume_handle.y = volume_background.height
                    }else{
                        volume_handle.y = mouseY
                    }
                    let v = Math.round((1 - (volume_handle.y / volume_background.height)) * 100) / 100
                    v = v < 0 ? 0 : v
                    video.volume = settings.videoVolume = v
                }
            }
        }
    }

    HoverHandler { //hover
        id: hover
    }

    property Video video: video
}