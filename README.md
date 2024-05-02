# struceOS-Pegasus-Theme

![screenshot_1](.meta/screenshot_1.png)
![screenshot_2](.meta/screenshot_2.png)
![screenshot_3](.meta/screenshot_3.png)
![screenshot_4](.meta/screenshot_4.png)

# struceOS theme for [Pegasus Frontend](http://pegasus-frontend.org/)
A simple theme for for easy navigation.

- Supports navigation using gamepad and keyboard/mouse.
- Collapsible info panel with video player
- Customizable settings in theme.qml

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
Near the top of the theme.qml file is a block of settings for easy customization. The default settings are below for reference:

    Item {

        id: settings

        //gameView Settings
        property int columns: 4                                             //Number of columns to display in gameView
        property var croppedThumbnails: ["windows"]                         //Array of game.shortName--banner images will be scaled to fill
        
        //Background Settings
        property bool bgOverlayOn: true                                     //Apply an overlay to the background
        property string bgOverlaySource: "assets/img/bg-gradient.png"       //Image source for the background overlay
        
        //Info Panel Settings
        property string fontFamilyRegular: 
            "assets/fonts/M_PLUS_Rounded_1c/MPLUSRounded1c-Regular.ttf"     //Font to use in the info panel
        property string fontFamilyBold: 
            "assets/fonts/M_PLUS_Rounded_1c/MPLUSRounded1c-Bold.ttf"        //Font to use in the info panel
        property bool videoMute: true                                       //Mute video by default
        property real videoVolume: 0.40                                     //Video volume 

    }

# Installation
Download the theme and place it in your [Pegasus theme directory](http://pegasus-frontend.org/docs/user-guide/installing-themes/).

# Download
Download struceOS-Pegasus-Theme-1.0.0.zip from [last releases](https://github.com/strucep/struceOS-Pegasus-Theme/releases).
