// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.15

Item { //viewer
    id: viewer
    
    width: parent.width
    height: width / 1.778

    property bool hovered: hover.hovered || selected ? true : false
    property bool selected: false
    property Item current: viewer

    property Item enter: play_pause

    //Functions--
        property var onUp: current.onUp
        property var onDown: current.onDown
        property var onLeft: current.onLeft
        property var onRight: current.onRight
        property var onPrevious: current.onPrevious
        property var onNext: current.onNext
        property var onFirst: current.onFirst
        property var onLast: current.onLast
        property var onDetails: current.onDetails
        property var onSort: current.onSort
        property var onCancel: current.onCancel
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
            source: currentGame.assets.video
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
                    source = currentGame.assets.video
                    muted = settings.videoMute = 
                        api.memory.get("struceOS_video_videoMute") != undefined ? 
                            api.memory.get("struceOS_video_videoMute") : true
                    volume = settings.videoVolume = api.memory.get("struceOS_video_volume") || 0.40
                }
            //--
        }

        Image { //frame
            id: frame
            anchors.fill: player

            source: getAssets(currentGame.assets).bg != "default" ? getAssets(currentGame.assets).bg : images.noImage

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
                video.selected || 
                video.playbackState != MediaPlayer.PlayingState
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
                height: width

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

                drag.target: scrub_handle
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: scrub_bar.width - scrub_handle.width

                onPressed: {
                    video.seek(mouseX/scrub_background.width * video.duration)
                }

                onPositionChanged: {
                    video.seek(scrub_handle.x/scrub_background.width * video.duration)
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
                height: width

                color: colors.slider
                radius: vpx(12)

                y: volume_background.height * (1 - settings.videoVolume)

                property bool selected: viewer.current === this

                //Functions--
                    function onUp(){
                        let v = (settings.videoVolume * 100) + 1
                        video.volume = settings.videoVolume = v < 100 ? v / 100 : 1
                    }

                    function onDown(){
                        let v = (settings.videoVolume * 100) - 1
                        video.volume = video.volume = settings.videoVolume = v > 0 ? v / 100 : 0
                    }

                    function onNext(){
                        let v = Math.round((settings.videoVolume * 100) % 5)
                        v = (settings.videoVolume * 100) - v + 5
                        video.volume = settings.videoVolume = v < 100 ? v / 100 : 1
                    }
                    property var onRight: onNext

                    function onPrevious(){
                        let v = Math.round((settings.videoVolume * 100) % 5)
                        v = v > 0 ? (settings.videoVolume * 100) - v : (settings.videoVolume * 100) - 5
                        video.volume = settings.videoVolume = v > 0 ? v / 100 : 0
                    }
                    property var onLeft: onPrevious

                    function onFirst(){
                        video.volume = settings.videoVolume = 0
                    }

                    function onLast(){
                        video.volume = settings.videoVolume = 1
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

                drag.target: volume_handle
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: volume_scrub.height - volume_handle.height

                onPressed: {
                    let v = Math.round((1 - (mouseY / volume_background.height)) * 100) / 100
                    v = v < 0 ? 0 : v
                    video.volume = settings.videoVolume = v
                }

                onPositionChanged: {
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