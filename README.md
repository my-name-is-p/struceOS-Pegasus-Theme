# struceOS-Pegasus-Theme

![screenshot_1](.meta/screenshot_1.png)
![screenshot_2](.meta/screenshot_2.png)
![screenshot_3](.meta/screenshot_3.png)
![screenshot_4](.meta/screenshot_4.png)
![screenshot_5](.meta/screenshot_5.png)
![screenshot_5](.meta/screenshot_6.png)

# struceOS theme for [Pegasus Frontend](http://pegasus-frontend.org/)
A simple theme for easy navigation.

- Supports navigation using gamepad and keyboard/mouse. (Gamepad settings controls TK)
- Collapsible info panel with video player. (Info panel refresh TK)
- Customizable settings.

If you have any issues, please open a ticket or  let me know on [discord](https://discord.gg/Pa92b2Q2pa)
# Version 1.2.0 Updates
1. Added game count to collection title
2. Added collection dropdown menu

# Thank yous
Thank you to both [VGmove (EasyLaunch)](https://github.com/VGmove/EasyLaunch) and [PlayingKarrde (clearOS)](https://github.com/PlayingKarrde/clearOS). I used your themes to build this theme.

# To come in future updates
1. Beautified info panel
2. Gamepad controls for the settings panel

# Controls
- Keyboard/Mouse
    - Select Game: WASD / Arrow Keys / Mouse click
    - Select Collection: Q / E
    - Open Info Panel: I / click "i" icon
    - Close Info Panel: I / click outside of the info panel
    - Toggle Video Mute: M / click mute icon (appears when hovering over the video)
    - Pause/Play Video: Spacebar / click on the video

- Gamepad
    - Select Game: Joystick / D-Pad
    - Select Collection: RB / LB
    - Toggle Info Panel: X / ▢
    - Toggle Video Mute: Y / △

# Customizable Settings
The most useful settings are now in a settings panel within the theme. The rest can be found in template/settings. The default settings are below for reference:

    //Fonts
    property string fontFamilyRegular: 
        "assets/fonts/Open Sans/OpenSans-Regular.ttf"
    property string fontFamilyBold: 
        "assets/fonts/Open Sans/OpenSans-Bold.ttf"

    //gameView Settings
    property int columns:                                               //Number of columns to display in gameView
        api.memory.get("struceOS_gameView_columns") != undefined ?
        api.memory.get("struceOS_gameView_columns") :
        4
    property int columnsMax: 10                                         //Maximum columns in gameView
    property int columnsMin: 3                                          //Minimum columns in gameView
    property var croppedThumbnails:                                     //Array of game.shortName--banner images will be scaled to fill
        api.memory.get("struceOS_gameView_croppedThumbnails") != undefined ? 
        api.memory.get("struceOS_gameView_croppedThumbnails") :
        []                                                     
    property bool lastPlayed:                                           //Open to last game played--otherwise opens to last selected
        api.memory.get("struceOS_gameView_lastPlayed") != undefined ? 
        api.memory.get("struceOS_gameView_lastPlayed") :
        true
    property bool allGames: 
    api.memory.get("struceOS_gameView_allGames") != undefined ?
    api.memory.get("struceOS_gameView_allGames") :
    true                                        //Turns on the All Games Category (Unde Development)
                                                                        //currently doubles up if games are contained in two collections (windows/pc)
    property string defaultGameImage: "img/none.jpg"                    //Image source for default game image (will only look in assets)

    //Background Settings
    property bool bgOverlayOn:                                          //Apply an overlay to the background
        api.memory.get("struceOS_background_overlayOn") != undefined ?
        api.memory.get("struceOS_background_overlayOn") :
        true
    property real bgOverlayOpacity:                                     //Overlay opacity 
        api.memory.get("struceOS_background_overlayOpacity") != undefined ?
        api.memory.get("struceOS_background_overlayOpacity") :
        0.75
    property string bgOverlaySource: "img/bg-gradient.png"              //Image source for the background overlay (will only look in assets)
    
    //Video Settings
    property bool videoMute:                                            //Mute video by default
        api.memory.get("struceOS_video_videoMute") != undefined ?
        api.memory.get("struceOS_video_videoMute") : 
        true
    property real videoVolume:                                          //Video volume
        api.memory.get("struceOS_video_volume") != undefined ?
        api.memory.get("struceOS_video_volume") :
        0.40

    //Search Settings
    property var firstWordIgnore: ["the","legend","of","lego"]          //Words to ignore in search as the first word

    //DevTools
    property bool enableDevTools:                                       //Dispalys "console" and a button for testing purposes 
        api.memory.get("struceOS_dev_enableDevTools") != undefined ?
        api.memory.get("struceOS_dev_enableDevTools") :
        true
    property real consoleLogBackground:                                 //clog background opacity
        api.memory.get("struceOS_dev_log_opacity") != undefined ?
        api.memory.get("struceOS_dev_log_opacity") :
        0.5
    property string version: "1.1.0"                                    //struceOS version
    property bool working: false

# Installation
Download the theme and place it in your [Pegasus theme directory](http://pegasus-frontend.org/docs/user-guide/installing-themes/).

# Download
Download struceOS-Pegasus-Theme-1.2.0.zip from [latest releases](https://github.com/strucep/struceOS-Pegasus-Theme/releases).

<details>
    <summary>Changelogs</summary>

## 1.2.0

```
1. Added game count to collection title
2. Added collection dropdown menu
```

## 1.1.0

```
1. Split theme.qml into separate files for easier editing
2. Moved common functions to js
2. Updated header logic
3. Added Search functionality
4. Added an in app Settings panel
5. Added an All Games collection 
6. Fixed GoG and Steam collections
```

## 1.0.1

```
1. Fixed audio discrepancies in button presses
2. Fixed unused settings properties
3. Added additional settings to the customizable settings
```

## 1.0.0

```
1. Initial release.
```
</details>
