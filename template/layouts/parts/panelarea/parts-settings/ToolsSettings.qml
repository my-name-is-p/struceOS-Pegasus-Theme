// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "../../../../widgets"

Item {
    id: page

    property bool selected: false
    property var current: theme_info_donation_link

    //Functions--
        function reset(){
            page.current = theme_info_donation_link
        }
    
        property var onUp: current.onUp
        property var onDown: current.onDown
        property var onLeft: current.onLeft
        property var onRight: current.onRight
        property var onPrevious: current.onPrevious
        property var onNext: current.onNext
        property var onFirst: current.onFirst
        property var onLast: current.onLast
        property var onDetails: current.onDetails
        property var onSort: current.onSort
        property var onCancel: current.onCancel
        property var onAccept: current.onAccept
    //--

    Item { //theme_info
        id: theme_info

        anchors.top: page.top
        anchors.left: page.left
        anchors.right: page.right
        anchors.margins: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Text { //theme_info_author
            id: theme_info_author
            text: "author: " + settings.author
            color: colors.text

            font.family: regular.name
            font.pixelSize: vpx(10)
        }
        
        Text { //theme_info_name
            id: theme_info_name
            text: "name: " + settings.name
            color: colors.text

            anchors.top: theme_info_author.bottom

            font.family: regular.name
            font.pixelSize: vpx(10)
        }

        Text { //theme_info_version
            id: theme_info_version
            text: "version: " + settings.version  + (settings.working ? "-working" : "")
            color: colors.text

            anchors.top: theme_info_name.bottom

            font.family: regular.name
            font.pixelSize: vpx(10)
        }

        DonationButton { //theme_info_donation_link
            id: theme_info_donation_link

            anchors.top: theme_info_version.bottom
            anchors.topMargin: vpx(6)

            //Functions--
                function onDown(){
                    page.current = general_tools_settings_osk
                }
                selected: page.selected && page.current === this

                function onAccept(){
                    Qt.openUrlExternally(theme_info_donation_link.link)
                }
            //--
        }
    }

    Item { //general_tools_settings
        id: general_tools_settings

        anchors.top: theme_info.bottom
        anchors.left: page.left
        anchors.right: page.right
        anchors.margins: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Text { //general_tools_settings_title
            id: general_tools_settings_title
            text: "General"

            anchors.top: general_tools_settings.top
            
            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }

        ToggleBox { //general_tools_settings_osk
            id: general_tools_settings_osk
            text: "onscreen keyboard"

            anchors.top: general_tools_settings_title.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.osk

            //Functions--
                onClicked: function(){
                    settings.osk = !value
                    api.memory.set("struceOS_ui_osk", settings.osk)
                }
                property var onAccept: onClicked

                function onUp(){
                    page.current = theme_info_donation_link
                }

                function onDown(){
                    page.current = general_tools_settings_button_hints
                }
            //--
        }

        ToggleBox { //general_tools_settings_button_hints
            id: general_tools_settings_button_hints
            text: "button hints"

            anchors.top: general_tools_settings_osk.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.buttonHints

            onClicked: function(){
                settings.buttonHints = !value
                api.memory.set("struceOS_ui_buttonHints", settings.buttonHints)
            }
            property var onAccept: onClicked

            function onUp(){
                page.current = general_tools_settings_osk
            }

            function onDown(){
                page.current = general_tools_settings_screensaver_timeout_slider
            }
        }

        Item { //general_tools_settings_screensaver_timeout
            id: general_tools_settings_screensaver_timeout

            anchors.top: general_tools_settings_button_hints.bottom
            anchors.topMargin: vpx(12)
            anchors.left: general_tools_settings.left
            anchors.right: general_tools_settings.right

            height: childrenSize(this, "height", "", 0, 0, true)

            Text { //devtools_settings_opacity_text
                id: general_tools_settings_screensaver_timeout_text
                text: "screensaver timeout (in seconds)"

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //general_tools_settings_screensaver_timeout_slider
                id: general_tools_settings_screensaver_timeout_slider

                anchors.left: general_tools_settings_screensaver_timeout_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: general_tools_settings_screensaver_timeout.right

                min: 1
                max: 600

                value: (settings.screensaverTimeout)
                memory: "struceOS_screensaver_timeout"

                selected: page.selected && page.current === this

                //Functions--
                    function onUp(){
                        if(current.onUp)
                            current.onUp()
                        else
                            page.current = general_tools_settings_button_hints
                    }

                    function onDown(){
                        if(current.onDown)
                            current.onDown()
                        else
                            page.current = devtools_settings_opacity_slider
                    }
                //--
            }
        }
    }

    Item { //devtools_settings
        id: devtools_settings

        anchors.top: general_tools_settings.bottom
        anchors.left: page.left
        anchors.right: page.right
        anchors.margins: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Text { //devtools_settings_title
            id: devtools_settings_title
            text: "Devtools"

            anchors.top: devtools_settings.top
            
            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }

        Item { //devtools_settings_opacity
            id: devtools_settings_opacity

            anchors.top: devtools_settings_title.bottom
            anchors.topMargin: vpx(12)
            anchors.left: devtools_settings.left
            anchors.right: devtools_settings.right

            height: childrenSize(this, "height", "", 0, 0, true)

            Text { //devtools_settings_opacity_text
                id: devtools_settings_opacity_text
                text: "log opacity"

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //devtools_settings_opacity_slider
                id: devtools_settings_opacity_slider

                anchors.left: devtools_settings_opacity_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: devtools_settings_opacity.right

                min: 1
                max: 100

                value: (settings.consoleLogBackground*100)
                percent: true
                memory: "struceOS_dev_log_opacity"

                selected: page.selected && page.current === this

                //Functions--
                    function onUp(){
                        if(current.onUp)
                            current.onUp()
                        else
                            page.current = general_tools_settings_screensaver_timeout_slider
                    }

                    function onDown(){
                        if(current.onDown)
                            current.onDown()
                        else
                            page.current = devtools_settings_on
                    }
                //--
            }
        }

        ToggleBox { //devtools_settings_on
            id: devtools_settings_on
            text: "show log"

            anchors.top: devtools_settings_opacity.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.enableDevTools

            //Functions--
                onClicked: function(){
                    settings.enableDevTools = !value
                    api.memory.set("struceOS_dev_enableDevTools", settings.enableDevTools)
                    if(settings.enableDevTools){
                        if(devtools.log_text.text.indexOf(settings.details) === -1)
                            devtools.log_text.text = settings.details + devtools.log_text.text
                        log(" log: open ", true)
                    }else{
                        log("log: closed", true)
                    }
                    
                }
                property var onAccept: onClicked

                function onUp(){
                    page.current = devtools_settings_opacity_slider
                }
            //--
        }
    }
}