IncludeScript("GIVE_TF_WEAPON_ALL.nut") //all weapon properties. REQUIRED

//vscript cvars. Adjust how you like, to customize the script easily.
::CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS <- true	//if true, overwrites current weapon in slot. NOTE: Cannot use more than two weapons in a slot, unless using "hud_fastswitch 0".
::CVAR_GTFW_USE_VIEWMODEL_FIX <- true	//automatically fixes any and all viewmodel arms to match the class you're playing as.
//::CVAR_GTFW_GIVEWEAPON_DROP_WEAPONS <- false		//Would drops your weapon in favor of the new one. Non-functional
//::CVAR_GTFW_USE_RESUPPLY_FIX	<- true		//Would fix resupply lockers destroying custom weapons. Non-functional

/*vScript "GIVE_TF_WEAPON" (originally giveweapon.nut) framework for Team Fortress 2, by Yaki
Special thanks ficool2 for finding the netprops to make the first weapon giving function, AddWeapon().
Special thanks Mr.Burguers (TF2Maps) for being a wealth of knowledge, teaching me how to use vscripts n stuff
Special thanks devs of Super Zombie Fortress + SCP Secret Fortress for releasing their source code (taught me what netprops were needed for custom viewmodels)

Notes to Users
 - Set CVAR_GTFW_* for easy tweaking of script.
 - When using GiveWeapon, weapon strings for unlocks don't need "The " in them. (i.e. "The Sandvich" is invalid, but "Sandvich" is acceptable)
 --> Also accepts handles, as well as item index values (from items_game.txt)
 - GiveWeapon also returns the weapon as a handle. So you can add attributes to the weapon!
 - Add function `CTFPlayer.GTFW_Cleanup` to your `player_death` and `post_inventory_application` events to delete unused weapons/viewmodels attached to the player
 --> Needs a player handle to clear weapons from
 --> Please place at the beginning of your "OnGameEvent_"s!
 --> Place these inside your "OnGameEvent_player_death".
 --> Place these inside your "OnGameEvent_post_inventory_application".
		
PUBLIC OPERATIONS
 Made to make giving weapons, easy! Also supports custom weapons!
	CheckItems()
		- Checks your current equipment, with item IDs. Spits out a list in chat with active weapon on top.
	CTFPlayer.GiveWeapon(weapon)
		- Gives you a weapon. Any weapon, as long as the entity and ID match from items_game.txt.
		- Returns given weapon as handle.
	CTFPlayer.GiveWeaponEx(searched_weapon, searched_itemID, new_weapon, new_itemID)
		- Extended version of `CTFPlayer.GiveWeapon`.
		- Searches the player's inventory for a weapon and replaces it.
		- Can do exceptions for searched entities (i.e. Search every weapon classname EXCLUDING the one with this itemID)
	CTFPlayer.DeleteWeapon(weapon)
		- Deletes a weapon from the player.
	CTFPlayer.DisableWeapon(weapon)
		- Makes a weapon non-functional on player, meaning they can't switch to nor use it.
	CTFPlayer.ReturnWeapon(weapon)
		- Searches weapon on player and returns as handle.
	CTFPlayer.SetCustomWeapon(baseitem, custom_weapon_model, custom_arms_model)
		- MAKES YOU A NEW CUSTOM WEAPON! Does not include stats.
		- Returns handle so you can add the stats yourself!
		
		
PRIVATE OPERATIONS
 Functions used only in this file. Not recommended unless you know what you're doing.
	CTFPlayer.AddWeapon(classname, itemindex, slot)
		Use if you want a specific weapon in a specific slot.
	CTFPlayer.UpdateArms(weapon, weapon_model, arms_model, arms_draw_seq)
		Updates the weapon's arm models
			Optional params: arms_model, arms_draw_seq
	CTFPlayer.CreateCustomWeaponModel(wearabletype, baseitem, weapon_model)
		Multiple functions.
			wearabletype = bool, true for making tf_wearable, false for making tf_wearable_vm
			baseitem = your base item's handle. Accepts null or main_viewmodel handle for making class arms only.
			weapon_model = model.mdl
		Returns handle of the entity it creates (tf_wearable or tf_wearable_vm)
	HasGunslinger()
		Checks if wearer is using the Gunslinger.
	CTFPlayer.AddThinkToViewModel()
		Updates the think script on tf_viewmodel. Branches from AddWeapon.
	CTFPlayer.SwitchToActive(NewGun)
		Forcefully switches to given weapon. If null, switches to first weapon it finds.
	GTFW_FindEquipByClassname(classname)
		Finds an item by classname
	GTFW_FindEquipByStringOrID(string_or_id)

Examples of Uses
	CheckItems()
		USE: In console, type "script CheckItems()" (without quotes)
	CTFPlayer.GiveWeapon(weapon_classname_or_id_or_string)
		USE: handle.GiveWeapon("Minigun")
			Gives player the stock minigun.
		USE: handle.GiveWeapon(132)
			Gives player the Eyelander
	CTFPlayer.GiveWeaponEx(searched_weapon, searched_itemID, new_weapon, new_itemID)
		USE: handle.GiveWeaponEx("tf_weapon_wrench", -7, "tf_weapon_knife", 4)
			Replaces all non-stock wrenches with stock knife
		USE: handle.GiveWeaponEx("melee", -1, "tf_weapon_robot_arm", 142)
			Replaces all melees with Gunslinger
		USE: handle.GiveWeaponEx("Brass Beast", -1, "Buff Banner", -1)
			Replaces just the Brass Beast with the Buff Banner.
	CTFPlayer.DeleteWeapon(weapon_classname_or_id_or_string)
		USE: handle.DeleteWeapon("Medigun")
			Deletes only the stock Medigun
		USE: handle.DeleteWeapon("misc")
			Deletes all misc items (PDAs, watches, spellbooks, grappling hooks, etc)
		USE: handle.DeleteWeapon(15)
			Deletes just the stock minigun with this ID
	CTFPlayer.DisableWeapon(weapon_classname_or_id_or_string)
		USE: CTFPlayer.DisableWeapon("Vaccinator")
			Disable only Vaccinator
		USE: CTFPlayer.DisableWeapon("secondary")
			Disable any secondary
		USE: CTFPlayer.DisableWeapon("tf_weapon_bottle")
			Disables any tf_weapon_bottle entity
	CTFPlayer.SetCustomWeapon(baseitem, custom_weapon_model, custom_arms_model)
		USE: handle.SetCustomWeapon("Knife", GTFW_MODELS_CUSTOM_WEAPONS.DEMO_BIGAXE, "models/weapons/c_models/c_scout_arms.mdl")
			Replaces stock knife with the Horseman's REAL Headtaker, using Scout's bat animations.
		USE: handle.SetCustomWeapon("primary", models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null)
			replaces all primaries with "c_demo_cannon.mdl"
			
			
Notes/Clarification
	-> CTFPlayer = handle ID for your player's entity (aka player's serial number)
	The following list are acceptable parameters for searching for weapons*:
		-> Handles (aka the weapon ID's serial number)
		-> Classnames of weapons (i.e. tf_weapon_wrench)
		(in quotes) "Primary", "Secondary", "Melee", "Misc", "Slot4", "Slot5", "Slot6", "Slot7"
			-> These terms can be lowercase or ALL CAPS (i.e. "PRIMARY", "melee").
			"misc" = anything that isn't melee, secondary, or primary (like spellbooks, grappling hooks, PDAs, watches, etc)
			"slot4" = Engineer's "Build PDA"
			"slot5" = Engineer's "Destroy PDA"
			"slot6" = Engineer toolbox, sapper (stock are both "tf_weapon_builder", sapper unlocks "tf_weapon_sapper")
			"slot7" = spellbook, grappling hook. (PASSTIME gun?)
		-> *SetCustomWeapon "baseitem" parameter takes all those above, except "misc".
		-> *GiveWeaponEx's second weapon parameter also only takes Classnames.
	itemID accepts:
		ANY: Valid items_game.txt IDs are 0 and above
		GiveWeaponEx: Can use exemption values by making the number negative (i.e. Wrench is itemID 7. Setting it to -7 would pick all wrenches except stock)
		GiveWeaponEx TIP: Use -0.0 to exempt all but all but Scout's stock bat (tf_weapon_bat)
		GiveWeaponEx TIP: Use any negative that isn't tied to that weapon to grab all weapons of that entity type. (i.e. searching "tf_weapon_wrench, -0.0," would search for any wrench)
	SetCustomWeapon Notes
		Please report any bugs to Yaki.
		NOTE: Watch your map's ent count! It spawns 1 entity for the class_arms (tf_wearable_vm). It spawns 2 additional entities--one for the thirdperson model (tf_wearable), and another for firstperson (tf_wearable_vm)
		NOTE: the player's viewmodel has a think script to fix the weapon appearing when needed, and being invisible when not (i.e. taunting, not holding)
			baseitem = Accepts handles, weapon's entity classnames, weapons by slot ("primary", "secondary", "melee", "slot4", "slot5", "slot6", "slot7", except "misc"), and weapon string name (i.e. "Crossbow")
			custom_weapon_model = your new model over the old one. Appears in thirdperson as well as firstperson.
			OPTIONAL: custom_arms_model = custom first person animations.
	GiveWeaponEx
		searched_weapon = weapon to be replaced. Accepts: "Primary", "Secondary", "Melee", or "Misc", weapon's string name (i.e. "Brass Beast"), or classname (i.e. "tf_weapon_wrench")
		searched_itemID = items_game.txt index. Negative numbers cause weapon to be excluded. If not a classname, ignores this value. Required for entity classnames (i.e. "tf_weapon_wrench").
		new_weapon = weapon to be given. Accepts: Weapon's string name (i.e. "Buff Banner"), or classname (i.e. "tf_weapon_knife")
		new_itemID = items_game.txt index. If new_weapon is a classname, must be positive. If not, it is ignored.


End instructions */

