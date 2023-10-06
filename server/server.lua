-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("relationship/setUserDb","INSERT INTO vieira_relationship(id,solteiro,namorando,casado,divorciado) VALUES(@user_id,1,0,0,0)")
vRP.prepare("relationship/userExistsInDb","SELECT * FROM vieira_relationship WHERE id = @id")
vRP.prepare("relationship/viewConj","SELECT conjid FROM vieira_relationship WHERE id = @id")
vRP.prepare("relationship/setUsersDate","UPDATE vieira_relationship SET solteiro = 0, namorando = 1, noivando = 0, casado = 0, divorciado = 0, conjid = @conjid WHERE id = @id")
vRP.prepare("relationship/setUsersEngage","UPDATE vieira_relationship SET solteiro = 0, namorando = 0, noivando = 1, casado = 0, divorciado = 0, conjid = @conjid WHERE id = @id")
vRP.prepare("relationship/setUsersMarriage","UPDATE vieira_relationship SET solteiro = 0, namorando = 0, noivando = 0, casado = 1, divorciado = 0, conjid = @conjid WHERE id = @id")
vRP.prepare("relationship/setUsersSingle","UPDATE vieira_relationship SET solteiro = 1, namorando = 0, noivando = 0, casado = 0, divorciado = 0, conjid = 0 WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
sdRP = {}
Tunnel.bindInterface(GetCurrentResourceName(),sdRP)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- CODE
-----------------------------------------------------------------------------------------------------------------------------------------
function sdRP.getUserName()
    local user_id = vRP.getUserId(source)
    local username = vRP.userIdentity(user_id)
    return username
end

function sdRP.userExists()
    local user_id = vRP.getUserId(source)
    local queryUser = vRP.query("relationship/userExistsInDb", { id = user_id })
    return queryUser[1] or false
end

function sdRP.setUserDb()
    local user_id = vRP.getUserId(source)
    vRP.execute("relationship/setUserDb",{ user_id = user_id })
end

function sdRP.viewConjId()
    local user_id = vRP.getUserId(source)
    local query = vRP.query("relationship/viewConj", { id = user_id })

    if not query[1].conjid or query[1].conjid == 0 then
        return 'Ninguém'
    end

    local conjName = vRP.userIdentity(query[1].conjid)
    local fullConjName = conjName['name']..' '..conjName['name2']
    return fullConjName
end

function sdRP.date()
    local source = source
    local user_id = vRP.getUserId(source)
    local queryUser = vRP.query("relationship/userExistsInDb", { id = user_id })
    local player = vRPC.nearestPlayer(source)
    local nplayerId = vRP.getUserId(player)
    local username = vRP.userIdentity(user_id)
    local nplayerIdentity = vRP.userIdentity(nplayerId)
    local allSources = vRP.userList()

    if not player then
        TriggerClientEvent('Notify', source, 'vermelho', 'Não possui nenhum player perto', 5000)
        return
    end

    if queryUser[1].namorando == 0 and player then
        if vRP.request(player, "".. username['name'] .. " " .. username['name2'] .. " está te pedindo em namoro", "Aceitar", "Recusar") then
            vRP.execute("relationship/setUsersDate", { conjid = nplayerId, id = user_id })
            vRP.execute("relationship/setUsersDate", { conjid = user_id, id = nplayerId })
            TriggerClientEvent('chatMessage', -1, "❤️ RELACIONAMENTOS: ",{250,0,0},"".. username['name'] .. " " .. username['name2'] .. " começou a namorar com " .. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'])
        else
            TriggerClientEvent('Notify', source, 'vermelho', "".. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'] .. " recusou o seu pedido de namoro", 5000)
        end
    else
        TriggerClientEvent('Notify', source, 'vermelho', 'Você já está namorando', 5000)
    end
end

function sdRP.engage()
    local source = source
    local user_id = vRP.getUserId(source)
    local queryUser = vRP.query("relationship/userExistsInDb", { id = user_id })
    local player = vRPC.nearestPlayer(source)
    local nplayerId = vRP.getUserId(player)
    local username = vRP.userIdentity(user_id)
    local nplayerIdentity = vRP.userIdentity(nplayerId)
    local allSources = vRP.userList()

    if not player then
        TriggerClientEvent('Notify', source, 'vermelho', 'Não possui nenhum player perto', 5000)
        return
    end

    if queryUser[1].noivando == 0 and player then
        if vRP.request(player, "".. username['name'] .. " " .. username['name2'] .. " está te pedindo em noivado", "Aceitar", "Recusar") then
            vRP.execute("relationship/setUsersEngage", { conjid = nplayerId, id = user_id })
            vRP.execute("relationship/setUsersEngage", { conjid = user_id, id = nplayerId })
            TriggerClientEvent('chatMessage', -1, "❤️ NOIVADOS: ",{250,25,210},"".. username['name'] .. " " .. username['name2'] .. " noivou com " .. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'])
        else
            TriggerClientEvent('Notify', source, 'vermelho', "".. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'] .. " recusou o seu pedido de namoro", 5000)
        end
    else
        TriggerClientEvent('Notify', source, 'vermelho', 'Você já está noivando', 5000)
    end
end

function sdRP.marriage()
    local source = source
    local user_id = vRP.getUserId(source)
    local queryUser = vRP.query("relationship/userExistsInDb", { id = user_id })
    local player = vRPC.nearestPlayer(source)
    local nplayerId = vRP.getUserId(player)
    local username = vRP.userIdentity(user_id)
    local nplayerIdentity = vRP.userIdentity(nplayerId)
    local allSources = vRP.userList()

    if not player then
        TriggerClientEvent('Notify', source, 'vermelho', 'Não possui nenhum player perto', 5000)
        return
    end

    if queryUser[1].casado == 0 and player then
        if vRP.request(player, "".. username['name'] .. " " .. username['name2'] .. " está te pedindo em casamento", "Aceitar", "Recusar") then
            vRP.execute("relationship/setUsersMarriage", { conjid = nplayerId, id = user_id })
            vRP.execute("relationship/setUsersMarriage", { conjid = user_id, id = nplayerId })
            TriggerClientEvent('chatMessage', -1, "❤️ CASAMENTOS: ",{124,21,213},"".. username['name'] .. " " .. username['name2'] .. " casou-se com " .. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'])
        else
            TriggerClientEvent('Notify', source, 'vermelho', "".. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'] .. " recusou o seu pedido de namoro", 5000)
        end
    else
        TriggerClientEvent('Notify', source, 'vermelho', 'Você já está casado', 5000)
    end
end

function sdRP.single()
    local source = source
    local user_id = vRP.getUserId(source)
    local queryUser = vRP.query("relationship/userExistsInDb", { id = user_id })
    local player = vRPC.nearestPlayer(source)
    local nplayerId = vRP.getUserId(player)
    local username = vRP.userIdentity(user_id)
    local nplayerIdentity = vRP.userIdentity(nplayerId)
    local allSources = vRP.userList()

    if not player then
        TriggerClientEvent('Notify', source, 'vermelho', 'Não possui nenhum player perto', 5000)
        return
    end


    if queryUser[1].namorando == 1 or queryUser[1].casado == 1 or queryUser[1].noivando == 1 or queryUser[1].casado == 1 then
        if vRP.request(player, "".. username['name'] .. " " .. username['name2'] .. " está te pedindo um tempo", "Aceitar", "Recusar") then
            vRP.execute("relationship/setUsersSingle", { id = user_id })
            vRP.execute("relationship/setUsersSingle", { id = nplayerId })
            TriggerClientEvent('chatMessage', -1, "💔 SEPARAÇÃO: ",{0,0,0},"".. username['name'] .. " " .. username['name2'] .. " se separou de " .. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'])
        else
            TriggerClientEvent('Notify', source, 'vermelho', "".. nplayerIdentity['name'] .. " " .. nplayerIdentity['name2'] .. " recusou o seu pedido de namoro", 5000)
        end
    else
        TriggerClientEvent('Notify', source, 'vermelho', 'Você precisa estar em um relacionamento para se separar', 5000)
    end
end

AddEventHandler("playerConnect",function(user_id)
    local queryUser = vRP.query("relationship/userExistsInDb", { id = user_id })
    if not queryUser[1] then
        print('O usuário '..user_id..' não tinha um registro na entidade de relacionamentos e por isso foi criado')
        vRP.execute("relationship/setUserDb",{ user_id = user_id })
    end
end)