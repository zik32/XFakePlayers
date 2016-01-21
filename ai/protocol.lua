--[[
	Основное описание протокола XFakePlayers AI.
	
		XFakePlayers AI предлагает высокоуровневое использование основных механик 
	игры с помощью встраиваемого языка Lua. Таким образом, это первый в своём 
	роде внешний AI для Half-Life и его модов (включая Counter-Strike).
	
		Движок проектировался таким образом, чтобы любой пользователь мог вносить
	правки в код, заставляя AI работать так, как ему этого хочется.
		
	Используемые методы из основного модуля:
	
		"Initialization" - вызывается из CL_InitializeLua (XPlayableClient) на 
	старте игровой сессии, может содержать любой кастомный код (а может и не содержать), 
	использовать для инициализации глобальных переменных.
	
		"Finalization" - аналогична предыдущему методу, но вызывается при завершении 
	игровой сессии (CL_FinalizeConnection, dropclient, disconnect, etc..), использовать по усмотрению.
	
		"Frame" - основной метод.
		
		"OnTrigger(TriggerType)" - события, которые передаёт движок.
		
		Все эти методы должны находиться в 'core.lua' - это единственный вызываемый файл.
]]
-- XNativeEngine.pas property

--[[
	ExecuteCommand(command: string)
		исполнить команду (command) на клиенте
]]
-- XBaseGameClient.pas property

--[[
	GetState(): State
		получить состояние подключения
]]
	State = {
		NONE = 0,
		HTTP_DOWNLOADING = 1,
		DISCONNECTED = 2,
		WAIT_CHALLENGE = 3,
		CONNECTING = 4,
		CONNECTION_ACCEPTED = 5,
		VERIFYING_RESOURCES = 6, -- or downloading resources
		SPAWNED = 7,
		GAME = 8
	}
--[[
	GetServer(): str
		получить адрес сервера, на котором находитс¤ актЄр

	GetTime(): float
		получить абсолютное врем¤ сервера (svc_time)
		
	GetServerInfo(ServerInfoType): any
		получить значение из структуры ServerInfo (svc_serverinfo)
]]
	ServerInfoType = {
		Protocol = 0, -- int
		SpawnCount = 1, -- int
		CheckSum = 2, -- int
		CRC = 3, -- int
		MaxPlayers = 4, -- int
		Index = 5,    -- your slot at server -- int
		GameDir = 6, -- str
		Name = 7, -- str
		Map = 8, -- str
		MapEx = 9 -- truncated map name -- str 
	}
--[[
	GetIntermission(): int
		svc_intermission state
		
	IsPaused(): bool
		svc_setpause state

	MoveTo(pos: float[3])
		двигатьс¤ к точке
		
	MoveTo(ent: int)
		двигатьс¤ к энтити под индексом
		
	MoveOut(pos: float[3])
		двигатьс¤ от точки
		
	MoveOut(ent: int)
		двигатьс¤ от энтити под индексом
	
	LookAt(pos: float[3])
		посмотреть на точку
		
	LookAt(ent: int)
		посмотреть на энтити под индексом
		
	LookAtEx(pos: float[3]) 
		плавно посмотреть на точку
	
	LookAtEx(ent: int) 
		плавно посмотреть на энтити под индексом

	PressButton(Button)
		нажать кнопку
	
	UnPressButton(Button)
		отжать кнопку
		
	IsButtonPressed(Button): bool
		нажата ли кнопка
]]
	Button = {
		ATTACK = 1 << 0,
		JUMP = 1 << 1,
		DUCK = 1 << 2,
		FORWARD = 1 << 3,
		BACK = 1 << 4,
		USE = 1 << 5,
		CANCEL = 1 << 6,
		LEFT = 1 << 7,
		RIGHT = 1 << 8,
		MOVELEFT = 1 << 9,
		MOVERIGHT = 1 << 10,
		ATTACK2 = 1 << 11,
		RUN = 1 << 12,
		RELOAD = 1 << 13,
		ALT1 = 1 << 14,
		SCORE = 1 << 15
	}
--[[
		
	GetOrigin(): float[3]
		получить координаты актёра
		
	GetVelocity(): float[3]
		получить скорость актЄра
	
	GetPunchAngle(): float[3]
		получить смещение прицела актЄра (отдача во врем¤ стрельбы)
		
	GetWeaponIndex(): int
		получить индекс текущего оружи¤ (clientdata.id)
		
	GetDistance(pos: float[3]): float
		получить дистанцию до точки
		
	GetDistance(ent: int): float
		получить дистанцию до энтити
		
	GetDistance2D(pos\ent: float[3]\int): float
		^^
	
	IsWeaponExists(weapon): bool
		есть ли в инвентаре оружие под индексом weapon
	
	IsCrouching(): bool
		находитс¤ ли актЄр в прис¤ди
	
	IsOnGround(): bool
		находитс¤ ли актЄр на земле (на полу)
		
	IsSpectator(): bool
		¤вл¤етс¤ ли актЄр наблюдателем
		
	HasWeaponData(weapon_index): bool
		есть ли weapondata_t для данного оружия
		
	GetWeaponDataField(weapon_index: int; field: WeaponDataField): any
		получить значение поля (field) из оружия под индексом (weapon_index), используя массив weapondata_t
]]
	WeaponDataField = {
		ID = 1, -- int
		Clip = 2, -- int
		NextPrimaryAttack = 3, -- float
		NextSecondaryAttack = 4, -- float
		TimeWeaponIdle = 5, -- float
		InReload = 6, -- int
		InSpecialReload = 7, -- int
		NextReload = 8, -- float
		PumpTime = 9, -- float
		ReloadTime = 10, -- float
		AimedDamage = 11, -- float
		NextAimBonus = 12, -- float
		InZoom = 13, -- int
		WeaponState = 14, -- int
		IUser1 = 15, -- int
		IUser2 = 16, -- int
		IUser3 = 17, -- int
		IUser4 = 18, -- int
		FUser1 = 19, -- float
		FUser2 = 20, -- float
		FUser3 = 21, -- float
		FUser4 = 22 -- float	
	}

