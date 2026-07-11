---
-- @Liquipedia
-- page=Module:Infobox/Character/Custom
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Lua = require('Module:Lua')

local Class = Lua.import('Module:Class')

local Character = Lua.import('Module:Infobox/Character')
local Injector = Lua.import('Module:Widget/Injector')
local PositionIcon = Lua.import('Module:PositionIcon', {loadData = true})

local Widgets = Lua.import('Module:Widget/All')
local Html = Lua.import('Module:Widget/Html')
local IconImageWidget = Lua.import('Module:Widget/Image/Icon/Image')
local Cell = Widgets.Cell

---@class DeltaforceCharacterInfobox: CharacterInfobox
local CustomCharacter = Class.new(Character)
---@class DeltaforceCharacterInfoboxWidgetInjector: WidgetInjector
---@field caller DeltaforceCharacterInfobox
local CustomInjector = Class.new(Injector)

---@param frame Frame
---@return Html
function CustomCharacter.run(frame)
	local character = CustomCharacter(frame)
	character:setWidgetInjector(CustomInjector(character))
	character.args.informationType = 'Characters'
	return character:createInfobox()
end

---@param id string
---@param widgets Widget[]
---@return Widget[]
function CustomInjector:parse(id, widgets)
	if id == 'role' then
		return {
			Cell{
				name = 'Position',
				children = {self:_toCellContent('class')}
			},
		}
	end
	return widgets
end

---@param key string
---@return Widget?
function CustomInjector:_toCellContent(key)
	local args = self.caller.args
	if not args[key] or args[key] == '' then return end
	local iconData = PositionIcon[args[key]:lower()]
	return iconData and Html.Fragment{
		children = {
			IconImageWidget{
				imageLight = iconData.icon,
				link = iconData.link,
				size = '15px'
			},
			' ',
			iconData.displayName
		}
	} or nil
end

---@param lpdbData table
---@param args table
---@return table
function CustomCharacter:addToLpdb(lpdbData, args)
	lpdbData.extradata.class = args.class
	return lpdbData
end

return CustomCharacter
