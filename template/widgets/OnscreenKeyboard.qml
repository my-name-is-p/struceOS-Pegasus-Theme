// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "onscreenkeyboard"

Item {
    id: osk

    property real s_single: vpx(48)
    property real s_double: vpx(96)
    property real s_space: vpx(768)

    property bool shift: false

    property var current: numbers

    property var text: osk_text

    property TextInput linked: null

    property var last_focus: null
    property var last_text: null
    property var validate_hex: false

    visible: false

    //Functions--
        function open(text, refocus){
            linked = text
            last_text = linked.text
            last_focus = refocus
            visible = true
            resetFocus(osk)
        }

        function close(){
            if(validate_hex){
                if(!validateHex(linked.text))
                    linked.text = last_text
                if(linked.text[0] != "#")
                    linked.text = "#"+ linked.text
            }

            linked.onEditingFinished()

            if(last_focus === header.search_bar){
                games.currentIndex = 0
                last_focus = game_layout
            }
            resetFocus(last_focus)

            linked = null
            last_focus = null
            shift = false
            validate_hex = false
            visible = false
            current = numbers
            numbers.currentIndex =numbers.count - 1
            
            s = audio.toggle_down
        }

        property var onLeft: current.decrementCurrentIndex

        property var onRight: current.incrementCurrentIndex

        property var onDetails: function(){
                let pos = text.cursorPosition != 0 ? text.cursorPosition - 1 : 0
                linked.remove(osk.text.cursorPosition - 1, text.cursorPosition)
                text.cursorPosition = pos
            }
        
        property var onSort: function(){shift = !shift}

        property var onPrevious: function(){text.cursorPosition = 0}
        property var onFirst: onPrevious

        property var onNext: function(){text.cursorPosition = length}
        property var onLast: onNext

        property var onUp: current.onUp
        property var onDown: current.onDown

        property var onCancel: function(){
            close()
        }

        property var onAccept: current.currentItem.onAccept
    //--

    MouseArea { //osk_block
        id: osk_block

        anchors.fill: osk

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }

        onClicked:{
            osk.close(true)
            audio.toggle_down.safePlay()
        }
    }

    MouseArea {
        id: osk_color_block
        
        anchors.fill: osk_color

        hoverEnabled: true

        onPositionChanged: {
            screensaver.reset()
        }
    }

    Rectangle{ //osk_color
        id: osk_color

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        height: childrenSize(this, "height", "topMargin") + vpx(12)

        color: addAlphaToHex(0.95, colors.onscreen_keyboard)

        Rectangle { //osk_text_wrapper
            id: osk_text_wrapper

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: vpx(12)

            height: vpx(48)

            color: colors.accent_light

            radius: vpx(12)

            TextInput { //osk_text
                id: osk_text
                text: linked != null ? linked.text : ""

                anchors.fill: parent
                anchors.margins: vpx(12)

                verticalAlignment: Text.AlignVCenter

                font.family: regular.name
                font.pixelSize: vpx(16)

                color: colors.text

                focus: f === osk

                Keys.forwardTo: root
                Keys.onPressed: {
                    if(gsk(event) != "f5"){
                        if(event.key === 1048587 && !event.isAutoRepeat){
                            osk.close()
                        }
                        else if((event.key === 1048576 && event.isAutoRepeat))
                            return
                        event.accepted = true
                    }
                    s = s != null ? s : audio.toggle_down
                    s.safePlay()
                }
            }
        }

        Item {
            id: keyboard_wrapper

            anchors.top: osk_text_wrapper.bottom
            anchors.topMargin: vpx(24)
            anchors.left: parent.left
            anchors.right: parent.right

            height: childrenSize(this, "height", "topMargin")

            ListView { //numbers
                id: numbers

                anchors.horizontalCenter: parent.horizontalCenter

                currentIndex: count - 1 
                
                height: vpx(48)
                width: {
                    let l = model.keys.length
                    let w = 0
                    for(var i = 0; i < l; i++){
                        switch(model.keys[i].size){
                            case "space":
                                w += s_space
                                break
                            case "double":
                                w += s_double
                                break
                            default:
                                w += s_single
                                break
                        }
                    }
                    return w + (spacing * (l - 1))
                }

                model: OSKnumbers{}
                delegate: OSKKey{}
                orientation: ListView.Horizontal

                spacing: vpx(24)

                highlightFollowsCurrentItem: false
                highlightMoveDuration: 1

                keyNavigationWraps: true

                //Functions--
                    function onDown(){
                        if(currentIndex !=0)
                            qwerty.currentIndex = currentIndex - 1 >= qwerty.count ? qwerty.count - 1 : currentIndex - 1
                        else
                            qwerty.currentIndex = 0
                        osk.current = qwerty
                    }
                //--
            }

            ListView { //qwerty
                id: qwerty

                anchors.top: numbers.bottom
                anchors.topMargin: vpx(24)
                anchors.horizontalCenter: parent.horizontalCenter
                
                height: vpx(48)
                width: {
                    let l = model.keys.length
                    let w = 0
                    for(var i = 0; i < l; i++){
                        switch(model.keys[i].size){
                            case "space":
                                w += s_space
                                break
                            case "double":
                                w += s_double
                                break
                            default:
                                w += s_single
                                break
                        }
                    }
                    return w + (spacing * (l - 1))
                }

                model: OSKqwerty{}
                delegate: OSKKey{}
                orientation: ListView.Horizontal

                spacing: vpx(24)

                highlightFollowsCurrentItem: false
                highlightMoveDuration: 1

                keyNavigationWraps: true

                //Functions--
                    function onUp(){
                        numbers.currentIndex = currentIndex + 1
                        osk.current = numbers
                    }

                    function onDown(){
                        asdfgh.currentIndex = currentIndex >= asdfgh.count ? asdfgh.count - 1 : currentIndex
                        osk.current = asdfgh
                    }
                //--
            }

            ListView { //asdfgh
                id: asdfgh

                anchors.top: qwerty.bottom
                anchors.topMargin: vpx(24)
                anchors.horizontalCenter: parent.horizontalCenter
                
                height: vpx(48)
                width: {
                    let l = model.keys.length
                    let w = 0
                    for(var i = 0; i < l; i++){
                        switch(model.keys[i].size){
                            case "space":
                                w += s_space
                                break
                            case "double":
                                w += s_double
                                break
                            default:
                                w += s_single
                                break
                        }
                    }
                    return w + (spacing * (l - 1))
                }

                model: OSKasdfgh{}
                delegate: OSKKey{}
                orientation: ListView.Horizontal

                spacing: vpx(24)

                highlightFollowsCurrentItem: false
                highlightMoveDuration: 1

                keyNavigationWraps: true

                //Functions--
                    function onUp(){
                        qwerty.currentIndex = currentIndex
                        osk.current = qwerty
                    }
                
                    function onDown(){
                        if(currentIndex !=0)
                            zxcvbn.currentIndex = currentIndex - 1 >= zxcvbn.count ? zxcvbn.count - 1 : currentIndex - 1
                        else
                            zxcvbn.currentIndex = 0
                        osk.current = zxcvbn
                    }
                //--
            }

            ListView { //zxcvbn
                id: zxcvbn

                anchors.top: asdfgh.bottom
                anchors.topMargin: vpx(24)
                anchors.horizontalCenter: parent.horizontalCenter
                
                height: vpx(48)
                width: {
                    let l = model.keys.length
                    let w = 0
                    for(var i = 0; i < l; i++){
                        switch(model.keys[i].size){
                            case "space":
                                w += s_space
                                break
                            case "double":
                                w += s_double
                                break
                            default:
                                w += s_single
                                break
                        }
                    }
                    return w + (spacing * (l - 1))
                }

                model: OSKzxcvbn{}
                delegate: OSKKey{}
                orientation: ListView.Horizontal

                spacing: vpx(24)

                highlightFollowsCurrentItem: false
                highlightMoveDuration: 1

                keyNavigationWraps: true

                //Functions--
                    function onUp(){
                        asdfgh.currentIndex = currentIndex + 1
                        osk.current = asdfgh
                    }
                
                    function onDown(){
                        space.currentIndex = 1
                        osk.current = space
                    }
                //--
            }

            ListView { //space
                id: space

                anchors.top: zxcvbn.bottom
                anchors.topMargin: vpx(24)
                anchors.horizontalCenter: parent.horizontalCenter
                
                height: vpx(48)
                width: {
                    let l = model.keys.length
                    let w = 0
                    for(var i = 0; i < l; i++){
                        switch(model.keys[i].size){
                            case "space":
                                w += s_space
                                break
                            case "double":
                                w += s_double
                                break
                            default:
                                w += s_single
                                break
                        }
                    }
                    return w + (spacing * (l - 1))
                }

                model: OSKspace{}
                delegate: OSKKey{}
                orientation: ListView.Horizontal

                spacing: vpx(24)

                highlightFollowsCurrentItem: false
                highlightMoveDuration: 1

                keyNavigationWraps: true

                //Functions--
                    function onUp(){
                        if(currentIndex === 1)
                            zxcvbn.currentIndex = (zxcvbn.count - 1) / 2
                        else if(currentIndex > 1)
                            zxcvbn.currentIndex = zxcvbn.count - 1
                        else
                            zxcvbn.currentIndex = 0
                        osk.current = zxcvbn
                    }
                //--
            }
        }


        Item {
            id: buttons

            anchors.top: keyboard_wrapper.bottom
            anchors.right: keyboard_wrapper.right
            anchors.margins: vpx(24)

            height: childrenSize(this, "height", "", 0, 0, true)
            width: childrenSize(this, "width", "leftMargin")

            Item{ //buttons_backspace
                id: buttons_backspace

                height: buttons_backspace_mask.height
                width: buttons_backspace_mask.width
                
                Item { //buttons_backspace_mask
                    id: buttons_backspace_mask

                    height: childrenSize(this, "height", "", 0, 0, true)
                    width: childrenSize(this, "width")

                    visible: false

                    Text { //buttons_backspace_text
                        id: buttons_backspace_text
                        text: "backspace  -  "

                        anchors.verticalCenter: buttons_backspace_mask.verticalCenter

                        font.family: regular.name
                        font.pixelSize: vpx(12)
                    }

                    Image { //buttons_backspace_image
                        id: buttons_backspace_image
                        source: images.face_button_left

                        anchors.left: buttons_backspace_text.right

                        height: vpx(24)

                        fillMode: Image.PreserveAspectFit
                    }
                }

                Rectangle { //buttons_backspace_color
                    id: buttons_backspace_color
                    anchors.fill: buttons_backspace_mask
                    color: colors.white
                    visible: false
                }

                OpacityMask { //buttons_backspace_out
                    id: buttons_backspace_out
                    anchors.fill: buttons_backspace_mask
                    source: buttons_backspace_color
                    maskSource: buttons_backspace_mask
                }
            }

            Item{ //buttons_shift
                id: buttons_shift

                anchors.left: buttons_backspace.right
                anchors.leftMargin: vpx(12)

                height: buttons_shift_mask.height
                width: buttons_shift_mask.width
                
                Item { //buttons_shift_mask
                    id: buttons_shift_mask

                    height: childrenSize(this, "height", "", 0, 0, true)
                    width: childrenSize(this, "width")

                    visible: false

                    Text { //buttons_shift_text
                        id: buttons_shift_text
                        text: "shift  -  "

                        anchors.verticalCenter: buttons_shift_mask.verticalCenter

                        font.family: regular.name
                        font.pixelSize: vpx(12)
                    }

                    Image { //buttons_shift_image
                        id: buttons_shift_image
                        source: images.face_button_top

                        anchors.left: buttons_shift_text.right

                        height: vpx(24)

                        fillMode: Image.PreserveAspectFit
                    }
                }

                Rectangle { //buttons_shift_color
                    id: buttons_shift_color
                    anchors.fill: buttons_shift_mask
                    color: colors.white
                    visible: false
                }

                OpacityMask { //buttons_shift_out
                    id: buttons_shift_out
                    anchors.fill: buttons_shift_mask
                    source: buttons_shift_color
                    maskSource: buttons_shift_mask
                }
            }

            Item{ //buttons_cancel
                id: buttons_cancel

                anchors.left: buttons_shift.right
                anchors.leftMargin: vpx(12)

                height: buttons_cancel_mask.height
                width: buttons_cancel_mask.width
                
                Item { //buttons_cancel_mask
                    id: buttons_cancel_mask

                    height: childrenSize(this, "height", "", 0, 0, true)
                    width: childrenSize(this, "width")

                    visible: false

                    Text { //buttons_cancel_text
                        id: buttons_cancel_text
                        text: "cancel  -  "

                        anchors.verticalCenter: buttons_cancel_mask.verticalCenter

                        font.family: regular.name
                        font.pixelSize: vpx(12)
                    }

                    Image { //buttons_cancel_image
                        id: buttons_cancel_image
                        source: images.face_button_right

                        anchors.left: buttons_cancel_text.right

                        height: vpx(24)

                        fillMode: Image.PreserveAspectFit
                    }
                }

                Rectangle { //buttons_cancel_color
                    id: buttons_cancel_color
                    anchors.fill: buttons_cancel_mask
                    color: colors.white
                    visible: false
                }

                OpacityMask { //buttons_shift_out
                    id: buttons_cancel_out
                    anchors.fill: buttons_cancel_mask
                    source: buttons_cancel_color
                    maskSource: buttons_cancel_mask
                }
            }

            Item{ //buttons_accept
                id: buttons_accept

                anchors.left: buttons_cancel.right
                anchors.leftMargin: vpx(12)

                height: buttons_accept_mask.height
                width: buttons_accept_mask.width
                
                Item { //buttons_accept_mask
                    id: buttons_accept_mask

                    height: childrenSize(this, "height", "", 0, 0, true)
                    width: childrenSize(this, "width")

                    visible: false

                    Text { //buttons_accept_text
                        id: buttons_accept_text
                        text: "accept  -  "

                        anchors.verticalCenter: buttons_accept_mask.verticalCenter

                        font.family: regular.name
                        font.pixelSize: vpx(12)
                    }

                    Image { //buttons_accept_image
                        id: buttons_accept_image
                        source: images.start

                        anchors.left: buttons_accept_text.right

                        height: vpx(24)

                        fillMode: Image.PreserveAspectFit
                    }
                }

                Rectangle { //buttons_accept_color
                    id: buttons_accept_color
                    anchors.fill: buttons_accept_mask
                    color: colors.white
                    visible: false
                }

                OpacityMask { //buttons_shift_out
                    id: buttons_accept_out
                    anchors.fill: buttons_accept_mask
                    source: buttons_accept_color
                    maskSource: buttons_accept_mask
                }
            }
        }
    }
}
