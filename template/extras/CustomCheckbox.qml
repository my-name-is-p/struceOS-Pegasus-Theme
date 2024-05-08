// struceOS
// Copyright (C) 2024 strucep
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.0

Rectangle {
    id: checkbox
    border.color: "#ffffff"
    border.width: vpx(2)
    radius: vpx(6)

    width: vpx(24)
    height: vpx(24)

    color: state != "checked" ? "transparent" : "#ffffff"

    states: State {
        name: "checked"
        PropertyChanges { 
            target: check
            text: "✓"
        }
    }

    Text {
        id: check
        anchors.centerIn: parent
        color: "#000000"

        text: ""

        font.pointSize: vpx(12)
    }
}