/* //Debug Stuff
PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
PrecacheModel("models/weapons/w_models/w_rapier_spy/w_rapier.mdl")
PrecacheModel("models/weapons/w_models/w_scroll_engineer/w_scroll_build.mdl")
PrecacheModel("models/weapons/w_models/w_scroll_engineer/w_scroll_destroy.mdl")
PrecacheModel("models/weapons/c_models/c_medic_wood_dart_rifle/c_medic_wood_dart_rifle.mdl")
enum GTFW_MODELS_CUSTOM_WEAPONS
{
	DEMO_BIGAXE		= "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl",
	SPY_RAPIER		= "models/weapons/w_models/w_rapier_spy/w_rapier.mdl",
	ENGI_SCROLL_BUILD = "models/weapons/w_models/w_scroll_engineer/w_scroll_build.mdl",
	ENGI_SCROLL_DESTROY = "models/weapons/w_models/w_scroll_engineer/w_scroll_destroy.mdl"
	SCOUT_DARTGUN	= "models/weapons/c_models/c_medic_wood_dart_rifle/c_medic_wood_dart_rifle.mdl"
}


//::_<-delegate{_get=function(idx){return idx;}}:{};

SendToConsole("con_filter_enable 1")
SendToConsole("con_filter_text_out Blocking")
SendToConsole ("ent_fire tf_wearable* kill; clear;")
printl("Executing...GTFW!")

::logPass <- 0
function logpass(name)
{
	logPass++
	printl("Pass #"+logPass+" ["+name+"]")
}
::ME <- GetListenServerHost()


::PlayerLoadoutGlobal_DrawSeq <- {}
::PlayerLoadoutGlobal_ClassArms <- {}
::PlayerLoadoutGlobal_BonemergedArms <- {}
::PlayerLoadoutGlobal_CustomWeaponModels_VM <- {}
::PlayerLoadoutGlobal_CustomWeaponModels_TP <- {}

PlayerLoadoutGlobal_DrawSeq.clear()
PlayerLoadoutGlobal_ClassArms.clear()
PlayerLoadoutGlobal_BonemergedArms.clear()
PlayerLoadoutGlobal_CustomWeaponModels_VM.clear()
PlayerLoadoutGlobal_CustomWeaponModels_TP.clear()


//"post_inventory_application" sent when a player gets a whole new set of items, aka touches a resupply locker / respawn cabinet or spawns in.
function OnGameEvent_post_inventory_application(params)
{
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params.userid)
		player.GTFW_Cleanup()	//must be at the beginning!!
		
	//	local melee = player.ReturnWeapon(tf_weapon_fists)
	//	melee.AddAttribute("disable weapon switch", 1, -1)
			
		if ( player.GetPlayerClass() == 1 )
		{
			local melee = player.GiveWeapon("Crossbow")
			player.SetCustomWeapon(melee, GTFW_MODELS_CUSTOM_WEAPONS.SCOUT_DARTGUN, GTFW_ARMS.MEDIC)
		}
		if ( player.GetPlayerClass() == 9 )
		{
		//	local melee = player.ReturnWeapon(tf_weapon_wrench)
		//	melee.AddAttribute("disable weapon switch", 1, -1)
			//melee.AddAttribute("force weapon switch", 1, -1)
		//	local melee = player.GiveWeapon("Eyelander")
		//	player.SetCustomWeapon(melee, -1, GTFW_MODELS_CUSTOM_WEAPONS.DEMO_BIGAXE, GTFW_ARMS.DEMO )
		//	player.SetCustomWeapon("Build PDA", GTFW_MODELS_CUSTOM_WEAPONS.ENGI_SCROLL_BUILD, null, null )
		//	player.SetCustomWeapon("Destroy PDA", GTFW_MODELS_CUSTOM_WEAPONS.ENGI_SCROLL_DESTROY, null )
		}
	//	player.GiveWeapon("Festive Buff Banner")
	//		player.GiveWeapon("Short Circuit")
	//		player.GiveWeapon("Gunslinger")
	//	local sword = player.GiveWeapon("Eyelander")
	//	local SpySword = player.SetCustomWeapon(knife, -1, "models/weapons/w_models/w_rapier_spy/w_rapier.mdl", GTFW_ARMS.SPY, "knife_draw" )
	//	NetProps.SetPropInt(player,"m_PlayerClass.m_iClass", 9)
	
	//	for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_drop*"); )
	//	{
	//		weapon.SetModel("models/weapons/w_models/w_rapier_spy/w_rapier.mdl")
	//	}
	}
}

::CTFPlayer.SetAmmo <- function()
{
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 0) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 1) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 2) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 3) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 4) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 5) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 6) )
	printl(NetProps.GetPropIntArray( this, "localdata.m_iAmmo", 7) )
}
function OnGameEvent_player_death(params)
{
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params.userid)
		player.GTFW_Cleanup()
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

//*/
///-------------------------------------///
const GLOBAL_WEAPON_COUNT = 10

enum GTFW_ARMS
{
	SCOUT	=	"models/weapons/c_models/c_scout_arms.mdl",
	SNIPER	=	"models/weapons/c_models/c_sniper_arms.mdl",
	SOLDIER	=	"models/weapons/c_models/c_soldier_arms.mdl",
	DEMO	=	"models/weapons/c_models/c_demo_arms.mdl",
	MEDIC	=	"models/weapons/c_models/c_medic_arms.mdl",
	HEAVY	=	"models/weapons/c_models/c_heavy_arms.mdl",
	PYRO	=	"models/weapons/c_models/c_pyro_arms.mdl",
	SPY		=	"models/weapons/c_models/c_spy_arms.mdl",
	ENGINEER=	"models/weapons/c_models/c_engineer_arms.mdl",
}

::GTFW_MODEL_ARMS <-
[
	"models/weapons/c_models/c_medic_arms.mdl", //dummy
	"models/weapons/c_models/c_scout_arms.mdl",
	"models/weapons/c_models/c_sniper_arms.mdl",
	"models/weapons/c_models/c_soldier_arms.mdl",
	"models/weapons/c_models/c_demo_arms.mdl",
	"models/weapons/c_models/c_medic_arms.mdl",
	"models/weapons/c_models/c_heavy_arms.mdl",
	"models/weapons/c_models/c_pyro_arms.mdl",
	"models/weapons/c_models/c_spy_arms.mdl",
	"models/weapons/c_models/c_engineer_arms.mdl",
	"models/weapons/c_models/c_engineer_gunslinger.mdl",	//Gunslinger/Civilian
]

::TF_GIVEWEAPON_CLASS <-
[
	0,	//MULTI-CLASS
	1,	//SCOUT
	3,	//SOLDIER
	7,	//PYRO
	4,	//DEMO
	6,	//HEAVY
	9,	//ENGINEER
	5,	//MEDIC
	2,	//SNIPER
	8,	//SPY
	10,	//CIVILIAN
]

::TF_GIVEWEAPON_CLASS_BY_NAME <-
[
	"MULTICLASS",
	"SCOUT",
	"SNIPER",
	"SOLDIER",
	"DEMO",
	"MEDIC",
	"HEAVY",
	"PYRO",
	"SPY",
	"ENGINEER",
	"CIVILIAN",
]

