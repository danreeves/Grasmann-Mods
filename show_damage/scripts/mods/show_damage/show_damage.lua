local mod = get_mod("ShowDamage")
--[[ 
	Show Damage
		- Shows damage / healing in chat and as floating numbers.
	
	Author: grasmann
	Version: 1.2.0
--]]

-- ##### ███████╗███████╗████████╗████████╗██╗███╗   ██╗ ██████╗ ███████╗ #############################################
-- ##### ██╔════╝██╔════╝╚══██╔══╝╚══██╔══╝██║████╗  ██║██╔════╝ ██╔════╝ #############################################
-- ##### ███████╗█████╗     ██║      ██║   ██║██╔██╗ ██║██║  ███╗███████╗ #############################################
-- ##### ╚════██║██╔══╝     ██║      ██║   ██║██║╚██╗██║██║   ██║╚════██║ #############################################
-- ##### ███████║███████╗   ██║      ██║   ██║██║ ╚████║╚██████╔╝███████║ #############################################
-- ##### ╚══════╝╚══════╝   ╚═╝      ╚═╝   ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝ #############################################
local options_widgets = {
	{
		["setting_name"] = "mode",
		--["widget_type"] = "dropdown",
		["widget_type"] = "stepper",
		["text"] = "Chat output",
		["tooltip"] = "Mode\n" ..
			"Switch mode for the player damage output.\n\n" ..
			"-- DEFAULT --\nShows damage, hit zone and kill confirmation.\n\n" ..
			"-- KILLS --\nShows the default message but only on kills.\n\n" ..
			"-- SIMPLE KILLS --\nShows a simple message on a kill.",
		["options"] = {
			--{ text = Localize("vmf_text_core_off"), value = 1 },
			{text = "Default", value = 2},
			{text = "Kills", value = 3},
			{text = "Simple Kills", value = 4},
		},
		["default_value"] = 2,
		["sub_widgets"] = {
			{
				["show_widget_condition"] = {1, 2, 3},
				["setting_name"] = "system_chat",
				["widget_type"] = "stepper",
				["text"] = "Use System Chat",
				["tooltip"] = "Use System Chat\n" ..
					"Uses the system chat instead of normal chat.",
				["options"] = {
					{text = "Off", value = false},
					{text = "On", value = true},
				},
				["default_value"] = true,
			},
			{
				["show_widget_condition"] = {1, 2},
				["setting_name"] = "hit_zone",
				["widget_type"] = "stepper",
				["text"] = "Show Hit Zone",
				["tooltip"] = "Show Hit Zone\n" ..
					"Will show the hit zone in output.",
				["options"] = {
					{text = "Off", value = false},
					{text = "On", value = true},
				},
				["default_value"] = true,
			},
			{
				["show_widget_condition"] = {1},
				["setting_name"] = "kill",
				["widget_type"] = "stepper",
				["text"] = "Show Kill Indicator",
				["tooltip"] = "Show Kill Indicator\n" ..
					"Will show an indication in output if hit was a kill.",
				["options"] = {
					{text = "Off", value = false},
					{text = "On", value = true},
				},
				["default_value"] = true,
			},
			{
				["show_widget_condition"] = {1, 2, 3},
				["setting_name"] = "send_chat",
				["widget_type"] = "stepper",
				["text"] = "Share to others",
				["tooltip"] = "Share to others\n" ..
					"Will send the damage messages to the chat for all to read.",
				["options"] = {
					{text = "Off", value = false},
					{text = "On", value = true},
				},
				["default_value"] = false,
			},
			{
				["show_widget_condition"] = {1, 2, 3},
				["setting_name"] = "damage_source",
				--["widget_type"] = "dropdown",
				["widget_type"] = "stepper",
				["text"] = "Source",
				["tooltip"] = "Show Player Damage Source\n" ..
					"Switch source for the player damage output.\n\n" ..
					"-- OFF --\nNo messages will be posted.\n\n" ..
					"-- ME ONLY --\nOnly show damage messages for yourself.\n\n" ..
					"-- ALL --\nShows damage messages for all players, including bots.\n\n" ..
					"-- CUSTOM --\nChoose the players you want to see damage messages of.\n\n",
				["options"] = {
					{text = "Me Only", value = 1},
					{text = "All", value = 2},
					{text = "Custom", value = 3},
				},
				["default_value"] = 1,
				["sub_widgets"] = {
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "chat_player_1",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "chat_player_2",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "chat_player_3",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "chat_player_4",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
				},
			},
		},
	},
	{
		["setting_name"] = "floating_numbers",
		["widget_type"] = "stepper",
		["text"] = "Floating Damage Numbers",
		["tooltip"] = "Floating Damage Numbers\n" ..
			"Switch floating damage numbers on / off.",
		["options"] = {
			{text = "Off", value = false},
			{text = "On", value = true},
		},
		["default_value"] = false,
		["sub_widgets"] = {
			{
				["show_widget_condition"] = {2},
				["setting_name"] = "floating_numbers_source",
				--["widget_type"] = "dropdown",
				["widget_type"] = "stepper",
				["text"] = "Source",
				["tooltip"] = "Show Player Damage Source\n" ..
					"Switch source for the player damage output.\n\n" ..
					"-- OFF --\nNo messages will be posted.\n\n" ..
					"-- ME ONLY --\nOnly show damage messages for yourself.\n\n" ..
					"-- ALL --\nShows damage messages for all players, including bots.\n\n" ..
					"-- CUSTOM --\nChoose the players you want to see damage messages of.\n\n",
				["options"] = {
					{text = "Me Only", value = 1},
					{text = "All", value = 2},
					{text = "Custom", value = 3},
				},
				["default_value"] = 1,
				["sub_widgets"] = {
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "floating_numbers_player_1",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "floating_numbers_player_2",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "floating_numbers_player_3",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
					{
						["show_widget_condition"] = {3},
						["setting_name"] = "floating_numbers_player_4",
						["widget_type"] = "checkbox",
						["text"] = "N/A",
						["default_value"] = false,
					},
				},
			},
		},
	},
}

