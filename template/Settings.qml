// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Item {
    id: settings

    //fonts
    property string fontFamilyRegular: 
        "assets/fonts/Open Sans/OpenSans-Regular.ttf"
    property string fontFamilyBold: 
        "assets/fonts/Open Sans/OpenSans-Bold.ttf"

    //ui
    property int hover_speed: 100
    
    property string headerSize: api.memory.get("struceOS_ui_headerSize") || "m"

    property bool twelvehour: 
        api.memory.get("struceOS_ui_twelvehour") != undefined ?
            api.memory.get("struceOS_ui_twelvehour") : true

    property bool buttonHints:
        api.memory.get("struceOS_ui_buttonHints") != undefined ?
            api.memory.get("struceOS_ui_buttonHints") : true

    property bool osk:
        api.memory.get("struceOS_ui_osk") != undefined ?
            api.memory.get("struceOS_ui_osk") : false
            
    //audio
        //video
        property bool videoMute:
            api.memory.get("struceOS_video_videoMute") != undefined ?
                api.memory.get("struceOS_video_videoMute") : true

        property real videoVolume: api.memory.get("struceOS_video_volume") || 0.40
    
        //ui
        property bool uiMute: 
            api.memory.get("struceOS_ui_Mute") != undefined ?
                api.memory.get("struceOS_ui_Mute") : false

        property real uiVolume: api.memory.get("struceOS_ui_volume") || 0.40

    //game_layout
    property int columns: api.memory.get("struceOS_gameLayout_columns") || 5

    property bool lastPlayed: 
        api.memory.get("struceOS_gameLayout_lastPlayed") != undefined ?
            api.memory.get("struceOS_gameLayout_lastPlayed") : true

    property bool allGames: 
        api.memory.get("struceOS_gameLayout_allGames") != undefined ?
            api.memory.get("struceOS_gameLayout_allGames") : true

    property bool showThumbs: 
        api.memory.get("struceOS_gameLayout_thumbnails") != undefined ?
            api.memory.get("struceOS_gameLayout_thumbnails") : true

    //background
    property bool bgOverlayOn:
        api.memory.get("struceOS_background_overlayOn") != undefined ?
            api.memory.get("struceOS_background_overlayOn") : true

    property real bgOverlayOpacity: api.memory.get("struceOS_background_overlayOpacity") || 0.75

    property string bgOverlay:
        api.memory.get("struceOS_background_overlaySource") != undefined ?
            api.memory.get("struceOS_background_overlaySource") : images.overlay_0002

    //devtools
    property bool enableDevTools:
        api.memory.get("struceOS_dev_enableDevTools") != undefined ?
            api.memory.get("struceOS_dev_enableDevTools") : false

    property real consoleLogBackground: api.memory.get("struceOS_dev_log_opacity") || 0.6

    property string version: "1.6.1"
    property string author: "my_name_is_p"
    property string name: "struceOS"
    property string details: "struceOS v" + version + (working ? "-working" : "")

    property bool working: false

    //Colors
    property var theme: 
        api.memory.get("struceOS_theme_colors") != undefined ?
            api.memory.get("struceOS_theme_colors") : JSON.parse(JSON.stringify(default_theme))
    
    property var default_theme: {
            "accent": "#011936",
            "accent_light": "#465362",
            "black": "#000000",
            "border": addAlphaToHex(0.6, "#FFFFFF"),
            "launch_button": "#1E824C",
            "launch_hover": "#FFFFFF",
            "launch_text": "#FFFFFF",
            "onscreen_keyboard": "#01070E",
            "slider": "#FE3734",
            "slider_base": "#F1C8C7",
            "t": "transparent",
            "text": "#FFFFFF",
            "text_invert": "#000000",
            "white": "#FFFFFF",
        }
}