::SearchAllWeapons <-
[
	"tf_weapon_bat",
	"tf_weapon_bat_fish",
	"tf_weapon_bat_giftwrap",
	"tf_weapon_bat_wood",
	"tf_weapon_bonesaw",
	"tf_weapon_bottle",
	"tf_weapon_breakable_sign",
	"tf_weapon_buff_item",
	"tf_weapon_builder",
	"tf_weapon_cannon",
	"tf_weapon_charged_smg",
	"tf_weapon_cleaver",
	"tf_weapon_club",
	"tf_weapon_compound_bow",
	"tf_weapon_crossbow",
	"tf_weapon_drg_pomson",
	"tf_weapon_fireaxe",
	"tf_weapon_fists",
	"tf_weapon_flamethrower",
	"tf_weapon_flaregun",
	"tf_weapon_flaregun_revenge",
	"tf_weapon_grapplinghook",
	"tf_weapon_grenadelauncher",
	"tf_weapon_handgun_scout_primary",
	"tf_weapon_handgun_scout_secondary",
	"tf_weapon_invis",
	"tf_weapon_jar",
	"tf_weapon_jar_milk",
	"tf_weapon_jar_gas",
	"tf_weapon_katana",
	"tf_weapon_knife",
	"tf_weapon_laser_pointer",
	"tf_weapon_lunchbox",
	"tf_weapon_lunchbox_drink",
	"tf_weapon_mechanical_arm",
	"tf_weapon_medigun",
	"tf_weapon_minigun",
	"tf_weapon_parachute",
	"tf_weapon_parachute_primary",
	"tf_weapon_parachute_secondary",
	"tf_weapon_particle_cannon",
	"tf_weapon_passtime_gun",
	"tf_weapon_pda_engineer_build",
	"tf_weapon_pda_engineer_destroy",
	"tf_weapon_pda_spy",
	"tf_weapon_pep_brawler_blaster",
	"tf_weapon_pipebomblauncher",
	"tf_weapon_pistol",
	"tf_weapon_pistol_scout",
	"tf_weapon_raygun",
	"tf_weapon_revolver",
	"tf_weapon_robot_arm",
	"tf_weapon_rocketlauncher",
	"tf_weapon_rocketlauncher_airstrike",
	"tf_weapon_rocketlauncher_directhit",
	"tf_weapon_rocketlauncher_fireball",
	"tf_weapon_rocketpack",
	"tf_weapon_sapper",
	"tf_weapon_scattergun",
	"tf_weapon_sentry_revenge",
	"tf_weapon_shotgun_hwg",
	"tf_weapon_shotgun_primary",
	"tf_weapon_shotgun_pyro",
	"tf_weapon_shotgun_building_rescue",
	"tf_weapon_shotgun_soldier",
	"tf_weapon_shovel",
	"tf_weapon_slap",
	"tf_weapon_smg",
	"tf_weapon_sniperrifle",
	"tf_weapon_sniperrifle_classic",
	"tf_weapon_sniperrifle_decap",
	"tf_weapon_soda_popper",
	"tf_weapon_spellbook",
	"tf_weapon_stickbomb",
	"tf_weapon_sword",
	"tf_weapon_syringegun_medic",
	"tf_weapon_wrench",
]
::SearchPrimaryWeapons <-
[
	"tf_weapon_cannon",
	"tf_weapon_compound_bow",
	"tf_weapon_crossbow",
	"tf_weapon_drg_pomson",
	"tf_weapon_flamethrower",
	"tf_weapon_grenadelauncher",
	"tf_weapon_handgun_scout_primary",
	"tf_weapon_minigun",
	"tf_weapon_parachute",
	"tf_weapon_parachute_primary",
	"tf_weapon_particle_cannon",
	"tf_weapon_pep_brawler_blaster",
	"tf_weapon_revolver",
	"tf_weapon_rocketlauncher",
	"tf_weapon_rocketlauncher_airstrike",
	"tf_weapon_rocketlauncher_directhit",
	"tf_weapon_rocketlauncher_fireball",
	"tf_weapon_scattergun",
	"tf_weapon_sentry_revenge",
	"tf_weapon_shotgun_primary",
	"tf_weapon_sniperrifle",
	"tf_weapon_sniperrifle_classic",
	"tf_weapon_sniperrifle_decap",
	"tf_weapon_soda_popper",
	"tf_weapon_syringegun_medic",
]
::SearchSecondaryWeapons <-
[
	"tf_weapon_buff_item",
	"tf_weapon_charged_smg",
	"tf_weapon_cleaver",
	"tf_weapon_flaregun",
	"tf_weapon_flaregun_revenge",
	"tf_weapon_handgun_scout_secondary",
	"tf_weapon_jar",
	"tf_weapon_jar_milk",
	"tf_weapon_jar_gas",
	"tf_weapon_laser_pointer",
	"tf_weapon_lunchbox",
	"tf_weapon_lunchbox_drink",
	"tf_weapon_mechanical_arm",
	"tf_weapon_medigun",
	"tf_weapon_parachute",
	"tf_weapon_parachute_secondary",
	"tf_weapon_pipebomblauncher",
	"tf_weapon_pistol",
	"tf_weapon_pistol_scout",
	"tf_weapon_raygun",
	"tf_weapon_rocketpack",
	"tf_weapon_shotgun_hwg",
	"tf_weapon_shotgun_pyro",
	"tf_weapon_shotgun_soldier",
]
::SearchMeleeWeapons <-
[
	"tf_weapon_bat",
	"tf_weapon_bat_fish",
	"tf_weapon_bat_giftwrap",
	"tf_weapon_bat_wood",
	"tf_weapon_bonesaw",
	"tf_weapon_bottle",
	"tf_weapon_breakable_sign",
	"tf_weapon_club",
	"tf_weapon_fireaxe",
	"tf_weapon_fists",
	"tf_weapon_katana",
	"tf_weapon_knife",
	"tf_weapon_robot_arm",
	"tf_weapon_shovel",
	"tf_weapon_slap",
	"tf_weapon_stickbomb",
	"tf_weapon_sword",
	"tf_weapon_wrench",
]
::SearchMiscWeapons <-
[
	"tf_weapon_builder",
	"tf_weapon_grapplinghook",
	"tf_weapon_invis",
	"tf_weapon_passtime_gun",
	"tf_weapon_pda_engineer_build",
	"tf_weapon_pda_engineer_destroy",
	"tf_weapon_pda_spy",
	"tf_weapon_sapper",
	"tf_weapon_spellbook",
	"tf_wearable",
	"tf_wearable_demoshield",
]
::SearchSlot4Weapons <-
[
	"tf_weapon_pda_spy",
	"tf_weapon_pda_engineer_build",
]
::SearchSlot5Weapons <-
[
	"tf_weapon_invis",
	"tf_weapon_pda_engineer_destroy",
]
::SearchSlot6Weapons <-
[
	"tf_weapon_builder",
	"tf_weapon_sapper",
]
::SearchSlot7Weapons <-
[
	"tf_weapon_grapplinghook",
	"tf_weapon_passtime_gun",
	"tf_weapon_spellbook",
]

::SearchBySlotsParameters <-
[
	"primary",
	"Primary",
	"PRIMARY",
	"secondary",
	"Secondary",
	"SECONDARY",
	"melee",
	"Melee",
	"MELEE",
	"misc",
	"Misc",
	"MISC",
	"slot4",
	"Slot4",
	"SLOT4",
	"slot5",
	"Slot5",
	"SLOT5",
	"slot6",
	"Slot6",
	"SLOT6",
	"slot7",
	"Slot7",
	"SLOT7",
]

enum TF_AMMO
{
	NONE = 0
	PRIMARY = 1
	SECONDARY = 2
	METAL = 3
	GRENADES1 = 4 // e.g. Sandman, Jarate, Sandvich
	GRENADES2 = 5 // e.g. Mad Milk, Bonk,
	GRENADES3 = 6 // e.g. Spells
}


