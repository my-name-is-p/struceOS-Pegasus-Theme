// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtMultimedia 5.9

Item {
    id: audio
    visible: false

    MediaPlayer {
		id: select
		source: "../assets/sounds/lc.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}
    property MediaPlayer select: select

    MediaPlayer {
		id: toggle_up
		source: "../assets/sounds/hc_down.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}
    property MediaPlayer toggle_up: toggle_up

    MediaPlayer {
		id: toggle_down
		source: "../assets/sounds/hc_up.wav"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}
    property MediaPlayer toggle_down: toggle_down

    MediaPlayer {
		id: home
		source: "../assets/sounds/home.mp3"
		volume: settings.uiMute ? 0 : settings.uiVolume
		loops : 1
	}
	property MediaPlayer home: home

	function stopAll(){
		for(var i = 0; i < children.length; i ++){
			children[i].stop()
		}
	}
}