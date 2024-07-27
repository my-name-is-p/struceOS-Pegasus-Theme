// struceOS
// Copyright (C) 2024 strucep

import QtQuick 2.15
import QtGraphicalEffects 1.15
import "parts/buttonhints-displays"

Rectangle {
    id: button_hints

    height: vpx(72)

    color: addAlphaToHex(0.6, settings.color_accent)

    Item {
        id: hints
        anchors.centerIn: parent

        property real margins: vpx(36)

        height: { //height
            let h = 0
            for (var i = 0; i < children.length; i++) {
                h = children[i].height > h ? children[i].height : h
            }
            return h;
        }

        width: { //width
            let sum = 0
            for (var i = 0; i < children.length; i++) {
                sum += children[i].width + children[i].anchors.leftMargin
            }
            return sum;
        }

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

            text: f.current === panel_area.info_panel ? "- game +" : 
                        f.current === panel_area.settings_panel ? 
                            "- page +" : "- collection +"

            anchors.left: accept.right
            anchors.leftMargin: hints.margins
        }

        SortFilt {
            id: sortfilt

            text: f.current === panel_area.info_panel ? 
                        currentGame.favorite ?
                            "unfavorite" : "favorite":
                    f === sortfilt_menu ? "close sort / filter" : "sort / filter"


            anchors.left: prevnext.right
            anchors.leftMargin: hints.margins
        }

        Details {
            id: details

            text: f.current === panel_area.info_panel ? "close details" : "details"

            anchors.left: sortfilt.right
            anchors.leftMargin: hints.margins
        }
    }
}
    //details
