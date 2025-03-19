Config = {}

-- General settings
Config.CommandClockIn = "clock-in"
Config.CommandClockOut = "clock-out"
Config.UseAcePermissions = true -- Set to false if you don't want to use ACE permissions

-- Department configurations
Config.Departments = {
    ["police"] = {
        label = "Police Department",
        color = 3447003, -- Discord embed color (blue)
        webhook = "YOUR_LEO_WEBHOOK_URL_HERE",
        acePermission = "department.police", -- ACE permission needed if Config.UseAcePermissions is true
        embedTitle = "Police Department Time Clock",
        embedFooter = "LSPD Time Management System",
        embedThumbnail = "https://example.com/police_logo.png" -- URL to department logo
    },
    ["ems"] = {
        label = "Emergency Medical Services",
        color = 15158332, -- Discord embed color (red)
        webhook = "YOUR_EMS_WEBHOOK_URL_HERE",
        acePermission = "department.ems",
        embedTitle = "EMS Time Clock",
        embedFooter = "EMS Time Management System",
        embedThumbnail = "https://example.com/ems_logo.png"
    },
    ["fire"] = {
        label = "Fire Department",
        color = 15105570, -- Discord embed color (orange)
        webhook = "YOUR_FIRE_WEBHOOK_URL_HERE",
        acePermission = "department.fire",
        embedTitle = "Fire Department Time Clock",
        embedFooter = "LSFD Time Management System",
        embedThumbnail = "https://example.com/fire_logo.png"
    },
    -- Add more departments as needed
}