--[[	
	IsReloading(): bool
		находитс¤ ли актЄр в состо¤нии перезар¤дки
		
	GetMaxSpeed(): float
		получить максимальную скорость (clientdata.maxspeed & movevars.maxspeed)
		
	IsAlive(): bool
		жив ли актЄр
		
	PrimaryAttack()
		...
		
	SecondaryAttack()
		...
		
	FastPrimaryAttack()
		...
		
	FastSecondaryAttack()
		...

	Jump()
		...
		
	Duck()
		...
		
	DuckJump()	
		...
		
	GetPlayersCount(): int
		
	GetPlayerField(player: int; field: PlayerField): any
		получить значение пол¤ (field) из игрока под индексом (player), использу¤ Players массив
		
]]
	PlayerField = {
		UserID = 1, -- int
		UserInfo = 2, -- : LStr;
		--MD5 = 3, -- : TMD5Digest; -------> DO NOT USE THIS
		Kills = 4, -- int 
		Deaths = 5, -- int
		Ping = 6, -- int
		Loss = 7, -- int
		--Entity = 8, -- int   --------> DO NOT USE DIS 

		-- from gmsgs
		Team = 9, -- : LStr;
		ClassID = 10, -- int 
		TeamID = 11, -- int

		-- cstrike
		Health = 12, -- int // event hltv
		ScoreAttrib = 13, -- int // event scoreattrib
		Location = 14, -- str // event location
		Radar = 15, -- float[3] // event radar

		-- utils
		Origin = 16, -- float[3]
		Name = 17, -- str
		
		IsCSAlive = 18, -- bool
		IsCSBomber = 19, -- bool
		IsCSVIP = 20, -- bool
		}
--[[	
	GetEntitiesCount(): int
		получить количесвто энтити 
		
	GetEntityField(ent: int; field: EntityField): any
		получить значение пол¤ (field) из энтити под индексом (ent)
]]
	EntityField = {
		EntityType = 1, -- int
		Number = 2, -- int
		
		MsgTime = 3, -- float
		MessageNum = 4, -- int
		
		Origin = 5, -- float[3]
		Angles = 6, -- float[3]
		
		ModelIndex = 7, -- int
		Sequence = 8, -- int
		Frame = 9, -- float
		ColorMap = 10, -- int
		Skin = 11, -- int
		Solid = 12, -- int
		Effects = 13, -- int
		Scale = 14, -- float
		EFlags = 15, -- int
		
		RenderMode = 16, -- int 
		RenderAmt = 17, -- int
		--RenderColor = 18, -- : TRGB;   -----------> FUCK YOU
		RenderFX = 19, -- int
		
		MoveType = 20, -- int
		AnimTime = 21, -- float
		FrameRate = 22, -- float
		Body = 23, -- int
		--Controller = 24, -- : array[0..3] of Byte; // int32 ?   -----------> DO NOT USE THIS FIELD
		--Blending = 25, -- : array[0..3] of Byte;     ----------------------> THIS TOO

		Velocity = 26, -- float[3]

		MinS = 27, -- float[3]
		MaxS = 28, -- float[3]

		AimEnt = 29, -- int
		Owner = 30, -- int

		Friction = 31, -- float
		Gravity = 32, -- float

		Team = 33, -- int // tfc
		PlayerClass = 34, -- int // tfc
		Health = 35, -- int
		Spectator = 36, -- int 
		WeaponModel = 37, -- int 
		GaitSequence = 38, -- int

		BaseVelocity = 39, -- float[3]
		UseHull = 40, -- int
		OldButtons = 41, -- int 
		OnGround = 42, -- int 
		StepLeft = 43, -- int

		FallVelocity = 44, -- float

		FOV = 45, -- float
		WeaponAnim = 46, -- int

		StartPos = 47, -- float[3] 
		EndPos = 48, -- float[3]
		ImpactTime = 49, -- float
		StartTime = 50, -- float

		IUser1 = 51, -- int 
		IUser2 = 52, -- int 
		IUser3 = 53, -- int 
		IUser4 = 54, -- int
		
		FUser1 = 55, -- float
		FUser2 = 56, -- float
		FUser3 = 57, -- float
		FUser4 = 58, -- float
		
		VUser1 = 59, -- float[3]
		VUser2 = 60, -- float[3]
		VUser3 = 61, -- float[3]
		VUser4 = 62, -- float[3]
		
		IsActive = 63 -- bool
	}
