local obj={}
obj.__index = obj

-- Metadata
obj.name = "AutoMute"
obj.version = "1.0"
obj.author = "yaxin <yaxin.me@gmail.com>"
obj.homepage = "https://github.com/bookiu/hammerspoon-automute"
obj.license = "MIT - https://opensource.org/licenses/MIT"


local log = hs.logger.new('AutoMute', 'debug')


-- 自定义提示框样式
hs.alert.defaultStyle = {
    strokeWidth  = 0,
    strokeColor = { white = 1, alpha = 0 },
    fillColor   = { white = 0, alpha = 0.75 },
    textColor = { white = 1, alpha = 1 },
    textFont  = ".AppleSystemUIFont",
    textSize  = 16,
    radius = 4,
    atScreenEdge = 0,
    fadeInDuration = 0.15,
    fadeOutDuration = 0.15,
    padding = 10,
}

-- 函数用于在右上角显示提示
function showAlertInTopRight(message, duration)
    duration = duration or 2  -- 默认显示2秒
    local screen = hs.screen.mainScreen()
    local frame = screen:frame()
    
    -- 计算右上角位置（稍微偏移一点，不紧贴边缘）
    local topRightPoint = hs.geometry.point(frame.x + frame.w - 20, frame.y + 20)

    hs.alert.show(message, {
        strokeWidth = 0,
        fadeInDuration = 0.1,
        fadeOutDuration = 0.1,
    }, screen, duration)
end


-- 定义一个函数来检查是否有耳机连接
local function hasHeadphones()
    local devices = hs.audiodevice.allOutputDevices()
    for _, device in ipairs(devices) do
        local transportType = device:transportType()
        local uid = device:uid()
        if transportType == "Built-in" and uid == "BuiltInHeadphoneOutputDevice" then
            return true
        end
    end
    return false
end

-- 定义一个函数来处理音频设备变化
local function audioDeviceChanged(event)
    if event == 'dev#' then  -- 设备数量变化
        log.d("audit device changed")
        if not hasHeadphones() then
            -- 如果没有检测到耳机，则静音
            local device = hs.audiodevice.defaultOutputDevice()
            if device then
                device:setMuted(true)
                showAlertInTopRight("耳机已拔出，系统已静音")
            end
        end
    end
end

function obj:start()
    local defaultDevice = hs.audiodevice.defaultOutputDevice()
    log.d("default output device transport type=" .. defaultDevice:transportType())
    log.d("default output device uid=" .. defaultDevice:uid())

    -- 初始检查
    if not hasHeadphones() then
        local device = hs.audiodevice.defaultOutputDevice()
        if device then
            device:setMuted(true)
            showAlertInTopRight("启动时未检测到耳机，系统已静音")
        end
    end

    -- 设置音频设备变化的监听器
    hs.audiodevice.watcher.setCallback(audioDeviceChanged)
    hs.audiodevice.watcher.start()

    return self
end

return obj