::GTFW_FindEquipByStringOrID <- function(baseitem)
{
	local truefalse = true
	foreach (exists in TF_WEAPONS_ALL)
	{
		if ( exists.itemString == baseitem || exists.itemString2 == baseitem )
		{
			if ( exists.className == "tf_weapon_saxxy" ) {
				exists.className = GTFW_Saxxy[this.GetPlayerClass()]
			}
			truefalse = true
			return exists
		}
		else if ( exists.itemID == baseitem || exists.itemID2 == baseitem )
		{
			if ( exists.className == "tf_weapon_saxxy" )
			{
				exists.className = GTFW_Saxxy[this.GetPlayerClass()]
			}
			if ( exists.itemID == baseitem ) {
				exists.itemID = exists.itemID
			}
			else if ( exists.itemID2 == baseitem ) {
				exists.itemID = exists.itemID2
			}
			truefalse = false
			return exists
		}
	}
	if ( truefalse )
	{
		foreach (exists in TF_WEAPONS_ALL_FESTIVE)
		{
			if ( exists.itemString == baseitem || exists.itemString2 == baseitem )
			{
				truefalse = false
				return exists
			}
			else if ( exists.itemID == baseitem )
			{
				truefalse = false
				return exists
			}
		}
		
		if ( truefalse )
		{
			foreach (exists in TF_WEAPONS_ALL_WARPAINTSnBOTKILLERS)
			{
				if ( exists.itemID == baseitem || exists.itemID2 == baseitem || exists.itemID3 == baseitem
				|| exists.itemID4 == baseitem || exists.itemID5 == baseitem || exists.itemID6 == baseitem
				|| exists.itemID7 == baseitem || exists.itemID8 == baseitem || exists.itemID9 == baseitem
				|| exists.itemID10 == baseitem || exists.itemID11 == baseitem || exists.itemID12 == baseitem
				|| exists.itemID13 == baseitem)
				{
					if ( exists.className == "tf_weapon_saxxy" )
					{
						exists.className = GTFW_Saxxy[this.GetPlayerClass()]
					}
					if ( exists.itemID == baseitem ) {
						exists.itemID = exists.itemID
					}
					else if ( exists.itemID2 == baseitem ) {
						exists.itemID = exists.itemID2
					}
					else if ( exists.itemID3 == baseitem ) {
						exists.itemID = exists.itemID3
					}
					else if ( exists.itemID4 == baseitem ) {
						exists.itemID = exists.itemID4
					}
					else if ( exists.itemID5 == baseitem ) {
						exists.itemID = exists.itemID5
					}
					else if ( exists.itemID6 == baseitem ) {
						exists.itemID = exists.itemID6
					}
					else if ( exists.itemID7 == baseitem ) {
						exists.itemID = exists.itemID7
					}
					else if ( exists.itemID8 == baseitem ) {
						exists.itemID = exists.itemID8
					}
					else if ( exists.itemID9 == baseitem ) {
						exists.itemID = exists.itemID9
					}
					else if ( exists.itemID10 == baseitem ) {
						exists.itemID = exists.itemID10
					}
					else if ( exists.itemID11 == baseitem ) {
						exists.itemID = exists.itemID11
					}
					else if ( exists.itemID12 == baseitem ) {
						exists.itemID = exists.itemID12
					}
					else if ( exists.itemID13 == baseitem ) {
						exists.itemID = exists.itemID13
					}
					return exists
				}
			}
		}
	}
}

::CheckIfEquipOnPlayer <- function(item_classname)
{
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep != null && wep.GetClassname() == item_classname ) {
			return true
		}
		else if ( i = GLOBAL_WEAPON_COUNT - 1) {
			return false
		}
	}
}
// FUNCTION: Used to update viewmodel arms. Don't use on its own

::CTFPlayer.UpdateArms <- function(weapon, weapon_model, arms_model, draw_anim)
{
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	
// USE: Updates arms if the class holding it is the owner
// Checks if not a custom weapon, then does *not* use special VM fix for it.
	if ( NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes") == 0 )
	{
		foreach (exists in TF_WEAPONS_ALL)
		{
			if ( exists.className == weapon.GetClassname() && this.GetPlayerClass() == exists.tf_class )
			{
				if ( exists.className == "tf_weapon_robot_arm" )
				{
					weapon.SetModelSimple( GTFW_MODEL_ARMS[10] )	//Gunslinger arms
				}
				else { weapon.SetModel( GTFW_MODEL_ARMS[this.GetPlayerClass()] ) }
				return weapon
			}
		}
	}
	
// USE: This is the special VM fix.
// it creates class arms that bonemerge with VM, and adds the weapon in the VM as a tf_wearable_vm.
// It creates the world model, as well.
	local class_arms = null
	
	local weapon_id = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local baseitem = GTFW_FindEquipByStringOrID(weapon_id)
	
	local baseitemClassname = null
	local is_tfclass = null
	local Slot = null
	local draw_seq = null
	
	if ( baseitem.className != null ) {
		baseitemClassname = baseitem.className
		is_tfclass = baseitem.tf_class
		Slot = baseitem.slot
		draw_seq = baseitem.draw_seq
	}
	else if ( baseitem.className == null ) {
		return
	}
	
	if ( weapon.GetClassname() != "tf_wearable" && weapon.GetClassname() != "tf_wearable_demoshield" ) {
		if ( CVAR_GTFW_USE_VIEWMODEL_FIX )
		{
			class_arms = GTFW_MODEL_ARMS[is_tfclass]
			
			if ( is_tfclass == 0 )
			{
				class_arms = GTFW_MODEL_ARMS[this.GetPlayerClass()]
			}
			else if ( is_tfclass == 9 && this.HasGunslinger() )
			{
				class_arms = GTFW_MODEL_ARMS[10]
			}
			if ( arms_model != null && draw_anim != null)
			{
				main_viewmodel.SetModel( arms_model )
				class_arms = arms_model
				draw_seq = main_viewmodel.LookupSequence( draw_anim )
			}
		//updates class arms if not using new weapon's class arms
		// setting this all the time breaks deploy animations
			else
			{
				main_viewmodel.SetModel( class_arms )
				draw_seq = main_viewmodel.LookupSequence( draw_seq )
			}
			if ( weapon_model != null && weapon_model != 0 )
			{
				
				local wearable_handle = this.CreateCustomWeaponModel(false, weapon, weapon_model)	// creates weapon in viewmodel, parents and does all that stuff

			//Mr. Burguers helped me with this part. Thanks Mr B!
				local wepClassname = weapon.GetClassname()
				
				local playerData = {}
				if (this in PlayerLoadoutGlobal_CustomWeaponModels_VM) {
					playerData = PlayerLoadoutGlobal_CustomWeaponModels_VM[this]
				} else {
					PlayerLoadoutGlobal_CustomWeaponModels_VM[this] <- playerData
				}
			
				if ( wepClassname in playerData )
				{
					local wepmodel = playerData[wepClassname]
					wepmodel.Kill()
					delete playerData[wepClassname]
				}
				else
				{
					playerData[weapon.GetClassname()] <- wearable_handle
				}
				
				if ( NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes") )	//checks if weapon is custom
				{
					wearable_handle = this.CreateCustomWeaponModel(true, weapon, weapon_model)	// creates thirdperson/world model, parents and does all that stuff
				}
			}
		}
	}

	return weapon
}

// FUNCTION: Finds Gunslinger on player. If found, returns true.
::CTFPlayer.HasGunslinger <- function()
{
	if ( this.GetPlayerClass() == 9 )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null && wep.GetClassname() == "tf_weapon_robot_arm" || wepID == 142 )
			{
				return true
			}
		}
	}
	return false
}

// FUNCTION: Clears and updates the viewmodel think script for weapon switching, enabling/disabling visibility of custom weapons.

::CTFPlayer.AddThinkToViewModel <- function()
{
	if ( CVAR_GTFW_USE_VIEWMODEL_FIX == false) {
		return
	}
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	local wearable_handle = null
	
	local thes = Entities.FindByClassname(null, "tf_wearable_vm")
	
// adds a class arms model if nothing has parented to the main_viewmodel
// this is used as a flag for initializing tables for the weapons
	if ( main_viewmodel.FirstMoveChild() == null )
	{
		::PlayerLoadoutGlobal_ClassArms[this] <- {}
		::PlayerLoadoutGlobal_DrawSeq[this] <- {}
		
		wearable_handle = this.CreateCustomWeaponModel(false, null, GTFW_MODEL_ARMS[this.GetPlayerClass()])	// creates player class' arms, parents and does all that stuff
	// PURPOSE: Gunslinger/Short Circuit Fix
	// Puts into a table "player = arms model" for easy tracking
		PlayerLoadoutGlobal_BonemergedArms[this] <- wearable_handle
	}
	
// FUNCTION: writes to the tables, which keep the class arms the weapon needs to update to when switched to,
// and the draw sequence. All draw sequences were found in the qc arms files, and are documented in GIVE_TF_WEAPON_ALL.nut.
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
		
		if ( wep != null )
		{
			local baseitem = GTFW_FindEquipByStringOrID(wepID)
			if ( baseitem != null) {
				PlayerLoadoutGlobal_DrawSeq[this][wep.GetClassname()] <- baseitem.draw_seq
				if ( this.HasGunslinger() )
				{
					PlayerLoadoutGlobal_ClassArms[this][wep.GetClassname()] <- GTFW_MODEL_ARMS[10]
					wep.SetModelSimple( GTFW_MODEL_ARMS[10] )
				}
				else {
					PlayerLoadoutGlobal_ClassArms[this][wep.GetClassname()] <- GTFW_MODEL_ARMS[baseitem.tf_class]
					wep.SetModel( GTFW_MODEL_ARMS[baseitem.tf_class] )
				}
			}
		}
	}

