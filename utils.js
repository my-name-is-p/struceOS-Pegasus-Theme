// struceOS
// Copyright (C) 2024 my_name_is_p

//launchGame
function launchGame(){
    log(currentGame)
    launch_window.visible = true
    if(settings.lastPlayed){
        api.memory.set("collectionIndex", currentCollectionIndex)
        api.memory.set("gameIndex", games.currentIndex)
    }
    s = audio.toggle_down
    currentGame.launch()
}

// GetSimpleKeys
// returns a simplfied control set
function gsk(event) {
    if(isNaN(parseInt(event.text))){
        let key = event.key
        //not a switch because checking enum and event -- remember not to try changing
        if(key == Qt.Key_Left || key == Qt.Key_A)
            return "left"
        if(key == Qt.Key_Right || key == Qt.Key_D)
            return "right"
        if(key == Qt.Key_Up || key == Qt.Key_W)
            return "up"
        if(key == Qt.Key_Down || key == Qt.Key_S)
            return "down"
        if(api.keys.isNextPage(event) || key == Qt.Key_Equal)
            return "next"
        if(api.keys.isPrevPage(event) || key == Qt.Key_Minus)
            return "prev"
        if(api.keys.isPageUp(event))
            return "first"
        if(api.keys.isPageDown(event))
            return "last"
        if(api.keys.isFilters(event))
            return "sort"
        if(api.keys.isDetails(event))
            return "details"
        if((api.keys.isAccept(event) || key == Qt.Key_Space) && !event.isAutoRepeat)
            return "accept"
        if(api.keys.isCancel(event))
            return "cancel"
    }else{
        return parseInt(event.text)
    }
    return undefined
}

function childrenSize(element, size = "", margin = "", start = 0, i = 0, max = false){
    let r = vpx(start)
    if(
        !(element != undefined) && 
        !(size === "width" || size === "height") 
    )
        return 0
    for(const [key, child] of Object.entries(element.children)){
        if(key >= i){
            if(!max){
                if(child.anchors[margin])
                    r = r + child.anchors[margin]
                r = r + child[size]
            }else{
                r = child[size] > r ? child[size] : r
            }
        }
    }
    return r
}

//getAssets
function getAssets(assets){
    let random = assets.screenshots.length > 1 ? Math.floor(Math.random() * assets.screenshots.length) : 0
    let gotAssets = {}

    // Background
    gotAssets.bg = 
        assets.screenshots[random] != undefined ?
        assets.screenshots[random] :
            assets.screenshot != "" ?
            assets.screenshot :
                assets.background != "" ? 
                assets.background : 
                    assets.banner != "" ? 
                    assets.banner : 
                        assets.boxFront != "" ? 
                        assets.boxFront : 
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
                "default"

    // Video
    gotAssets.video = 
        assets.video != "" ?
        assets.video :
            "default"
    return gotAssets
}

//log
function log(str = "", tag = false, clear = false){
    let s = "\n"
    if(tag)
        str = "[>--| " + str + " |--<]"
    if(!clear){
        str = devtools.log_text.text + s + str
    } else {
        str = str
    }
    devtools.log_text.text = str
}

//alphaDecToHex - Converts Decimal alpha value to Hex value
function alphaDecToHex(alpha) {
    return Math.round(Math.max(0, Math.min(alpha, 1)) * 255).toString(16).toUpperCase().padStart(2, '0')
}

