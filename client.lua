ESX = nil
QBcore = nil
PlayerJob = nil
PlayerGrade = nil
PlayerData = nil

local isLawEnforcement = false
local Tracker = false
local TrackedVehicle = false
local TrackerUsed = false
local hasDevice = false

CreateThread(function()
    if Config.UseESX then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
        while not ESX.IsPlayerLoaded() do
            Wait(100)
        end
        PlayerData = ESX.GetPlayerData()
        CreateThread(function()
            while true do
                if PlayerData ~= nil then
                    PlayerJob = PlayerData.job.name
                    PlayerGrade = PlayerData.job.grade
                    isLawEnforcement = LawEnforcement()
                    break
                end
                Wait(100)
            end
        end)
        RegisterNetEvent('esx:setJob', function(job)
            PlayerJob = job.name
            PlayerGrade = job.grade
            isLawEnforcement = LawEnforcement()
        end)

    elseif Config.UseQBCore then
        QBCore = exports['qb-core']:GetCoreObject()
        CreateThread(function ()
			while true do
                PlayerData = QBCore.Functions.GetPlayerData()
				if PlayerData.citizenid ~= nil then
					PlayerJob = PlayerData.job.name
					PlayerGrade = PlayerData.job.grade.level
                    isLawEnforcement = LawEnforcement()
					break
				end
				Wait(100)
			end
		end)
        RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
            PlayerJob = job.name
            PlayerGrade = job.grade.level
            isLawEnforcement = LawEnforcement()
        end)
    end
end)

RegisterNetEvent('angelicxs-cellPing:Notify', function(message, type)
	if Config.UseCustomNotify then
        TriggerEvent('angelicxs-cellPing:CustomNotify',message, type)
	elseif Config.UseESX then
		ESX.ShowNotification(message)
	elseif Config.UseQBCore then
		QBCore.Functions.Notify(message, type)
	end
end)

RegisterNetEvent('angelicxs-cellPing:CheckPhoneNumber')
AddEventHandler('angelicxs-cellPing:CheckPhoneNumber', function(phone)
    local Player = PlayerPedId()
    local PlayerCoods = GetEntityCoords(Player)
    TriggerServerEvent('angelicxs-cellPing:Server:PhonePing', phone, PlayerCoods)
end)
CreateThread(function()
    if Config.UseChatCommand then
        RegisterCommand(Config.ChatCommand, function()
            TriggerEvent('angelicxs-cellPing:EnterCellNumber')
        end)
    end
    if Config.UseThirdEye then
        for i=1, #Config.ThirdEyeTerminal, 1 do
            exports[Config.ThirdEyeName]:AddBoxZone(Config.ThirdEyeTerminal [i]..'angelicxs-cellPing', Config.ThirdEyeTerminal[i], 2, 2, {
                name = Config.ThirdEyeTerminal [i]..'angelicxs-cellPing',
                heading = 0,
                debugPoly = false,
                minZ = Config.ThirdEyeTerminal[i].z - 1.5,
                maxZ = Config.ThirdEyeTerminal[i].z + 1.5
            },
            {
                options = {
                    {
                        event = 'angelicxs-cellPing:EnterCellNumber',
                        icon = "fas fa-sign-in-alt",
                        label = Config.Lang['access'],
                    },
                },
                distance = 1.5 
            })
        end
    end
end)

RegisterNetEvent('angelicxs-cellPing:EnterCellNumber')
AddEventHandler('angelicxs-cellPing:EnterCellNumber', function()
    if isLawEnforcement then
        local phonenumber = nil
        if Config.NHInput then
            local keyboard, amount = exports["nh-keyboard"]:Keyboard({
                header = Config.Lang['phone_enter'],
                rows = {Config.Lang['amount']}
            })
            if keyboard then
                if amount then
                    phonenumber = amount
                else
                    TriggerEvent('angelicxs-cellPing:Notify', Config.Lang['zero_error'], Config.LangType['error'])
                end
            end
        elseif Config.QBInput then
            local sellingItem = exports['qb-input']:ShowInput({
                header = Config.Lang['phone_enter'],
                submitText = Config.Lang['amount'],
                inputs = {
                    {
                        type = 'text',
                        isRequired = false,
                        name = 'amount',
                        text = Config.Lang['amount'],
                    }
                }
            })    
            if sellingItem then
                    if sellingItem.amount then
                        phonenumber = sellingItem.amount
                else
                    TriggerEvent('angelicxs-cellPing:Notify', Config.Lang['zero_error'], Config.LangType['error'])
                end
            end
        elseif Config.OXLib then
            local input = lib.inputDialog(Config.Lang['phone_enter'], {Config.Lang['phone_enter']})
            if input then
                phonenumber = input[1]
            end
        end
        TriggerServerEvent('angelicxs-cellPing:Server:SendPhoneNumber', phonenumber)
    else
        TriggerEvent('angelicxs-cellPing:Notify', Config.Lang['wrong_job'], Config.LangType['error'])
    end
end)

RegisterNetEvent('angelicxs-cellPing:TrackingPhone')
AddEventHandler('angelicxs-cellPing:TrackingPhone', function(targetCoords, phone)
	if isLawEnforcement then		
        TriggerEvent('angelicxs-cellPing:Notify', Config.Lang['track_phone']..phone, Config.LangType['success'])
		local Alpha = 640
		local TrackerDevice = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)
        SetBlipSprite(TrackerDevice, Config.PhoneSprite)
		SetBlipColour(TrackerDevice, Config.PhoneColour)
		SetBlipHighDetail(TrackerDevice, true)
		SetBlipAlpha(TrackerDevice, Alpha)
		SetBlipAsShortRange(TrackerDevice, true)
        BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(Config.Lang['ping_cell']..tostring(phone))
		EndTextCommandSetBlipName(TrackerDevice)
        Wait(Config.WaitTIme*1000)
        RemoveBlip(TrackerDevice)
	end
end)

function LawEnforcement()
	for i = 1, #Config.LEOJobName do
		if PlayerJob == Config.LEOJobName[i] then
			return true
		end
	end
	return false
end
