function up(){
    if(info.currentItem.controls.up != null){
        info.currentItem = info.currentItem.controls.up
    }
    toggle_up.play()
}

function down(){
    if(info.currentItem.controls.down != null){
        info.currentItem = info.currentItem.controls.down
    }
    toggle_up.play()
}

function right(){
    if(info.currentItem.controls.right != null){
        info.currentItem = info.currentItem.controls.right
    }
    toggle_up.play()
}

function left() {
    if(info.currentItem.controls.left != null){
        info.currentItem = info.currentItem.controls.left
    }
    toggle_up.play()
}

function accept(){
    let temp = info.currentItem.controls.name
    switch(temp){
        case "favorite":
            currentGame.favorite = !currentGame.favorite
            break
        case "video":
            info.currentItem.playbackState === 1 ? info.currentItem.pause() : info.currentItem.play()
            break
        case "mute":
            info.currentItem.controls.up.muted = !info.currentItem.controls.up.muted
            break
        case "close":
            U.focusToggle()
            break
        case "play":
            if(settings.lastPlayed){
                api.memory.set("collectionIndex", currentCollectionIndex)
                api.memory.set("gameIndex", games.gameView.currentIndex)
            }
            currentGame.launch()
            break
        default:
            break
    }
    if(temp != "close"){
        select.play()
    }
}
