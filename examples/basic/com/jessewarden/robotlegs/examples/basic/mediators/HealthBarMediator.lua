--[[
	Copyright (c) 2011 the original author or authors

	Permission is hereby granted to use, modify, and distribute this file
	in accordance with the terms of the license agreement accompanying it.
--]]


local Mediator = require "org.robotlegs.Mediator"

local PlayerModel = require "com.jessewarden.robotlegs.examples.basic.models.PlayerModel"

local HealthBarMediator = {}

function HealthBarMediator:new()
	
	local mediator = Mediator:new()
	
	function mediator:onRegister()
		Runtime:addEventListener("PlayerModel_hitPointsChanged", self)
		self:PlayerModel_hitPointsChanged()
	end
	
	function mediator:onRemove()
		Runtime:removeEventListener("PlayerModel_hitPointsChanged", self)
	end
	
	function mediator:PlayerModel_hitPointsChanged(event)
		mediator.viewInstance:setHealth(PlayerModel.instance:getHitpointsPercentage())
	end
	
	return mediator
	
end

return HealthBarMediator