do
	-- Função para configurar ROE para um grupo específico
	function ApplyROEToGroup(group, roeState)
		if group and group:IsAlive() then
			group:OptionROE(roeState)
			env.info("ROE aplicado ao grupo: " .. group:GetName())
		else
			env.info("Grupo inválido ou não encontrado ao tentar aplicar ROE.")
		end
	end

	-- Função para configurar ROE para todas as unidades terrestres ativas
	function SetROEForAllGroundUnits(roeState)
		local groundGroups = SET_GROUP:New():FilterCategories("ground"):FilterStart()
		local count = 0

		groundGroups:ForEachGroup(
			function(group)
				ApplyROEToGroup(group, roeState)
				count = count + 1
			end
		)

		-- Mensagem no jogo para confirmar que o script foi carregado
		MESSAGE:New("ROE configurado para " .. count .. " grupos terrestres.", 15):ToAll()
		env.info("SetROEForAllGroundUnits: ROE configurado para " .. count .. " grupos terrestres.")
	end

	-- Função para monitorar a ativação tardia de grupos
	function MonitorLateActivation(roeState)
		world.addEventHandler({
			onEvent = function(self, event)
				if event.id == world.event.S_EVENT_BIRTH and event.initiator then
					local unit = UNIT:Find(event.initiator)
					if unit and unit:IsAlive() then
						local group = unit:GetGroup()
						if group and group:GetCategory() == Group.Category.GROUND then
							ApplyROEToGroup(group, roeState)
						end
					end
				end
			end
		})
		env.info("Monitor de ativação tardia configurado.")
	end

	-- Configurar ROE para grupos existentes e monitorar novos spawns
	function InitializeROE(roeState)
		SetROEForAllGroundUnits(roeState)  -- Configurar ROE para grupos existentes
		MonitorLateActivation(roeState)   -- Monitorar ativação tardia
	end

	-- Inicializar com ROE configurado como Open Fire
	InitializeROE(ENUMS.ROE.OpenFire)

	-- Mensagem para confirmar que o script foi carregado
	MESSAGE:New("Script de ROE com monitoramento carregado com sucesso.", 10):ToAll()
	env.info("Script de ROE com monitoramento carregado com sucesso.")

end