//addAlphaToHex - Adds an alpha value to a standard 6-digit Hex code
function addAlphaToHex(alpha, hex) {
    hex = hex.replace(/^#/, '')

    if(!validateHex(hex))
        return

    const alphaHex = alphaDecToHex(alpha)

    return `#${alphaDecToHex(alpha)}${hex}`
}

//validateHex
function validateHex(hex){
    hex = hex.replace(/^#/, '')
    if (!/^[0-9a-f]{6}$/i.test(hex)) 
        return false
    else 
        return true
}

//collectionNext
function collectionNext(){
    games.currentIndex = 0
    if(currentCollectionIndex != api.collections.count - 1){
        currentCollectionIndex++
    }else{
        if(settings.allGames)
            currentCollectionIndex = -1
        else
            currentCollectionIndex = 0
    }
    collection_menu.positionViewAtCurrentIndex()
    background.refresh()
}

//collectionPrevious
function collectionPrevious(){
    games.currentIndex = 0
    if(currentCollectionIndex != -1){
        if(currentCollectionIndex != 0){
            currentCollectionIndex--
        }else{
            if(settings.allGames)
                currentCollectionIndex = -1
            else
                currentCollectionIndex = api.collections.count - 1
        }
    }else{
        currentCollectionIndex = api.collections.count - 1
    }
    collection_menu.positionViewAtCurrentIndex()
    background.refresh()
}

function resetFocus(c = game_layout){
    video.reset()
    f = background
    f = c
}

//logVideoStates
function logVideoStates(){
    log("--video.status--")
    log("NoMedia: " + MediaPlayer.NoMedia)
    log("Loading: " + MediaPlayer.Loading)
    log("Loaded: " + MediaPlayer.Loaded)
    log("Buffering: " + MediaPlayer.Buffering)
    log("Stalled: " + MediaPlayer.Stalled)
    log("Buffered: " + MediaPlayer.Buffered)
    log("EndOfMedia: " + MediaPlayer.EndOfMedia)
    log("InvalidMedia: " + MediaPlayer.UnknownStatus)
    log("--video.playbackState--")
    log("PlayingState: " + MediaPlayer.PlayingState)
    log("PausedState: " + MediaPlayer.PausedState)
    log("StoppedState: " + MediaPlayer.StoppedState)
}


//logFocus
function logFocus(){
    log("root: " + root.focus)
    // log("settings: " + settings.focus)
    log("search: " + search.focus)
    log("audio: " + audio.focus)
    log("images: " + images.focus)
    log("background: " + background.focus)
    log("header: " + header.focus)
    log("collection_menu: " + collection_menu.focus)
    log("panel_area: " + panel_area.focus)
    log("sortfilt_toolbar: " + sortfilt_toolbar.focus)
    log("sortfilt_menu: " + sortfilt_menu.focus)
    log("game_layout: " + game_layout.focus)
    log("launch_window: " + launch_window.focus)
}

//clearMemory
function clearMemory(){
    log("memory cleared -- may require restart")
    api.memory.unset("collectionIndex")
    api.memory.unset("gameIndex")
    api.memory.unset("struceOS_ui_headerSize")
    api.memory.unset("struceOS_ui_twelvehour")
    api.memory.unset("struceOS_video_videoMute")
    api.memory.unset("struceOS_video_volume")
    api.memory.unset("struceOS_ui_Mute")
    api.memory.unset("struceOS_ui_volume")
    api.memory.unset("struceOS_gameLayout_columns")
    api.memory.unset("struceOS_gameLayout_lastPlayed")
    api.memory.unset("struceOS_gameLayout_allGames")
    api.memory.unset("struceOS_gameLayout_thumbnails")
    api.memory.unset("struceOS_background_overlayOn")
    api.memory.unset("struceOS_background_overlayOpacity")
    api.memory.unset("struceOS_dev_enableDevTools")
    api.memory.unset("struceOS_dev_log_opacity")
    api.memory.unset("struceOS_ui_buttonHints")
    api.memory.set("struceOS_background_overlaySource", images.overlay_0002)
    api.memory.set("struceOS_theme_colors", settings.default_theme)
    f = game_layout
}

//checkSettings
function checkSettings(){
    log(settings.fontFamilyRegular)
    log(settings.fontFamilyBold)
    log(settings.hover_speed)
    log(settings.headerSize)
    log(settings.twelvehour)
    log(settings.videoMute)
    log(settings.videoVolume)
    log(settings.uiMute)
    log(settings.uiVolume)
    log(settings.columns)
    log(settings.lastPlayed)
    log(settings.allGames)
    log(settings.showThumbs)
    log(settings.bgOverlayOn)
    log(settings.bgOverlayOpacity)
    log(settings.enableDevTools)
    log(settings.consoleLogBackground)
    log(settings.version)
    log(settings.name)
    log(settings.working)
    log(settings.theme)
}