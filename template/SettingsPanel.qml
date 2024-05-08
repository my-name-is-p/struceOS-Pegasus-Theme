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
import QtGraphicalEffects 1.12
import "../utils.js" as U
import "extras"

Rectangle {
    id: settings_panel_outer_wrapper
    height: parent.height
    width: parent.width
    anchors.bottom: parent.top
    color: Qt.rgba(0,0,0,0.75)

    states: State {
        name: "opened"
        PropertyChanges{
            target: settings_panel_outer_wrapper
            anchors.bottom: parent.bottom
        }
    }

    MouseArea {
        id: settings_panel_prevent
        anchors.fill: parent

        onClicked: {
            mouse.event = accept
        }

        onWheel: {
            mouse.event = accept
        }
    }

    Rectangle {
        id: settings_panel_inner_wrapper
        anchors.fill: parent
        anchors.margins: vpx(24)
        color: Qt.rgba(0,0,0,0.95)

        radius: vpx(6)

        Rectangle { //settings_panel_close
            id: settings_panel_close
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: vpx(12)
            width: vpx(48)
            height: vpx(48)

            color: "transparent"

            Rectangle {
                id: settings_panel_close_hover
                anchors.fill: parent

                color: Qt.hsla(0.79, 0.2, 0.26, 0.85)
                radius: vpx(6)
                opacity: 0

                states: State {
                    name: "hover"
                    PropertyChanges { target: settings_panel_close_hover; opacity: 1 }
                }

                transitions: Transition {
                    NumberAnimation {
                        properties: "opacity"
                        duration: 150 
                        easing.type: Easing.EaseInOut
                    }
                }
            }

            Text { //settings_panel_close_icon
                id: settings_panel_close_icon
                anchors.fill: parent
                anchors.bottomMargin: (font.pixelSize / 4)

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: "🗙"
                color: "#ffffff"

                font.pixelSize: vpx(24)
            }

            Rectangle { //settings_panel_close_border
                id: settings_panel_close_border
                anchors.fill: parent
                color: "transparent"

                visible: false

                border.color: Qt.hsla(1,1,1,0.6)
                border.width: vpx(3)
                radius: vpx(6)
            }

            MouseArea{ //settings_panel_close_click
                id: settings_panel_close_click

                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    U.toggleSettings("gameView")
                }

                onEntered: {
                    settings_panel_close_hover.state = "hover"
                }

                onExited: {
                    settings_panel_close_hover.state = ""
                }
            }
        }

        Rectangle { //settings_panel_content
            id: settings_panel_content

            anchors{
                top: settings_panel_close.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: vpx(24)
            }

            color: "transparent"

            Row { //settings_panel_content_columns
                id: settings_panel_content_columns
                anchors.fill: parent

                Item { //settings_panel_content_column1
                    id: settings_panel_content_column1
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.horizontalCenter
                        bottom: parent.bottom
                        rightMargin: vpx(24)
                    }

                    Item { //gameview_settings
                        id: gameview_settings
                        anchors.fill: parent

                        Text { //gameview_settings_title
                            id: gameview_settings_title
                            text: "Game View Settings"
                            color: "#ffffff"

                            font.family: bold.name
                            font.bold: true
                            font.pixelSize: vpx(24)
                        }
                        
                        Row { //gameview_settings_column_count
                            id: gameview_settings_column_count
                            anchors.top: gameview_settings_title.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //gameview_settings_column_count_label
                                id: gameview_settings_column_count_label
                                text: "Game View column amount: "
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            MinusButton { //column_minus
                                id: column_minus

                                anchors.right: column_plus.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: gameview_settings_column_count_amount.verticalCenter
                                
                                property string name: "column_minus"
                                property Text currentValue: gameview_settings_column_count_amount

                            }

                            PlusButton { //column_plus
                                id: column_plus

                                anchors.right: gameview_settings_column_count_amount.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: gameview_settings_column_count_amount.verticalCenter

                                property string name: "column_plus"
                                property Text currentValue: gameview_settings_column_count_amount

                            }

                            Text { //gameview_settings_column_count_amount
                                id: gameview_settings_column_count_amount
                                text: settings.columns
                                color: "#ffffff"

                                anchors.right: parent.right

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }
                        }

                        Row { //gameview_settings_last_played
                            id: gameview_settings_last_played
                            anchors.top: gameview_settings_column_count.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //gameview_settings_column_count_label
                                id: gameview_settings_last_played_label
                                text: "Open to last played:"
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            CustomCheckbox {
                                id: gameview_settings_last_played_checkbox
                                anchors.right: parent.right

                                state: settings.lastPlayed ? "checked" : ""

                                MouseArea { //checkbox_click
                                    id: gameview_settings_last_played_checkbox_click
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        select.play()
                                        if(gameview_settings_last_played_checkbox.state != "checked"){
                                            settings.lastPlayed = !settings.lastPlayed
                                            parent.state = "checked"
                                        } else {
                                            settings.lastPlayed = !settings.lastPlayed
                                            parent.state = ""
                                        }
                                        api.memory.set("struceOS_gameView_lastPlayed", settings.lastPlayed)
                                    }
                                }
                            }
                        }

                        Row { //gameview_settings_all_games
                            id: gameview_settings_all_games
                            anchors.top: gameview_settings_last_played.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //gameview_settings_all_games_label
                                id: gameview_settings_all_games_label
                                text: "Show \"All Games\" collection:"
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            CustomCheckbox {
                                id: gameview_settings_all_games_checkbox
                                anchors.right: parent.right
                                state: settings.allGames ? "checked" : ""

                                MouseArea { //checkbox_click
                                    id: gameview_settings_all_games_checkbox_click
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        select.play()
                                        if(gameview_settings_all_games_checkbox.state != "checked"){
                                            settings.allGames = !settings.allGames
                                            parent.state = "checked"
                                        } else {
                                            settings.allGames = !settings.allGames
                                            parent.state = ""
                                        }
                                        api.memory.set("struceOS_gameView_allGames", settings.allGames)
                                    }
                                }
                            }
                        }

                        Item { //gameview_settings_thumbnails
                            id: gameview_settings_thumbnails
                            anchors.top: gameview_settings_all_games.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom

                            Text {
                                id: gameview_settings_thumbnails_description
                                text: "Scale and crop game thumbnails in: "
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx(16)
                            }

                            SettingsCollectionList{
                                id: gameview_settings_thumbnails_collection_list
                                anchors.top: gameview_settings_thumbnails_description.bottom
                                anchors.topMargin: vpx(6)
                                anchors.left: parent.left
                                anchors.leftMargin: vpx(12)
                                anchors.right: parent.right
                                anchors.bottom: parent.bottom
                                clip: true
                            }                            
                        }
                    }
                }

                Item { //settings_panel_content_column2
                    id: settings_panel_content_column2
                    anchors {
                        top: parent.top
                        left: parent.horizontalCenter
                        right: parent.right
                        bottom: parent.bottom
                        leftMargin: vpx(24)
                    }

                    Item { //background_settings
                        id: background_settings
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right

                        height: vpx(95)

                        Text { //background_settings_title
                            id: background_settings_title
                            text: "Background Settings"
                            color: "#ffffff"

                            font.family: bold.name
                            font.bold: true
                            font.pixelSize: vpx(24)
                        }

                        Row { //background_settings_overlay_on
                            id: background_settings_overlay_on
                            anchors.top: background_settings_title.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //background_settings_overlay_on_label
                                id: background_settings_overlay_on_label
                                text: "Background overlay on:"
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            CustomCheckbox {
                                id: background_settings_overlay_on_chekbox
                                anchors.right: parent.right

                                state: settings.bgOverlayOn ? "checked" : ""

                                MouseArea { //checkbox_click
                                    id: background_settings_overlay_on_label_click
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        select.play()
                                        if(background_settings_overlay_on_chekbox.state != "checked"){
                                            settings.bgOverlayOn = !settings.bgOverlayOn
                                            parent.state = "checked"
                                        } else {
                                            settings.bgOverlayOn = !settings.bgOverlayOn
                                            parent.state = ""
                                        }
                                        api.memory.set("struceOS_background_overlayOn", settings.bgOverlayOn)
                                    }
                                }
                            }
                        }


                        Row { //background_settings_overlay_opactiy
                            id: background_settings_overlay_opactiy
                            anchors.top: background_settings_overlay_on.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //background_settings_overlay_opactiy_label
                                id: background_settings_overlay_opactiy_label
                                text: "Background overlay opacity (0-1): "
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            MinusButton { //column_minus
                                id: bg_opacity_minus

                                anchors.right: bg_opacity_plus.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: background_settings_overlay_opactiy_amount.verticalCenter
                                
                                property string name: "bg_opacity_minus"
                                property Text currentValue: background_settings_overlay_opactiy_amount

                            }

                            PlusButton { //column_plus
                                id: bg_opacity_plus

                                anchors.right: background_settings_overlay_opactiy_amount.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: background_settings_overlay_opactiy_amount.verticalCenter

                                property string name: "bg_opacity_plus"
                                property Text currentValue: background_settings_overlay_opactiy_amount

                            }

                            Text { //background_settings_overlay_opactiy_amount
                                id: background_settings_overlay_opactiy_amount
                                text: settings.bgOverlayOpacity.toFixed(2)
                                color: "#ffffff"

                                anchors.right: parent.right

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }
                        }
                    }

                    Item { //video_settings
                        id: video_settings
                        anchors.top: background_settings.bottom
                        anchors.topMargin: vpx(24)
                        anchors.left: parent.left
                        anchors.right: parent.right

                        height: vpx(95)

                        Text { //video_settings_title
                            id: video_settings_title
                            text: "Video Settings"
                            color: "#ffffff"

                            font.family: bold.name
                            font.bold: true
                            font.pixelSize: vpx(24)
                        }

                        Row { //video_settings_mute
                            id: video_settings_mute
                            anchors.top: video_settings_title.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //background_settings_overlay_on_label
                                id: video_settings_mute_label
                                text: "Mute video:"
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            CustomCheckbox {
                                id: video_settings_mute_checkbox
                                anchors.right: parent.right

                                state: settings.videoMute ? "checked" : ""

                                MouseArea { //checkbox_click
                                    id: video_settings_mute_chekbox_click
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        select.play()
                                        if(video_settings_mute_checkbox.state != "checked"){
                                            settings.videoMute = !settings.videoMute
                                            parent.state = "checked"
                                        } else {
                                            settings.videoMute = !settings.videoMute
                                            parent.state = ""
                                        }
                                        api.memory.set("struceOS_video_videoMute", settings.videoMute)
                                    }
                                }
                            }
                        }

                        Row { //video_settings_volume
                            id: video_settings_volume
                            anchors.top: video_settings_mute.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //video_settings_volume_label
                                id: video_settings_volume_label
                                text: "Video volume (0-1): "
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            MinusButton { //column_minus
                                id: video_volume_minus

                                anchors.right: video_volume_plus.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: video_settings_volume_amount.verticalCenter
                                
                                property string name: "video_volume_minus"
                                property Text currentValue: video_settings_volume_amount

                            }

                            PlusButton { //column_plus
                                id: video_volume_plus

                                anchors.right: video_settings_volume_amount.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: video_settings_volume_amount.verticalCenter

                                property string name: "video_volume_plus"
                                property Text currentValue: video_settings_volume_amount

                            }

                            Text { //video_settings_volume_amount
                                id: video_settings_volume_amount
                                text: settings.videoVolume.toFixed(2)
                                color: "#ffffff"

                                anchors.right: parent.right

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }
                        }
                    }

                    Item {
                        id: dev_settings
                        anchors.top: video_settings.bottom
                        anchors.topMargin: vpx(24)
                        anchors.left: parent.left
                        anchors.right: parent.right

                        //height: vpx(95)

                        Text { //dev_settings_title
                            id: dev_settings_title
                            text: "Dev Tools Settings"
                            color: "#ffffff"

                            font.family: bold.name
                            font.bold: true
                            font.pixelSize: vpx(24)
                        }

                        Row { //dev_settings_on
                            id: dev_settings_on
                            anchors.top: dev_settings_title.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //dev_settings_on_label
                                id: dev_settings_on_label
                                text: "Enable Dev Tools:"
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            CustomCheckbox {
                                id: dev_settings_on_checkbox
                                anchors.right: parent.right

                                state: settings.enableDevTools ? "checked" : ""

                                MouseArea { //checkbox_click
                                    id: dev_settings_on_click
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        select.play()
                                        if(dev_settings_on_checkbox.state != "checked"){
                                            settings.enableDevTools = !settings.enableDevTools
                                            parent.state = "checked"
                                        } else {
                                            settings.enableDevTools = !settings.enableDevTools
                                            parent.state = ""
                                        }
                                        api.memory.set("struceOS_dev_enableDevTools", settings.enableDevTools)
                                    }
                                }
                            }
                        }

                        Row { //dev_settings_log_opacity
                            id: dev_settings_log_opacity
                            anchors.top: dev_settings_on.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //dev_settings_log_opacity_label
                                id: dev_settings_log_opacity_label
                                text: "Log opacity (0-1): "
                                color: "#ffffff"

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            MinusButton { //column_minus
                                id: dev_log_opacity_minus

                                anchors.right: dev_log_opacity_plus.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: dev_settings_log_opacity_amount.verticalCenter
                                
                                property string name: "dev_log_opacity_minus"
                                property Text currentValue: dev_settings_log_opacity_amount

                            }

                            PlusButton { //column_plus
                                id: dev_log_opacity_plus

                                anchors.right: dev_settings_log_opacity_amount.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: dev_settings_log_opacity_amount.verticalCenter

                                property string name: "dev_log_opacity_plus"
                                property Text currentValue: dev_settings_log_opacity_amount

                            }

                            Text { //dev_settings_log_opacity_amount
                                id: dev_settings_log_opacity_amount
                                text: settings.consoleLogBackground.toFixed(2)
                                color: "#ffffff"

                                anchors.right: parent.right

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }
                        }
                    }
                }
            }
        }
    }
}