// Think script itself.
// Reads from several tables to find weapon's draw sequences and class arms.
	if( main_viewmodel.ValidateScriptScope() )
	{
		local wep = null

		local player = this
		
		local entscriptname = "THINK_VM_FIX_"+this.tostring()
		
		local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
		
		local DisableDrawQueue = null
		
		const THINK_VMFIX_DELAY = 0
		
		local entityscript = main_viewmodel.GetScriptScope()
		entityscript[entscriptname] <- function()
		{
		// disables custom weapons, if the queue is full
			if ( player.GetActiveWeapon() != wep && !player.InCond("TF_COND_TAUNTING") && DisableDrawQueue != null )
			{
				DisableDrawQueue.DisableDraw()
				DisableDrawQueue = null
			}
		// updates weapons' visibility based on which one is being used
			if ( player.GetActiveWeapon() != wep && !player.InCond("TF_COND_TAUNTING") )
			{
				wep = player.GetActiveWeapon()
		
			/*	printl("WEAPON ACTIVE "+wep)
				printl( PlayerLoadoutGlobal_ClassArms[player][wep.GetClassname()] )
				printl( PlayerLoadoutGlobal_DrawSeq[player][wep.GetClassname()] )
			*/
				
			// This updates the viewmodel.
			// Remember, the weapon's sequences are decided by tf_viewmodel (or this handle, main_viewmodel)
				main_viewmodel.SetModel( PlayerLoadoutGlobal_ClassArms[player][wep.GetClassname()] )
				main_viewmodel.SetSequence( main_viewmodel.LookupSequence( PlayerLoadoutGlobal_DrawSeq[player][wep.GetClassname()] ) )
				
			// These are vars are for the next part
				local asdf = null
				DisableDrawQueue = null
				
			//Checks for custom weapon and/or weapon unintended for the class.
			//Passing as a custom weapon means it updates the weapon visibility, disables the base weapon,
				if (NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes") )
				{
					main_viewmodel.DisableDraw()		//makes firstperson weapon invisible (as well as other's class arms from the other class)
					DoEntFire("!self", "RunScriptCode", "self.DisableDraw()", 0.01, null, wep)	//using delay here purposely. Won't update b/c thinks too fast!!
					asdf = PlayerLoadoutGlobal_CustomWeaponModels_TP[player][wep.GetClassname()]	//reads from table
					asdf.EnableDraw()		//shows custom weapon
					DisableDrawQueue = asdf	//custom weapon disables visibility at beginning of think script.
				}
				else if ( NetProps.GetPropInt(wep, "m_bValidatedAttachedEntity") ) {
					main_viewmodel.DisableDraw()		//makes firstperson weapon invisible (as well as other's class arms from the other class)
				}
			// this part reads from the bonemerged arms table
			// who ever the class is, and which ever arms they are using, this will put it as a value...
				local bonemerged = PlayerLoadoutGlobal_BonemergedArms[player]
				
				local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			// if ShortCircuit, disable the class arms' visibility
				if ( wepID == 528 ) { // Short Circuit
					bonemerged.DisableDraw()
				}
				else
				{
					bonemerged.EnableDraw()	//enable otherwise
				}
			}
			return THINK_VMFIX_DELAY
		}
		AddThinkToEnt(main_viewmodel, entscriptname)	//adds think script
	}
}

//FUNCTION: Don't use by itself. Used to find switch to a gun forcefully.
// See top of script for info
::CTFPlayer.SwitchToActive <- function(NewGun)
{
	if ( NewGun == null ) {
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
		// pass if our active weapon was not the deleted one, nor any misc weapon like a PDA or spellbook
			if ( wep != null && wep != this.GetActiveWeapon() )
			{
				NetProps.SetPropEntity(this, "m_hActiveWeapon", wep)
				NetProps.SetPropInt(wep, "m_iState", 2)
				break
			}
		}
	}
	else {
		NetProps.SetPropEntity(this, "m_hActiveWeapon", NewGun)
		NetProps.SetPropInt(NewGun, "m_iState", 2)
	}
}

//Base for making weapons. Netprops compiled by ficool2.
::CTFPlayer.AddWeapon <- function(classname, itemindex, slot)
{
	local weapon = Entities.CreateByClassname(classname)

	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", itemindex)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityQuality", 0)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityLevel", 1)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bInitialized", 1)
	
	NetProps.SetPropEntity(weapon, "m_hOwnerEntity", this)
	NetProps.SetPropEntity(weapon, "m_hOwner", this)
	NetProps.SetPropInt(weapon, "m_iTeamNum", this.GetTeam())
	
	NetProps.SetPropInt(weapon, "m_bClientSideAnimation", 1)
	NetProps.SetPropInt(weapon, "m_fEffects", 129)
	NetProps.SetPropInt(weapon, "m_iState", 2)
	NetProps.SetPropInt(weapon, "m_CollisionGroup", 11)
	
	local curTime = Time()
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextPrimaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextSecondaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flTimeWeaponIdle", curTime)
	
//	NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1) //using as flag for if weapon is being used by unintended class
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity", 3)
	
	weapon.SetAbsOrigin(Vector(0,0,0))
	weapon.SetAbsAngles(QAngle(0,0,0))
	
	Entities.DispatchSpawn(weapon)
	
	local solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags | Constants.SolidFlags.FSOLID_NOT_SOLID);
	
	solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags & ~(Constants.SolidFlags.FSOLID_TRIGGER));
	
	if ( classname != "tf_wearable_demoshield" || classname != "tf_wearable" || classname != "tf_wearable_razorback" )
	{
		NetProps.SetPropEntityArray(this, "m_hMyWeapons", weapon, slot)
	}
	weapon.SetLocalOrigin(this.GetLocalOrigin())
	weapon.SetLocalAngles(this.GetAbsAngles())
	DoEntFire("!self", "SetParent", "!activator", 0, this, weapon)
	NetProps.SetPropInt(weapon, "m_MoveType", 0)

//If added weapon is not intended to be used by player's tfclass, mark it to fix VM arms
	local addedWep = GTFW_FindEquipByStringOrID(itemindex)
	if ( this.GetPlayerClass() != addedWep.tf_class)
	{
		NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1)
	}
	

	if ( classname == "tf_weapon_builder")	//Engineer toolbox
	{
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_iObjectType", 0)
		NetProps.SetPropInt(weapon, "m_iSubType", 0)
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.000", 257)	// ??? needs to be 257
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.001", -1)	//changes based on blueprint building phase, before placement.
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.002", 0)
		NetProps.SetPropInt(weapon, "BuilderLocalData.m_aBuildableObjectTypes.003", 0)
	}
	if ( itemindex == 998 )	//Vaccinator
	{
		weapon.AddAttribute("lunchbox adds minicrits", 3, -1)
		weapon.AddAttribute("medigun charge is resists", 3, -1)
	}
	if ( itemindex == 132 || itemindex == 482 || itemindex == 1082 || itemindex == 266 ) //eyelanders fix
	{
		weapon.AddAttribute("decapitate type", 1, -1)
		weapon.AddAttribute("crit mod disabled", 0, -1)
		weapon.AddAttribute("is_a_sword", 72, -1)
		weapon.AddAttribute("max health additive bonus", -25, -1)
	}
	
	local weapon_model = NetProps.GetPropInt(weapon, "m_iWorldModelIndex")

	this.UpdateArms(weapon, weapon_model, null, null)
	this.AddThinkToViewModel()
	return weapon
}

::CTFPlayer.GTFW_Cleanup <- function()
{
	// Deletes any viewmodels that the script has created
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	AddThinkToEnt(main_viewmodel, null)	//clears script if it was being used
	if ( main_viewmodel != null && main_viewmodel.FirstMoveChild() != null )
	{
		main_viewmodel.FirstMoveChild().Kill()
	}
	for (local i = 0; i < 42; i++)
	{
		local wearable = Entities.FindByNameWithin(this, "tf_wearable_vscript", this.GetLocalOrigin(), 128)

		if ( wearable != null && NetProps.GetPropEntity(wearable, "m_hOwnerEntity") == this )
		{
			printl("Deleting wearable... "+wearable+" Model# "+NetProps.GetPropInt(wearable, "m_nModelIndex") )

			wearable.Kill()
		}
		else
		{
			break
		}
	}
//cleans all custom weapons
	::PlayerLoadoutGlobal_CustomWeaponModels_VM[this] <- {}
	::PlayerLoadoutGlobal_CustomWeaponModels_TP[this] <- {}
}


/*FUNCTION: Finds an empty weapon equipment slot and gives weapon to the player
	-> See top of script for more info
 weapon = weapon classname (i.e. "tf_weapon_knife")
 itemID = items_game.txt index (i.e. 4)

 USE: handle.GiveWeapon(15) // Gives the stock minigun
 USE: handle.GiveWeapon("Eyelander")
*/

