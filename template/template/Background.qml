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

import QtQuick 2.15
import "../utils.js" as U

Rectangle {
    id: background
    anchors.fill: parent
    color: "#000000"
    Image {
        id:bg_back

        smooth: true
        antialiasing: true

        opacity: 0

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        source: bg

        Behavior on opacity {NumberAnimation {duration: (bg_refresh.duration / 2)}}

        NumberAnimation {
            id: bg_refresh
            target: bg_back

            duration: 500
           
            onStarted: {
                stop()
                if(getAssets(gcg().assets).bg != bg)
                    bg_back.opacity = 0

            }

            onFinished: {
                if(!bg_refresh.running){
                    bg = getAssets(gcg().assets).bg
                    bg_back.opacity = 1
                }
            }
        }
    }

    property Animation bg_refresh: bg_refresh

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
