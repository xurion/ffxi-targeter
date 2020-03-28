_addon.name = 'Targeter'
_addon.author = 'Dean James (Xurion of Bismarck)'
_addon.commands = {'targeter', 'targ'}
_addon.version = '0.0.1'

res = require('resources')
config = require('config')

settings = config.load({
    targets = {

    },
    add_to_chat_mode = 8
})

presets = {
    statues = {
        ['Corporal Tombstone'], --San d'Oria
        ['Lithicthrower Image'], --Bastok
        ['Incarnation Idol'], --Windurst
        ['Impish Statue'], --Jeuno
    }
}

commands = {}

commands.preset = function(preset)
    if not preset or not presets[preset] then
        windower.add_to_chat(settings.add_to_chat_mode, 'Unknown ')
        return
    end

    settings.targets = presets[preset]
end

commands.add = function() end
commands.preset = function() end
commands.remove = function() end
commands.removeall = function() end
commands.list = function() end
commands.target = function() end
commands.help = function()
    windower.add_to_chat(settings.add_to_chat_mode, 'Targeter:')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter add <target name> - add a target to the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter preset <preset name> - add a preset of targets to the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter remove <target name> - remove a target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter removeall - remove all targets from the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter list - list all targets')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter target - target the nearest target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, '  //targeter help - display this help')
    windower.add_to_chat(settings.add_to_chat_mode, 'For more detailed information, see the readme')
end

windower.register_event('addon command', function(command)
    command = command and command:lower() or 'help'

    if commands[command] then
        commands[command](...)
    else
        commands.help()
    end
end)
