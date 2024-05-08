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

import QtQuick 2.0
import "../utils.js" as U

Rectangle {
    id: background
    anchors.fill: parent
    color: "#000000"




    Image {
        id: backgroundGame
        source: currentBG
        opacity: 0

        smooth: true
        antialiasing: true

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        onStatusChanged: {
            if(backgroundGame.status === Image.Ready)
                bgFadeIn.start()
        }

        NumberAnimation {
            id: bgFadeIn
            target: backgroundGame
            
            properties: "opacity"
            from: 0
            to: 1.0
            
            duration: 350
        }

        NumberAnimation {
            id: bgFadeOut
            target: backgroundGame
            
            properties: "opacity"
            from: backgroundGame.opacity
            to: 0
            
            duration: 350

            onRunningChanged: {
                if(!bgFadeOut.running){
                    currentBG = U.getAsset(currentGame, currentGame.assets, "bg")
                }
            }
        }
    }
    property Image backgroundGame: backgroundGame
    property Animation bgFadeOut: bgFadeOut
    

    //Background Overlay
    Image {
        id: backgroundOverlay
        source: "../assets/" + settings.bgOverlaySource
        opacity: settings.bgOverlayOn ? settings.bgOverlayOpacity : 0

        smooth: true
        antialiasing: true

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }
}
