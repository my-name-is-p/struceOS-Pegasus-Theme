function alphaDecToHex(alpha) {
    // let t = Math.round(Math.max(0, Math.min(alpha, 1)) * 255)
    // t = t.toString(16).toUpperCase()
    // t = t.padStart(2, '0')
    //return t
    
    //condensed
    return Math.round(Math.max(0, Math.min(alpha, 1)) * 255).toString(16).toUpperCase().padStart(2, '0')
}

function addAlphaToHex(alpha, hex) {
    hex = hex.replace(/^#/, '')

    if (!/^[0-9a-f]{6}$/i.test(hex)) {
        throw new Error('Invalid hex code format (must be 6 digits)')
    }

    const alphaHex = alphaDecToHex(alpha)

    return `#${alphaDecToHex(alpha)}${hex}`
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