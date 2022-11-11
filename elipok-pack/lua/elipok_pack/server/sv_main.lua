// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Network Declarations
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

util.AddNetworkString("elipok_pack_net")

// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Functions
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local function elipok_message(ply, message)
    if IsValid(ply) then
        net.Start("elipok_pack_net")
        net.WriteString(message)
        net.Send(ply)
    else
        print(message)
    end
end

local function elipok_pack(ply, cmd, args)
    local weps = {}
    if file.Exists("elipok_pack/"..args[1]..".json", "DATA") then
        weps = util.JSONToTable(file.Read("elipok_pack/"..args[1]..".json", "DATA"))
    end
    if cmd == "elipok_pack_add" then
        weps[args[2]] = true
        elipok_message(ply, Elipok_Pack.Lang["you_add"] .. args[2] .. Elipok_Pack.Lang["to_list"] .. args[1] .. ".")
    elseif cmd == "elipok_pack_remove" then
        weps[args[2]] = false
        elipok_message(ply, Elipok_Pack.Lang["you_remove"] .. args[2] .. Elipok_Pack.Lang["to_list"] .. args[1] .. ".")
    elseif cmd == "elipok_pack_reset" then
        elipok_message(ply, Elipok_Pack.Lang["you_reset"] .. args[1])
        weps = {}
    end
    file.Write("elipok_pack/"..args[1]..".json", util.TableToJSON(weps))
end

// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Give Perma
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

hook.Add("PlayerLoadout", "GivePermaPack", function(ply)
    if !ply:IsBot() && file.Exists( "elipok_pack/" .. ply:SteamID64() .. ".json", "DATA" ) then
        local packs = util.JSONToTable(file.Read( "elipok_pack/" .. ply:SteamID64() .. ".json", "DATA" ))
        local ply_team = team.GetName(ply:Team())
        for k, v in pairs(packs) do
            local pack = Elipok_Pack.Packs[k]
            if v && pack[ply_team] then
                for m, l in pairs(pack[ply_team]) do
                    if l then
                        elipok_message(ply, Elipok_Pack.Lang["wep_take"] .. m)
                        ply:Give(m)
                    end
                end
            end
        end
    end
end)

// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Server Console Commands
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

concommand.Add("elipok_pack_add", function(ply, cmd, args)
    elipok_pack(ply, cmd, args)
end)

concommand.Add("elipok_pack_remove", function(ply, cmd, args)
    elipok_pack(ply, cmd, args)
end)

concommand.Add("elipok_pack_reset", function(ply, cmd, args)
    elipok_pack(ply, cmd, args)
end)

// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Network
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

net.Receive("elipok_pack_net", function(len, ply)
    if !ply:IsBot() && ply:IsValid() && Elipok_Pack.Admin[ply:GetUserGroup()] then
        local data = util.JSONToTable(net.ReadString())
        elipok_pack(ply, data.cmd, data.args)
    else
        elipok_message(ply, Elipok_Pack.Lang["not_allow"])
    end
end)