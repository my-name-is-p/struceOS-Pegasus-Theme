// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15

Item {
    id: images
    visible: false

    //Images
        Image {
            id: noImage
            source: "../assets/img/no_image.png"
        }
        property string noImage: noImage.source

        Image {
            id: overlay
            source: "../assets/img/backgrounds/" + stest.bgOverlaySource
        }
        property string overlay: overlay.source

        Image {
            id: current_collection
            source: "../assets/logos/" + currentCollection.shortName + ".svg"
        }    
        property string current_collection: current_collection.source
    //--

    //--General UI
        Image {
            id: cross
            source: "../assets/img/ui-icons/general/cross.svg"
        }    
        property string cross: cross.source

        Image {
            id: favorite_icon_empty
            source: "../assets/img/ui-icons/general/heart_empty.svg"
        }
        property string favorite_icon_empty: favorite_icon_empty.source
        
        Image {
            id: favorite_icon_filled
            source: "../assets/img/ui-icons/general/heart_filled.svg"
        }
        property string favorite_icon_filled: favorite_icon_filled.source
        
        Image {
            id: info_icon
            source: "../assets/img/ui-icons/general/info.svg"
        }
        property string info_icon: info_icon.source
        
        Image {
            id: players
            source: "../assets/img/ui-icons/general/players.svg"
        }    
        property string players: players.source

        Image {
            id: search_icon
            source: "../assets/img/ui-icons/general/search.svg"
        }
        property string search_icon: search_icon.source

        Image {
            id: settings_icon
            source: "../assets/img/ui-icons/general/settings.svg"
        }
        property string settings_icon: settings_icon.source

        Image {
            id: slash
            source: "../assets/img/ui-icons/general/slash.svg"
        }
        property string slash: slash.source

        Image {
            id: sort_direction_empty
            source: "../assets/img/ui-icons/general/arrow_empty.svg"
        }
        property string sort_direction_empty: sort_direction_empty.source

        Image {
            id: sort_direction_filled
            source: "../assets/img/ui-icons/general/arrow_filled.svg"
        }
        property string sort_direction_filled: sort_direction_filled.source

        Image {
            id: sortfilt_icon_empty
            source: "../assets/img/ui-icons/general/sortfilt_icon_empty.svg"
        }
        property string sortfilt_icon_empty: sortfilt_icon_empty.source

        Image {
            id: sortfilt_icon_filled
            source: "../assets/img/ui-icons/general/sortfilt_icon_filled.svg"
        }
        property string sortfilt_icon_filled: sortfilt_icon_filled.source

        Image {
            id: stars_empty
            source: "../assets/img/ui-icons/general/star_empty.svg"
        }
        property string stars_empty: stars_empty.source

        Image {
            id: stars_filled
            source: "../assets/img/ui-icons/general/star_filled.svg"
        }
        property string stars_filled: stars_filled.source

        Image {
            id: kofi
            source: "../assets/img/ui-icons/general/kofi_button.svg"
        }
        property string kofi: kofi.source
    //--


    //--Media UI
        Image {
            id: loop
            source: "../assets/img/ui-icons/media/loop.svg"
        }    
        property string loop: loop.source

        Image {
            id: mute
            source: "../assets/img/ui-icons/media/mute.svg"
        }    
        property string mute: mute.source

        Image {
            id: no_loop
            source: "../assets/img/ui-icons/media/no_loop.svg"
        }
        property string no_loop: no_loop.source

        Image {
            id: pause
            source: "../assets/img/ui-icons/media/pause.svg"
        }    
        property string pause: pause.source

        Image {
            id: play
            source: "../assets/img/ui-icons/media/play.svg"
        }    
        property string play: play.source

        Image {
            id: sound
            source: "../assets/img/ui-icons/media/sound.svg"
        }    
        property string sound: sound.source
    //--

    //--Controller UI
        Image {
            id: dpad
            source: "../assets/img/ui-icons/controller/dpad.svg"
        }    
        property string dpad: dpad.source

        Image {
            id: dpad_up
            source: "../assets/img/ui-icons/controller/dpad_up.svg"
        }    
        property string dpad_up: dpad_up.source
        

        Image {
            id: dpad_down
            source: "../assets/img/ui-icons/controller/dpad_down.svg"
        }    
        property string dpad_down: dpad_down.source
        

        Image {
            id: dpad_left
            source: "../assets/img/ui-icons/controller/dpad_left.svg"
        }    
        property string dpad_left: dpad_left.source
        

        Image {
            id: dpad_right
            source: "../assets/img/ui-icons/controller/dpad_right.svg"
        }    
        property string dpad_right: dpad_right.source

        Image {
            id: face_button
            source: "../assets/img/ui-icons/controller/face_button.svg"
        }    
        property string face_button: face_button.source

        Image {
            id: face_button_top
            source: "../assets/img/ui-icons/controller/face_button_top.svg"
        }    
        property string face_button_top: face_button_top.source

        Image {
            id: face_button_bottom
            source: "../assets/img/ui-icons/controller/face_button_bottom.svg"
        }    
        property string face_button_bottom: face_button_bottom.source

        Image {
            id: face_button_left
            source: "../assets/img/ui-icons/controller/face_button_left.svg"
        }    
        property string face_button_left: face_button_left.source

        Image {
            id: face_button_right
            source: "../assets/img/ui-icons/controller/face_button_right.svg"
        }    
        property string face_button_right: face_button_right.source

        Image {
            id: leftBumper
            source: "../assets/img/ui-icons/controller/LB.svg"
        }    
        property string leftBumper: leftBumper.source

        Image {
            id: rightBumper
            source: "../assets/img/ui-icons/controller/RB.svg"
        }    
        property string rightBumper: rightBumper.source
    //--

    //--Keyboard UI
        Image {
            id: key_w
            source: "../assets/img/ui-icons/keyboard/key_w.svg"
        }    
        property string key_w: key_w.source
        
        Image {
            id: key_s
            source: "../assets/img/ui-icons/keyboard/key_s.svg"
        }    
        property string key_s: key_s.source
        
        Image {
            id: key_a
            source: "../assets/img/ui-icons/keyboard/key_a.svg"
        }    
        property string key_a: key_a.source
        
        Image {
            id: key_d
            source: "../assets/img/ui-icons/keyboard/key_d.svg"
        }    
        property string key_d: key_d.source
        
        Image {
            id: key_q
            source: "../assets/img/ui-icons/keyboard/key_q.svg"
        }    
        property string key_q: key_q.source
        
        Image {
            id: key_e
            source: "../assets/img/ui-icons/keyboard/key_e.svg"
        }    
        property string key_e: key_e.source
        
        Image {
            id: key_space
            source: "../assets/img/ui-icons/keyboard/key_space.svg"
        }    
        property string key_space: key_space.source
        
        Image {
            id: key_enter
            source: "../assets/img/ui-icons/keyboard/key_enter.svg"
        }    
        property string key_enter: key_enter.source
        
    //--

}