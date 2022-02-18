registerForEvent('onInit', function()
	local file = io.open("persistency.json", "r")
	local contents = file:read("*a")
	local validJson, persistedState = pcall(function() return json.decode(contents) end)

	if validJson then
		file:close();

		Observe('inkLogicController', 'LoadPersistedState', function(self)
			local widgetName = Game.NameToString(self:GetRootWidget():GetName());

			local scale = persistedState[widgetName]["scale"];
			local translation = persistedState[widgetName]["translation"];

			self:SetPersistedState(translation.X, translation.Y, scale.X, scale.Y);
		end)
		
		Observe('inkLogicController', 'UpdatePersistedState', function(self, translation, scale)
			local widgetName = Game.NameToString(self:GetRootWidget():GetName());

			persistedState[widgetName].translation.X = translation.X;
			persistedState[widgetName].translation.Y = translation.Y;
			persistedState[widgetName].scale.X = scale.X;
			persistedState[widgetName].scale.Y = scale.Y;
		end)

		Observe('inkHUDGameController', 'PersistHUDWidgetsState', function(self)
			local validJson, contents = pcall(function() return json.encode(persistedState) end)

			if validJson and contents ~= nil then
				local updatedFile = io.open("persistency.json", "w+");

				updatedFile:write(contents);
				updatedFile:close();
			end
		end)
	end
end)

