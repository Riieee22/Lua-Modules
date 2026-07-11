---
-- @Liquipedia
-- page=Module:Infobox/Character/Custom
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Lua = require('Module:Lua')

local Class = Lua.import('Module:Class')
local Logic = Lua.import('Module:Logic')
local String = Lua.import('Module:StringUtils')

local Injector = Lua.import('Module:Widget/Injector')
local Character = Lua.import('Module:Infobox/Character')
local PositionIcon = Lua.import('Module:PositionIcon', { loadData = true })

local Widgets = Lua.import('Module:Widget/All')
local HtmlWidgets = Lua.import('Module:Widget/Html/All')
local Cell = Widgets.Cell
local IconImageWidget = Lua.import('Module:Widget/Image/Icon/Image')

---@class DeltaforceCharacterInfobox: CharacterInfobox
local CustomCharacter = Class.new(Character)
---@class DeltaforceCharacterInfoboxWidgetInjector: WidgetInjector
---@field caller DeltaforceCharacterInfobox
local CustomInjector = Class.new(Injector)

---@param frame Frame
---@return VNode
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
				children = { self:_toCellContent('position') }
			},
		}
	end
	return widgets
end

---@param key string
---@return Widget?
function CustomInjector:_toCellContent(key)
	local args = self.caller.args
	if String.isEmpty(args[key]) then return end
	local iconData = PositionIcon[args[key]:lower()]
	return Logic.isNotEmpty(iconData) and HtmlWidgets.Fragment{
		children = {
			IconImageWidget{
				imageLight = iconData.icon,
				link = iconData.link
			},
			' ',
			iconData.displayName
		}
	} or args[key]
end

---@param lpdbData table
---@param args table
---@return table
function CustomCharacter:addToLpdb(lpdbData, args)
	lpdbData.extradata.class = args.class
	lpdbData.extradata.position = args.position
	return lpdbData
end

return CustomCharacter
