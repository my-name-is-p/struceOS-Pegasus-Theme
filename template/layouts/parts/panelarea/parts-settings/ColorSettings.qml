// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import QtGraphicalEffects 1.15

import "../../../../widgets"
import "colors"
import "radio"

Item {
    id: page

    property bool selected: false
    property var current: background_settings_overlay_on

    //Functions--
        function reset(){
            page.current = background_settings_overlay_on
            color_options.currentIndex = 0
            color_options.model.populateModel()
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
    //

    Item { //background_settings
        id: background_settings

        anchors.top: page.top
        anchors.left: page.left
        anchors.right: page.right
        anchors.margins: vpx(12)

        height: childrenSize(this, "height", "topMargin")

        Text { //background_settings_title
            id: background_settings_title
            text: "Background"

            anchors.top: background_settings.top

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)
        }

        ToggleBox { //background_settings_overlay_on
            id: background_settings_overlay_on
            text: "overlay on"

            anchors.top: background_settings_title.bottom
            anchors.topMargin: vpx(12)

            selected: page.selected && page.current === this
            value: settings.bgOverlayOn

            //Functions--
                onClicked: function(){
                    settings.bgOverlayOn = !value
                    api.memory.set("struceOS_background_overlayOn", settings.bgOverlayOn)
                }
                property var onAccept: onClicked

                function onDown(){
                    page.current = background_settings_overlay_opacity_slider
                }
            //--
        }

        Item { //background_settings_overlay_opacity
            id: background_settings_overlay_opacity

            anchors.top: background_settings_overlay_on.bottom
            anchors.topMargin: vpx(12)
            anchors.left: background_settings.left
            anchors.right: background_settings.right

            height: childrenSize(this, "height", "", 0, 0, true)

            Text { //background_settings_overlay_opacity_text
                id: background_settings_overlay_opacity_text
                text: "overlay opacity"

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            SliderBar { //background_settings_overlay_opacity_slider
                id: background_settings_overlay_opacity_slider

                anchors.left: background_settings_overlay_opacity_text.right
                anchors.leftMargin: vpx(12)
                anchors.right: background_settings_overlay_opacity.right

                min: 1
                max: 100

                value: (settings.bgOverlayOpacity*100)
                percent: true
                selected: page.selected && page.current === this
                memory: "struceOS_background_overlayOpacity"

                //Functions--
                    function onUp(){
                        if(current.onUp)
                            current.onUp()
                        else
                            page.current = background_settings_overlay_on
                    }

                    function onDown(){
                        if(current.onDown)
                            current.onDown()
                        else
                            page.current = background_settings_overlay_style_radio
                    }
                //--
            }
        }

        Item { //background_settings_overlay_style
            id: background_settings_overlay_style

            anchors.top: background_settings_overlay_opacity.bottom
            anchors.topMargin: vpx(12)
            anchors.left: background_settings.left
            anchors.right: background_settings.right

            height: childrenSize(this, "height", "", 0, 0, true)

            Text { //background_settings_overlay_style_text
                id: background_settings_overlay_style_text
                text: "overlay style"

                color: colors.text

                font.family: regular.name
                font.pixelSize: vpx(16)
            }

            OverlayStyleRadio { //background_settings_overlay_style_radio
                id: background_settings_overlay_style_radio

                anchors.right: background_settings_overlay_style.right
                anchors.verticalCenter: background_settings_overlay_style.verticalCenter

                selected: page.selected && page.current === this

                //Functions
                    function onUp(){
                        if(current.onUp)
                            current.onUp()
                        else
                            page.current = background_settings_overlay_opacity_slider
                    }

                    function onDown(){
                        if(current.onDown)
                            current.onDown()
                        else
                            page.current = color_settings_title
                    }
                //--
            }
        }
    }

    Item { //color_settings
        id: color_settings

        anchors.top: background_settings.bottom
        anchors.bottom: page.bottom
        anchors.left: page.left
        anchors.right: page.right
        anchors.margins: vpx(12)
        anchors.bottomMargin: 0

        height: childrenSize(this, "height", "topMargin")

        property bool selected: page.selected && page.current === this
        property var current: color_settings_title

        Text { //color_settings_title
            id: color_settings_title
            text: "Colors"

            anchors.top: color_settings.top

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(24)

            property bool selected: page.selected && page.current === this

            //Functions--
                function onUp(){
                    page.current = background_settings_overlay_style_radio
                }

                function onAccept(){
                    settings.theme = JSON.parse(JSON.stringify(settings.default_theme))
                    api.memory.unset("struceOS_theme_colors")
                    colors_loader.sourceComponent = undefined
                    colors_loader.sourceComponent = colors_component
                    color_options.model.populateModel()
                }

                function onDown(){
                    color_options.currentIndex = 0
                    page.current = color_options
                }
            //--

            UIButton { //reset_button
                id: reset_button
                icon: images.refresh
                icon_color: colors.text
                sound: audio.toggle_down

                anchors.left: color_settings_title.right
                anchors.leftMargin: vpx(6)
                anchors.verticalCenter: color_settings_title.verticalCenter

                selected: color_settings_title.selected

                onClicked: function(){
                    settings.theme = JSON.parse(JSON.stringify(settings.default_theme))
                    api.memory.unset("struceOS_theme_colors")
                    colors_loader.sourceComponent = undefined
                    colors_loader.sourceComponent = colors_component
                    color_options.model.populateModel()
                }
            }
        }

        GridView { //color_options
            id: color_options

            model: ColorsModel{}
            delegate: ColorsGridItem{}

            anchors.top: color_settings_title.bottom
            anchors.topMargin: vpx(16)
            anchors.left: color_settings.left
            anchors.right: color_settings.right
            anchors.bottom: color_settings.bottom

            cellWidth: width / 2
            cellHeight: vpx(36)

            flow: GridView.FlowTopToBottom

            property bool selected: page.selected && page.current === this

            //Functions
                function onUp(){
                    if(currentIndex <= 0)
                        page.current = color_settings_title
                    else{
                        moveCurrentIndexUp()
                    }
                }

                function onDown(){
                    moveCurrentIndexDown()
                }

                function onLeft(){
                    moveCurrentIndexLeft()
                }

                function onRight(){
                    moveCurrentIndexRight()
                }

                property var onAccept: currentItem.onAccept
            //--
        }
    }
}