hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.loadSpoon("AutoMuteEarphone")
spoon.AutoMuteEarphone:start()

local log = hs.logger.new("IME", "debug")
local wechatInputMethodSourceID = "com.tencent.inputmethod.wetype.pinyin"
local squirrelIMSourceID = "im.rime.inputmethod.Squirrel.Hans"

local usedIMSourceID = wechatInputMethodSourceID

function isCurrentInputSource(sourceID, isMethod)
	if isMethod then
		local current = hs.keycodes.currentSourceID()
		-- log.d("get current IM source id. IMSourceId=" .. current)
		return sourceID == current
	end
	return sourceID == hs.keycodes.currentLayout()
end

function changeInputSource(sourceID)
	hs.keycodes.currentSourceID(sourceID)
end

function forceChangeInputMethod(sourceID)
	return function()
		if isCurrentInputSource(sourceID, true) then
			return
		end
		-- change to wechat
		-- log.d("start to change IME. target=" .. sourceID)
		changeInputSource(sourceID)
	end
end

hs.keycodes.inputSourceChanged(forceChangeInputMethod(usedIMSourceID))
