math.randomseed(os.time())

QBCore = exports['qb-core']:GetCoreObject()

local addictions = {}

for k,v in pairs(Config.UsableDrugs) do
    QBCore.Functions.CreateUseableItem(k, function(source)
        local _source = source
        local gotAddicted = false
        local addiction = math.random(1,100)
        local xPlayer = QBCore.Functions.GetPlayer(_source)
        local citizenid = xPlayer.PlayerData.citizenid

        if not addictions[citizenid] then addictions[citizenid] = {} end
        if not addictions[citizenid][k] then
            if addiction <= v.addiction.chance then
                gotAddicted = true
                addictions[citizenid][k] = v.addiction.time
                update(citizenid, true)
            end
        elseif addictions[citizenid][k] then
            addictions[citizenid][k] = v.addiction.time
            update(citizenid, true)
        end
        xPlayer.Functions.RemoveItem(k, 1)
        TriggerClientEvent('space_addicion:useDrug', _source, k, gotAddicted)
    end)
end

for k,v in pairs(Config.Medication) do
    QBCore.Functions.CreateUseableItem(k, function(source)
        local _source = source
        local xPlayer = QBCore.Functions.GetPlayer(_source)
        local citizenid = xPlayer.PlayerData.citizenid

        if not addictions[citizenid] then return end
        for _, drug in pairs(v) do
            if addictions[citizenid][drug] then
                addictions[citizenid][drug] = nil
            end
        end

        xPlayer.Functions.RemoveItem(k, 1)
        update(citizenid, true)
        TriggerClientEvent('space_addicion:useMedication', _source)
    end)
end

Citizen.CreateThread(function()
    Wait(1000)
    for _, source in ipairs(GetPlayers()) do
        local _source = source
        local xPlayer = QBCore.Functions.GetPlayer(_source)
        if xPlayer then
            local citizenid = xPlayer.PlayerData.citizenid
            if citizenid then
                addictions[citizenid] = {}
                local row = MySQL.single.await('SELECT `addiction` FROM `players` WHERE `citizenid` = ? LIMIT 1', {citizenid})
                if row.addiction then
                    for k,v in pairs(json.decode(row.addiction)) do
                        addictions[citizenid][k] = v
                    end
                    TriggerClientEvent('space_addicion:data', _source, addictions[citizenid])
                end
            end
        end
    end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    if _source <= 0 or not xPlayer then return end
    local citizenid = xPlayer.PlayerData.citizenid
    if not citizenid then return end
    addictions[citizenid] = {}
    local row = MySQL.single.await('SELECT `addiction` FROM `players` WHERE `citizenid` = ? LIMIT 1', {citizenid})
    if row.addiction then
        for k,v in pairs(json.decode(row.addiction)) do
            addictions[citizenid][k] = v
        end
        TriggerClientEvent('space_addicion:data', _source, addictions[citizenid])
    end
end)

AddEventHandler('playerDropped', function()
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)
    local citizenid = xPlayer.PlayerData.citizenid
    addictions[citizenid] = nil
end)

function update(citizenid, using)
    if addictions[citizenid] then
        MySQL.update.await('UPDATE players SET addiction = ? WHERE citizenid = ?', {json.encode(addictions[citizenid]), citizenid})
        local xPlayer = QBCore.Functions.GetPlayerByCitizenId(citizenid)
        local _source = xPlayer.PlayerData.source
        TriggerClientEvent('space_addicion:data', _source, addictions[citizenid], using)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60*1000)
        for k,v in pairs(addictions) do
            for k2, v2 in pairs(addictions[k]) do
                addictions[k][k2] = v2 - 1
                if addictions[k][k2] > Config.UsableDrugs[k2].addiction.time then
                    addictions[k][k2] = Config.UsableDrugs[k2].addiction.time
                end
                if addictions[k][k2] < 0 then
                    addictions[k][k2] = 0
                end
            end
            update(k)
            local xPlayer = QBCore.Functions.GetPlayerByCitizenId(k)
            local _source = xPlayer.PlayerData.source
            TriggerClientEvent('space_addicion:data', _source, addictions[k])
        end
    end
end)
--- Comando admin para limpar vícios de outro jogador
QBCore.Commands.Add("limparvicios", "Remove todos os vícios de um jogador (ADMIN)", {
    {name = "id", help = "ID do jogador"}
}, true, function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then return end

    local xTarget = QBCore.Functions.GetPlayer(targetId)
    if not xTarget then return end

    local citizenid = xTarget.PlayerData.citizenid

    -- Limpa tabela em memória
    addictions[citizenid] = {}

    -- Limpa do banco de dados (define como NULL)
    MySQL.update.await('UPDATE players SET addiction = NULL WHERE citizenid = ?', { citizenid })

    -- Envia feedback ao jogador alvo
    TriggerClientEvent("space_addictions:notifyClean", targetId)
end, "admin")

-- Versão chamada pelo próprio jogador (caso use o comando sem ID no client)
RegisterNetEvent("space_addictions:adminClearAddictions", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    if not xPlayer then return end

    local citizenid = xPlayer.PlayerData.citizenid
    addictions[citizenid] = {}

    MySQL.update.await('UPDATE players SET addiction = NULL WHERE citizenid = ?', { citizenid })

    TriggerClientEvent("space_addictions:notifyClean", src)
end)