::CTFPlayer.GiveWeapon <- function(weapon)
{
	local YourNewGunSaxtonApproved = null
	local DeletedWeapon = null

//searches for the correct item based on parameter 'baseitem'...
	local baseitem = GTFW_FindEquipByStringOrID(weapon)
	
	local NewWeapon = baseitem.className
	local ItemID = baseitem.itemID
	local Slot = baseitem.slot
	
/*marks weapon as unintended for class
	if ( baseitem.tf_class != this.GetPlayerClass() )
	{
		NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1) // is a weapon unintended for the class
	}*/

//searches inventory
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)

		if ( CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS && wep != null ) {
			DeletedWeapon = wep.entindex()
			if ( Slot == 1 && SearchPrimaryWeapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
			else if ( Slot == 2 && SearchSecondaryWeapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
			else if ( Slot == 3 && SearchMeleeWeapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
			else if ( Slot == 4 && SearchSlot4Weapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
			else if ( Slot == 5 && SearchSlot5Weapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
			else if ( Slot == 6 && SearchSlot6Weapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
			else if ( Slot == 7 && SearchSlot7Weapons.find(wep.GetClassname()) != null )
			{
				wep.Kill()
			}
		}
		if ( wep == null ) {
			YourNewGunSaxtonApproved = this.AddWeapon(NewWeapon, ItemID, i)
			break
		}
	}
	if ( YourNewGunSaxtonApproved == null ) {
		return null
	}
	
// switches to another weapon if active one was deleted
// if given weapon matches the slot of the old weapon, stay in slot
	if (CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS)
	{
		local SlotNew = null
		foreach (exists in TF_WEAPONS_ALL)
		{
			if ( exists.className == NewWeapon )
			{
				SlotNew = exists.slot
			}
		}
		if ( Slot == SlotNew )
		{
			this.SwitchToActive(YourNewGunSaxtonApproved)
		}
		else
		{
			for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
			{
				local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
				
			// pass if our active weapon was not the deleted one, nor any misc weapon like a PDA or spellbook
				if ( wep != null && wep != DeletedWeapon && SearchMiscWeapons.find(wep.GetClassname()) < 0 )
				{
					NetProps.SetPropEntity(this, "m_hActiveWeapon", wep)
					break
				}
			}
		}
	}
	
	return YourNewGunSaxtonApproved
}

/*FUNCTION: Deletes a weapon equipped on player
	-> See top of script for more info
 Accepts handles, entity classnames, strings, slots
 USE: handle.DeleteWeapon("tf_weapon_minigun")	//deletes only stock minigun
 USE: handle.DeleteWeapon("SECONDARY")	//deletes all secondaries
*/

::CTFPlayer.DeleteWeapon <- function(weapon)
{
	local YourGunWasTakenBySAXTONHALE = null
	local DeleteThis = weapon
	local wep_itemID = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local DeletedWeapon = null
	local wep = null
	
//converts our weapon from string/ID to a classname...
	local baseitem = GTFW_FindEquipByStringOrID(weapon)
	if ( baseitem != null ) {
		DeleteThis = baseitem.className
	} else {
		local baseitem = GTFW_FindEquipByStringOrID(wep_itemID)
		if ( baseitem != null ) {
			DeleteThis = baseitem.className
		}
	}
	if ( CheckIfEquipOnPlayer(DeleteThis) ) {
		return null
	}
	
	local LOOPCOUNT_MAX = 1
	
	if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
	{
		LOOPCOUNT_MAX = 4	//setting to 3 for multiple PDAs, InvisWatch, Spellbook etc
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null )
			{
				if ( FindEquipBySlot(wep) )
				{
					DeleteThis = wep.GetClassname()
				}
				if ( wep.GetClassname() == DeleteThis )
				{
					DeletedWeapon = wep.entindex()
					wep.Kill()
					break
				}
			}
		}
	}
	
// switches to another weapon if active one was deleted
	this.SwitchToActive(null)
}


/*FUNCTION: Overwrites a weapon with another weapon
	-> See top of script for more info
 CTFPlayer = handle for your player's entity
 searched_weapon = weapon to be replaced. Accepts: "Primary", "Secondary", "Melee", or "Misc", weapon's string name (i.e. "Brass Beast"), or classname (i.e. "tf_weapon_wrench")
 searched_itemID = items_game.txt index. Negative numbers cause weapon to be excluded. If not a classname, ignores this value. Required for entity classnames (i.e. "tf_weapon_wrench").
 new_weapon = weapon to be given. Accepts: Weapon's string name (i.e. "Buff Banner"), or classname (i.e. "tf_weapon_knife")
 new_itemID = items_game.txt index. If new_weapon is a classname, must be positive. If not, it is ignored.

 USE: CTFPlayer.GiveWeaponEx("tf_weapon_wrench", -7, "tf_weapon_knife", 4)	//replaces all non-stock wrenches with stock knife
 USE: CTFPlayer.GiveWeaponEx("melee", -1, "tf_weapon_robot_arm", 142)	//replaces all melees with gunslinger
 USE: CTFPlayer.GiveWeaponEx("Brass Beast", -1, "Buff Banner", -1)		//replaces just the Brass Beast with the Buff Banner.
*/

::CTFPlayer.GiveWeaponEx <- function(searched_weapon, searched_itemID, new_weapon, new_itemID)
{
	local YourNewGunSaxtonApproved = null
	local ReplaceThis = searched_weapon
	local ReplaceThisID = searched_itemID
	local wep_itemID = NetProps.GetPropInt(searched_weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local GiveThis = new_weapon
	local GiveThisID = new_itemID

//converts our weapon from string/ID to a classname...
	local baseitem = GTFW_FindEquipByStringOrID(searched_weapon)
	if ( baseitem != null ) {
		ReplaceThis = baseitem.className
	} else {
		local baseitem = GTFW_FindEquipByStringOrID(wep_itemID)
		if ( baseitem != null ) {
			ReplaceThis = baseitem.className
		}
	}
//cancels the operation if we don't have this weapon...
	if ( CheckIfEquipOnPlayer(ReplaceThis) ) {
		return null
	}
	
//putting "a" here so it doesn't error with nothing in array[0]
	local CheckIfAllButWeapon = split(ReplaceThisID.tostring()+"a",abs(ReplaceThisID).tostring())[0]
//a negative itemID is excluded in the search
	local ExcludeWeapon = false	//off by default
	if ( CheckIfAllButWeapon == "-" )	//if itemID is negative...
	{
		ReplaceThisID = abs(searched_itemID).tointeger()
		ExcludeWeapon = true
	}
//searches for the correct item based on parameter 'baseitem'...
	baseitem = GTFW_FindEquipByStringOrID(new_weapon)
	if ( baseitem != null ) {
		GiveThisID = baseitem.itemID
	}
	else if ( baseitem == null ) {
		return null
	}
	
	local LOOPCOUNT_MAX = 1
	
	if ( searched_weapon == "misc" || searched_weapon == "MISC" || searched_weapon == "Misc" )
	{
		LOOPCOUNT_MAX = 4	//setting to 3 for multiple PDAs, InvisWatch, Spellbook etc
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			local wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null )
			{
				if ( FindEquipBySlot(wep) )
				{
					ReplaceThis = wep.GetClassname()
				}
				if ( ( wep.GetClassname() == ReplaceThis && ExcludeWeapon == false && wep_itemID == ReplaceThisID ) || ( wep.GetClassname() == ReplaceThis && ExcludeWeapon == true && wep_itemID != searched_itemID ) )
				{
					wep.Kill()
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						YourNewGunSaxtonApproved = this.GiveWeapon(GiveThisID)
						break
					}
				}
			}
		}
	}
	
	return YourNewGunSaxtonApproved
}


/*	FUNCTION: Shows in console all equips on host of listen server.
		-> See top of script for more info

	USE: CheckItems()
*/

::CheckItems <- function()
{
	local ActiveWeapon = GetListenServerHost().GetActiveWeapon()
	local ActiveWeaponID = NetProps.GetPropInt(ActiveWeapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local slot = "ERROR"
	if ( SearchPrimaryWeapons.find(ActiveWeapon.GetClassname()) != null )
	{
		slot = "Primary"
	}
	else if ( SearchSecondaryWeapons.find(ActiveWeapon.GetClassname()) != null )
	{
		slot = "Secondary"
	}
	else if ( SearchMeleeWeapons.find(ActiveWeapon.GetClassname()) != null )
	{
		slot = "Melee"
	}
	else if ( SearchMiscWeapons.find(ActiveWeapon.GetClassname()) != null )
	{
		slot = "Misc"
	}
	Say(GetListenServerHost(), " ", false)
	Say(GetListenServerHost(), "Active "+slot+" ["+ActiveWeapon.GetClassname()+"] (ItemID = "+ActiveWeaponID+")", false)
	printl(slot+" "+ActiveWeapon+" (ItemID = "+ActiveWeaponID+")" )
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(GetListenServerHost(), "m_hMyWeapons", i)
		local wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
		if ( wep != null && wep != ActiveWeapon)
		{
			if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
			{
				slot = "Primary"
			}
			else if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
			{
				slot = "Secondary"
			}
			else if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
			{
				slot = "Melee"
			}
			else if ( SearchMiscWeapons.find(wep.GetClassname()) != null )
			{
				slot = "Misc"
			}
			Say(GetListenServerHost(), slot+" ["+wep.GetClassname()+"] (ItemID = "+wep_itemID+")", false)
			printl(slot+" "+wep+" (ItemID = "+wep_itemID+")" )
		}
	}
/*	for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_wea*"); )
		{
			printl("WEARABLE "+weapon+" "+weapon.GetMoveParent())
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityQuality")) //typically -1
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bInitialized")) //1
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes")) //0, or 1 for GiveWeapons
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity")) //3 or 5
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_AttributeManager.m_ProviderType")) //1
			printl(weapon+" "+NetProps.GetPropEntity(weapon, "m_AttributeManager.m_hOuter")) //typically self
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_bClientSideAnimation")) //1
			printl(weapon+" "+NetProps.GetPropEntity(weapon, "m_hOwnerEntity")) //
			printl(weapon+" "+NetProps.GetPropFloat(weapon, "m_hEffectEntity")) //
			printl(weapon+" "+NetProps.GetPropInt(weapon, "m_bValidatedAttachedEntity") ) //0, or 1 for GiveWeapons
		}
*/
}

