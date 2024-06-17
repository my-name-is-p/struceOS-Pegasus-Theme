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
    color: settings.colors.black75

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
        color: settings.colors.black90

        radius: vpx(6)

        CloseButton {
            id: settings_panel_close
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: vpx(12)
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
                            color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                                        collectionsView.collectionsModel.populateModel()
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
                                color: settings.colors.white

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

                    Item { //general_settings
                        id: general_settings
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right

                        height: vpx(95)

                        Text { //general_settings_title
                            id: general_settings_title
                            text: "General Settings"
                            color: settings.colors.white

                            font.family: bold.name
                            font.bold: true
                            font.pixelSize: vpx(24)
                        }

                        Row { //general_settings_mute
                            id: general_settings_mute
                            anchors.top: general_settings_title.bottom
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //general_settings_mute_label
                                id: general_settings_mute_label
                                text: "Mute UI:"
                                color: settings.colors.white

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            CustomCheckbox {
                                id: general_settings_mute_checkbox
                                anchors.right: parent.right

                                state: settings.uiMute ? "checked" : ""

                                MouseArea { //checkbox_click
                                    id: general_settings_mute_chekbox_click
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        select.play()
                                        if(general_settings_mute_checkbox.state != "checked"){
                                            settings.uiMute = !settings.uiMute
                                            parent.state = "checked"
                                        } else {
                                            settings.uiMute = !settings.uiMute
                                            parent.state = ""
                                        }
                                        api.memory.set("struceOS_ui_Mute", settings.uiMute)
                                    }
                                }
                            }
                        }

                        Row { //general_settings_volume
                            id: general_settings_volume
                            anchors.top: general_settings_mute.bottom
                            anchors.topMargin: vpx(12)
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: column_minus.height

                            Text { //video_settings_volume_label
                                id: general_settings_volume_label
                                text: "UI volume (0-1): "
                                color: settings.colors.white

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }

                            MinusButton { //column_minus
                                id: general_volume_minus

                                anchors.right: general_volume_plus.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: general_settings_volume_amount.verticalCenter
                                
                                property string name: "general_volume_minus"
                                property Text currentValue: general_settings_volume_amount

                            }

                            PlusButton { //column_plus
                                id: general_volume_plus

                                anchors.right: general_settings_volume_amount.left
                                anchors.rightMargin: vpx(12)

                                anchors.verticalCenter: general_settings_volume_amount.verticalCenter

                                property string name: "general_volume_plus"
                                property Text currentValue: general_settings_volume_amount

                            }

                            Text { //video_settings_volume_amount
                                id: general_settings_volume_amount
                                text: settings.uiVolume.toFixed(2)
                                color: settings.colors.white

                                anchors.right: parent.right

                                font.family: regular.name
                                font.pixelSize: vpx (16)
                            }
                        }
                    }



                    Item { //background_settings
                        id: background_settings
                        anchors.top: general_settings.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right

                        anchors.topMargin: vpx(24)

                        height: vpx(95)

                        Text { //background_settings_title
                            id: background_settings_title
                            text: "Background Settings"
                            color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                            color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                            color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

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
                                color: settings.colors.white

                                anchors.right: parent.right

                                font.family: regular.name
                                font.pixelSize: vpx (16)
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
                text:"Buy me a ko-fi"
                property string link: "https://ko-fi.com/strucep"
                color: settings.colors.white

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

                border.color: settings.colors.white
                border.width: vpx(2)
                radius: vpx(6)
            }

            Text { //version number
                id: version
                text:"struceOS v" + settings.version + (settings.working ? "-working" : "")
                property string link: "https://github.com/strucep/struceOS-Pegasus-Theme"
                color: settings.colors.white

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
    }
}