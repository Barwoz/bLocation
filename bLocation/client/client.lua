ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

------------------------------MENU SHOPS

local vehiculename = {
    "~b~Scooter~s~",
    "~b~Blista~s~",
    "~b~Bmx~s~"
}

local notifname = {
    "Scooter",
    "Blista",
    "Bmx"
}

local vehiculemodel = {
    "faggio",
    "blista",
    "bmx"
}

local MenuList = {
    List = 1
}

local LocaMenu = false

local location = RageUI.CreateMenu("Location", "Nos Vehicules :")
location.Closed = function() LocaMenu = false end

function OpenMenuLocation()
    if LocaMenu then
        LocaMenu = false
    else
        LocaMenu = true
    RageUI.Visible(location, true)
        CreateThread(function()
            while LocaMenu do
                Wait(1)
                
                local playerPos = GetEntityCoords(PlayerPedId())
                local dst = #(vector3(265.18, -152.53, 63.31)-playerPos)
                    if dst < 10.0 then
                RageUI.IsVisible(location, function()

                    RageUI.Separator('~b~↓~s~ Véhicule à Louer ~b~↓~s~')
                    
                    RageUI.List("Choisis ton Véhicule", vehiculename, MenuList.List, nil, {}, true, {
                        onListChange = function(i, Item)
                            MenuList.List = i;

                        end,
                    })

                    RageUI.Button("Acheter ~b~" ..vehiculename[MenuList.List], nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                                TriggerServerEvent('barwoz:location', vehiculename[MenuList.List], vehiculemodel[MenuList.List], 500)
                            end
                        })

                end)

                else 
                    RageUI.CloseAll()
                    LocaMenu = false
                end
            end
        end)
    end 
end 

------------------------------DRAWMARKERS

CreateThread(function()
    while true do
        local pCoords2 = GetEntityCoords(PlayerPedId())
        local activerfps = false
        local dst = GetDistanceBetweenCoords(pCoords2, true)
        for _, v in pairs(Config.positionlocation) do
            if #(pCoords2 - v.position) < 1.5 then
                activerfps = true
                Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour louer un ~b~Véhicule~s~ !")
                if LocaMenu == false then
                    if IsControlJustReleased(0, 38) then
                        OpenMenuLocation()
                    end
                end
            elseif #(pCoords2 - v.position) < 7.0 then
                activerfps = true
                DrawMarker(20, v.position, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 80, 170, 1, 1, 2, 0, nil, nil, 0)
            end
        end
        if activerfps then
            Wait(1)
        else
            Wait(1500)
        end
    end
end)

------------------------------BLIPS

CreateThread(function()

    for _, info in pairs(Config.blipslocation) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.7)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

------------------------------CREATED BY BARWOZ------------------------------


-- Faire spawn le véhicule
RegisterNetEvent('barwoz:spawnCar')
AddEventHandler('barwoz:spawnCar', function(car)
    local model = GetHashKey(vehiculemodel[MenuList.List])
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(10)
    end

    local pos = GetEntityCoords(PlayerPedId())
    local vehicle = CreateVehicle(model, 264.11, -148.37, 63.92, 340.00, true, false)
    local plaque = "MEMORYS"
    SetVehicleNumberPlateText(vehicle, plaque) 
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    TriggerServerEvent('ddx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(vehicle))
end)

-----PlayAnim

function PlayAnim(ped, animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end
    TaskPlayAnim(ped, animDict, animName, 1.0, -1.0, duration, 1, 1, false, false, false)
    RemoveAnimDict(animDict)
end

-----Peds

if Config.EnabledPedsLoca == true then
	for k,v in pairs(Config.PedsLoca) do
		CreateThread(function()
			local hash = GetHashKey(v.ped)
			while not HasModelLoaded(hash) do
			RequestModel(hash)
			Wait(40)
			end
			local coords = v.pos
			local ped = CreatePed(4, hash, coords, false, false)
			local heading = 340.0
			PlayAnim(ped, v.d1, v.d2, 99999999999999999999)
			SetEntityInvincible(ped, true)
			SetEntityHeading(ped, heading)
			SetEntityAsMissionEntity(ped, true, true)
			SetPedHearingRange(ped, 0.0)
			SetPedSeeingRange(ped, 0.0)
			SetPedAlertness(ped, 0.0)
			SetPedFleeAttributes(ped, 0, 0)
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetPedCombatAttributes(ped, 46, true)
			SetPedFleeAttributes(ped, 0, 0)
		end)
	end
end