//gv = gameView
function up(){
    if(games.gameView.currentIndex - settings.columns >= 0){
        games.gameView.moveCurrentIndexUp()
        background.bgFadeOut.start()
    } else {
        header.focus = true
        if(header.searchTerm.text != ""){
            U.focusToggle("search")
        } else {
            let a = games.gameView.currentIndex
            let b = settings.columns - 1
            if(a < b / 2 && (b - a) > b / 2){
                header.currentItem = header.gv_up_1
            } else {
                header.currentItem = header.gv_up_2
            }
        }
    }
}

function down() {
    games.gameView.moveCurrentIndexDown()
    background.bgFadeOut.start()
}

function left() {
    games.gameView.moveCurrentIndexLeft()
    background.bgFadeOut.start()
}

function right() {
    games.gameView.moveCurrentIndexRight()
    background.bgFadeOut.start()
}

function first() {
    games.gameView.currentIndex = 0
    background.bgFadeOut.start()
}

function last() {
    games.gameView.currentIndex = games.gameView.count - 1
    background.bgFadeOut.start()
}
