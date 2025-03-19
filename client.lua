-- Register command suggestions
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/' .. Config.CommandClockIn, 'Clock in to a department', {
        { name = "department", help = "Department ID (police, ems, fire, etc.)" }
    })
    
    TriggerEvent('chat:addSuggestion', '/' .. Config.CommandClockOut, 'Clock out from your current department')
end)
