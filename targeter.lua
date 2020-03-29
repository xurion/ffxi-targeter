_addon.name = 'Targeter'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.commands = {'targeter', 'targ'}
_addon.version = '0.0.1'

config = require('config')
packets = require('packets')
require('tables')

settings = config.load({
    targets = L{},
    add_to_chat_mode = 8,
    presets = {},
})

commands = {}

commands.save = function(preset_name)
    if not preset_name then
        windower.add_to_chat(settings.add_to_chat_mode, 'Saved targets need a name. //targ save <name>')
        return
    end

    settings.presets[preset_name] = L{settings.targets:unpack()}
    settings:save()
    windower.add_to_chat(settings.add_to_chat_mode, preset_name .. ' saved')
end

commands.load = function(preset_name)
    if not preset_name or not settings.presets[preset_name] then
        windower.add_to_chat(settings.add_to_chat_mode, 'Unknown preset. //targ load <name>')
        return
    end

    settings.targets = L{settings.presets[preset_name]:unpack()}
    settings:save()
    windower.add_to_chat(settings.add_to_chat_mode, preset_name .. ' preset loaded')
end

commands.add = function(...)
    local target = T{...}:sconcat()
    if target == 'nil' then return end

    if target == '' then
        local selected_target = windower.ffxi.get_mob_by_target('t')
        if not selected_target then return end
        target = selected_target.name
    end

    target = target:lower()
    if not settings.targets:contains(target) then
        settings.targets:append(target)
        settings.targets:sort()
        settings:save()
    end

    windower.add_to_chat(settings.add_to_chat_mode, target .. ' added')
end
commands.a = commands.add

commands.remove = function(...)
    local target = T{...}:sconcat()

    if target == '' then
        local selected_target = windower.ffxi.get_mob_by_target('t')
        if not selected_target then return end
        target = selected_target.name
    end

    target = target:lower()
    local new_targets = L{}
    for k, v in ipairs(settings.targets) do
        if v ~= target then
            new_targets:append(v)
        end
    end
    settings.targets = new_targets
    settings:save()
    windower.add_to_chat(settings.add_to_chat_mode, target .. ' removed')
end
commands.r = commands.remove

commands.removeall = function()
    settings.targets = L{}
    settings:save()
    windower.add_to_chat(settings.add_to_chat_mode, 'All targets removed')
end
commands.ra = commands.removeall

commands.list = function()
    if #settings.targets == 0 then
        windower.add_to_chat(settings.add_to_chat_mode, 'There are no targets set')
        return
    end

    windower.add_to_chat(settings.add_to_chat_mode, 'Targets:')
    for _, target in ipairs(settings.targets) do
        windower.add_to_chat(settings.add_to_chat_mode, '  ' .. target)
    end
end
commands.l = commands.list

commands.target = function()
    local mobs = windower.ffxi.get_mob_array()
    local closest
    for _, mob in pairs(mobs) do
        if mob.valid_target and mob.hpp > 0 and settings.targets:contains(mob.name:lower()) then
            if not closest or mob.distance < closest.distance then
                closest = mob
            end
        end
    end

    if not closest then
        windower.add_to_chat(settings.add_to_chat_mode, 'Cannot find valid target')
        return
    end

    local player = windower.ffxi.get_player()

    packets.inject(packets.new('incoming', 0x058, {
        ['Player'] = player.id,
        ['Target'] = closest.id,
        ['Player Index'] = player.index,
    }))
end
commands.t = commands.target

commands.help = function()
    windower.add_to_chat(settings.add_to_chat_mode, 'Targeter:')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ add <target name> - add a target to the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ preset <preset name> - add a preset of targets to the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ remove <target name> - remove a target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ removeall - remove all targets from the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ list - list all targets')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ target - target the nearest target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targ help - display this help')
    windower.add_to_chat(settings.add_to_chat_mode, '(For more detailed information, see the readme)')
end

windower.register_event('addon command', function(command, ...)
    command = command and command:lower() or 'help'

    if commands[command] then
        commands[command](...)
    else
        commands.help()
    end
end)

--[[
    Tests:

    Add a single-worded name
    Add a multiple-worded name
    Add a null name
    Add a duplicate

    Add with a selected target and no target name (//targ add)

    Add a preset
    Add an invalid preset
    Add a duplicate preset

    Check settings persistance
    Check sorting

    Check help + null command for help
]]