//Worked but didn't
/*
Item { //settings wrapper
    id: settingsWrapper
    anchors{
        top: header.bottom
        left: parent.horizontalCenter
        leftMargin: parent.width * 0.125
        right: parent.right
        bottom: parent.bottom
    }
    clip: true
    opacity: 0
    state: settingsPanel.state

    property bool enableButtons: state === "opended"


    states: State {
        name: "opened"
        PropertyChanges{
            target: settingsWrapper
            opacity: 1
        }
    }

    transitions: Transition {
        NumberAnimation {
            properties: "opacity"
            duration: 150 
        }
    }

    MouseArea{
        id: settingsPreventClick

        anchors.fill: parent
        enabled: parent.enableButtons
        anchors.leftMargin: parent.state != "opened" ? parent.width : 0
    }

    Rectangle {
        id: settingsPanel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.leftMargin: parent.state != "opened" ? parent.width : 0
        width: parent.width - vpx(12)
        height: 0
        color: Qt.hsla(0.79, 0.2, 0.26, 0.85)
        radius: vpx(6)

        states: State {
            name: "opened"
            PropertyChanges {
                target: settingsPanel
                height: parent.height - vpx(12)
            }
        }

        transitions: Transition {
            NumberAnimation {
                properties: "height"
                duration: 150 
            }
        }

        property bool enableButtons: parent.enableButtons

        Item {
            id: settingsTextWrapper
            anchors.fill: parent
            anchors.margins: vpx(12)

            property bool enableButtons: parent.enableButtons

            Item{
                id: generalSettings
                anchors.left: parent.left
                anchors.right: parent.right

                property bool enableButtons: parent.enableButtons

                Text{
                    id: generalSettings_head
                    text: "General Settings"
                    color: "#ffffff"
                    font.family: bold.name
                    font.pixelSize: vpx(24)
                    font.bold: true
                }

                Row { //column amount
                    id: column_amount_setting
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: generalSettings_head.bottom
                    anchors.topMargin: vpx(6)

                    Text {
                        id: columns_description
                        text: "Game grid columns: "
                        color: "#ffffff"

                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        font.family: regular.name
                        font.pixelSize: vpx(16)
                    }

                    MinusButton {
                        id: column_minus

                        anchors.right: column_plus.left
                        anchors.rightMargin: vpx(12)

                        anchors.verticalCenter: columns_amount.verticalCenter
                        
                        property string name: "column_minus"
                        property Text currentValue: columns_amount

                        enabled: parent.enableButtons
                    }

                    PlusButton {
                        id: column_plus

                        anchors.right: columns_amount.left
                        anchors.rightMargin: vpx(12)

                        anchors.verticalCenter: columns_amount.verticalCenter

                        property string name: "column_plus"
                        property Text currentValue: columns_amount

                        enabled: parent.enableButtons
                    }
                    

                    Text {
                        id: columns_amount
                        text: settings.columns

                        anchors.right: parent.right

                        color: "#ffffff"
                        
                        verticalAlignment: Text.AlignVCenter

                        font.family: bold.name
                        font.pixelSize: vpx(16)
                    }
                }

                Item { // gameView_thumbnails
                    id: thumbnail_settings
                    anchors.top: generalSettings_head.bottom
                    anchors.topMargin: vpx(36)
                    anchors.bottom: collection_list_wrapper.bottom
                    height: vpx((api.collections.count * 29) + 33)

                    property bool enableButtons: parent.enableButtons

                    Text {
                        id: thumbnail_description
                        text: "Scale and crop game thumbnails in: "
                        color: "#ffffff"

                        font.family: regular.name
                        font.pixelSize: vpx(16)
                    }

                    Item {
                        id: collection_list_wrapper

                        anchors.top: thumbnail_description.bottom
                        anchors.topMargin: vpx(6)
                        anchors.left: parent.left
                        anchors.leftMargin: vpx(12)
                        anchors.right: parent.right
                        height: api.collections.count * 29 + 16

                        property bool enableButtons: parent.enableButtons

                        SettingsCollectionList{
                            id: settingsCollectionList
                            property bool enableButtons: parent.enableButtons
                            anchors.top: gameView_thumbnails_description.bottom
                        }
                    }
                }

                Row{
                    id: last_played_setting
                    anchors.top: thumbnail_settings.bottom
                    anchors.topMargin: vpx(6)

                    Text {
                        text: "Open to last played?"
                        color: "#ffffff"

                        font.family: regular.name
                        font.pixelSize: vpx(16)
                    }

                    Rectangle {

                        id: last_played_checkbox
                        border.color: "#ffffff"
                        border.width: vpx(2)
                        radius: vpx(6)

                        anchors.leftMargin: vpx(12)

                        width: vpx(24)
                        height: vpx(24)

                        color: state != "checked" ? "transparent" : "#ffffff"

                        state: settings.lastPlayed ? "checked" : ""

                        states: State {
                            name: "checked"
                            PropertyChanges { 
                                target: last_played_check
                                text: "✓"
                            }
                        }

                        Text {
                            id: last_played_check
                            anchors.centerIn: parent
                            color: "#000000"

                            text: ""

                            font.pointSize: vpx(12)
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            enabled: settingsPanel.settingsPanel.state === "opened"

                            onClicked: {
                                select.play()
                                if(last_played_checkbox.state != "checked"){
                                    last_played_checkbox.state = "checked"
                                } else {
                                    last_played_checkbox.state = ""
                                }
                                api.memory.set("lastPlayed", last_played_checkbox.state === "checked")
                                games.gameView.forceLayout()
                            }
                        }
                    }
                }

            }
        }

        Item { //settingsFooter
            
            id: settingsFooter
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: vpx(12)

            Text { //donation link
                id: donationLink
                text:"If you are enjoying this theme, please consider donating."
                property string link: "https://www.paypal.com/donate/?business=UVLTE2DMLAR3G&no_recurring=1&item_name=donations+for+struceOS%2C+Pegasus+Frontend+Theme&currency_code=USD"
                color: "#ffffff"

                anchors.bottom: parent.bottom
                anchors.right: decoration.left
                anchors.rightMargin: vpx(6)

                font.pixelSize: vpx(11)
                font.underline: false
                horizontalAlignment: Text.AlignRight

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    enabled: settingsPanel.state === "opened"

                    onClicked: {
                        Qt.openUrlExternally(donationLink.link)
                    }

                    onEntered: {
                        donationLink.font.underline = true
                    }

                    onExited: {
                        donationLink.font.underline = false
                    }
                }
            }

            Rectangle { //decoration
                id: decoration
                width: vpx(6)
                height: vpx(6)

                anchors.verticalCenter: version.verticalCenter
                anchors.right: version.left
                anchors.rightMargin: vpx(6)

                border.color: "#ffffff"
                border.width: vpx(2)
                radius: vpx(6)
            }

            Text { //version number
                id: version
                text:"struceOS v" + settings.version + (settings.working ? "-working" : "")
                property string link: "https://github.com/strucep/struceOS-Pegasus-Theme"
                color: "#ffffff"

                anchors.bottom: parent.bottom
                anchors.right: parent.right

                font.pixelSize: vpx(11)
                font.underline: false
                horizontalAlignment: Text.AlignRight

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    enabled: settingsPanel.state === "opened"

                    onClicked: {
                        Qt.openUrlExternally(version.link)
                    }

                    onEntered: {
                        version.font.underline = true
                    }

                    onExited: {
                        version.font.underline = false
                    }
                }
            }
        }

        Item { //FirstAttempt
            id: settingsTextWrapper
            anchors.fill: parent
            anchors.margins: vpx(12)

            Rectangle {
                id: settingsOptions
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    bottom: donationLink.top
                    margins: vpx(12)
                }
                color: "transparent"

                Item {
                    anchors.fill: parent

                    Column { // gameView_thumbnails
                        id: gameView_thumbnails
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: column_minus.bottom
                        anchors.topMargin: vpx(24)
                        spacing: vpx(6)
                        height: settingsCollectionList.height

                        Text {
                            id: gameView_thumbnails_description
                            text: "Scale and crop thumbnails (updates on refresh): "
                            color: "#ffffff"

                            font.family: bold.name
                            font.pixelSize: vpx(16)
                        }

                        Item {
                            anchors.top: gameView_thumbnails_description.bottom
                            anchors.left: parent.left
                            anchors.leftMargin: vpx(12)
                            anchors.right: parent.right

                            SettingsCollectionList{
                                id: settingsCollectionList
                                anchors.top: gameView_thumbnails_description.bottom
                            }
                        }
                    }
                    
                    Row { //general_last_played
                        id: general_last_played
                        anchors.top: settingsCollectionList.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: vpx(36)
                
                        Text {
                            id: general_last_played_description
                            text: "Open to selcted game (off = last played)"
                            color: "#ffffff"

                            anchors.top: parent.top
                            anchors.bottom: parent.bottom

                            verticalAlignment: Text.AlignVCenter

                            font.family: bold.name
                            font.pixelSize: vpx(16)
                        }
                                                
                        Text {
                            id: general_last_played_note
                            text: "(off = last played)"

                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right

                            color: "#ffffff"
                            
                            verticalAlignment: Text.AlignVCenter

                            font.family: bold.name
                            font.pixelSize: vpx(16)
                        }
                    }
                }
            }

            Row{
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }
        }
    }

    DropShadow {
        anchors.fill: settingsPanel
        cached: true
        horizontalOffset: 6
        verticalOffset: 6
        radius: 8.0
        samples: 16
        color: "#80000000"
        source: settingsPanel
    }

    property Rectangle settingsPanel: settingsPanel
    property Text column: gameView_columns_value.text
    
}
*/