--[[
	GetGroundedOrigin(): float[3]
		тоже самое что и GetOrigin, однако получаем координаты поверхности, где стоит актёр
	
	GetGroundedDistance(origin: float[3]): float
		тоже самое что и GetDistance, однако вычисления ведётся используя GetGroundedOrigin
		
	GetGroundedDistance(ent: int): float
		...

]]

-- XSimpleGameClient.pas property

--[[
	GetHealth(): int
		получить очки здоровь¤ актЄра (EHealth)
		
	GetWeaponsCount(): int
		получить количество доступного оружия
		
	GetWeaponField(weapon: int; field: WeaponField): any
		получить значение поля (field) из оружия под индексом (weapon)
]]
	WeaponField = {
		Name = 1, -- string
		PrimaryAmmoID = 2, -- int
		PrimaryAmmoMaxAmount = 3, -- int
		SecondaryAmmoID = 4, -- int
		SecondaryAmmoMaxAmount = 5, -- int
		SlotID = 6, -- int
		NumberInSlot = 7, -- int
		Index = 8, -- int
		Flags = 9,  -- int
		
		ResolvedName = 10 -- string
	}

--[[
	IsTeamPlay(): bool
		reading EGameMode event status
		
	GetAmmo(weapon: int): int
		reading EAmmoX event
]]

-- XPlayableClient.pas property

--[[
	HasNavigation(): bool
		is navigation (*.nav) file loaded
		
	HasWorld(): bool
		is world (*.bsp) file loaded
		
	HasWays(): bool
		is ways (*.way) file loaded
		
	IsVisible(pos: float[3]): bool
		видна ли точка из глаз актёра (используетс¤ bsp карта дл¤ анализа)
		
	IsVisible(ent: int): bool
		тоже самое, только дл¤ энтити
		
	NavGetArea(pos: float[3]): int
		получить абсолютный индекс зоны из NAV файла
	
	NavGetArea(ent: int): int
		same..^
		
	NavAreaGetField(area: int; field: NavAreaField): any
		...
]]
	NavAreaField = {
		Index = 1, -- int - unique area index
		Flags = 2, -- int - set of attribute bit flags
		TextName = 3, -- str - resolve area name
		Center = 4, -- float[3] - get center in world
		
		ConnectionsCount = 5, -- int
		HidingSpotsCount = 6, -- int
		ApproachesCount = 7, -- int
		EncountersCount = 8, -- int
		LaddersCount = 9, -- int
		VisiblesCount = 10 -- int
	}
--[[		
	NavGetRandomArea(): int
		...
		
	NavGetChain(area1, area2: int): int[any]
		...
		
	NavAreaIsConnected(area1, area2: int): bool
		...
	
	NavAreaGetPortal(area1, area2: int): float[3]
		...
		
	NavAreaGetPortal(area1, area2: int; start, end: float[3])
		...
		
	NavAreaGetWindow(area1, area2: int): float[6]
		...
		
	NavAreaIsBiLinked(area1, area2: int): bool
		...
		
	NavAreaApproachGetField(area, approach: int; field: NavApproachField): any
]]
	NavApproachField = {
		Here = 1, -- int - the approach area
		Prev = 2, -- int - the area just before the approach area on the path
		PrevToHereHow = 3, -- int
		Next = 4, -- int - the area just after the approach area on the path
		HereToNextHow = 5, -- int -
		Parent = 6 -- int
	}

--[[

]]
	

-- personal 

	ModificationType = {
		Unknown = 0,
		HalfLife = 1,
		CounterStrike = 2,
		ConditionZero = 3,
		DayOfDefeat = 4,
		DeathmatchClassic = 5,
		OpposingForce = 6,
		Ricochet = 7,
		TeamFortressClassic = 8
	}

-- Protocol.pas property

	HUMAN_HEIGHT_STAND = 36
	HUMAN_HEIGHT_DUCK = HUMAN_HEIGHT_STAND / 2

	HUMAN_WIDTH = 32
	HUMAN_WIDTH_HALF = HUMAN_WIDTH / 2

	MAX_UNITS = 8192
	
-- Weapon.pas property

	MAX_WEAPONS = 32
	WEAPON_NOCLIP = -1

