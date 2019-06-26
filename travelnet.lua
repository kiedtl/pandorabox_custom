

travelnet.allow_travel = function( player_name, owner_name, network_name, station_name_start, station_name_target )

	local has_override_priv = minetest.check_player_privs(player_name, { protection_bypass=true })
	if has_override_priv then
		return true
	end

	if station_name_target and string.sub(station_name_target, 1, 3) == "(P)" then
		-- protected target
		if travelnet.targets[owner_name] and travelnet.targets[owner_name][network_name] and
				travelnet.targets[owner_name][network_name][station_name_target] then

			local target_pos = travelnet.targets[owner_name][network_name][station_name_target].pos
			minetest.load_area(target_pos)
			if minetest.is_protected(target_pos, player_name) then
				return false
			end
		end
	end

	return true
end