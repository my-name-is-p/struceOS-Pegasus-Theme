// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtMultimedia 5.9

Item {
    id: audio
    visible: false

    SoundEffect {
		id: select
		source: "../assets/sounds/lc.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume ? settings.uiVolume : 0.40
		loops: 1

		function safePlay() {
			toggle_up_play.stop()
			toggle_down_play.stop()
			home_play.stop()
			select_play.start()
		}
	}
    property SoundEffect select: select

	Timer {
		id: select_play
		interval: 10
		onTriggered: select.play()
	}

    SoundEffect {
		id: toggle_up
		source: "../assets/sounds/hc_down.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume ? settings.uiVolume : 0.40
		loops: 1

		function safePlay() {
			select_play.stop()
			toggle_down.stop()
			toggle_down_play.stop()
			toggle_up_play.start()
		}

	}
    property SoundEffect toggle_up: toggle_up

	Timer {
		id: toggle_up_play
		interval: 10
		onTriggered: toggle_up.play()
	}

    SoundEffect {
		id: toggle_down
		source: "../assets/sounds/hc_up.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume ? settings.uiVolume : 0.40
		loops: 1

		function safePlay() {
			select_play.stop()
			toggle_up_play.stop()
			home_play.stop()
			toggle_down_play.start()
		}
	}
    property SoundEffect toggle_down: toggle_down

	Timer {
		id: toggle_down_play
		interval: 10
		onTriggered: toggle_down.play()
	}

    MediaPlayer {
		id: home
		source: "../assets/sounds/home.mp3"
		volume: settings.uiMute ? 0 : settings.uiVolume ? settings.uiVolume : 0.40
		loops: 1

		function safePlay() {
			select_play.stop()
			toggle_up_play.stop()
			toggle_down_play.stop()
			home_play.start()
		}
	}
	property MediaPlayer home: home

	Timer {
		id: home_play
		interval: 10
		onTriggered: home.play()
	}


	function stopAll(){
		for(var i = 0; i < children.length; i ++){
			children[i].stop()
		}
	}
}