-- ##### ███████╗██╗  ██╗████████╗███████╗███╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗ ####################################
-- ##### ██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝████╗  ██║██╔════╝██║██╔═══██╗████╗  ██║ ####################################
-- ##### █████╗   ╚███╔╝    ██║   █████╗  ██╔██╗ ██║███████╗██║██║   ██║██╔██╗ ██║ ####################################
-- ##### ██╔══╝   ██╔██╗    ██║   ██╔══╝  ██║╚██╗██║╚════██║██║██║   ██║██║╚██╗██║ ####################################
-- ##### ███████╗██╔╝ ██╗   ██║   ███████╗██║ ╚████║███████║██║╚██████╔╝██║ ╚████║ ####################################
-- ##### ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ####################################
--[[
	Replace the text of an initialized option widget
--]]
mod.update_setting_text = function(self, setting_name, text)
	local ingame_ui_exists, ingame_ui = pcall(function () return Managers.player.network_manager.matchmaking_manager.matchmaking_ui.ingame_ui end)
	if ingame_ui_exists then
		local vmf_options_view = ingame_ui.views["vmf_options_view"]
		if vmf_options_view then
			local searched_widget = nil
			
			for _, mod_widgets in ipairs(vmf_options_view.settings_list_widgets) do
				if mod_widgets[1].content.mod_name == self._name then
					for _, widget in ipairs(mod_widgets) do
						if widget.content.setting_name == setting_name then
							-- do your thing
							searched_widget = widget
						end
					end
				end
			end
			
			if searched_widget then
				searched_widget.content.text = text
			end
		end
	end
end

-- ##### ██████╗  █████╗ ████████╗ █████╗ #############################################################################
-- ##### ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗ ############################################################################
-- ##### ██║  ██║███████║   ██║   ███████║ ############################################################################
-- ##### ██║  ██║██╔══██║   ██║   ██╔══██║ ############################################################################
-- ##### ██████╔╝██║  ██║   ██║   ██║  ██║ ############################################################################
-- ##### ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ############################################################################
mod.chat = {
	units = {},
	NAME_LENGTH = 20,
}
mod.floating = {
	corpses = {},
	units = {},
	delete = {},
	fade_time = 2,
	definition = {
		position = nil,
		damage = 0,
		color = nil,
		timer = 0,
	},
}
mod.enemies = {
	specials = {
		"skaven_storm_vermin",
		"skaven_storm_vermin_commander",
		"skaven_loot_rat",
		"skaven_rat_ogre",
		"skaven_gutter_runner",
		"skaven_poison_wind_globadier",
		"skaven_pack_master",
		"skaven_ratling_gunner",
		"skaven_grey_seer",
		"skaven_storm_vermin_champion",
	},
	breed_names = {
		skaven_slave = "Slave Rat",
		skaven_storm_vermin = "Stormvermin",
		skaven_storm_vermin_commander = "Stormvermin",
		skaven_clan_rat = "Clan Rat",
		skaven_loot_rat = "Loot Rat",
		skaven_rat_ogre = "Rat Ogre",
		skaven_gutter_runner = "Gutter Runner",
		skaven_poison_wind_globadier = "Globadier",
		skaven_pack_master = "Pack Master",
		skaven_ratling_gunner = "Ratling Gunner",
		skaven_grey_seer = "Grey Seer",
		critter_pig = "Pig",
		critter_rat = "Rat",
		skaven_storm_vermin_champion = "Stormvermin Champion",
	},
	hit_zones = {
		full = "",
		head = "Head",
		right_arm = "R. Arm",
		left_arm = "L. Arm",
		torso = "Torso",
		right_leg = "R. Leg",
		left_leg = "L. Leg",
		tail = "Tail",
		neck = "Neck",
	},
	offsets = {
		default = 1,
		skaven_slave = 1,
		skaven_clan_rat = 1,
		skaven_storm_vermin = 1,
		skaven_storm_vermin_commander = 1,
		skaven_gutter_runner = 1,
		skaven_ratling_gunner = 1,
		skaven_pack_master = 1,
		skaven_poison_wind_globadier = 1,
		skaven_rat_ogre = 2,
		skaven_loot_rat = 1,
		skaven_grey_seer = 2,
		critter_pig = 0.5,
		critter_rat = 0,
		skaven_storm_vermin_champion = 2,
	},
}
mod.players = {}
mod.strings = {}
mod.console = {}

