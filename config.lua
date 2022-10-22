----------------------------------------------------------------------
-- Thanks for supporting AngelicXS Scripts!							--
-- Support can be found at: https://discord.gg/tQYmqm4xNb			--
-- More paid scripts at: https://angelicxs.tebex.io/ 				--
-- More FREE scripts at: https://github.com/GouveiaXS/ 				--
----------------------------------------------------------------------

Config = {}


Config.UseESX = true						-- Use ESX Framework
Config.UseQBCore = false					-- Use QBCore Framework (Ignored if Config.UseESX = true)

Config.UseCustomNotify = false				-- Use a custom notification script, must complete event below.

-- Only complete this event if Config.UseCustomNotify is true; mythic_notification provided as an example
RegisterNetEvent('angelicxs-cellPing:CustomNotify')
AddEventHandler('angelicxs-cellPing:CustomNotify', function(message, type)
    --exports.mythic_notify:SendAlert(type, message, 4000)
end)

Config.LEOJobName = 'police'                -- Name of police job

Config.UseChatCommand = true				-- If true, use a /command to activate cell ping
Config.ChatCommand = 'ping'					-- If Config.UseChatCommand = true, sets the command to ping cellphone

Config.UseThirdEye = true 					-- Enables using a third eye (third eye requires the following arguments debugPoly, useZ, options {event, icon, label}, distance)
Config.ThirdEyeName = 'qb-target' 			-- Name of third eye aplication
Config.ThirdEyeTerminal = vector3(100.1,120.2,130.3)	-- Location of Third Eye spot

Config.WaitTIme = 20						-- How long (in seconds) will the ping be on the map
Config.NHInput = false						-- Use NH-Input [https://github.com/nerohiro/nh-keyboard] ONLY used if Config.VehicleTimeLimit = true
Config.QBInput = false						-- Use QB-Input (Ignored if Config.NHInput = true) [https://github.com/qbcore-framework/qb-input] ONLY used if Config.VehicleTimeLimit = true
Config.OXLib = true						-- Use the OX_lib (Ignored if Config.NHInput or Config.QBInput = true) [https://github.com/overextended/ox_lib] ONLY used if Config.VehicleTimeLimit = true !! must add shared_script '@ox_lib/init.lua' and lua54 'yes' to fxmanifest!!


-- https://docs.fivem.net/docs/game-references/blips/
Config.PhoneSprite = 441                   -- Sprite used to mark pinged phone
Config.PhoneColour = 25                    -- Colour of sprite used to mark pinged phone


-- Language Configuration
Config.LangType = {
	['error'] = 'error',
	['success'] = 'success',
	['info'] = 'primary'
}

Config.Lang = {
	['phone_enter'] = 'Enter Phone Number to Ping',
	['amount'] = 'Phone Number',
	['zero_error'] = 'You must enter something!',
	['wrong_job'] = 'Only the police can use this!',
	['access'] = 'Request Cell Phone Ping',
	['track_phone'] = 'The following phone has been pinged: ',
	['ping_cell'] = 'Pinged Cell: ',
}