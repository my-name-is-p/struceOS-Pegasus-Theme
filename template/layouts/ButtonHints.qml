// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15
import "parts/buttonhints"

Rectangle {
    id: button_hints

    height: vpx(72)

    color: addAlphaToHex(0.6, colors.accent)

    Item {
        id: hints

        anchors.centerIn: parent

        height: childrenSize(this, "height", "", 0, 0,  true)
        width: childrenSize(this, "width", "leftMargin")

        property real margins: vpx(48)

        Navigate {
            id: navigate
        }

        Accept {
            id: accept
            text: "select"
            
            anchors.left: navigate.right
            anchors.leftMargin: hints.margins
        }

        PrevNext {
            id: prevnext
            text: f === panel_area && panel_area.current === panel_area.info_panel ? "- game +" : 
                        f === panel_area && panel_area.current === panel_area.settings_panel ? 
                            "- page +" : "- collection +"

            anchors.left: accept.right
            anchors.leftMargin: hints.margins
        }

        SortFilt {
            id: sortfilt
            text: f === panel_area && f.current === panel_area.info_panel ? 
                        currentGame.favorite ?
                            "unfavorite" : "favorite":
                    f === sortfilt_menu ? "close sort / filter" : "sort / filter"

            anchors.left: prevnext.right
            anchors.leftMargin: hints.margins
        }

        Details {
            id: details
            text: f === panel_area && panel_area.current === panel_area.info_panel ? "close details" : "details"

            anchors.left: sortfilt.right
            anchors.leftMargin: hints.margins
        }
    }
}