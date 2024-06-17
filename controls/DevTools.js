function clearMemory(type = "all"){
    switch(type){
        default:
            api.memory.unset("struceOS_gameView_croppedThumbnails")
            break
    }
}

