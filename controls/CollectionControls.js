function down(){
    if(collectionsView.collectionView_list.currentItem.currentIndex + 1 < collectionsView.collectionView_list.currentItem.count) {
        collectionsView.collectionView_list.currentItem.currentIndex++
    } else {
        collectionsView.collectionView_list.currentItem.currentIndex = 0
    }
    select.play()
}

function up(){
    if(collectionsView.collectionView_list.currentItem.currentIndex - 1 >= 0) {
        collectionsView.collectionView_list.currentItem.currentIndex--
    } else {
        collectionsView.collectionView_list.currentItem.currentIndex = collectionsView.collectionView_list.currentItem.count - 1
    }
    select.play()
}

function accept(){
    currentCollectionIndex = collectionsView.collectionView_list.currentItem.currentIndex
    currentCollection = U.getCollection(currentCollectionIndex)
    U.toggleCollections()
    games.gameView.currentIndex = 0
    currentBG = U.getAsset(currentGame, currentGame.assets, "bg")
    U.clog('collection accept')
}
