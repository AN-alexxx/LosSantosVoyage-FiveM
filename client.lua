local currentLocation = "Los Santos"
local NorthLoaded = false
local CayoLoaded = false


------------------------------------------------
-- MENU
------------------------------------------------

RMenu.Add(
    'airport',
    'main',
    RageUI.CreateMenu(
        "Los Santos Airport",
        "Voyage"
    )
)


RMenu:Get('airport','main').Closed = function()
end



function OpenAirportMenu()

    RageUI.Visible(
        RMenu:Get('airport','main'),
        true
    )

end



RageUI.CreateWhile(1.0,function()


    if RageUI.Visible(RMenu:Get('airport','main')) then


        RageUI.DrawContent(
        {
            header = true,
            glare = true,
            instructionalButton = true
        },
        function()



            RageUI.Button(
                "🌴 Cayo Perico",
                "Vol vers l'île tropicale",
                {
                    RightLabel="→→→"
                },
                true,
                function(_,_,Selected)

                    if Selected then
                        TravelTo("Cayo")
                    end

                end
            )



            RageUI.Button(
                "❄ North Yankton",
                "Destination actuellement indisponible",
                {
                    RightBadge = RageUI.BadgeStyle.Lock
                },
                false,
                function()
                end
            )



        end)

    end


end,1)







------------------------------------------------
-- MARKER AEROPORT
------------------------------------------------


CreateThread(function()

while true do

    local wait = 1000


    local ped = PlayerPedId()

    local coords = GetEntityCoords(ped)


    local dist =
    #(coords - Config.Airport.coords)



    if dist < 15.0 then

        wait = 0


        DrawMarker(
            1,
            Config.Airport.coords.x,
            Config.Airport.coords.y,
            Config.Airport.coords.z-1.0,

            0,0,0,
            0,0,0,

            2.5,
            2.5,
            0.25,

            0,
            150,
            255,
            150,

            false,
            true,
            2,
            false
        )



        if dist < Config.Airport.radius then


            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(
                "Appuyez sur ~INPUT_CONTEXT~ pour voyager"
            )
            EndTextCommandDisplayHelp(0,false,true,-1)



            if IsControlJustPressed(0,38) then

                OpenAirportMenu()

            end


        end


    end


    Wait(wait)

end

end)








------------------------------------------------
-- SYSTEME VOYAGE
------------------------------------------------


function TravelTo(destination)


local data = Config.Destinations[destination]


DoScreenFadeOut(1000)


while not IsScreenFadedOut() do
    Wait(0)
end



Wait(1000)



-- enlever l'ancienne zone

if currentLocation == "Cayo" then
    UnloadCayo()
end


if currentLocation == "North" then
    UnloadNorth()
end




-- charger nouvelle zone


if destination == "Cayo" then

    LoadCayo()


elseif destination == "North" then

    LoadNorth()

end



Wait(3000)



SetFocusPosAndVel(
    data.coords.x,
    data.coords.y,
    data.coords.z,
    0.0,
    0.0,
    0.0
)



RequestCollisionAtCoord(
    data.coords.x,
    data.coords.y,
    data.coords.z
)



SetEntityCoordsNoOffset(
    PlayerPedId(),
    data.coords.x,
    data.coords.y,
    data.coords.z,
    false,
    false,
    false
)



SetEntityHeading(
    PlayerPedId(),
    data.coords.w
)



Wait(2000)


ClearFocus()



currentLocation = destination



DoScreenFadeIn(1500)


end








------------------------------------------------
-- CAYO PERICO
------------------------------------------------


function LoadCayo()


    if NorthLoaded then
        UnloadNorth()
        Wait(1000)
    end


    CayoLoaded = true


    SetIslandHopperEnabled(
        "HeistIsland",
        true
    )


    RequestIpl("h4_islandairstrip")
    RequestIpl("h4_islandairstrip_props")
    RequestIpl("h4_islandx_mansion")


end





function UnloadCayo()


SetIslandHopperEnabled(
    "HeistIsland",
    false
)


RemoveIpl("h4_islandairstrip")
RemoveIpl("h4_islandairstrip_props")
RemoveIpl("h4_islandx_mansion")


end







------------------------------------------------
-- NORTH YANKTON
------------------------------------------------

function LoadNorth()

    if CayoLoaded then 
        UnloadCayo()
        Wait(1000)
    end

    NorthLoaded = true


    RequestIpl("prologue01")
    RequestIpl("prologue01c")
    RequestIpl("prologue01d")
    RequestIpl("prologue01e")
    RequestIpl("prologue01f")
    RequestIpl("prologue01g")
    RequestIpl("prologue01h")

    RequestIpl("prologue02")
    RequestIpl("prologue02b")
    RequestIpl("prologue02c")

    RequestIpl("prologue03")
    RequestIpl("prologue03b")


end







function UnloadNorth()

    NorthLoaded = false


    RemoveIpl("prologue01")
    RemoveIpl("prologue01c")
    RemoveIpl("prologue01d")
    RemoveIpl("prologue01e")
    RemoveIpl("prologue01f")
    RemoveIpl("prologue01g")
    RemoveIpl("prologue01h")

    RemoveIpl("prologue02")
    RemoveIpl("prologue02b")
    RemoveIpl("prologue02c")

    RemoveIpl("prologue03")
    RemoveIpl("prologue03b")


    -- force le streaming à oublier la zone

    ClearFocus()


    SetFocusEntity(PlayerPedId())


end







------------------------------------------------
-- RETOUR LOS SANTOS
------------------------------------------------


RegisterCommand(
"tpback",
function()



DoScreenFadeOut(1000)


Wait(1000)



if currentLocation == "Cayo" then

    UnloadCayo()

end



if currentLocation == "North" then

    UnloadNorth()

end



Wait(2000)



SetFocusPosAndVel(
    Config.Return.x,
    Config.Return.y,
    Config.Return.z,
    0.0,
    0.0,
    0.0
)



RequestCollisionAtCoord(
    Config.Return.x,
    Config.Return.y,
    Config.Return.z
)



SetEntityCoordsNoOffset(
    PlayerPedId(),
    Config.Return.x,
    Config.Return.y,
    Config.Return.z,
    false,
    false,
    false
)



SetEntityHeading(
    PlayerPedId(),
    Config.Return.w
)



Wait(2000)



ClearFocus()



currentLocation = "Los Santos"



DoScreenFadeIn(1500)



end
)

------------------------------------------------
-- BLIP AEROPORT
------------------------------------------------

CreateThread(function()

    local blip = AddBlipForCoord(
        Config.Airport.coords.x,
        Config.Airport.coords.y,
        Config.Airport.coords.z
    )


    SetBlipSprite(
        blip,
        307 -- avion
    )


    SetBlipDisplay(
        blip,
        4
    )


    SetBlipScale(
        blip,
        0.8
    )


    SetBlipColour(
        blip,
        3
    )


    SetBlipAsShortRange(
        blip,
        true
    )


    BeginTextCommandSetBlipName(
        "STRING"
    )

    AddTextComponentString(
        "Aéroport de Los Santos"
    )

    EndTextCommandSetBlipName(
        blip
    )

end)