-- Half-Life

	HL_WEAPON_NONE = 0
	HL_WEAPON_CROWBAR = 1
	HL_WEAPON_GLOCK = 2
	HL_WEAPON_PYTHON = 3
	HL_WEAPON_MP5 = 4
	HL_WEAPON_CHAINGUN = 5
	HL_WEAPON_CROSSBOW = 6
	HL_WEAPON_SHOTGUN = 7
	HL_WEAPON_RPG = 8
	HL_WEAPON_GAUSS = 9
	HL_WEAPON_EGON = 10
	HL_WEAPON_HORNETGUN = 11
	HL_WEAPON_HANDGRENADE = 12
	HL_WEAPON_TRIPMINE = 13
	HL_WEAPON_SATCHEL = 14
	HL_WEAPON_SNARK = 15

	-- weapon clip/carry ammo capacities
	HL_AMMO_URANIUM_MAX_CARRY = 100
	HL_AMMO_9MM_MAX_CARRY = 250
	HL_AMMO_357_MAX_CARRY = 36
	HL_AMMO_BUCKSHOT_MAX_CARRY = 125
	HL_AMMO_BOLT_MAX_CARRY = 50
	HL_AMMO_ROCKET_MAX_CARRY = 5
	HL_AMMO_HANDGRENADE_MAX_CARRY = 10
	HL_AMMO_SATCHEL_MAX_CARRY = 5
	HL_AMMO_TRIPMINE_MAX_CARRY = 5
	HL_AMMO_SNARK_MAX_CARRY = 15
	HL_AMMO_HORNET_MAX_CARRY = 8
	HL_AMMO_M203_GRENADE_MAX_CARRY = 10

	-- The amount of ammo given to a player by an ammo item.
	HL_AMMO_URANIUMBOX_GIVE = 20
	HL_AMMO_9MM_GIVE = 17
	HL_AMMO_357_GIVE = 6
	HL_AMMO_MP5CLIP_GIVE = 50
	HL_AMMO_CHAINBOX_GIVE = 200
	HL_AMMO_M203BOX_GIVE = 2
	HL_AMMO_BUCKSHOTBOX_GIVE = 12
	HL_AMMO_CROSSBOWCLIP_GIVE = 5
	HL_AMMO_RPGCLIP_GIVE = 1
	HL_AMMO_SNARKBOX_GIVE = 5

	-- weapon weight factors (for auto-switching)   (-1 = noswitch)
	HL_WEAPON_CROWBAR_WEIGHT = 0

	HL_WEAPON_GLOCK_WEIGHT = 10
	HL_WEAPON_PYTHON_WEIGHT = 15

	HL_WEAPON_MP5_WEIGHT = 15
	HL_WEAPON_SHOTGUN_WEIGHT = 15
	HL_WEAPON_CROSSBOW_WEIGHT = 15

	HL_WEAPON_RPG_WEIGHT = 20
	HL_WEAPON_GAUSS_WEIGHT = 20
	HL_WEAPON_EGON_WEIGHT = 25
	HL_WEAPON_HORNETGUN_WEIGHT = 20

	HL_WEAPON_HANDGRENADE_WEIGHT = 10
	HL_WEAPON_SNARK_WEIGHT = 15
	HL_WEAPON_SATCHEL_WEIGHT = -10
	HL_WEAPON_TRIPMINE_WEIGHT = -10

	-- the maximum amount of ammo each weapon's clip can hold
	HL_WEAPON_CROWBAR_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_GLOCK_MAX_CLIP = HL_AMMO_9MM_GIVE
	HL_WEAPON_PYTHON_MAX_CLIP = HL_AMMO_357_GIVE
	HL_WEAPON_MP5_MAX_CLIP = HL_AMMO_MP5CLIP_GIVE
	HL_WEAPON_MP5_DEFAULT_AMMO = 25
	HL_WEAPON_SHOTGUN_MAX_CLIP = 8
	HL_WEAPON_CROSSBOW_MAX_CLIP = HL_AMMO_CROSSBOWCLIP_GIVE
	HL_WEAPON_RPG_MAX_CLIP = HL_AMMO_RPGCLIP_GIVE
	HL_WEAPON_GAUSS_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_EGON_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_HORNETGUN_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_HANDGRENADE_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_SATCHEL_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_TRIPMINE_MAX_CLIP = WEAPON_NOCLIP
	HL_WEAPON_SNARK_MAX_CLIP = WEAPON_NOCLIP

	HLAmmo9mm = {Give = HL_AMMO_9MM_GIVE, MaxCarry = HL_AMMO_9MM_MAX_CARRY}
	HLAmmo357 = {Give = HL_AMMO_357_GIVE, MaxCarry = HL_AMMO_357_MAX_CARRY}
	HLAmmoBolt = {Give = HL_AMMO_CROSSBOWCLIP_GIVE, MaxCarry = HL_AMMO_BOLT_MAX_CARRY}
	HLAmmoBuckShot = {Give = HL_AMMO_BUCKSHOTBOX_GIVE, MaxCarry = HL_AMMO_BUCKSHOT_MAX_CARRY}
	HLAmmoRPG = {Give = HL_AMMO_RPGCLIP_GIVE, MaxCarry = HL_AMMO_ROCKET_MAX_CARRY}
	HLAmmoUranium = {Give = HL_AMMO_URANIUMBOX_GIVE, MaxCarry = HL_AMMO_URANIUM_MAX_CARRY}
	HLAmmoGrenade = {MaxCarry = HL_AMMO_HANDGRENADE_MAX_CARRY}
	HLAmmoTripmine = {MaxCarry = HL_AMMO_TRIPMINE_MAX_CARRY}
	HLAmmoSatchel = {MaxCarry = HL_AMMO_SATCHEL_MAX_CARRY}
	HLAmmoSnark = {Give = HL_AMMO_SNARKBOX_GIVE, MaxCarry = HL_AMMO_SNARK_MAX_CARRY}
  
	HLWeaponCrowbar = {Weight = HL_WEAPON_CROWBAR_WEIGHT, MaxClip = HL_WEAPON_CROWBAR_MAX_CLIP} -- no ammo
	HLWeaponGlock = {Weight = HL_WEAPON_GLOCK_WEIGHT, MaxClip = HL_WEAPON_GLOCK_MAX_CLIP, Ammo = HLAmmo9mm}
	HLWeaponPython = {Weight = HL_WEAPON_PYTHON_WEIGHT, MaxClip = HL_WEAPON_PYTHON_MAX_CLIP, Ammo = HLAmmo357}
	HLWeaponMP5 = {Weight = HL_WEAPON_MP5_WEIGHT, MaxClip = HL_WEAPON_MP5_WEIGHT, Ammo = HLAmmo9mm}
	HLWeaponChainGun = {}
	HLWeaponCrossbow = {Weight = HL_WEAPON_CROSSBOW_WEIGHT, MaxClip = HL_WEAPON_CROSSBOW_MAX_CLIP, Ammo = HLAmmoBolt}
	HLWeaponShotgun = {Weight = HL_WEAPON_SHOTGUN_WEIGHT, MaxClip = HL_WEAPON_SHOTGUN_MAX_CLIP, Ammo = HLAmmoBuckShot}
	HLWeaponRPG = {Weight = HL_WEAPON_RPG_WEIGHT, MaxClip = HL_WEAPON_RPG_MAX_CLIP, Ammo = HLAmmoRPG}
	HLWeaponGauss = {Weight = HL_WEAPON_GAUSS_WEIGHT, MaxClip = HL_WEAPON_GAUSS_MAX_CLIP, Ammo = HLAmmoUranium}
	HLWeaponEgon = {Weight = HL_WEAPON_EGON_WEIGHT, MaxClip = HL_WEAPON_EGON_MAX_CLIP, Ammo = HLAmmoUranium}
	HLWeaponHornet = {Weight = HL_WEAPON_HORNETGUN_WEIGHT, MaxClip = HL_WEAPON_HORNETGUN_MAX_CLIP} -- no ammo
	HLWeaponGrenade = {Weight = HL_WEAPON_HANDGRENADE_WEIGHT, MaxClip = HL_WEAPON_HANDGRENADE_MAX_CLIP, Ammo = HLAmmoGrenade}
	HLWeaponTripmine = {Weight = HL_WEAPON_TRIPMINE_WEIGHT, MaxClip = HL_WEAPON_TRIPMINE_MAX_CLIP, Ammo = HLAmmoTripmine}
	HLWeaponSatchel = {Weight = HL_WEAPON_SATCHEL_WEIGHT, MaxClip = HL_WEAPON_SATCHEL_MAX_CLIP, Ammo = HLAmmoSatchel}
	HLWeaponSnark = {Weight = HL_WEAPON_SNARK_WEIGHT, MaxClip = HL_WEAPON_SNARK_MAX_CLIP, Ammo = HLAmmoSnark}

	HLWeapons = { 
		HLWeaponCrowbar,
		HLWeaponGlock,
		HLWeaponPython,
		HLWeaponMP5,
		HLWeaponChainGun,
		HLWeaponCrossbow,
		HLWeaponShotgun,
		HLWeaponRPG,
		HLWeaponGauss,
		HLWeaponEgon,
		HLWeaponHornet,
		HLWeaponGrenade,
		HLWeaponTripmine,
		HLWeaponSatchel,
		HLWeaponSnark  
	}
  
