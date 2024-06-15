function down(){
    collectionsView.collectionView_list.currentItem.incrementCurrentIndex()
}

function up(){
    collectionsView.collectionView_list.currentItem.decrementCurrentIndex()
}

function accept(){
    currentCollectionIndex = settings.allGames ? collectionsView.collectionView_list.currentItem.currentIndex - 1 : collectionsView.collectionView_list.currentItem.currentIndex
    currentCollection = U.getCollection(currentCollectionIndex)
    U.focusToggle()
    games.gameView.currentIndex = 0
    U.changeGame()
}
