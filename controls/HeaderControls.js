function down(){
    if(header.currentItem.controls.name != "collections")
        games.gameView.currentIndex = settings.columns - 1
    else
        games.gameView.currentIndex = 0
    U.focusToggle()
}

function right(){
    if(header.currentItem.controls.next != null){
        header.currentItem = header.currentItem.controls.next
    }
    toggle_up.play()
}

function left() {
    if(header.currentItem.controls.prev != null){
        header.currentItem = header.currentItem.controls.prev
    }
    toggle_up.play()
}

function accept(){
    if(header.currentItem.controls.name != "favorite")
        U.focusToggle(header.currentItem.controls.name)
    else
        header.favorite.filterEnabled = !header.favorite.filterEnabled
        //games.gameView.currentIndex = 0
        toggle_up.play()
}
