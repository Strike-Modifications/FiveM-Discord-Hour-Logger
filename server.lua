local playerClockStatus = {}

-- Function to send Discord webhook
function SendDiscordWebhook(department, player, action)
    local deptConfig = Config.Departments[department]
    if not deptConfig then return end
    
    local playerName = GetPlayerName(player)
    local identifiers = GetPlayerIdentifiers(player)
    local steamID = "Unknown"
    local discordID = "Unknown"
    
    for _, id in ipairs(identifiers) do
        if string.find(id, "steam:") then
            steamID = id
        elseif string.find(id, "discord:") then
            discordID = string.gsub(id, "discord:", "")
        end
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local actionText = action == "in" and "Clocked In" or "Clocked Out"
    local description = string.format("**Player:** %s\n**Steam:** %s\n**Discord:** <@%s>\n**Time:** %s", 
        playerName, steamID, discordID, timestamp)
    
    local totalTime = ""
    if action == "out" and playerClockStatus[player] and playerClockStatus[player].clockInTime then
        local clockInTime = playerClockStatus[player].clockInTime
        local clockOutTime = os.time()
        local timeDiff = clockOutTime - clockInTime
        local hours = math.floor(timeDiff / 3600)
        local minutes = math.floor((timeDiff % 3600) / 60)
        totalTime = string.format("\n**Session Duration:** %d hours, %d minutes", hours, minutes)
        description = description .. totalTime
    end
    
    local embed = {
        {
            ["title"] = actionText,
            ["description"] = description,
            ["color"] = deptConfig.color,
            ["footer"] = {
                ["text"] = deptConfig.embedFooter
            },
            ["thumbnail"] = {
                ["url"] = deptConfig.embedThumbnail
            },
            ["author"] = {
                ["name"] = deptConfig.embedTitle
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    PerformHttpRequest(deptConfig.webhook, function(err, text, headers) end, 'POST', json.encode({
        username = deptConfig.label .. " Time Clock",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Check if player has permission for department
function HasDepartmentPermission(source, department)
    if not Config.UseAcePermissions then return true end
    
    local deptConfig = Config.Departments[department]
    if not deptConfig then return false end
    
    return IsPlayerAceAllowed(source, deptConfig.acePermission)
end

-- Clock In Command
RegisterCommand(Config.CommandClockIn, function(source, args, rawCommand)
    if source == 0 then return end -- Prevent server console from using this command
    
    local department = args[1]
    if not department or not Config.Departments[department] then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "Invalid department. Available departments: " .. GetAvailableDepartments(source)}
        })
        return
    end
    
    if not HasDepartmentPermission(source, department) then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "You don't have permission to clock in to this department."}
        })
        return
    end
    
    if playerClockStatus[source] and playerClockStatus[source].clockedIn then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "You are already clocked in to " .. playerClockStatus[source].department .. ". Clock out first."}
        })
        return
    end
    
    playerClockStatus[source] = {
        clockedIn = true,
        department = department,
        clockInTime = os.time()
    }
    
    SendDiscordWebhook(department, source, "in")
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"System", "You have clocked in to " .. Config.Departments[department].label}
    })
end, false)

-- Clock Out Command
RegisterCommand(Config.CommandClockOut, function(source, args, rawCommand)
    if source == 0 then return end -- Prevent server console from using this command
    
    if not playerClockStatus[source] or not playerClockStatus[source].clockedIn then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", "You are not clocked in to any department."}
        })
        return
    end
    
    local department = playerClockStatus[source].department
    
    SendDiscordWebhook(department, source, "out")
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"System", "You have clocked out from " .. Config.Departments[department].label}
    })
    
    playerClockStatus[source] = nil
end, false)

-- Helper function to get available departments for a player
function GetAvailableDepartments(source)
    local availableDepts = {}
    
    for deptId, deptConfig in pairs(Config.Departments) do
        if not Config.UseAcePermissions or IsPlayerAceAllowed(source, deptConfig.acePermission) then
            table.insert(availableDepts, deptId)
        end
    end
    
    return table.concat(availableDepts, ", ")
end

-- Clean up when player disconnects
AddEventHandler('playerDropped', function()
    local source = source
    
    if playerClockStatus[source] and playerClockStatus[source].clockedIn then
        local department = playerClockStatus[source].department
        SendDiscordWebhook(department, source, "out")
        playerClockStatus[source] = nil
    end
end)
