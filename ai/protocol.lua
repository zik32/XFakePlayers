--[[
	XFakePlayers AI
	
	Forced methods from engine:
	
		Initialization()

		Finalization()

		Frame()

		OnTrigger(ATrigger)


-- available methods:

	ExecuteCommand(command: str)
		executes command on client

	GetServer(): str
		server address as text string

	GetTime(): float
		svc_time

	GetProtocol(): int
		svc_serverinfo.protocol 

	GetMaxPlayers(): int
		svc_serverinfo.maxplayers

	GetClientIndex(): int
		svc_serverinfo.index

	GetGameDir(): str
		svc_serverinfo.gamedir

	GetMap(): str
		svc_serverinfo.map

	GetMaxEx(): str
		extended version of GetMap() - map name truncated here

	GetIntermission(): int
		svc_intermission state

	IsPaused(): bool
		svc_setpause state

	MoveTo(pos: float[3])
	MoveTo(ent: int)


	MoveOut(pos: float[3])
	MoveOut(ent: int)

	LookAt(pos: float[3])
	LookAt(ent: int)

	GetViewAngles(): float[3]
	SetViewAngles(angles: float[3])

	LookAtEx(pos: float[3]) 
	LookAtEx(ent: int) 
	lookat equivalent with some smoothing

	PressButton(Button)
	UnPressButton(Button)
	IsButtonPressed(Button): bool

	GetOrigin(): float[3]

	GetVelocity(): float[3]

	GetPunchAngle(): float[3]

	GetWeaponAbsoluteIndex(): int
		clientdata.id

	GetDistance(pos: float[3]): float
	GetDistance(ent: int): float

	GetDistance2D(pos\ent: float[3]\int): float

	IsWeaponExists(absolute_weapon_index: int): bool
		this using absolute index, not weaponlist index

	IsCrouching(): bool

	IsOnGround(): bool

	IsSpectator(): bool

	HasWeaponData(absolute_weapon_index): bool

	GetWeaponDataField(weapon_index: int; field: WeaponDataField): any
		get field from weapondata_t array for specific weapon
		
]]
	WeaponDataField = {  -- TODO: delete this shit. really.
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

	GetMaxSpeed(): float
		clientdata.maxspeed & movevars.maxspeed

	CanAttack(): boolean
		is clientdata_t.nextattack <= 0

	IsAlive(): bool

	PrimaryAttack()
		equivalent for PressButton(ATTACK)

	SecondaryAttack()
		equivalent for PressButton(ATTACK2)

	FastPrimaryAttack()

	FastSecondaryAttack()

	Jump()
		equivalent for PressButton(JUMP)

	Duck()
		equivalent for PressButton(DUCK)

	DuckJump()	

	GetResourcesCount(): int

	GetResourceName(index: int): str

	GetResourceType(index: int): int

	GetResourceIndex(index: int): int

	GetResourceSize(index: int): int

	GetResourceFlags(index: int): int

	GetPlayersCount(): int
		length of players array

	GetPlayerUserInfo(player_index): str

	GetPlayerKills(player_index): int

	GetPlayerDeaths(player_index): int

	GetPlayerPing(player_index): int

	GetPlayerLoss(player_index): int

	GetPlayerTeam(player_index): str
		based on TeamInfo gmsg event

	GetPlayerClassID(player_index): int
		based on ScoreInfo gmsg event

	GetPlayerTeamID(player_index): int
		based on ScoreInfo gmsg event

	GetPlayerHealth(player_index): int
		based on HLTV gmsg event (cstrike, czero only)

	GetPlayerScoreAttrib(player_index): int 
		based on ScoreAttrib gmsg event (cstrike, czero only)

	GetPlayerLocation(player_index): str
		based on Location gmsg event (cstrike, czero only)

	GetPlayerRadar(player_index): float[3]
		based on Radar gmsg event (cstrike, czero only)

	GetPlayerOrigin(player_index): float[3]
		extended version to resolve player origin
		it using allocated entity for this player to resolve origin
		also, if entity isn't active - using GetRadar() instead

	IsPlayerAlive(player_index): bool
		based on GetPlayerScoreAttrib(), it will check bit flag SCORE_ATTRIB_FLAG_DEAD
		working only for cstrike & czero

	IsPlayerBomber(player_index): bool
		based on GetPlayerScoreAttrib(), it will check bit flag SCORE_ATTRIB_FLAG_BOMB
		working only for cstrike & czero

	IsPlayerVIP(player_index): bool
		based on GetPlayerScoreAttrib(), it will check bit flag SCORE_ATTRIB_FLAG_VIP
		working only for cstrike & czero

	GetEntitiesCount(): int
		length of entities array

	GetEntityType(index: int): int

	GetEntityNumber(index: int): int

	GetEntityMsgTime(index: int): float

	GetEntityMessageNum(index: int): int

	GetEntityOrigin(index: int): float[3]

	GetEntityAngles(index: int): float[3]

	GetEntityModelIndex(index: int): int

	GetEntitySequence(index: int): int

	GetEntityFrame(index: int): float

	GetEntityColorMap(index: int): int

	GetEntitySkin(index: int): int

	GetEntitySolid(index: int): int

	GetEntityEffects(index: int): int

	GetEntityScale(index: int): int

	GetEntityEFlags(index: int): int

	GetEntityRenderMode(index: int): int

	GetEntityRenderAmt(index: int): int

	GetEntityRenderFX(index: int): int

	GetEntityMoveType(index: int): int

	GetEntityAnimTime(index: int): float

	GetEntityFrameRate(index: int): float

	GetEntityBody(index: int): int

	GetEntityVelocity(index: int): float[3]

	GetEntityMinS(index: int): int

	GetEntityMaxS(index: int): int

	GetEntityAimEnt(index: int): int

	GetEntityOwner(index: int): int

	GetEntityFriction(index: int): float

	GetEntityGravity(index: int): float

	GetEntityTeam(index: int): int

	GetEntityPlayerClass(index: int): int

	GetEntityHealth(index: int): int

	GetEntitySpectator(index: int): int

	GetEntityWeaponModel(index: int): int

	GetEntityGaitSequence(index: int): int

	GetEntityBaseVelocity(index: int): float[3]

	GetEntityUseHull(index: int): int

	GetEntityOldButtons(index: int): int

	GetEntityOnGround(index: int): int

	GetEntityStepLeft(index: int): int

	GetEntityFallVelocity(index: int): float

	GetEntityFOV(index: int): int

	GetEntityWeaponAnim(index: int): int

	GetEntityStartPos(index: int): float[3]

	GetEntityEndPos(index: int): float[3]

	GetEntityImpactTime(index: int): float

	GetEntityStartTime(index: int): float

	GetEntityIUser1(index: int): int

	GetEntityIUser2(index: int): int

	GetEntityIUser3(index: int): int

	GetEntityIUser4(index: int): int

	GetEntityFUser1(index: int): int

	GetEntityFUser2(index: int): int

	GetEntityFUser3(index: int): int

	GetEntityFUser4(index: int): int

	GetEntityVUser1(index: int): float[3]

	GetEntityVUser2(index: int): float[3]

	GetEntityVUser3(index: int): float[3]

	GetEntityVUser4(index: int): float[3]

	IsEntityActive(index: int): int
		is entity currenrly spawned for actor

	GetGroundedOrigin(): float[3]
		equivalent for GetOrigin with subtracted human height

	GetGroundedDistance(origin: float[3]): float
	GetGroundedDistance(ent: int): float
		see below

	GetHealth(): int
		Health gmsg event

	GetWeaponsCount(): int
		length of weapon array (WeaponList gmsg event)

	-> next weapon functions using WeaponList array, be careful

	GetWeaponName(index_in_weaponlist): str

	GetWeaponPrimaryAmmoID(index_in_weaponlist): int

	GetWeaponPrimaryAmmoMaxAmount(index_in_weaponlist): int

	GetWeaponSecondaryAmmoID(index_in_weaponlist): int

	GetWeaponSecondaryAmmoMaxAmount(index_in_weaponlist): int

	GetWeaponSlotID(index_in_weaponlist): int

	GetWeaponNumberInSlot(index_in_weaponlist): int

	GetWeaponIndex(index_in_weaponlist): int
		return absolute index for given weapon

	GetWeaponFlags(index_in_weaponlist): int

	GetWeaponNameEx(index_in_weaponlist): str
		truncated version of GetWeaponName, weapon_m4a1 -> m4a1

	GetWeaponByAbsoluteIndex(absolute_weapon_index): int
		return weapon index from weaponlist array (WeaponList gmsg event) for using with extended weapon functions
		return -1 if weapon isn't exist

	GetStatusIconsCount(): int
		length of status icon array (StatusIcon gmsg event)

	GetStatusIconName(statusicon_index: int): str

	GetStatusIconStatus(statusicon_index: int): int

	GetBombStateActive(): bool
		is bomb on radar ?
	
	GetBombStatePosition(): float[3]
		get radar bomb position
		
	GetBombStatePlanted(): bool
		is bomb on radar is planted bomb ?
	
	IsTeamPlay(): bool
		gamemode gmsg event state

	GetAmmo(weapon: int): int
		ammox gmsg event

	HasNavigation(): bool
		is navigation (*.nav) file loaded

	HasWorld(): bool
		is world (*.bsp) file loaded

	HasWays(): bool
		is ways (*.way) file loaded

	IsVisible(pos: float[3]): bool
	IsVisible(ent: int): bool
		checks visibility of object (or point) from actor's eyes

	GetNavArea(): int
		search and return absolute nav area index by actor's origin

	GetNavArea(index: int): int
		search and return absolute nav area index by nav area index

	GetNavArea(pos: float[3]): int
		search and return absolute nav area index by position

	GetRandomNavArea(): int
		this will return random nav area from navigation mesh

	GetNavAreaIndex(area: int): int
		return unique nav area index for given nav area

	GetNavAreaFlags(area: int): int

	GetNavAreaName(area: int): str
		nav area name contains name of location, where nav area stays (if location name set) and unique nav area index

	GetNavAreaCenter(area: int): float[3]
		return nav area center coords in world

	GetNavAreaConnectionsCount(area: int): int
		return count of nav areas which connected to given nav area

	GetNavAreaHidingSpotsCount(area: int): int

	GetNavAreaApproachesCount(area: int): int

	GetNavAreaApproachHere(area, approach: int): int

	GetNavAreaApproachPrev(area, approach: int): int

	GetNavAreaApproachNext(area, approach: int): int

	GetNavAreaEncountersCount(area: int): int

	GetNavAreaLaddersCount(area: int): int

	GetNavAreaRandomConnection(area: int): int
		return random ajacent nav area for given area

	IsNavAreaConnected(area1, area2: int): bool

	IsNavAreaBiLinked(area1, area2: int): bool

	GetNavAreaPortal(area1, area2: int): float[3]
		return coords in world of portal between two connected areas

	GetNavAreaPortal(area1, area: int; start, end: float[3])
		extended version of GetNavAreaPortal(...) 

	GetNavAreaWindow(area1, area2: int): float[6]
		return coords of two points between two connected areas

	GetNavChain(area1, area2): array of int

	GetWorldEntitiesCount(): int

	GetWorldVertexesCount(): int

	GetWorldEdgesCount(): int

	GetWorldSurfEdgesCount(): int

	GetWorldTexturesCount(): int

	GetWorldPlanesCount(): int

	GetWorldFacesCount(): int

	GetWorldLeafsCount(): int

	GetWorldNodesCount(): int

	GetWorldClipNodesCount(): int

	GetWorldModelsCount(): int

	GetWorldEntity(field, value: str): int
		return entity absolute index in world with given field and value
		return -1 if not found

	GetWorldEntities(field, value: str): int
		returns an array of absolute indexes of entities in world with given field and value

	GetWorldRandomEntity(field, value: str): int
		working like GetWorldEntities(.., ..)[Random(Length(GetWorldEntities(.., ..)))]

	GetWorldEntityByClassName(classname: str): int
		equivalent for GetWorldEntity("classname", ...)

	GetWorldEntitiesByClassName(classname: str): int
		equivalent for GetWorldEntities("classname", ...)

	GetWorldRandomEntityByClassName(classname: str): int
		equivalent for GetWorldRandomEntity("classname", ...)		

	GetWorldEntityField(index: int, field: str): str
		returns a string data under the field
		returns empty string if field does not exist

	GetModelForEntity(index: int): int	
		returns absolute world model index from world models array for model, 
		who allocated with given entity.
		returns -1 if entity does not have model or model was not found

	GetWorldModelMinS(index: int): float[3]

	GetWorldModelMaxS(index: int): float[3]

	GetWorldModelOrigin(index: int): float[3]

	GetWorldModelVisLeafs(index: int): int

	GetWorldModelFirstFace(index: int): int

	GetWorldModelNumFaces(index: int): int

]]

