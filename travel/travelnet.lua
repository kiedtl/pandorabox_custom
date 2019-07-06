travelnet.allow_travel = function( player_name, owner_name, network_name, station_name_start, station_name_target )

	local has_override_priv = minetest.check_player_privs(player_name, { protection_bypass=true })
	if has_override_priv then
		-- admin can go everywhere...
		return true
	end

	-- extracted target pos
	local target_pos

	-- sanity check
	if travelnet.targets[owner_name] and travelnet.targets[owner_name][network_name] and
		travelnet.targets[owner_name][network_name][station_name_target] then
		target_pos = travelnet.targets[owner_name][network_name][station_name_target].pos
	else
		-- error!
		return false
	end

	-- protected target with "(P) name"
	if station_name_target and string.sub(station_name_target, 1, 3) == "(P)" then
		if travelnet.targets[owner_name] and travelnet.targets[owner_name][network_name] and
				travelnet.targets[owner_name][network_name][station_name_target] then

			minetest.load_area(target_pos)
			if minetest.is_protected(target_pos, player_name) then
				minetest.chat_send_player(player_name, "This station is protected!")
				return false
			end
		end
	end

	-- check if player can teleport there
	local player = minetest.get_player_by_name(player_name)
	local can_teleport, err_msg = pandorabox.can_teleport(player, target_pos)

	if err_msg then
		minetest.chat_send_player(player_name, err_msg)
	end

	return can_teleport
end