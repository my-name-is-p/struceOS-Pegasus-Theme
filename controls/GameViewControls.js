//gv = gameView
function changeCollection(event,i){
        if(api.keys.isNextPage(event)){
            if(currentCollectionIndex === -1){
                    currentCollectionIndex = 0
            } else {
                currentCollectionIndex >= api.collections.count - 1 ? currentCollectionIndex = allGames : currentCollectionIndex++
            }
        } else {
            if(currentCollectionIndex === -1){
                currentCollectionIndex = api.collections.count - 1
            } else {
                currentCollectionIndex <= 0 ? currentCollectionIndex = (allGames != 0 ? -1 : api.collections.count - 1) : currentCollectionIndex--
            }
        }
        U.focusToggle()
        currentCollection = U.getCollection(currentCollectionIndex)
        games.gameView.currentIndex = 0
    U.bgFadeOutIn()
}


function up(){
    if(games.gameView.currentIndex - settings.columns >= 0){
        games.gameView.currentIndex = games.gameView.currentIndex - settings.columns
    } else {
        header.focus = true
        if(header.searchTerm.text != ""){
            U.focusToggle("search")
        } else {
            let a = games.gameView.currentIndex
            let b = settings.columns - 1
            if(a < b / 2 && (b - a) > b / 2){
                header.currentItem = header.gv_up_1
            } else if (a != b) {
                header.currentItem = header.gv_up_2
            } else {
                header.currentItem = header.gv_up_3
            }
        }
        toggle_up.play()
    }
}

function down() {
    if(games.gameView.currentIndex + settings.columns < games.gameView.count){
        games.gameView.currentIndex = games.gameView.currentIndex + settings.columns
    } else {
        games.gameView.currentIndex = games.gameView.count - 1
    }
}

function left() {
    if(games.gameView.currentIndex - 1 >= 0){
        games.gameView.currentIndex = games.gameView.currentIndex - 1
    } else {
        games.gameView.currentIndex = 0
    }
}

function right() {
    if(games.gameView.currentIndex + 1 < games.gameView.count){
        games.gameView.currentIndex = games.gameView.currentIndex + 1
    } else {
        games.gameView.currentIndex = games.gameView.count - 1
    }
}

function first() {
    games.gameView.currentIndex = 0
}

function last() {
    games.gameView.currentIndex = games.gameView.count - 1
}