-- Counter-Strike

	CS_WEAPON_SLOT_RIFLE = 0
	CS_WEAPON_SLOT_PISTOL = 1
	CS_WEAPON_SLOT_KNIFE = 2
	CS_WEAPON_SLOT_GRENADES = 3
	CS_WEAPON_SLOT_C4 = 4
	
	CS_WEAPONSTATE_USP_SILENCED = 1 << 0
	CS_WEAPONSTATE_GLOCK18_BURST_MODE = 1 << 1
	CS_WEAPONSTATE_M4A1_SILENCED = 1 << 2
	CS_WEAPONSTATE_ELITE_LEFT = 1 << 3
	CS_WEAPONSTATE_FAMAS_BURST_MODE = 1 << 4
	CS_WEAPONSTATE_SHIELD_DRAWN = 1 << 5
	
	CS_WEAPON_P228 = 1
	CS_WEAPON_SCOUT = 3
	CS_WEAPON_HEGRENADE = 4
	CS_WEAPON_XM1014 = 5
	CS_WEAPON_C4 = 6
	CS_WEAPON_MAC10 = 7
	CS_WEAPON_AUG = 8
	CS_WEAPON_SMOKEGRENADE = 9
	CS_WEAPON_ELITE = 10
	CS_WEAPON_FIVESEVEN = 11
	CS_WEAPON_UMP45 = 12
	CS_WEAPON_SG550 = 13
	CS_WEAPON_GALIL = 14
	CS_WEAPON_FAMAS = 15
	CS_WEAPON_USP = 16
	CS_WEAPON_GLOCK18 = 17
	CS_WEAPON_AWP = 18
	CS_WEAPON_MP5NAVY = 19
	CS_WEAPON_M249 = 20
	CS_WEAPON_M3 = 21
	CS_WEAPON_M4A1 = 22
	CS_WEAPON_TMP = 23
	CS_WEAPON_G3SG1 = 24
	CS_WEAPON_FLASHBANG = 25
	CS_WEAPON_DEAGLE = 26
	CS_WEAPON_SG552 = 27
	CS_WEAPON_AK47 = 28
	CS_WEAPON_KNIFE = 29
	CS_WEAPON_P90 = 30
	CS_WEAPON_VEST = 31
	CS_WEAPON_VESTHELM = 32

	CS_AMMO_338MAGNUMCLIP_GIVE = 10
	CS_AMMO_357SIGCLIP_GIVE = 13
	CS_AMMO_45ACPCLIP_GIVE = 12
	CS_AMMO_50AECLIP_GIVE = 7
	CS_AMMO_556NATOCLIP_GIVE = 30
	CS_AMMO_556NATOBOXCLIP_GIVE = 30
	CS_AMMO_57MMCLIP_GIVE = 50
	CS_AMMO_762NATOCLIP_GIVE = 30
	CS_AMMO_9MMCLIP_GIVE = 30
	CS_AMMO_BUCKSHOTCLIP_GIVE = 8

	CS_AMMO_338MAGNUM_MAX_CARRY = 30
	CS_AMMO_357SIG_MAX_CARRY = 52
	CS_AMMO_45ACP_MAX_CARRY = 100
	CS_AMMO_50AE_MAX_CARRY = 35
	CS_AMMO_556NATO_MAX_CARRY = 90
	CS_AMMO_556NATOBOX_MAX_CARRY = 200
	CS_AMMO_57MM_MAX_CARRY = 100
	CS_AMMO_762NATO_MAX_CARRY = 90
	CS_AMMO_9MM_MAX_CARRY = 120
	CS_AMMO_BUCKSHOT_MAX_CARRY = 32

	CS_AMMO_338MAGNUM_COST = 125
	CS_AMMO_357SIG_COST = 50
	CS_AMMO_45ACP_COST = 25
	CS_AMMO_50AE_COST = 40
	CS_AMMO_556NATO_COST = 60
	CS_AMMO_556NATOBOX_COST = CS_AMMO_556NATO_COST
	CS_AMMO_57MM_COST = 50
	CS_AMMO_762NATO_COST = 80
	CS_AMMO_9MM_COST = 20
	CS_AMMO_BUCKSHOT_COST = 65	
	
	CSAmmo338Magnum = {Give = CS_AMMO_338MAGNUMCLIP_GIVE, MaxCarry = CS_AMMO_338MAGNUM_MAX_CARRY, Cost = CS_AMMO_338MAGNUM_COST}
	CSAmmo357Sig = {Give = CS_AMMO_357SIGCLIP_GIVE, MaxCarry = CS_AMMO_357SIG_MAX_CARRY, Cost = CS_AMMO_357SIG_COST}
	CSAmmo45ACP = {Give = CS_AMMO_45ACPCLIP_GIVE, MaxCarry = CS_AMMO_45ACP_MAX_CARRY, Cost = CS_AMMO_45ACP_COST}
	CSAmmo50AE = {Give = CS_AMMO_50AECLIP_GIVE, MaxCarry = CS_AMMO_50AE_MAX_CARRY, Cost = CS_AMMO_50AE_COST}
	CSAmmo556Nato = {Give = CS_AMMO_556NATOCLIP_GIVE, MaxCarry = CS_AMMO_556NATO_MAX_CARRY, Cost = CS_AMMO_556NATO_COST}
	CSAmmo556NatoBox = {Give = CS_AMMO_556NATOBOXCLIP_GIVE, MaxCarry = CS_AMMO_556NATOBOX_MAX_CARRY, Cost = CS_AMMO_556NATOBOX_COST}
	CSAmmo57mm = {Give = CS_AMMO_57MMCLIP_GIVE, MaxCarry = CS_AMMO_57MM_MAX_CARRY, Cost = CS_AMMO_57MM_COST}
	CSAmmo762Nato = {Give = CS_AMMO_762NATOCLIP_GIVE, MaxCarry = CS_AMMO_762NATO_MAX_CARRY, Cost = CS_AMMO_762NATO_COST}
	CSAmmo9mm = {Give = CS_AMMO_9MMCLIP_GIVE, MaxCarry = CS_AMMO_9MM_MAX_CARRY, Cost = CS_AMMO_9MM_COST}
	CSAmmoBuckshot = {Give = CS_AMMO_BUCKSHOTCLIP_GIVE, MaxCarry = CS_AMMO_BUCKSHOT_MAX_CARRY, Cost = CS_AMMO_BUCKSHOT_COST}

	CS_WEAPON_AK47_WEIGHT = 25 
	CS_WEAPON_AUG_WEIGHT = 25 
	CS_WEAPON_AWP_WEIGHT = 30 
	CS_WEAPON_C4_WEIGHT = 30 
	CS_WEAPON_DEAGLE_WEIGHT = 7 
	CS_WEAPON_ELITE_WEIGHT = 5 
	CS_WEAPON_FAMAS_WEIGHT = 75 
	CS_WEAPON_FIVESEVEN_WEIGHT = 5 
	CS_WEAPON_FLASHBANG_WEIGHT = 1 
	CS_WEAPON_G3SG1_WEIGHT = 30 
	CS_WEAPON_GALIL_WEIGHT = 25 
	CS_WEAPON_GLOCK18_WEIGHT = 7 
	CS_WEAPON_HEGRENADE_WEIGHT = 2 
	CS_WEAPON_KNIFE_WEIGHT = 0 
	CS_WEAPON_M249_WEIGHT = 25 
	CS_WEAPON_M3_WEIGHT = 20 
	CS_WEAPON_M4A1_WEIGHT = 25 
	CS_WEAPON_MAC10_WEIGHT = 25 
	CS_WEAPON_MP5NAVY_WEIGHT = 25 
	CS_WEAPON_P228_WEIGHT = 5 
	CS_WEAPON_P90_WEIGHT = 26 
	CS_WEAPON_SCOUT_WEIGHT = 30 
	CS_WEAPON_SG550_WEIGHT = 20 
	CS_WEAPON_SG552_WEIGHT = 25 
	CS_WEAPON_SMOKEGRENADE_WEIGHT = 2 
	CS_WEAPON_TMP_WEIGHT = 25 
	CS_WEAPON_UMP45_WEIGHT = 25 
	CS_WEAPON_USP_WEIGHT = 5 
	CS_WEAPON_XM1014_WEIGHT = 20 
	CS_WEAPON_SHIELD_WEIGHT = 0 
	
	CSWeaponAk47 = {Weight = CS_WEAPON_AK47_WEIGHT, MaxClip = 30, Ammo = CSAmmo762Nato, Cost = 2500, BuyName = 'ak47', BuyName2 = 'cv47'}
	CSWeaponAUG = {Weight = CS_WEAPON_AUG_WEIGHT, MaxClip = 30, Ammo = CSAmmo762Nato, Cost = 3500, BuyName = 'aug', BuyName2 = 'bullpup'}
	CSWeaponAWP = {Weight = CS_WEAPON_AWP_WEIGHT, MaxClip = 10, Ammo = CSAmmo338Magnum, Cost = 4750, BuyName = 'awp', BuyName2 = 'magnum'}
	CSWeaponC4 = {Weight = CS_WEAPON_C4_WEIGHT}
	CSWeaponDeagle = {Weight = CS_WEAPON_DEAGLE_WEIGHT, MaxClip = 7, Ammo = CSAmmo50AE, Cost = 650, BuyName = 'deagle', BuyName2 = 'nighthawk'}
	CSWeaponElite = {Weight = CS_WEAPON_ELITE_WEIGHT, MaxClip = 30, Ammo = CSAmmo9mm, Cost = 800, BuyName = 'elites'}
	CSWeaponFamas = {Weight = CS_WEAPON_FAMAS_WEIGHT, MaxClip = 30, Ammo = CSAmmo556Nato, Cost = 2250, BuyName = 'famas', BuyName2 = 'clarion'}
	CSWeaponFiveseven = {Weight = CS_WEAPON_FIVESEVEN_WEIGHT, MaxClip = 20, Ammo = CSAmmo57mm, Cost = 750, BuyName = 'fn57', BuyName2 = 'fiveseven'}
	CSWeaponFlashbang = {Weight = CS_WEAPON_FLASHBANG_WEIGHT, Cost = 200, BuyName = 'flash'}
	CSWeaponG3SG1 = {Weight = CS_WEAPON_G3SG1_WEIGHT, MaxClip = 20, Ammo = CSAmmo762Nato, Cost = 5000 , BuyName = 'g3sg1', BuyName2 = 'd3au1'}
	CSWeaponGalil = {Weight = CS_WEAPON_GALIL_WEIGHT, MaxClip = 35, Ammo = CSAmmo556Nato, Cost = 2000, BuyName = 'galil'}
	CSWeaponGlock18 = {Weight = CS_WEAPON_GLOCK18_WEIGHT, MaxClip = 20, Ammo = CSAmmo9mm, Cost = 400, BuyName = 'glock', BuyName2 = '9x19mm'}
	CSWeaponHEGrenade = {Weight = CS_WEAPON_HEGRENADE_WEIGHT, Cost = 300, BuyName = 'hegren'}
	CSWeaponKnife = {Weight = CS_WEAPON_KNIFE_WEIGHT}
	CSWeaponM249 = {Weight = CS_WEAPON_M249_WEIGHT, MaxClip = 100, Ammo = CSAmmo556NatoBox, Cost = 5750, BuyName = 'm242'}
	CSWeaponM3 = {Weight = CS_WEAPON_M3_WEIGHT, MaxClip = 8, Ammo = CSAmmoBuckshot, Cost = 1700, BuyName = 'm3', BuyName2 = '12gauge'}
	CSWeaponM4A1 = {Weight = CS_WEAPON_M4A1_WEIGHT, MaxClip = 30, Ammo = CSAmmo556Nato, Cost = 3100, BuyName = 'm4a1'}
	CSWeaponMAC10 = {Weight = CS_WEAPON_MAC10_WEIGHT, MaxClip = 30, Ammo = CSAmmo45ACP, Cost = 1400, BuyName = 'mac10'}
	CSWeaponMP5Navy = {Weight = CS_WEAPON_MP5NAVY_WEIGHT, MaxClip = 30, Ammo = CSAmmo9mm, Cost = 1500, BuyName = 'mp5', BuyName2 = 'smg'}
	CSWeaponP228 = {Weight = CS_WEAPON_P228_WEIGHT, MaxClip = 13, Ammo = CSAmmo357Sig, Cost = 600, BuyName = 'p228', BuyName2 = '228compact'}
	CSWeaponP90 = {Weight = CS_WEAPON_P90_WEIGHT, MaxClip = 50, Ammo = CSAmmo57mm, Cost = 2350, BuyName = 'p90', BuyName2 = 'c90'}
	CSWeaponScout = {Weight = CS_WEAPON_SCOUT_WEIGHT, MaxClip = 10, Ammo = CSAmmo762Nato, Cost = 2750, BuyName = 'scout'}
	CSWeaponSG550 = {Weight = CS_WEAPON_SG550_WEIGHT, MaxClip = 30, Ammo = CSAmmo556Nato, Cost = 4200, BuyName = 'sg550'}
	CSWeaponSG552 = {Weight = CS_WEAPON_SG552_WEIGHT, MaxClip = 30, Ammo = CSAmmo556Nato, Cost = 3500, BuyName = 'sg552', BuyName2 = 'krieg552'}
	CSWeaponSmokeGrenade = {Weight = CS_WEAPON_SMOKEGRENADE_WEIGHT, Cost = 300, BuyName = 'sgren'}
	CSWeaponTMP = {Weight = CS_WEAPON_TMP_WEIGHT, MaxClip = 30, Ammo = CSAmmo9mm, Cost = 1250, BuyName = 'tmp', BuyName2 = 'mp'}
	CSWeaponUMP45 = {Weight = CS_WEAPON_UMP45_WEIGHT, MaxClip = 25, Ammo = CSAmmo45ACP, Cost = 1700, BuyName = 'ump45'}
	CSWeaponUSP = {Weight = CS_WEAPON_USP_WEIGHT, MaxClip = 12, Ammo = CSAmmo57mm, Cost = 500, BuyName = 'usp', BuyName2 = 'km45'}
	CSWeaponXM1014 = {Weight = CS_WEAPON_XM1014_WEIGHT, MaxClip = 7, Ammo = CSAmmoBuckshot, Cost = 3000, BuyName = 'xm1014', BuyName2 = 'autoshotgun'}
	CSWeaponShield = {Weight = CS_WEAPON_SHIELD_WEIGHT, Cost = 220, BuyName = 'shield'}

	CSWeapons = { 
		CSWeaponP228,
		CSWeaponShield,
		CSWeaponScout,
		CSWeaponHegrenade,
		CSWeaponXM1014,
		CSWeaponC4,
		CSWeaponMAC10,
		CSWeaponAUG,
		CSWeaponSmokeGrenade,
		CSWeaponElite,
		CSWeaponFiveseven,
		CSWeaponUMP45,
		CSWeaponSG550,
		CSWeaponGalil,
		CSWeaponFamas,
		CSWeaponUSP,
		CSWeaponGlock18,
		CSWeaponAWP,
		CSWeaponMP5Navy,
		CSWeaponM249,
		CSWeaponM3,
		CSWeaponM4A1,
		CSWeaponTMP,
		CSWeaponG3SG1,
		CSWeaponFlashbang,
		CSWeaponDeagle,
		CSWeaponSG552,
		CSWeaponAk47,
		CSWeaponKnife,
		CSWeaponP90
	}
	
	
