local PLUGIN = PLUGIN


PLUGIN:RegisterArgumentType("Player", function(argument)
    local matches = {}

    for _, ply in _player.Iterator() do
        if string.find(string.lower(ply:Nick()), string.lower(argument), 1, true) then
            table.insert(matches, ply:Nick())
        end
    end

    return matches
end)

PLUGIN:RegisterArgumentType("Weather", function(argument)
    local matches = {}

    for weather, _ in pairs(cwWeather.weatherTypes) do
        if string.find(string.lower(weather), string.lower(argument), 1, true) then
            table.insert(matches, weather)
        end
    end

    return matches

end)

PLUGIN:RegisterArgumentType("Rank", function(argument, args)

    if !args or !args[1] then return {} end

    local plystr = string.gsub(args[1], "\"", "")

    local target = Clockwork.player:FindByID(plystr)

    local ranks = {}


    if target then
        ranks = Schema.Ranks[target:GetFaction()] or {}
    end

    
    local matches = {}

    for k, v in pairs(ranks) do
        if string.find(string.lower(v), string.lower(argument), 1, true) then
            table.insert(matches, v)
        end
    end

    return matches

end)


local seek = {
    ["ply"] = "Player",
    ["char"] = "Player"
}

local cmdblacklist = {
    ["charfallover"] = true,
    ["charcancelgetup"] = true,
    ["charphysdesc"] = true,
}


function PLUGIN:ClockworkSchemaLoaded()
    for k, v in pairs(Clockwork.command:GetAll()) do
        for k2, v2 in pairs(seek) do
            if k:lower():find(k2) and !cmdblacklist[k:lower()] and !v.types then
                v.types = {}
                v.types[1] = v2
            end
        end
    end
end