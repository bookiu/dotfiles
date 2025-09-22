local obj={}
obj.__index = obj

-- Metadata
obj.name = "QuickLauncher"
obj.version = "1.0"
obj.author = "yaxin <yaxin.me@gmail.com>"
obj.homepage = "https://github.com/bookiu/hammerspoon-quicklauncher"
obj.license = "MIT - https://opensource.org/licenses/MIT"


local log = hs.logger.new('QuickLauncher', 'debug')


local function launchOrFocus(appName)
    -- if app is running as a full screen window, then focus it
    -- if app is running in the background, then activate it
    local app = hs.application.get(appName)
    if app then
        log.d("app is running, activate it. app=" .. appName .. ", isFrontmost=" .. tostring(app:isFrontmost()) .. ", isHidden=" .. tostring(app:isHidden()) .. ", isRunning=" .. tostring(app:isRunning()))
        
        if appName == "Lark" then
            hs.application.launchOrFocus(appName)
        else
            app:activate()
        end
    
    else
        log.d("app is not running, launch it. appName=" .. appName)
        hs.application.launchOrFocus(appName)
    end
end


function obj:start()
    hs.hotkey.bind({'cmd'}, '1', function () launchOrFocus("Google Chrome") end)
    hs.hotkey.bind({'cmd'}, '2', function () launchOrFocus("iTerm") end)
    hs.hotkey.bind({'cmd'}, '3', function () launchOrFocus("Lark") end)
    hs.hotkey.bind({'cmd'}, '4', function () launchOrFocus("Cursor") end)
    hs.hotkey.bind({'cmd'}, '5', function () launchOrFocus("Arc") end)
    hs.hotkey.bind({'cmd'}, '6', function () launchOrFocus("Sublime Text") end)
    return self
end

return obj
