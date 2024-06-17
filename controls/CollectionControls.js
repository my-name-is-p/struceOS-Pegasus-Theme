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
    background.bgFadeOut.start()
}


function down(){
    collectionsView.collectionView_list.currentItem.incrementCurrentIndex()
}

function up(){
    collectionsView.collectionView_list.currentItem.decrementCurrentIndex()
}

function left(){
    collectionsView.collectionView_list.currentItem.currentIndex = 0 
}

function right(){
    collectionsView.collectionView_list.currentItem.currentIndex = collectionsView.collectionView_list.currentItem.count - 1
}


function accept(){
    currentCollectionIndex = settings.allGames ? collectionsView.collectionView_list.currentItem.currentIndex - 1 : collectionsView.collectionView_list.currentItem.currentIndex
    currentCollection = U.getCollection(currentCollectionIndex)
    U.focusToggle()
    games.gameView.currentIndex = 0
    background.bgFadeOut.start()
}
