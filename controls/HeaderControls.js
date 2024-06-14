function down(){
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
    U.focusToggle(header.currentItem.controls.name)
}
