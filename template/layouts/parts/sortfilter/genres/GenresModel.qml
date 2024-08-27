// struceOS
// Copyright (C) 2024 my_name_is_p

import QtQuick 2.15

ListModel {
    id: genres_model

    function getGenres(){
        let genres = new Set()
        for (let i = 0; i < currentCollection.games.count; i++) {
            let genreList = currentCollection.games.get(i).genre.replace(/ ?\/ ?|,/g, ",").split(",")
            genreList.forEach(function(genre){
                if(genre)
                    genres.add(genre.trim())
            })
        }
        genres = Array.from(genres).sort()
        return genres
    }

    function populateModel() {
        clear()
        let genres = getGenres()
        genres.forEach(function(genre){
            append({genre: genre})
        })
    }
    
    Component.onCompleted: {
        populateModel()
    }
}
