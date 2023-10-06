-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
sdRP = {}
Tunnel.bindInterface(GetCurrentResourceName(),sdRP)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
-----------------------------------------------------------------------------------------------------------------------------------------
-- CODE
-----------------------------------------------------------------------------------------------------------------------------------------
local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

RegisterNUICallback("clickNamorar",function()
  vSERVER.date()
end)

RegisterNUICallback("clickNoivar",function()
  vSERVER.engage()
end)

RegisterNUICallback("clickCasar",function()
  vSERVER.marriage()
end)

RegisterNUICallback("clickSolteiro",function()
  vSERVER.single()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('love', function()
  debugPrint('Show NUI frame')
  local username = vSERVER.getUserName()
  local fullname = username['name']..' '.. username['name2']
  local tableUserInDB = json.encode(userExistsInDB);
  print(fullname)
  SendReactMessage('sendFullname', fullname)


  local userExistsInDB = vSERVER.userExists();
  if not userExistsInDB then
    vSERVER.setUserDb()
  end

  local forceUserExist = vSERVER.userExists();
  SendReactMessage('sendStatus', json.encode(forceUserExist))

  local fullConjName = vSERVER.viewConjId()
  SendReactMessage('fullConjName', fullConjName)

  toggleNuiFrame(true)
end)