-- ██╗  ██╗ ██████╗     ██████╗ ███████╗██╗   ██╗███████╗██╗      ██████╗ ██████╗ ███████╗██████╗ 
-- ██║  ██║██╔════╝     ██╔══██╗██╔════╝██║   ██║██╔════╝██║     ██╔═══██╗██╔══██╗██╔════╝██╔══██╗
-- ███████║██║  ███╗    ██║  ██║█████╗  ██║   ██║█████╗  ██║     ██║   ██║██████╔╝█████╗  ██████╔╝
-- ██╔══██║██║   ██║    ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║     ██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗
-- ██║  ██║╚██████╔╝    ██████╔╝███████╗ ╚████╔╝ ███████╗███████╗╚██████╔╝██║     ███████╗██║  ██║
-- ╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚══════╝  ╚═══╝  ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝

local Keys = { ["E"] = 38 } 

ESX = exports['es_extended']:getSharedObject()


CreateThread(function()
 while true do
	Wait(7)
		local sleep = 500 
		local vehicle = GetClosestVehicle()
		if vehicle then
			local playerPed = GetPlayerPed(-1)
			local isInVehicle = IsPedInVehicle(playerPed, vehicle, false)
			sleep = 10
			if not isInVehicle and not IsAnyPassengerInCar(vehicle) then
				if Config.Debug then 
				   DrawMarker(1, GetEntityCoords(vehicle)+vector3(0,0,0), 0.0,0.0,0.0, 0.0,0.0,0.0, 5.0,5.0,0.125, 255,255,255, 255, false,true,2,nil,nil,false)
				end 
			
				SetEntityNoCollisionEntity(vehicle, playerPed, false)
				SetEntityAlpha(vehicle, Config.Alpha, true )
		   
				sleep = 10
			else 
				if Config.Debug then 
				   DrawMarker(1, GetEntityCoords(vehicle)+vector3(0,0,0), 0.0,0.0,0.0, 0.0,0.0,0.0, 5.0,5.0,0.125, 255,0,0, 255, false,true,2,nil,nil,false)
				end 
			
				SetEntityNoCollisionEntity(vehicle, playerPed, true)
				SetEntityAlpha(vehicle, 255 , true )
			end 
		
			if not IsAnyPassengerInCar(vehicle) then
			   -- ทำตามที่ต้องการเมื่อไม่มีใครนั่งรถ
			   -- ตัวอย่าง: SetEntityAlpha(vehicle, 0, true)
			else 
				SetEntityNoCollisionEntity(vehicle, playerPed, false)
			end
		end
		if sleep then 
			Wait(500)
		end 
	end
end)


CreateThread(function()
	Wait(3000)  
	print("^0[^2"..GetCurrentResourceName().."^0] Verification SuccessFul , This is Resource ^4 Hg developer ^0")
end)	

IsAnyPassengerInCar = function(vehicle)
    local playerPed = GetPlayerPed(-1)
    local numPassengers = GetVehicleNumberOfPassengers(vehicle)

    for i = -1, numPassengers do
        local passenger = GetPedInVehicleSeat(vehicle, i)
        if passenger ~= 0 and passenger ~= playerPed then
            return true
        end
    end

    return false
end

GetClosestVehicle = function()
    local data = {}
    local coords = GetEntityCoords(PlayerPedId())
	local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(PlayerPedId()), 50.0)
    for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= Config.Cardistance then
			table.insert(data, {
                Veh = vehicles[i],
                dist = distance
            })
		end
	end
    table.sort(data, function(a, b) return b.dist > a.dist end)

    if #data > 0 then
        return data[1].Veh
    else
        return nil
    end
end

IsInExcludedZone = function(vehicle)
    local vehicleCoords = GetEntityCoords(vehicle)
    for _, zone in pairs(Config.ExcludedZones) do
	    if Config.Debug then 
		   DrawMarker(1,zone.x, zone.y, zone.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 5.0,5.0,0.125, 145,128,200, 255, false,true,2,nil,nil,false)
		end 
        local distance = GetDistanceBetweenCoords(vehicleCoords, zone.x, zone.y, zone.z, true)
        if distance <= zone.radius then
            return true
        end
    end
    return false
end