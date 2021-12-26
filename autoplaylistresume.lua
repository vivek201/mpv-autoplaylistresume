needToAutoplay = false
autoplayComplete = false
playlistHistoryPos = nil
playlistName = nil

historyFileName = 'mpvPlaylistHistory.log'
historyFileLocation = mp.find_config_file("."):gsub(".$", "") .. historyFileName

mp.add_hook('on_load', 50, function () 
    fileName = mp.get_property("filename");
    fileExtension = string.match(fileName, "^.+(%..+)$");
    if fileExtension ~= nil and fileExtension == '.m3u' then
        needToAutoplay = true
        playlistName = fileName
        -- check if history exists for playlist
        local history = readHistoryIntoTable()

        if history[playlistName] ~= nil and autoplayComplete == false then
            playlistHistoryPos = history[playlistName]
            mp.osd_message("History found for playlist", 5)
        else
            print("No history found for playlist: " .. playlistName)
        end
    elseif needToAutoplay then
        if autoplayComplete == false and playlistHistoryPos ~= nil then
            mp.osd_message("Autoplaying item #" .. playlistHistoryPos, 5)
            mp.commandv("playlist-play-index", playlistHistoryPos)
            autoplayComplete = true
        else
            local playlistPos = mp.get_property('playlist-pos')
            print('Current playing item #' .. playlistPos);
    
            local history = readHistoryIntoTable()
            history[playlistName] = playlistPos
    
            saveHistoryToFile(history)
        end
    end
end)

function readHistoryIntoTable() 
    local file = io.open(historyFileLocation, 'r')
    local filemap = {}
    if file ~= nil then
        for line in file:lines() do
            if string.match(line, ".*.m3u|<%d+>") then
                filemap[string.match(line, "(.*.m3u)|<%d+>")] = tonumber(string.match(line, ".*.m3u|<(%d+)>"))
            end
        end
        file:close()
    end
    return filemap
end

function saveHistoryToFile(history)
    if history ~= nil then
        local file = io.open(historyFileLocation, 'w+');
        for key, value in pairs(history) do
            file:write(string.format("%s|<%s>", key, value))
        end
        file:close()
    end
end
