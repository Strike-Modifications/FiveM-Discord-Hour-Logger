![image](https://github.com/user-attachments/assets/e32bda58-fd25-4809-a031-dd66f2b7b81c)


# FiveM Discord Hour Logger

A simple FiveM script for tracking duty hours across multiple departments with Discord webhook integration.

## Description

This script allows server administrators to track session times for law enforcement, EMS, fire department, staff, and other custom departments. It provides a straightforward way for players to clock in and out, with automatic Discord notifications and session duration tracking.

## Features

- **Multiple Department Support**: Configure as many departments as needed
- **Discord Webhook Integration**: Detailed embeds for clock in/out events
- **Session Duration Tracking**: Automatically calculates time on duty
- **Automatic Clock-Out**: Players who disconnect or crash are automatically clocked out
- **Permission System**: Optional ACE permissions to restrict department access
- **Customizable**: Easy to configure for any community structure

## Installation

1. Download the latest release
2. Extract the folder to your server's `resources` directory
3. Configure the `config.lua` file with your Discord webhooks and department settings
4. Add `ensure discord_hour_logger` to your server.cfg
5. If using ACE permissions, set up the appropriate permissions in your server.cfg

## Configuration

The `config.lua` file allows you to customize various aspects of the script:

```lua
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
        webhook = "YOUR_POLICE_WEBHOOK_URL_HERE",
        acePermission = "department.police",
        embedTitle = "Police Department Time Clock",
        embedFooter = "LSPD Time Management System",
        embedThumbnail = "https://example.com/police_logo.png"
    },
    
    -- Add more departments as needed
}
```

### ACE Permissions Setup (Optional)

If using ACE permissions, add these lines to your server.cfg:

```
# Department permissions
add_ace group.police department.police allow
add_ace group.ems department.ems allow
add_ace group.fire department.fire allow

# Assign players to groups
add_principal identifier.license:YOUR_LICENSE_HERE group.police
```

## Usage

### Player Commands

Players can use the following commands:

- `/clock-in [department]` - Clock in to a specific department
  - Example: `/clock-in police`

- `/clock-out` - Clock out from the current department

### Discord Notifications

Each clock in/out event sends a Discord webhook with detailed information:

- Player name and identifiers
- Timestamp of action
- Session duration (for clock-out events)
- Department-specific styling

## Example Discord Embed

**Clock In:**
```
Police Department Time Clock
Player: John Doe
Steam: steam:110000112345678
Discord: @johndoe
Time: 2023-05-15 14:30:45
```

**Clock Out:**
```
Police Department Time Clock
Player: John Doe
Steam: steam:110000112345678
Discord: @johndoe
Time: 2023-05-15 17:45:22
Session Duration: 3 hours, 15 minutes
```

## Support

If you encounter any issues or have questions, please open an issue on the GitHub repository.

## Contributing

Contributions are welcome! Feel free to submit pull requests with improvements or new features.
