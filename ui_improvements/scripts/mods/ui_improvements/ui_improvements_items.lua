local mod = get_mod("ui_improvements")
--[[
	Author: grasmann

	Lets you switch equippment of all characters / classes in inventory

	Version: 1.3.0
--]]

-- ##### ██████╗  █████╗ ████████╗ █████╗ #############################################################################
-- ##### ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗ ############################################################################
-- ##### ██║  ██║███████║   ██║   ███████║ ############################################################################
-- ##### ██║  ██║██╔══██║   ██║   ██╔══██║ ############################################################################
-- ##### ██████╔╝██║  ██║   ██║   ██║  ██║ ############################################################################
-- ##### ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ############################################################################
local saved_index = 1
local dont_save = false
mod.orig_profile_index = nil
mod.orig_career_index = nil

-- ##### ███████╗██╗   ██╗███╗   ██╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗███████╗ ###################################
-- ##### ██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝ ###################################
-- ##### █████╗  ██║   ██║██╔██╗ ██║██║        ██║   ██║██║   ██║██╔██╗ ██║███████╗ ###################################
-- ##### ██╔══╝  ██║   ██║██║╚██╗██║██║        ██║   ██║██║   ██║██║╚██╗██║╚════██║ ###################################
-- ##### ██║     ╚██████╔╝██║ ╚████║╚██████╗   ██║   ██║╚██████╔╝██║ ╚████║███████║ ###################################
-- ##### ╚═╝      ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ###################################
--[[
    Overwrite functions
--]]
mod.overwrite_item_functions = function(self, overwrite)
    local player = Managers.player:local_player()

    if overwrite then

        -- Backup original profile function
        mod.orig_profile_index = player.profile_index

        -- Overwrite profile function
        player.profile_index = function(self)
            return mod.profile_index or mod.orig_profile_index(self)
        end

        -- Backup original career function
        mod.orig_career_index = player.career_index

        -- Overwrite career function
        player.career_index = function(self)
            return mod.career_index or mod.orig_career_index(self)
        end

    else

        -- Reset original profile functions
        if mod.orig_profile_index then
            player.profile_index = mod.orig_profile_index
            mod.orig_profile_index = nil
        end

        -- Reset original career functions
        if mod.orig_career_index then
            player.career_index = mod.orig_career_index
            mod.orig_career_index = nil
        end

    end

end

-- ##### ██╗  ██╗ ██████╗  ██████╗ ██╗  ██╗███████╗ ###################################################################
-- ##### ██║  ██║██╔═══██╗██╔═══██╗██║ ██╔╝██╔════╝ ###################################################################
-- ##### ███████║██║   ██║██║   ██║█████╔╝ ███████╗ ###################################################################
-- ##### ██╔══██║██║   ██║██║   ██║██╔═██╗ ╚════██║ ###################################################################
-- ##### ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗███████║ ###################################################################
-- ##### ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝ ###################################################################
--[[
	Render correct item tooltips
--]]
mod:hook(UIPasses.item_tooltip, "draw", function(func, ...)
	local player = Managers.player:local_player()
	local orig_profile_index, orig_career_index

	-- -- Overwrite profile function
	-- orig_profile_index = player.profile_index
	-- player.profile_index = function(self)
	-- 	return mod.profile_index or orig_profile_index(self)
	-- end

	-- -- Overwrite career function
	-- orig_career_index = player.career_index
	-- player.career_index = function(self)
	-- 	return mod.career_index or orig_career_index(self)
    -- end
    
    mod:overwrite_item_functions(true)

	-- Original function
	func(...)

    mod:overwrite_item_functions(false)

	-- -- Reset functions
	-- player.profile_index = orig_profile_index
	-- player.career_index = orig_career_index

end)
--[[
	Prevent equipment to be destroyed and spawned when not active character
--]]
mod:hook(SimpleInventoryExtension, "create_equipment_in_slot", function(func, ...)
	-- If different character or career selected cancel process
	if mod.profile_index ~= mod.actual_profile_index or mod.career_index ~= mod.actual_career_index then
		return
	end
	-- Continue with original function
	func(...)
end)
--[[
	Get correct items for selected character
--]]
mod:hook(ItemGridUI, "_get_items_by_filter", function(func, self, ...)
	local player = Managers.player:local_player()
	local orig_profile_index, orig_career_index

	-- -- Backup profile function
	-- orig_profile_index = player.profile_index
	-- player.profile_index = function(self)
	-- 	return mod.profile_index or orig_profile_index(self)
	-- end

	-- -- Backup career function
	-- orig_career_index = player.career_index
	-- player.career_index = function(self)
	-- 	return mod.career_index or orig_career_index(self)
    -- end
    
    mod:overwrite_item_functions(true)

	-- Orig function
    local items = func(self, ...)
    
    mod:overwrite_item_functions(false)

	-- -- Reset functions
	-- player.profile_index = orig_profile_index
	-- player.career_index = orig_career_index

	return items
end)

--[[
    Open saved inventory category on enter
--]]
mod:hook(HeroWindowLoadoutInventory, "on_enter", function(func, self, params, offset, ...)

    -- Prevent saved inventory category being overwritten
	dont_save = true
	func(self, params, offset, ...)
    dont_save = false
    
    -- Open saved inventory category
	if saved_index and mod:get("remember_categories") then
		self.parent:set_selected_loadout_slot_index(saved_index)
    end
    
end)
--[[
    Save opened inventory category
--]]
mod:hook_safe(HeroWindowLoadoutInventory, "_change_category_by_index", function(self, index, force_update, ...)

    -- Save selected inventory category
    if not dont_save then saved_index = index end
    
end)