-- ##### ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗ ###################################
-- ##### ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝ ###################################
-- ##### █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗ ###################################
-- ##### ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║ ###################################
-- ##### ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║ ###################################
-- ##### ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ###################################
--[[
	Get a generic character name
--]]
mod.players.unit_name = function(unit_name)
	if unit_name == "empire_soldier" then
		return "Empire Soldier"
	elseif unit_name == "witch_hunter" then
		return "Witch Hunter"
	elseif unit_name == "bright_wizard" then
		return "Bright Wizard"
	elseif unit_name == "dwarf_ranger" then
		return "Dwarf Ranger"
	elseif unit_name == "wood_elf" then
		return "Waywatcher"
	end
	return nil
end
--[[
	Get player name from index
--]]
mod.players.set_names = function()
	local player_manager = Managers.player
	local players = player_manager:human_and_bot_players()
	local i = 1
	for _, player in pairs(players) do
		local name = mod.strings.check({player._cached_name, mod.players.unit_name(player.player_name)}) or "N/A"
		mod:update_setting_text("chat_player_"..tostring(i), name)
		mod:update_setting_text("floating_numbers_player_"..tostring(i), name)
		i = i + 1
	end
end
--[[
	Shorten string
--]]
mod.strings.shorten = function(str)
	if string.len(str) >= mod.chat.NAME_LENGTH then
		return string.sub(str, 1, mod.chat.NAME_LENGTH)
	end
	return str
end
--[[
	Check if objects are strings
	Returns first string
--]]
mod.strings.check = function(strings, default)
	if type(strings) == "table" then
		for _, str in pairs(strings) do
			if type(str) == "string" and Utf8.valid(str) then
				return mod.strings.shorten(str)
			end
		end
	elseif type(strings) == "string" and Utf8.valid(strings) then
		return mod.strings.shorten(strings)
	end
	if type(default) == "string" and Utf8.valid(default) then
		return mod.strings.shorten(default)
	end
	return "N/A"
end
--[[
	Check if unit is player unit
--]]
mod.players.is_player_unit = function(unit)
	return DamageUtils.is_player_unit(unit)
end
--[[
	Get player from player unit
--]]
mod.players.from_player_unit = function(player_unit)
	local player_manager = Managers.player
	local players = player_manager:human_and_bot_players()
	for _, player in pairs(players) do
		if player.player_unit == player_unit then
			return player
		end
	end
	return nil
end

-- ##### ██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗ ###################################################################
-- ##### ██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝ ###################################################################
-- ##### ███████║██║   ██║██║   ██║█████╔╝ ███████╗ ###################################################################
-- ##### ██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║ ###################################################################
-- ##### ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║ ###################################################################
-- ##### ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝ ###################################################################
--[[
	Catch option menu being opened
--]]
mod:hook("VMFOptionsView.on_enter", function(func, self)
	mod.players.set_names()
	func(self)
end)

-- ##### ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗ #########################################################
-- ##### ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝ #########################################################
-- ##### █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗ #########################################################
-- ##### ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║ #########################################################
-- ##### ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║ #########################################################
-- ##### ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝ #########################################################
--[[
	Mod Setting changed
--]]
mod.setting_changed = function(setting_name)
end
--[[
	Mod Suspended
--]]
mod.suspended = function()
end
--[[
	Mod Unsuspended
--]]
mod.unsuspended = function()
end
--[[
	Mod Update
--]]
mod.update = function(dt)
end

mod:create_options(options_widgets, true, "Show Damage", "Mod description")