/*	 FUNCTION: Finds equip if it has parameters like "primary", "secondary", etc
	returns true if it found anything

*/
function FindEquipBySlot(weapon)
{
	if ( weapon == "primary" || weapon == "PRIMARY" || weapon == "Primary" )
	{
		if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "secondary" || weapon == "SECONDARY" || weapon == "Secondary" )
	{
		if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "melee" || weapon == "MELEE" || weapon == "Melee" )
	{
		if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
	{
		if ( SearchMiscWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "slot4" || weapon == "SLOT4" || weapon == "Slot4" )
	{
		if ( SearchSlot4Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "slot5" || weapon == "SLOT5" || weapon == "Slot5" )
	{
		if ( SearchSlot5Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "slot6" || weapon == "SLOT6" || weapon == "Slot6" )
	{
		if ( SearchSlot6Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( weapon == "slot7" || weapon == "SLOT7" || weapon == "Slot7" )
	{
		if ( SearchSlot7Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else {
		return false
	}
}
				
/* FUNCTION: disables being able to switch to a weapon.
	-> See top of script for more info
 weapon = weapon to disable
 itemID = items_game.txt item ID index. Can take -1 if there is none.
	
 USE: CTFPlayer.DisableWeapon("tf_weapon_medigun", 998) //Disable only Vaccinator
 USE: CTFPlayer.DisableWeapon("secondary", -1) //Disable any secondary
*/

::CTFPlayer.DisableWeapon <- function(weapon)
{
	local YourGunWasPUNCHEDBySaxtonHale = null
	local wep_ID = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local DisableThis = null
	
//searches for the correct item based on parameter 'baseitem'...
	local baseitem = GTFW_FindEquipByStringOrID(weapon)
	if ( baseitem != null ) {
		DisableThis = baseitem.className
	} else {
		local baseitem = GTFW_FindEquipByStringOrID(wep_ID)
		if ( baseitem != null ) {
			DisableThis = baseitem.className
		}
	}
//cancels the operation if we don't have this weapon...
	if ( CheckIfEquipOnPlayer(DisableThis) ) {
		return null
	}
	
	local wep = null
	local LOOPCOUNT_MAX = 1
	
	if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
	{
		LOOPCOUNT_MAX = 4	//setting to 4 for multiple PDAs, InvisWatch, Spellbook etc
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
			if ( wep != null )
			{
				if ( FindEquipBySlot(wep) )
				{
					DisableThis = wep.GetClassname()
				}
				if ( wep.GetClassname() == DisableThis )
				{
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						DisableThis = wep.GetClassname().tostring()+"_disabled"
						
						wep.__KeyValueFromString("classname", wep.GetClassname().tostring()+"_disabled") //works but visually buggy
					//	wep.AddAttribute("disable weapon switch", 1, -1) //doesn't work??
						break
					}
				}
			}
		}
	}
	
// switches to another weapon if active one was disabled
	if ( this.GetActiveWeapon().GetClassname() == DisableThis )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
		// pass if our active weapon was not the disabled one, nor any misc weapon like a PDA or spellbook
			if ( wep != null && wep.GetClassname() != DisableThis && SearchMiscWeapons.find(wep.GetClassname()) < 0 )
			{
				NetProps.SetPropEntity(this, "m_hActiveWeapon", wep)
				YourGunWasPUNCHEDBySaxtonHale = wep
				break
			}
		}
	}
	return YourGunWasPUNCHEDBySaxtonHale
}


/* FUNCTION: Returns weapon from player as a handle.
	-> See top of script for more info
*/

::CTFPlayer.ReturnWeapon <- function(searched_weapon)
{
	local GetThis = searched_weapon
	local GetThisID = NetProps.GetPropInt(searched_weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local YourGunFoundBySaxtonHale = null
	//searches for the correct item based on parameter 'baseitem'...
	local baseitem = GTFW_FindEquipByStringOrID(GetThis)
	if ( baseitem != null ) {
		GetThis = baseitem.className
	} else {
		local baseitem = GTFW_FindEquipByStringOrID(GetThisID)
		if ( baseitem != null ) {
			GetThis = baseitem.className
		}
	}
//cancels the operation if we don't have this weapon...
	if ( CheckIfEquipOnPlayer(GetThis) ) {
		return null
	}

	
	local LOOPCOUNT_MAX = 1
	
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
			if ( wep != null )
			{
				if ( FindEquipBySlot(wep) )
				{
					GetThis = wep.GetClassname()
				}
				if ( wep.GetClassname() == GetThis )
				{
					YourGunFoundBySaxtonHale = wep
					break
				}
			}
		}
	}
	return YourGunFoundBySaxtonHale
}


/*Notes (UNFINISHED)
main_viewmodel (tf_viewmodel) needs to be the class arms model for bonemerging with weapon_arms. Cannot be unparented without complication. Cannot arbitrarily set "m_hWeapon" (netprop for current weapon entity seen by player).
weapon_arms (tf_wearable_vm) are the new class' hands that bonemerge with main_viewmodel.
baseitem (the weapon entity) displays the thirdperson model but the model it uses is the class arms.
When baseitem is unparented, it unparents the third person model from the player. However, doing this makes the weapon stay visible with taunts. (A think script fixes this)
baseitem's viewmodel animation sequences are taken from main_viewmodel.
baseitem's modelindex are the /class_arms/. Changing this changes what sequences are read by main_viewmodel.
baseitem netprop "m_iViewModelIndex" is viewmodel index. Cannot change arbitrarily.
baseitem netprop "m_iWorldModelIndex" is thirdperson index. Cannot change arbitrarily.

//How the weapon's VIEWMODEL changes visibility depending on when player is holding the weapon:
new_weapon_viewmodel (tf_wearable_vm) is another entity model parented to the existing viewmodel.
new_weapon_viewmodel links itself to the baseitem (w/ netprop "m_hWeaponAssociatedWith")
baseitem links itself to the new_weapon_viewmodel (w/ netprop "m_hExtraWearableViewModel")

//How the weapon's THIRDPERSON/WORLD MODEL changes visibility depending on when player is holding the weapon:
new_weapon_thirdperson (tf_wearable) is another entity model parented on the player.
new_weapon_thirdperson links itself to the baseitem (w/ netprop "m_hWeaponAssociatedWith")
baseitem links itself to the new_weapon_thirdperson (w/ netprop "m_hExtraWearable")

//viewmodel hierarchy:
main_viewmodel sequences [become]-> baseitem's sequences
main_viewmodel (tf_viewmodel) sequences are used by weapon_arms (tf_wearable_vm) for bonemerging
weapon_arms bonemerge with baseitem to complete the effect that class is holding the baseitem
baseitem's sequences MUST MATCH main_viewmodel's

//If you intend to update the weapon's animation sequences:
Can set Sequence of weapon via main_viewmodel. Example for Scout's Bat:
main_viewmodel.SetSequence(main_viewmodel.LookupSequence("b_draw") )

You can change which sequence list by changing the model itself to a different class arms model.
change the main_viewmodel using main_viewmodel.SetModel() to change to new set of class arms
change the baseitem's modelindex (which are class_arms) to the animations you want to use for the new weapon
*/


::CTFPlayer.CreateCustomWeaponModel <- function(wearabletype, baseitem, weapon_model)
{
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")

	if ( IsModelPrecached( weapon_model.tostring() ) )
	{
		weapon_model = GetModelIndex(weapon_model)
	}
	if ( this.HasGunslinger() && baseitem == null || baseitem == main_viewmodel ) {
		weapon_model = GetModelIndex( GTFW_MODEL_ARMS[10] )
	}
	
	local wearable_handle = null
	
// bool. If true, make a tf_wearable. If false, tf_wearable_vm.
	if (wearabletype)
	{
		wearable_handle = Entities.CreateByClassname("tf_wearable")
	}
	else
	{
		wearable_handle = Entities.CreateByClassname("tf_wearable_vm")
	}
	
	
// our properties. Taken from source code for Super Zombie Fortress + SCP Secret Fortress
	wearable_handle.SetAbsOrigin(this.GetLocalOrigin())
	wearable_handle.SetAbsAngles(this.GetLocalAngles())
	NetProps.SetPropInt(wearable_handle, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropEntity(wearable_handle, "m_hOwnerEntity", this)
	NetProps.SetPropInt(wearable_handle, "m_iTeamNum", this.GetTeam())
	NetProps.SetPropInt(wearable_handle, "m_Collision.m_usSolidFlags", Constants.SolidFlags.FSOLID_NOT_SOLID)
	NetProps.SetPropInt(wearable_handle, "m_CollisionGroup", 11)
	NetProps.SetPropInt(wearable_handle, "m_fEffects", 129)
	
	NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_iEntityQuality", 0)
	NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_iEntityLevel", 1)
	NetProps.SetPropInt(wearable_handle, "m_AttributeManager.m_Item.m_bInitialized", 1)
	
	NetProps.SetPropInt(wearable_handle, "m_nModelIndex", weapon_model)

//for hands
	if ( baseitem == null || baseitem == main_viewmodel)
	{
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
	}
// for viewmodel
	else if ( baseitem != null && wearable_handle.GetClassname() == "tf_wearable_vm" )
	{
		NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
		NetProps.SetPropEntity(baseitem, "m_hExtraWearableViewModel", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
	}
//for world model (weapons only)
	else if ( baseitem != null && wearable_handle.GetClassname() == "tf_wearable" )
	{
	//	NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
	//	NetProps.SetPropEntity(baseitem, "m_hExtraWearable", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, this, wearable_handle)
		wearable_handle.EnableDraw()
		
		PlayerLoadoutGlobal_CustomWeaponModels_TP[this][baseitem.GetClassname()] <- wearable_handle

	//	DoEntFire("!self", "AddOutput", "rendermode 1", 0, this, wearable_handle)
		//DoEntFire("!self", "Color", "0 0 255", 0, this, wearable_handle)//colored weapons!
	//	DoEntFire("!self", "Clearparent", "", 0, null, baseitem)	//Disables the baseitem from appearing in thirdperson. However, various bugs like weapon appearing while taunting, or firing effecting origin messing up...
	}
// we name this for easy finding+cleanup
	wearable_handle.__KeyValueFromString("targetname", "tf_wearable_vscript")

	return wearable_handle
}


/* FUNCTION: Sets a custom weapon model (!!!) on a player's weapon
 NOTE: Watch your map's ent count! It spawns 1 entity for the class_arms (tf_wearable_vm). It spawns 2 additional entities--one for the thirdperson model (tf_wearable), and another for firstperson (tf_wearable_vm)
 NOTE: Each weapon uses a think script to fix the weapon appearing when needed, and being invisible when not (i.e. taunting, not holding)
 baseitem = Accepts handles, weapon's entity classnames, weapons by slot ("primary", "secondary", "melee", "slot4", "slot5", "slot6", "slot7", except "misc"), and weapon string name (i.e. "Crossbow")
 custom_weapon_model = your new model over the old one. Appears in thirdperson as well as firstperson.
 OPTIONAL: custom_arms_model = custom first person animations.
 OPTIONAL: custom_draw_seq = Weapon's deploy sequence. Ties with above, required when using another custom arms model.

	// USE: handle.SetCustomWeapon("tf_weapon_knife", "models/weapons/c_models/spy_sword.mdl", "models/weapons/c_models/c_scout_arms.mdl", null)
	// USE: handle.SetCustomWeapon("primary", models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null, null)
*/

::CTFPlayer.SetCustomWeapon <- function(baseitem, custom_weapon_model, custom_arms_model)
{
	local CUSTOM_WEAPON = baseitem
	local ItemID = NetProps.GetPropInt(baseitem, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local Slot	= null
	local draw_seq	= null
//searches for the correct item based on parameter 'baseitem'...
	local baseitem = GTFW_FindEquipByStringOrID(baseitem)
	
	if ( baseitem != null ) {
		CUSTOM_WEAPON = baseitem.className
		ItemID = baseitem.itemID
		Slot = baseitem.slot
		draw_seq = baseitem.draw_seq
	} else {
		local baseitem = GTFW_FindEquipByStringOrID(ItemID)
		if ( baseitem != null ) {
			CUSTOM_WEAPON = baseitem.className
			ItemID = baseitem.itemID
			Slot = baseitem.slot
			draw_seq = baseitem.draw_seq
		}
	}
//cancels the operation if we don't have this weapon...
	if ( CheckIfEquipOnPlayer(CUSTOM_WEAPON) ) {
		return null
	}
	
	local wep = null
// Checks if our weapon is on the list of all weapons. If yes, search classname and turn it into a handle.
// This allows us to use classnames as a parameter.
	if ( SearchBySlotsParameters.find(CUSTOM_WEAPON) != null )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
			if ( wep != null && FindEquipBySlot(wep) )
			{
				CUSTOM_WEAPON = wep
				break
			}
		}
	}
	else if ( SearchAllWeapons.find(CUSTOM_WEAPON) != null )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)

			if ( wep != null && wep.GetClassname() == CUSTOM_WEAPON )
			{
				CUSTOM_WEAPON = wep
				break
			}
		}
	}
	
	local CUSTOM_WEAPON_ID = NetProps.GetPropInt(CUSTOM_WEAPON, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	
	if ( CUSTOM_WEAPON_ID == ItemID )
	{
	/*	local wearable = custom_extra_wearable
		if ( wearable != null ) {
			this.CreateCustomWeaponModel(true, this, custom_extra_wearable)	// creates thirdperson/world model for wearables, parents and does all that stuff
		}
	*/
				
		NetProps.SetPropInt(CUSTOM_WEAPON, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)	//marks our weapon as custom
		this.UpdateArms(CUSTOM_WEAPON, custom_weapon_model, custom_arms_model, draw_seq)
	}
	else
	{
		CUSTOM_WEAPON = null
	}
	
//returns handle back to script for adding new attributes
	return CUSTOM_WEAPON
}


/*

Dev Notes
 - "m_bOnlyIterateItemViewAttributes" is used to mark if an item is custom. It's set to 1 via SetCustomWeapon.
 - "m_bValidatedAttachedEntity" is used for classes that have unintended weapons. It's set to 1 via AddWeapon.
FIXME: Does not accout for weapons like mediguns, banners, shields, etc that add an extra wearable, so they aren't added to the player
NOTE: tf_weapon_builder lets you build on any class that has it
FIXME: tf_weapon_builder doesn't let you build sentries for some reason (even minisentries), but it does let you build dispensers/teleporters
TODO: Consolidate think scripts from each weapon and put it on viewmodel (somehow)
DONE: Add think scripts for all that can take them.
DONE: Add more support for weapons with unique animations (like Kunai, Southern Hospitality, etc)
DONE: Remove "tf_weapon_" prefix from entities for easier computation (from TF_WEAPONS function at least)
DONE: Add class for all weapons containing various parameters (itemID, draw anim, primaryammo, secondaryammo, etc)
DONE: Add full names of all weapons (i.e. "Brass Beast")
DONE: Add feature for "GiveWeapon" to replace weapon if it fills a slot with another weapon in it. (It's now a cvar)
TODO: ReturnWeaponSlot
FIXME: Find a way to add/detect wearables like demoshield, booties, razorback, etc
DONE: Grab active weapon and switch it. If slot exists, just switch to the new weapon
FIXME: Fix crit boosts' colors
TODO: Giving class with passive items (Targe, Razorback, etc) need extra check when deleting secondaries because they're not in m_hMyWeapons
FIXME: Update pistols and shotguns to give correct viewmodels (BUG: Scout can get Engineer's pistol)
TODO: Fix dropped weapons breaking the script
TODO: Add exceptions/checks for shotguns and pistols, katana, multiclass etc.
DONE: m_bValidatedAttachedEntity = weapon on unintended class
TODO: Keep weapons on resupply
FIXME: Fix arms not updating when touching resupply if you have an unintended weapon
DONE: Thirdperson weapon model visibility bugs for custom weapons
TODO: Extra wearable on SetCustomWeapon
TODO: Search excemptions for custom weapons (so you can't delete the custom one if it uses the base of another)
TODO: ReactivateWeapon to fix disarmed weapons
TODO: Custom stats table auto-applied to custom weapons, based on a parameter set by SetCustomWeapon.
TODO: Add DeleteWeaponEx for searching all ents + ID value.
TODO: Add custom weapon support.

*/
