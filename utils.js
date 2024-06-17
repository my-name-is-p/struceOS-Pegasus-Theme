function clog(str, tag = "", clear = false){
    let temp = consoleLog.text
    let s = "\n"
    if(!clear){
        if( tag != ""){
            temp = consoleLog.text + s + tag + ">>>"  +  s + str + s + "<<<" + tag
        } else {
            temp = consoleLog.text + s + str
        }
    } else {
        if( tag != ""){
            temp = tag + ">>>"  +  s + str + s + "<<<" + tag
        } else {
            temp = str
        }
    }
    consoleLog.text = temp
}

function focusToggle(focus = "gameView"){
    settingsPanel.state = ""
    info.video.stop()
    info.state = ""
    info.currentItem = info.play_button
    header.searchbox.state = ""
    collectionsView.collectionView_outer_wrapper.state = ""
    games.gameView.focus = "false"
    switch (focus){
        case "settings":
            settingsPanel.state = "opened"
            settingsPanel.focus = true
            break
        case "info":
            info.state = "opened" 
            info.focus = true
            info.detailsModel.populateModel()
            info.video.play()
            break
        case "search":
            header.searchbox.state = "opened"
            header.searchTerm.focus = true
            break
        case "collections":
            collectionsView.collectionView_list.currentItem.currentIndex = settings.allGames ? currentCollectionIndex + 1 : currentCollectionIndex
            collectionsView.collectionView_outer_wrapper.state = "opened"
            collectionsView.collectionView_list.focus = true
            break
        default:
            games.gameView.focus = true
            break
    }
    if(focus != "noSound")
        toggle_up.play()
}


function settingsUpdate(setting, currentValue){
    let currentValueInt = parseInt(currentValue.text)
    let currentValueFloat = parseFloat(currentValue.text)
    switch(setting){
        case "column_plus":
            if(currentValueInt < settings.columnsMax){ settings.columns++ }
            api.memory.set("struceOS_gameView_columns", settings.columns)
            break;
        case "column_minus":
            if(currentValueInt > settings.columnsMin ){ settings.columns-- }
            api.memory.set("struceOS_gameView_columns", settings.columns)
            break;
        case "general_volume_plus":
            currentValueFloat + 0.05 < 1.0 ? settings.uiVolume = (currentValueFloat + 0.05).toFixed(2) : settings.uiVolume = 1
            api.memory.set("struceOS_ui_volume", settings.uiVolume)
            break
        case "general_volume_minus":
            currentValueFloat - 0.05 > 0 ? settings.uiVolume = parseFloat((currentValueFloat - 0.05).toFixed(2)) : settings.uiVolume = 0
            api.memory.set("struceOS_ui_volume", settings.uiVolume)
            break;
        case "bg_opacity_plus":
            currentValueFloat + 0.05 < 1.0 ? settings.bgOverlayOpacity = (currentValueFloat + 0.05).toFixed(2) : settings.bgOverlayOpacity = 1
            api.memory.set("struceOS_background_overlayOpacity", settings.bgOverlayOpacity)
            break;
        case "bg_opacity_minus":
            currentValueFloat - 0.05 > 0 ? settings.bgOverlayOpacity = parseFloat((currentValueFloat - 0.05).toFixed(2)) : settings.bgOverlayOpacity = 0
            api.memory.set("struceOS_background_overlayOpacity", settings.bgOverlayOpacity)
            break;
        case "video_volume_plus":
            currentValueFloat + 0.05 < 1.0 ? settings.videoVolume = (currentValueFloat + 0.05).toFixed(2) : settings.videoVolume = 1
            api.memory.set("struceOS_video_volume", settings.videoVolume)
            break;
        case "video_volume_minus":
            currentValueFloat - 0.05 > 0 ? settings.videoVolume = parseFloat((currentValueFloat - 0.05).toFixed(2)) : settings.videoVolume = 0
            api.memory.set("struceOS_video_volume", settings.videoVolume)
            break;
        case "dev_log_opacity_plus":
            currentValueFloat + 0.05 < 1.0 ? settings.consoleLogBackground = (currentValueFloat + 0.05).toFixed(2) : settings.consoleLogBackground = 1
            api.memory.set("struceOS_dev_log_opacity", settings.consoleLogBackground)
            break;
        case "dev_log_opacity_minus":
            currentValueFloat - 0.05 > 0 ? settings.consoleLogBackground = parseFloat((currentValueFloat - 0.05).toFixed(2)) : settings.consoleLogBackground = 0
            api.memory.set("struceOS_dev_log_opacity", settings.consoleLogBackground)
            break;
        default:
            break;
    }
    select.play()
}

function getCollection(i){
    if(i >= 0){
        return api.collections.get(i)
    } else if (i === -1) {
        return {
            name: "All games",
            shortName: "allgames",
            games: api.allGames
        }
    }
}


function getAssets(assets){
    let random = assets.screenshots.length > 1 ? Math.floor(Math.random() * assets.screenshots.length) : 0
    let gotAssets = {}

    // Background
    gotAssets.bg = 
        assets.screenshots[random] != undefined ?
        assets.screenshots[random] :
            assets.screenshot != "" ?
            assets.screenshots :
                assets.background != "" ? 
                assets.background : 
                    "default"

    // Banner
    gotAssets.banner = 
        assets.steam != "" ? 
        assets.steam : 
            assets.banner != "" ? 
            assets.banner : 
                assets.boxFront != "" ? 
                assets.boxFront : 
                    assets.logo != "" ? 
                    assets.logo :
                        "default"

    // Logo
    gotAssets.logo = 
        assets.logo != "" ? 
        assets.logo : 
            assets.wheel != "" ?
            assets.wheel :
                "default"

    // Video
    gotAssets.video = 
        assets.video != "" ?
        assets.video :
            "default"

    return gotAssets
}