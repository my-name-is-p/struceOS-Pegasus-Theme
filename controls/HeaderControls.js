function down(){
    games.gameView.focus = true
    header.lastFocus.selected = false
    toggle.play()
}

function right(){
    header.lastFocus.selected = false
    header.lastFocus = header.lastFocus.next
    header.lastFocus.selected = true
    toggle.play()
}

function left() {
    header.lastFocus.selected = false
    header.lastFocus = header.lastFocus.prev
    header.lastFocus.selected = true
    toggle.play()
}

function accept(){
    switch(header.lastFocus.curr){
        case "utilitiesSearch":
            U.toggleSearch("searchBar")
            break
        case "utilitiesSettings":
            U.toggleSettings()
            break
        default:
            break
    }
    event.accepted = true
}