-- Navigation.pas property

	NAV_NONE = 0
	NAV_AREA_INVALID = NAV_NONE -- for source engine
	NAV_AREA_CROUCH = 1 << 0 -- must crouch to use this node/area
	NAV_AREA_JUMP = 1 << 1 -- must jump to traverse this area
	NAV_AREA_PRECISE = 1 << 2 -- do not adjust for obstacles, just move along area. NAV_AREA_DANGER is synonim ? не использовать AI_ObstacleAvoidance ?
	NAV_AREA_NO_JUMP = 1 << 3 -- inhibit discontinuity jumping

	-- source engine :
	NAV_AREA_STOP = 1 << 4 -- must stop when entering this area
	NAV_AREA_RUN = 1 << 5 -- must run to traverse this area
	NAV_AREA_WALK = 1 << 6 -- must walk to traverse this area
	NAV_AREA_AVOID = 1 << 7 -- avoid this area unless alternatives are too dangerous
	NAV_AREA_TRANSIENT = 1 << 8 -- area may become blocked, and should be periodically checked
	NAV_AREA_DONT_HIDE = 1 << 9 -- area should not be considered for hiding spot generation
	NAV_AREA_STAND = 1 << 10 -- bots hiding in this area should stand
	NAV_AREA_NO_HOSTAGES = 1 << 11 -- hostages shouldn't use this area
	NAV_AREA_STAIRS = 1 << 12 -- this area represents stairs, do not attempt to climb or jump them - just walk up
	NAV_AREA_NO_MERGE = 1 << 13 -- don't merge this area with adjacent areas
	NAV_AREA_OBSTACLE_TOP = 1 << 14 -- this nav area is the climb point on the tip of an obstacle
	NAV_AREA_CLIFF = 1 << 15 -- this nav area is adjacent to a drop of at least CliffHeight

	NAV_AREA_CUSTOM_START = 1 << 16 -- apps may define custom app-specific bits starting with this value
	-- custom area flags must be between this two
	NAV_AREA_CUSTOM_END = 1 << 26 -- apps must not define custom app-specific bits higher than with this value

	NAV_AREA_FUNC_COST = 1 << 29 -- area has designer specified cost controlled by func_nav_cost entities
	NAV_AREA_HAS_ELEVATOR = 1 << 30 -- area is in an elevator's path
	NAV_AREA_NAV_BLOCKER = 1 << 31 -- area is blocked by nav blocker ( Alas, needed to hijack a bit in the attributes to get within a cache line [7/24/2008 tom])
	