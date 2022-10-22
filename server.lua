ESX = nil
QBcore = nil

if Config.UseESX then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    TriggerEvent('qs-core:getSharedObject', function(obj) QS = obj end)
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('angelicxs-cellPing:Server:PhonePing')
AddEventHandler('angelicxs-cellPing:Server:PhonePing', function(phone, coords)
    local src = source
    local player = nil
    local id = nil
    local result = nil
    local table = nil
    local search = nil
    local finalresult = nil
    if Config.UseESX then
        player = ESX.GetPlayerFromId(src)
        id = player.identifier
        result = 'phone_number'
        table = 'users'
        search = 'identifier'
    elseif Config.UseQBCore then
        player = QBCore.Functions.GetPlayer(src)
        id = player.PlayerData.citizenid
        result = 'charinfo'
        table = 'players'
        search = 'citizenid'
    end
    local sqlinqury = tostring("SELECT "..result.." FROM "..table.." WHERE "..search.." = @"..search)
    exports.oxmysql:query(sqlinqury,
    {[search] = id,}, function(results)
         for k, v in pairs(results) do
            if Config.UseESX then
                for i,p in pairs(v) do
                        finalresult = tostring(p)
                end
            elseif Config.UseQBCore then
                local item = json.decode(v.charinfo)
                finalresult = tostring(item.phone)
            end
        end
        if finalresult == phone then
            TriggerClientEvent('angelicxs-cellPing:TrackingPhone',-1,coords, phone)
        end
    end)
end)

RegisterServerEvent('angelicxs-cellPing:Server:SendPhoneNumber')
AddEventHandler('angelicxs-cellPing:Server:SendPhoneNumber', function(phone)
	TriggerClientEvent('angelicxs-cellPing:CheckPhoneNumber',-1, phone)
end)