-- Protocol.pas property
	HUMAN_HEIGHT = 36
	HUMAN_HEIGHT_HALF = HUMAN_HEIGHT / 2

	HUMAN_HEIGHT_STAND = HUMAN_HEIGHT
	HUMAN_HEIGHT_DUCK = HUMAN_HEIGHT_STAND / 2

	HUMAN_WIDTH = 32
	HUMAN_WIDTH_HALF = HUMAN_WIDTH / 2

	MAX_UNITS = 8192

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
	
-- Weapon.pas property

	MAX_WEAPONS = 32
	WEAPON_NOCLIP = -1
	
-- Resource.pas property

	RT_SOUND = 0
	RT_SKIN = 1
	RT_MODEL = 2
	RT_DECAL = 3
	RT_GENERIC = 4
	RT_EVENTSCRIPT = 5
	RT_WORLD = 6

	RES_FATALIFMISSING = 1 << 0
	RES_WASMISSING = 1 << 1
	RES_CUSTOM = 1 << 2
	RES_REQUESTED = 1 << 3
	RES_PRECACHED = 1 << 4
	RES_ALWAYS = 1 << 5
	RES_PADDING = 1 << 6
	RES_CHECKFILE = 1 << 7

-- Weapon.pas property

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
	
-- World

	SF_BREAKABLE_ONLY_TRIGGER = 1 << 0 -- If set, this func_breakable will only break when triggered, even if its health value is set to '1'.
	SF_BREAKABLE_TOUCH = 1 << 1 -- If set, this func_breakable will break as soon as a player touches it. If a delay before fire is set, the func_breakable will wait for that to run out before breaking after a touch.
	SF_BREAKABLE_PRESSURE = 1 << 2 -- If set, the func_breakable can be destroyed from pressure, as is e.g. inflicted by a func_train, regardless of the train's damage.
	SF_BREAKABLE_REPAIRABLE = 1 << 3 -- If set, this func_breakable can be repaired, as in, have its health restored, by a player 'attacking' it with weapon_pipewrenches' primary attack, for the amount of that weapon's primary damage value.
	SF_BREAKABLE_SHOW_HUD_INFO = 1 << 4 -- If set, the func_breakable will show HUD info for players looking at it. This is not affected by CVar 'mp_allowmonsterinfo'.
	SF_BREAKABLE_INSTANT_BREAK = 1 << 8 -- 256 If set, this func_breakable will break instantly if hit with a crowbar.
	SF_BREAKABLE_EXPLOSIVES_ONLY = 1 << 9 -- If set, this func_breakable can be damaged by explosives only.

	
-------------------------------
	
	HL_PLAYER_MODELS = {
		"barney", 
		"gina", 
		"gman", 
		"gordon", 
		"helmet", 
		"hgrunt", 
		"recon", 
		"robo", 
		"scientist", 
		"zombie"
	} 
	
	OPFOR_PLAYER_MODELS = {
		"barney", 
		"beret", 
		"cl_suit", 
		"drill",
		"fassn", 
		"gina", 
		"gman", 
		"gordon", 
		"grunt", 
		"helmet", 
		"hgrunt", 
		"massn", 
		"otis",
		"recon", 
		"recruit", 
		"robo", 
		"scientist", 
		"shepard", 
		"tower", 
		"zombie"
	}