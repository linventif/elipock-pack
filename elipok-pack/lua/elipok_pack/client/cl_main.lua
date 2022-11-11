// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Network
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

net.Receive("elipok_pack_net", function()
    local message = net.ReadString()
    chat.AddText(Elipok_Pack.ColorAddon, Elipok_Pack.NameChat, Elipok_Pack.ColorText, message)
    print(message)
end)

// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Functions
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local function net_to_serv(cmd, args)
    local data = {
        ["cmd"] = cmd,
        ["args"] = args
    }
    net.Start("elipok_pack_net")
    net.WriteString(util.TableToJSON(data))
    net.SendToServer()
end

// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //
// Client Console Commands
// -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

concommand.Add("elipok_pack_add", function(ply, cmd, args)
    net_to_serv(cmd, args)
end)

concommand.Add("elipok_pack_remove", function(ply, cmd, args)
    net_to_serv(cmd, args)
end)

concommand.Add("elipok_pack_reset", function(ply, cmd, args)
    net_to_serv(cmd, args)
end)