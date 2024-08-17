// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

Item { //developer_publisher
    id: developer_publisher

    height: childrenSize(this, "height", "topMargin")


    Rectangle { //developer
        id: developer

        anchors.left: developer_publisher.left
        anchors.right: developer_publisher.right

        height: developer_text.height + vpx(24)

        color: colors.accent_light

        visible: currentGame.developer != ""

        Rectangle { //developer_color
            id: developer_color

            anchors.right: developer.right

            width: developer_text.contentWidth + vpx(48)
            height: developer.height

            color: colors.accent
        }

        Rectangle { //developer_decor
            id: developer_decor

            anchors.top: developer.top
            anchors.bottom: developer.bottom
            anchors.right: developer_color.left
            anchors.left: developer.left
            anchors.margins: vpx(2)
            anchors.rightMargin: vpx(0)

            color: colors.t
            border.width: vpx(4)
            border.color: colors.accent
        }

        Text { //developer_text
            id: developer_text
            text: currentGame.developer

            anchors.verticalCenter: developer.verticalCenter
            anchors.left: developer.left
            anchors.right: developer.right
            anchors.margins: vpx(24)
            anchors.leftMargin: vpx(12)

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(16)

            elide: Text.ElideRight

            horizontalAlignment: Text.AlignRight
        }

        Rectangle { //developer_border
            id: developer_border

            height: developer.height
            width: developer.width

            color: colors.t
            border.width: vpx(4)
            border.color: colors.accent_light
        }
    }

    Rectangle { //publisher
        id: publisher

        anchors.top: developer.bottom
        anchors.topMargin: vpx(-3)
        anchors.left: developer_publisher.left
        anchors.right: developer_publisher.right

        height: publisher_text.height + vpx(24)

        color: colors.accent_light

        visible: currentGame.publisher != ""

        Rectangle { //publisher_color
            id: publisher_color

            height: publisher.height
            width: publisher_text.contentWidth + vpx(48)

            color: colors.accent
        }

        Rectangle { //publisher_decor
            id: publisher_decor

            anchors.top: publisher.top
            anchors.bottom: publisher.bottom
            anchors.left: publisher_color.right
            anchors.right: publisher.right
            anchors.margins: vpx(2)
            anchors.leftMargin: vpx(0)

            color: colors.t
            border.width: vpx(4)
            border.color: colors.accent
        }

        Text { //publisher_text
            id: publisher_text

            text: currentGame.publisher

            anchors.verticalCenter: publisher.verticalCenter
            anchors.left: publisher.left
            anchors.right: publisher.right
            anchors.margins: vpx(24)
            anchors.rightMargin: vpx(12)

            color: colors.text

            font.family: bold.name
            font.bold: true
            font.pixelSize: vpx(16)

            elide: Text.ElideRight
        }

        Rectangle { //publish_border
            id: publisher_border

            height: publisher.height
            width: publisher.width

            color: colors.t
            border.width: vpx(4)
            border.color: colors.accent_light
        }
    }
}
