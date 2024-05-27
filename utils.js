

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

function bgFadeOutIn(){
    background.bgFadeOut.start()
}

function changeGame(){
    bgFadeOutIn()
}

function toggleSettings(focus = "utilitiesSettings"){
    if(settingsPanel.state != "opened"){
        settingsPanel.state = "opened"
    } else {
        settingsPanel.state = ""
        if(focus != "gameView")
            focus ="utilitiesSettings"
    }
    updateFocus(focus)
    toggle.play()
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

function toggleInfo(focus = "info"){
    if(info.state != "opened"){
        info.state = "opened" 
        info.video.play()
    }else{
        info.state = ""
        info.video.stop()
        focus = "gameView"
    }
    updateFocus(focus)
    toggle.play()
}

function toggleSearch(focus){
    if((header.searchTerm.focus && focus === "utilitiesSearch") && focus !="searchBar"){
        focus = "gameView" 
    }
    if(header.searchbox.state != "opened"){
        header.searchbox.state = "opened"
    } else if(header.searchTerm.text === ""){
        header.searchbox.state = ""
    }
    updateFocus(focus)
    toggle.play()
}

function toggleCollections(focus = "collections"){
    if(collectionsView.collectionView_outer_wrapper.state != "opened"){
        collectionsView.collectionView_outer_wrapper.state = "opened"
        collectionsView.collectionView_list.currentItem.currentIndex = 0
    } else {
        collectionsView.collectionView_outer_wrapper.state = ""
        focus = "gameView"
    }
    updateFocus(focus)
    toggle.play()
}


function updateFocus(focus) {
    switch (focus) {
        case "header":
            header.focus = true
            break
        case "gameView":
            games.gameView.focus = true
            break
        case "searchBar":
            header.searchTerm.focus = true
            break
        case "settings":
            settingsPanel.focus = true
            break
        case "utilitiesSearch":
            header.utilitiesSearch.focus = true
            break
        case "utilitiesSettings":
            header.focus = true
            header.utilitiesSettings.selected = true
            header.lastFocus = header.utilitiesSettings
            break
        case "info":
            info.focus = true
            break
        case "collections":
            collectionsView.collectionView_list.focus = true
            break
        default:
            root.focus = true
    }
}

function removeButtonFocusOnClick(buttons="all") {
    switch(buttons){
        case "header":
            header.utilitiesSearch.focus = false
            header.utilitiesSettings.focus = false
            header.utilitiesInfo.focus = false
            header.collectionTitle.focus = false
            
            header.utilitiesSearch.selected = false
            header.utilitiesSettings.selected = false
            header.utilitiesInfo.selected = false
            header.collectionTitle.selected = false
            break
        default:
            header.utilitiesSearch.focus = false
            header.utilitiesSettings.focus = false
            header.utilitiesInfo.focus = false
            header.collectionTitle.focus = false
            
            header.utilitiesSearch.selected = false
            header.utilitiesSettings.selected = false
            header.utilitiesInfo.selected = false
            header.collectionTitle.selected = false
    }
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

function generalClose(closee= "", focus = "gameView"){
    if(closee !=""){

    } else {
        info.state = ""
        collectionsView.collectionView_outer_wrapper.state = ""
    }
    updateFocus(focus)
}

function getAsset(data, assets, type = "", log = false) {
    var shortName = data.collections.get(0).shortName.toString()
    if(log){
        let temp = []
        for (const [key, value] of Object.entries(assets)) {
            if(value != ""){
                temp.push(`${key}: ${value}` + "\n");
            }
        }
    }

    let source = ""
    switch(shortName){
        case "gog":
            switch(type){
                case "bg":
                    let i = Math.floor(Math.random() * assets.screenshots.length)
                    source = assets.screenshots[i]
                    break;
                case "banner":
                    source = assets.boxFront
                    break;
                default:
                    break;
            }
            break;

            case "steam":
                switch(type){
                    case "bg":
                        let i = Math.floor(Math.random() * assets.screenshots.length)
                        source = assets.screenshots[i]
                        break;
                    case "banner":
                        source = assets.steam
                        break;
                    default:
                        break;
                }
                break;

            default:
            break;
    }

    if(source === ""){
        switch(type){
            case "bg":
                source = assets.background != "" ? assets.background : assets.screenshot
                break;
            case "banner":
                source = assets.banner != "" ? assets.banner : assets.boxFront != "" ? assets.boxFront : assets.logo
                break;
            case "logo":
                source = assets.logo
                break;
            case "video":
                source = assets.video
                break;
            default:
                break;
        }
    }
    return source != "" ? source : type !="bg" ? "../assets/" + settings.defaultGameImage : ""
}
