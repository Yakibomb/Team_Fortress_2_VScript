
IncludeScript("GIVE_TF_WEAPON_ALL.nut")
PrecacheModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
PrecacheModel("models/weapons/w_models/w_rapier_spy/w_rapier.mdl")
PrecacheModel("models/weapons/w_models/w_scroll_engineer/w_scroll_build.mdl")
PrecacheModel("models/weapons/w_models/w_scroll_engineer/w_scroll_destroy.mdl")
PrecacheModel("models/weapons/c_models/c_medic_wood_dart_rifle/c_medic_wood_dart_rifle.mdl")
PrecacheModel("models/weapons/c_models/c_engineer_gunslinger.mdl")
enum GTFW_MODELS_CUSTOM_WEAPONS
{
	DEMO_BIGAXE		= "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl",
	SPY_RAPIER		= "models/weapons/w_models/w_rapier_spy/w_rapier.mdl",
	ENGI_SCROLL_BUILD = "models/weapons/w_models/w_scroll_engineer/w_scroll_build.mdl",
	ENGI_SCROLL_DESTROY = "models/weapons/w_models/w_scroll_engineer/w_scroll_destroy.mdl"
	SCOUT_DARTGUN	= "models/weapons/c_models/c_medic_wood_dart_rifle/c_medic_wood_dart_rifle.mdl"
}


SendToConsole("con_filter_enable 1")
SendToConsole("con_filter_text_out Blocking")
SendToConsole ("ent_fire tf_wearable* kill; clear;")
SendToConsole ("ent_fire tf_weapon_sword kill")
printl("Executing...GTFW!")

::logPass <- 0
function logpass(name)
{
	logPass++
	printl("Pass #"+logPass+" ["+name+"]")
}
::ME <- GetListenServerHost()

//"post_inventory_application" sent when a player gets a whole new set of items, aka touches a resupply locker / respawn cabinet or spawns in.
function OnGameEvent_post_inventory_application(params)
{
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params.userid)
		player.GiveWeaponCleanup()
		
		if ( player.GetPlayerClass() == 1 )
		{
			local melee = player.GiveWeapon("Crossbow")
			player.SetCustomWeapon("Crossbow", GTFW_MODELS_CUSTOM_WEAPONS.SCOUT_DARTGUN, GTFW_ARMS.MEDIC, "sg_draw" )
		}
		if ( player.GetPlayerClass() == 9 )
		{
		//	local melee = player.GiveWeapon("Eyelander")
		//	player.SetCustomWeapon(melee, -1, GTFW_MODELS_CUSTOM_WEAPONS.DEMO_BIGAXE, GTFW_ARMS.DEMO, "cm_draw" )
		//	player.SetCustomWeapon("Build PDA", GTFW_MODELS_CUSTOM_WEAPONS.ENGI_SCROLL_BUILD, null, null )
		//	player.SetCustomWeapon("Destroy PDA", GTFW_MODELS_CUSTOM_WEAPONS.ENGI_SCROLL_DESTROY, null, null )
		}
			player.GiveWeapon("Short Circuit")
			player.GiveWeapon("Gunslinger")
		player.AddThinkToViewModel()
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
		player.GiveWeaponCleanup()
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)
	
::CEconEntity.SetStat <- function(attr, stat)
{
	this.AddAttribute(attr, stat, -1)
}
/*vScript "GIVE_TF_WEAPON" framework for Team Fortress 2, by Yaki
Special thanks ficool2 for finding the netprops to make the first weapon giving function, AddWeapon().
Special thanks Mr.Burguers (TF2Maps) for being a wealth of knowledge, teaching me how to use vscripts n stuff
Special thanks devs of Super Zombie Fortress + SCP Secret Fortress for releasing their source code (taught me what netprops were needed for custom viewmodels)

FIXME: Does not accout for weapons like mediguns, banners, shields, etc that add an extra wearable, so they aren't added to the player
NOTE: tf_weapon_builder lets you build on any class that has it
FIXME: tf_weapon_builder doesn't let you build sentries for some reason (even minisentries), but it does let you build dispensers/teleporters

TODO: Consolidate think scripts from each weapon and put it on viewmodel (somehow)
WIP: Add think scripts for all that can take them.
WIP: Add more support for weapons with unique animations (like Kunai, Southern Hospitality, etc)
DONE: Remove "tf_weapon_" prefix from entities for easier computation (from TF_WEAPONS function at least)
WIP: Add class for all weapons containing various parameters (itemID, draw anim, primaryammo, secondaryammo, etc)
WIP: Add full names of all weapons (i.e. "The Brass Beast")
DONE: Add feature for "GiveWeapon" to replace weapon if it fills a slot with another weapon in it. (It's now a cvar)
TODO: ReturnWeaponSlot
TODO: Find a way to add wearables like demoshield, booties, etc
DONE: Grab active weapon and switch it. If slot exists, just switch to the new weapon
TODO: Fix crit boosts' colors
TODO: Giving class with passive items (Targe, Razorback, etc) need extra check when deleting secondaries because they're not in m_hMyWeapons

Notes to Users
 - Set CVAR_GTFW_* for easy tweaking of script.
 - "m_bOnlyIterateItemViewAttributes" is used to mark if an item is custom. It's set to 1 via SetCustomWeapon.
 - When using GiveWeapon, weapon strings for unlocks don't need "The " in them. (i.e. "The Sandvich" is invalid, but "Sandvich" is acceptable)

Functions to put in Your OnGameEvents
	CTFPlayer.GiveWeaponCleanup_post_inventory_application
		Clears custom equipped entities on resupply or respawn 
		NOTE: Place these inside your "OnGameEvent_post_inventory_application".
	
	CTFPlayer.GiveWeaponCleanup_player_death
		Clears equipped entities on death
		NOTE: Place these inside your "OnGameEvent_player_death".

PUBLIC OPERATIONS
 Made to make giving weapons, easy! Also supports custom weapons!
	CTFPlayer.CheckItems()
		Checks your current equipment. Spits out a list in chat with active weapon on top.
	CTFPlayer.ReplaceWeapon(searched_weapon, searched_itemID, new_weapon, new_itemID)
		Searches the chosen player's inventory for a weapon and replaces it.
		Returns new weapon as handle.
		NOTE: Cannot use more than two weapons in a slot, unless using "hud_fastswitch 0".
	CTFPlayer.DeleteWeapon(weapon, itemID)
		Deletes a weapon from chosen player's inventory.
	CTFPlayer.GiveWeapon(weapon, itemID)
		Gives you a weapon. Any weapon, as long as the entity and ID match from items_game.txt.
		Returns given weapon as handle.
	CTFPlayer.DisableWeapon(weapon, itemID)
		Makes a weapon non-functional on chosen player, meaning they can't switch to nor use it.
	CTFPlayer.ReturnWeapon(weapon, itemID)
		Searches weapon on player and returns as handle.
	CTFPlayer.SetCustomWeapon(baseitem, itemID, custom_weapon_model, custom_arms_model, custom_draw_seq)
		MAKES YOU A NEW CUSTOM WEAPON! Does not include stats.
		Returns handle of new custom weapon
			
PRIVATE OPERATIONS
 Functions used only in this file. Not recommended unless you know what you're doing.
	CTFPlayer.AddWeapon(classname, itemindex, slot)
		Use if you want a specific wearable or arms on a class.
	CTFPlayer.UpdateArms(weapon, useviewmodelfix, weapon_model, arms_model, arms_draw_seq)
		Updates the weapon's arm models
			Adds a think script to them if "useviewmodelfix" set to true.
			Optional params: arms_model, arms_draw_seq
	CTFPlayer.CreateCustomWeaponModel(wearabletype, baseitem, weapon_model)
		Multiple functions.
			wearabletype = bool, true for making tf_wearable, false for making tf_wearable_vm
			baseitem = your base item's handle. Accepts null or main_viewmodel handle for making class arms only.
			weapon_model = model.mdl
		Returns handle of the entity it creates (tf_wearable or tf_wearable_vm)

Notes
	CTFPlayer = handle ID for your player's entity
	The following list are acceptable parameters for searching for weapons*:
		(in quotes) "Primary", "Secondary", "Melee", or "Misc", in those terms or ALL CAPS (i.e. "PRIMARY") or no caps (i.e. "melee").
			"misc" = anything that isn't melee, secondary, or primary (like spellbooks, grappling hooks, PDAs, watches, etc)
		Handles (aka the weapon ID's serial number)
		Classnames of weapons (i.e. tf_weapon_wrench)
		*SetCustomWeapon "baseitem" parameter takes all those above, except "misc".
		*ReplaceWeapon's second weapon parameter also only takes Classnames.
	itemID accepts:
		ANY: Valid items_game.txt IDs are 0 and above
		ReplaceWeapon: Can use exemption values by making the number negative (i.e. Wrench is itemID 7. Setting it to -7 would pick all wrenches except stock)
		ReplaceWeapon TIP: Use -0.0 to exempt all but all but Scout's stock bat (tf_weapon_bat)
		ReplaceWeapon TIP: Use any negative that isn't tied to that weapon to grab all weapons of that entity type. (i.e. searching "tf_weapon_wrench, -0.0," would search for any wrench)
	SetCustomWeapon Notes
		Not tested completely. Please report any bugs to Yaki.
		Watch your map's ent count! It spawns 1 entity for the class_arms (tf_wearable_vm).It spawns 2 additional entities--one for the thirdperson model (tf_wearable), and another for firstperson (tf_wearable_vm)
		Each weapon uses a think script to fix the weapon appearing when needed, and being invisible when not (i.e. taunting, not holding)
			baseitem = handle for the weapon. Accepts classnames. Accepts weapons by slot ("primary", "secondary", "melee"). Does not accept "misc".
			itemID = OPTIONAL items_game.txt item ID index. Use if replacing a certain weapon.
			custom_weapon_model = your new model over the old one. Appears in thirdperson as well as firstperson.
			OPTIONAL: custom_arms_model = custom first person animations.
			OPTIONAL: custom_draw_seq = Weapon's deploy sequence. Ties with above, required when using another custom arms model.
		
Examples of Uses
	CTFPlayer.CheckItems()
		USE: In console, type "script CheckItems()" (without quotes)
	CTFPlayer.ReplaceWeapon(searched_weapon, searched_itemID, new_weapon, new_itemID)
		USE: handle.ReplaceWeapon("tf_weapon_wrench", -7, "tf_weapon_knife", 4)
			Replaces the wrench entity with the stock knife
		USE: handle.ReplaceWeapon("melee", -1, "tf_weapon_robot_arm", 142)
			Replaces any melee with the Gunslinger
		USE: handle.ReplaceWeapon("tf_weapon_wrench", -7, "tf_weapon_wrench", 7)
			Replaces any non-stock Wrench with the stock Wrench
	CTFPlayer.GiveWeapon(weapon, itemID)
		USE: handle.GiveWeapon("tf_weapon_minigun", 15)
			Gives player a minigun.
	CTFPlayer.DeleteWeapon(weapon, itemID)
		USE: handle.DeleteWeapon("tf_weapon_medigun", 29)
			Deletes only the stock medigun with this itemID (NOTE: There is a strange version with a different itemID)
		USE: handle.DeleteWeapon("misc", -1)
			Deletes all misc items (PDAs, watches, spellbooks, grappling hooks, etc)
	CTFPlayer.DisableWeapon(weapon, itemID)
		USE: CTFPlayer.DisableWeapon("tf_weapon_medigun", 998)
			Disable only Vaccinator
		USE: CTFPlayer.DisableWeapon("secondary", -1)
			Disable any secondary
		USE: CTFPlayer.DisableWeapon("tf_weapon_bottle", -1)
			Disables any tf_weapon_bottle entity
	CTFPlayer.SetCustomWeapon(baseitem, itemID, custom_weapon_model, custom_arms_model, custom_draw_seq)
		USE: handle.SetCustomWeapon("tf_weapon_knife", 4, "models/weapons/c_models/spy_sword.mdl", "models/weapons/c_models/c_scout_arms.mdl", "b_draw")
			replaces stock knife with a custom spy sword, using Scout's bat animations.
		USE: handle.SetCustomWeapon("primary", -1, models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null, null)
			replaces all primaries with "c_demo_cannon.mdl"*/

const GLOBAL_WEAPON_COUNT = 10

//vscript cvars. Adjust how you like, to customize the script easily.
::CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS <- true	//if true, overwrites current weapon in slot
::CVAR_GTFW_USE_VIEWMODEL_FIX <- true	//automatically fixes any and all viewmodel arms to match the class you're playing as.
::CVAR_GTFW_GIVEWEAPON_DROP_WEAPONS <- false		//drops your weapon in favor of the new one


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

GTFW_MODEL_ARMS <-
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

::GTFW_Saxxy <-
[
	"tf_weapon_fireaxe",	//MULTI-CLASS
	"tf_weapon_bat",	//SCOUT
	"tf_weapon_club",	//SNIPER
	"tf_weapon_shovel",	//SOLDIER
	"tf_weapon_bottle",	//DEMO
	"tf_weapon_bonesaw",	//MEDIC
	"tf_weapon_fireaxe",	//HEAVY
	"tf_weapon_fireaxe",	//PYRO
	"tf_weapon_knife",	//SPY
	"tf_weapon_wrench",	//ENGINEER
	"tf_weapon_fireaxe",	//CIVILIAN
]

::GTFW_TFClass_DrawAnims <-
{
	MULTICLASS = 
	{
		tf_weapon_spellbook = "spell_draw"
	}
	SCOUT =
	{
		tf_weapon_bat = "b_draw"
		tf_weapon_lunchbox_drink = "ed_draw"
	}
	SOLDIER =
	{
		tf_weapon_particle_cannon = "draw"
		tf_weapon_katana = "s_draw"
		tf_weapon_buff_item = "wh_draw"
	}
	PYRO =
	{
		tf_weapon_flamethrower = "ft_draw"
		tf_weapon_fireaxe = "fa_draw"
	}
	HEAVY = 
	{
		tf_weapon_minigun	= "m_draw"
		tf_weapon_fists		= "f_draw"
	}
	ENGINEER =
	{
		tf_weapon_wrench = "spk_draw"
	}
	MEDIC =
	{
		tf_weapon_crossbow	= "sg_draw",
		tf_weapon_syringegun_medic	= "sg_draw",
		tf_weapon_medigun	= "draw",
		tf_weapon_bonesaw	= "bs_draw",
	}
	SPY =
	{
		tf_weapon_revolver	= "draw",
		tf_weapon_builder	= "c_sapper_draw",
		tf_weapon_sapper	= "c_sapper_draw",
		tf_weapon_knife		= "knife_draw",
		tf_weapon_pda_spy	= "",
		tf_weapon_invis		= "offhand_draw",
	}
}

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

function GTFW_FindByClassname(baseitem) {
	foreach (exists in TF_WEAPONS_ALL) {
		if ( exists.className == baseitem ) {
			return exists
		}
	}
	return null
}


::FindByBaseItem <- function(baseitem)
{
	foreach (exists in TF_WEAPONS_ALL)
	{
		if ( exists.itemString == baseitem || exists.itemString2 == baseitem )
		{
			if ( exists.className == "tf_weapon_saxxy" ) {
				exists.className = GTFW_Saxxy[this.GetPlayerClass()]
			}
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
			return exists
		}
	}
}

// FUNCTION: Used to update viewmodel arms. Don't use on its own

::CTFPlayer.UpdateArms <- function(weapon, weapon_model, arms_model, draw_anim)
{
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	
// USE: Updates arms if the class holding it is the owner
// Checks if not a custom weapon, if weapon is from the class, then does *not* use special VM fix for it.
	if ( NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes") == 0 )
	{
		foreach (exists in TF_WEAPONS_ALL)
		{
			if ( exists.className == weapon.GetClassname() && this.GetPlayerClass() == exists.tf_class )
			{
				if ( exists.className == "tf_weapon_robot_arm" )
				{
					weapon.SetModel( GTFW_MODEL_ARMS[10] )	//Gunslinger arms
				}
				else { weapon.SetModel( GTFW_MODEL_ARMS[this.GetPlayerClass()] ) }
				return weapon
			}
		}
	}
	
// USE: This is the special VM fix.
// it creates class arms that bonemerge with VM, and adds the weapon in the VM as a tf_wearable_vm.
// It creates the world model, as well.
	local weapon_id = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local class_arms = null
	local is_tfclass = 0
	local Slot = null
	local draw_seq = null
	
	foreach (exists in TF_WEAPONS_ALL)
	{
		if ( exists.itemID == weapon_id || exists.itemID2 == weapon_id )
		{
			is_tfclass = exists.tf_class
			Slot = exists.slot
			draw_seq = exists.draw_seq
			break
		}
	}
	if ( weapon.GetClassname() != "tf_wearable" && weapon.GetClassname() != "tf_wearable_demoshield" ) {
		if ( CVAR_GTFW_USE_VIEWMODEL_FIX )
		{
			class_arms = GTFW_MODEL_ARMS[is_tfclass]
			
			if ( is_tfclass == 0 )
			{
				class_arms = GTFW_MODEL_ARMS[this.GetPlayerClass()]
			}
			else if ( is_tfclass == 9 && this.FindEquipGunslinger() )
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
		// adds a class arms model if nothing has parented to the main_viewmodel
		/*	if ( main_viewmodel.FirstMoveChild() == null )
			{
				this.CreateCustomWeaponModel(false, null, GTFW_MODEL_ARMS[this.GetPlayerClass()])	// creates player class' arms, parents and does all that stuff
				
				weapon.SetModel( class_arms )
			}*/
			if ( weapon_model != null && weapon_model != 0 )
			{
				this.CreateCustomWeaponModel(false, weapon, weapon_model)	// creates viewmodel, parents and does all that stuff

				this.CreateCustomWeaponModel(true, weapon, weapon_model)	// creates thirdperson/world model, parents and does all that stuff
			}
		}
	}

	return weapon
}

::DeepPrintTable <- function( debugTable, prefix = "" )
{
	if (prefix == "")
	{
		printl(prefix + debugTable)
		printl("{")
		prefix = "   "
	}
	foreach (idx, val in debugTable)
	{
		if (typeof(val) == "table")
		{
			printl( prefix + idx + " = \n" + prefix + "{")
			DeepPrintTable( val, prefix + "   " )
			printl(prefix + "}")
		}
		else if (typeof(val) == "string")
			printl(prefix + idx + "\t= \"" + val + "\"")
		else
			printl(prefix + idx + "\t= " + val)
	}
	if (prefix == "   ")
		printl("}")
}

::CTFPlayer.FindEquipGunslinger <- function()
{
	if ( this.GetPlayerClass() == 9 )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep.GetClassname() == "tf_weapon_robot_arm" || wepID == 142 )
			{
				return true
			}
		}
	}
	return false
}

::PlayerLoadoutGlobal_DrawSeq <- {}
::PlayerLoadoutGlobal_ClassArms <- {}
::PlayerLoadoutGlobal_BonemergedArms <- {}

PlayerLoadoutGlobal_DrawSeq.clear()
PlayerLoadoutGlobal_ClassArms.clear()
PlayerLoadoutGlobal_BonemergedArms.clear()
	
::CTFPlayer.AddThinkToViewModel <- function()
{
	if ( CVAR_GTFW_USE_VIEWMODEL_FIX == false) {
		return
	}
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	local wearable_handle = null
	
//	if ( main_viewmodel.FirstMoveChild() != null )
//	{
//		main_viewmodel.FirstMoveChild().Kill()
//	}
	::PlayerLoadoutGlobal_ClassArms[this] <- {}
	::PlayerLoadoutGlobal_DrawSeq[this] <- {}
	::PlayerLoadoutGlobal_BonemergedArms[this] <- {}
	
	// adds a class arms model if nothing has parented to the main_viewmodel
	local thes = Entities.FindByClassname(null, "tf_wearable_vm")
	
	if ( main_viewmodel.FirstMoveChild() == null )
	{
		logpass("asd")
		wearable_handle = this.CreateCustomWeaponModel(false, null, GTFW_MODEL_ARMS[this.GetPlayerClass()])	// creates player class' arms, parents and does all that stuff
	// PURPOSE: Gunslinger/Short Circuit Fix
	// Puts into a table "player = arms model" for easy tracking
		PlayerLoadoutGlobal_BonemergedArms[this] <- wearable_handle
	}
	local HasGunslinger = this.FindEquipGunslinger()
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
		
		if ( wep != null )
		{
			foreach (exists in TF_WEAPONS_ALL)
			{
				if ( exists.itemID == wepID || exists.itemID2 == wepID )
				{
					PlayerLoadoutGlobal_DrawSeq[this][wep] <- exists.draw_seq
					if ( HasGunslinger )
					{
						PlayerLoadoutGlobal_ClassArms[this][wep] <- GTFW_MODEL_ARMS[10]
						wep.SetModel( GTFW_MODEL_ARMS[10] )
					}
					else {
						PlayerLoadoutGlobal_ClassArms[this][wep] <- GTFW_MODEL_ARMS[exists.tf_class]
						wep.SetModel( GTFW_MODEL_ARMS[exists.tf_class] )
					}
					break
				}
			}
		}
	}
	
	if( main_viewmodel.ValidateScriptScope() )
	{
		local wep = null

		local player = this
		
		local entscriptname = "THINK_VM_FIX_"+this.tostring()
		
		const THINK_VMFIX_DELAY = 0
		
		local entityscript = main_viewmodel.GetScriptScope()
		entityscript[entscriptname] <- function()
		{
			if ( player.GetActiveWeapon() != wep && !player.InCond("TF_COND_TAUNTING") )
			{
				wep = player.GetActiveWeapon()
		
				printl("WEAPON ACTIVE "+wep)
				printl( PlayerLoadoutGlobal_ClassArms[player][wep] )
				printl( PlayerLoadoutGlobal_DrawSeq[player][wep] )
		
				
				if (NetProps.GetPropInt(player.GetActiveWeapon(), "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes"))
				{
					main_viewmodel.DisableDraw()		//makes firstperson weapon invisible
				}
			
				local bonemerged = PlayerLoadoutGlobal_BonemergedArms[player]
				
				local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")

				if ( wepID == 528 ) { // Short Circuit
					bonemerged.DisableDraw()
				}
				else
				{
					bonemerged.EnableDraw()
				} 
		
				main_viewmodel.SetModel( PlayerLoadoutGlobal_ClassArms[player][wep] )
				main_viewmodel.SetSequence( main_viewmodel.LookupSequence( PlayerLoadoutGlobal_DrawSeq[player][wep] ) )
			}
			return THINK_VMFIX_DELAY
		}
		AddThinkToEnt(main_viewmodel, entscriptname)
	}
}

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
	
	NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity", 3)
	
	weapon.SetAbsOrigin(Vector(0,0,0))
	weapon.SetAbsAngles(QAngle(0,0,0))
	
	Entities.DispatchSpawn(weapon)
	
	local solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags | Constants.SolidFlags.FSOLID_NOT_SOLID);
	
	solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags & ~(Constants.SolidFlags.FSOLID_TRIGGER));
	
	if ( classname != "tf_wearable_demoshield" || classname != "tf_wearable" )
	{
		NetProps.SetPropEntityArray(this, "m_hMyWeapons", weapon, slot)
	}
	weapon.SetLocalOrigin(this.GetLocalOrigin())
	weapon.SetLocalAngles(this.GetAbsAngles())
	DoEntFire("!self", "SetParent", "!activator", 0, this, weapon)
	NetProps.SetPropInt(weapon, "m_MoveType", 0)

//If added weapon is not owned by player's tfclass, mark it custom to fix VM arms
	foreach (exists in TF_WEAPONS_ALL)
	{
		if ( exists.className == classname && this.GetPlayerClass() != exists.tf_class)
		{
			NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)
			break
		}
	}
	
	local weapon_model = NetProps.GetPropInt(weapon, "m_iWorldModelIndex")

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
	if ( itemindex == 132 || itemindex == 482 || itemindex == 1082 || itemindex == 266 ) //eyelanders
	{
		weapon.AddAttribute("decapitate type", 1, -1)
		weapon.AddAttribute("crit mod disabled", 0, -1)
		weapon.AddAttribute("is_a_sword", 72, -1)
		weapon.AddAttribute("max health additive bonus", -25, -1)
	}

	return this.UpdateArms(weapon, weapon_model, null, null)
}

::CTFPlayer.GiveWeaponCleanup <- function()
{
	// Deletes any viewmodels that the script has created
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	if ( main_viewmodel != null && main_viewmodel.FirstMoveChild() != null )
	{
		main_viewmodel.FirstMoveChild().Kill()
	}
	for (local i = 0; i < 10; i++)
	{
		local wearable = Entities.FindByNameWithin(this, "tf_wearable_vscript", this.GetLocalOrigin(), 128)

		if ( wearable != null && NetProps.GetPropEntity(wearable, "m_hOwnerEntity") == this )
		{
			printl("Deleting wearable... "+wearable)
			wearable.Kill()
		}
		else
		{
			break
		}
	}
}


/*FUNCTION: Finds an empty weapon equipment slot and gives weapon to the player
 weapon = weapon classname (i.e. "tf_weapon_knife")
 itemID = items_game.txt index (i.e. 4)

 USE: handle.GiveWeapon(15) // spawns the stock minigun
 USE: handle.GiveWeapon("Eyelander")
*/

::CTFPlayer.GiveWeapon <- function(weapon)
{
	local YourNewGunSaxtonApproved = null
	local DeletedWeapon = null

//searches for the correct item based on parameter 'baseitem'...
	local baseitem = FindByBaseItem(weapon)
	
	local NewWeapon = baseitem.className
	local ItemID = baseitem.itemID
	local Slot = baseitem.slot
	
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
			NetProps.SetPropEntity(this, "m_hActiveWeapon", YourNewGunSaxtonApproved)
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
	this.AddThinkToViewModel()
	return YourNewGunSaxtonApproved
}

/*FUNCTION: Deletes a weapon equipped on player
 weapon = weapon classname (i.e. "tf_weapon_knife"). Also takes "Primary", "Secondary", "Melee", or "Misc"
 itemID = items_game.txt index

 USE: handle.DeleteWeapon("tf_weapon_minigun", 15)	//deletes only stock minigun with matching ID#15
 USE: handle.DeleteWeapon("SECONDARY", -1)	//deletes all secondaries
*/

::CTFPlayer.DeleteWeapon <- function(weapon, itemID)
{
	local DeleteThis = weapon
	local DeletedWeapon = null
	local wep = null
	local wep_itemID = -1
	
	local LOOPCOUNT_MAX = 1
	
	if ( this.GetPlayerClass() == 9 || this.GetPlayerClass() == 8 ) //Engineer and Spy ID#s
	{
		if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
		{
			LOOPCOUNT_MAX = 4	//setting to 3 for multiple PDAs, InvisWatch, Spellbook etc
		}
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null )
			{
				if ( weapon == "primary" || weapon == "PRIMARY" || weapon == "Primary" )
				{
					if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
					{
						DeleteThis = wep.GetClassname()
					}
				}
				else if ( weapon == "secondary" || weapon == "SECONDARY" || weapon == "Secondary" )
				{
					if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
					{
						DeleteThis = wep.GetClassname()
					}
				}
				else if ( weapon == "melee" || weapon == "MELEE" || weapon == "Melee" )
				{
					if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
					{
						DeleteThis = wep.GetClassname()
					}
				}
				else if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
				{
					if ( SearchMiscWeapons.find(wep.GetClassname()) != null )
					{
						DeleteThis = wep.GetClassname()
					}
				}
				if ( wep.GetClassname() == DeleteThis && itemID < 0 || wep_itemID == itemID)
				{
					DeletedWeapon = wep.entindex()
					wep.Kill()
					break
				}
			}
		}
	}
	
// switches to another weapon if active one was deleted
	if ( this.GetActiveWeapon().entindex() == DeletedWeapon )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
		// pass if our active weapon was not the deleted one, nor any misc weapon like a PDA or spellbook
			if ( wep != null && wep.GetClassname() != DeleteThis && SearchMiscWeapons.find(wep.GetClassname()) < 0 )
			{
				NetProps.SetPropEntity(this, "m_hActiveWeapon", wep)
				break
			}
		}
	}
}


/*FUNCTION: Overwrites a weapon with another weapon
 CTFPlayer = handle for your player's entity
 searched_weapon = weapon classname to be replaced (i.e. "tf_weapon_wrench"). Also takes "Primary", "Secondary", "Melee", or "Misc"
 searched_itemID = items_game.txt index. Can take -1 if none exists.
 new_weapon = weapon classname to be equipped (i.e. "tf_weapon_knife")
 new_itemID = items_game.txt index

 USE: CTFPlayer.ReplaceWeapon("tf_weapon_wrench", -7, "tf_weapon_knife", 4)
 USE: CTFPlayer.ReplaceWeapon("melee", -1, "tf_weapon_robot_arm", 142)
*/

::CTFPlayer.ReplaceWeapon <- function(searched_weapon, searched_itemID, new_weapon, new_itemID)
{
//putting "a" here so it doesn't error with nothing in array[0]
	local CheckIfAllButWeapon = split(searched_itemID.tostring()+"a",abs(searched_itemID).tostring())[0]
//a negative itemID is excluded in the search
	local ExcludeWeapon = false	//off by default
	if ( CheckIfAllButWeapon == "-" )	//if itemID is negative...
	{
		searched_itemID = abs(searched_itemID).tointeger()
		ExcludeWeapon = true
	}
	
	local ReplaceThis = searched_weapon
	local YourNewGunSaxtonApproved = null
	local DeletedWeapon = null
	local LOOPCOUNT_MAX = 1
	
	if ( this.GetPlayerClass() == 9 || this.GetPlayerClass() == 8 ) //Engineer and Spy ID#s
	{
		if ( searched_weapon == "misc" || searched_weapon == "MISC" || searched_weapon == "Misc" )
		{
			LOOPCOUNT_MAX = 4	//setting to 3 for multiple PDAs, InvisWatch, Spellbook etc
		}
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			local wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null )
			{
				if ( searched_weapon == "primary" || searched_weapon == "PRIMARY" || searched_weapon == "Primary" )
				{
					if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
					{
						ReplaceThis = wep.GetClassname()
					}
				}
				else if ( searched_weapon == "secondary" || searched_weapon == "SECONDARY" || searched_weapon == "Secondary" )
				{
					if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
					{
						ReplaceThis = wep.GetClassname()
					}
				}
				else if ( searched_weapon == "melee" || searched_weapon == "MELEE" || searched_weapon == "Melee" )
				{
					if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
					{
						ReplaceThis = wep.GetClassname()
					}
				}
				else if ( searched_weapon == "misc" || searched_weapon == "MISC" || searched_weapon == "Misc" )
				{
					if ( SearchMiscWeapons.find(wep.GetClassname()) != null )
					{
						ReplaceThis = wep.GetClassname()
					}
				}
				if ( ( wep.GetClassname() == ReplaceThis && ExcludeWeapon == false && wep_itemID == searched_itemID ) || ( wep.GetClassname() == ReplaceThis && ExcludeWeapon == true && wep_itemID != searched_itemID ) )
				{
					DeletedWeapon = wep.entindex()
					wep.Kill()
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						YourNewGunSaxtonApproved = this.AddWeapon(new_weapon, new_itemID, i)
						break
					}
				}
			}
		}
	}
	
// switches to another weapon if active one was deleted
	if ( this.GetActiveWeapon().entindex() == DeletedWeapon )
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
	return YourNewGunSaxtonApproved
}


// FUNCTION: Shows in console all equips on host of listen server.

// USE: CheckItems()

::CheckItems <- function()
{
	local ActiveWeapon = GetListenServerHost().GetActiveWeapon()
	local ActiveWeapon_itemID = NetProps.GetPropInt(ActiveWeapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
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
	Say(GetListenServerHost(), "Active "+slot+" ["+ActiveWeapon.GetClassname()+"] (ItemID = "+ActiveWeapon_itemID+")", false)
	
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
		}
	}
	for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_wea*"); )
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
}

/* FUNCTION: disables being able to switch to a weapon.
 weapon = weapon to disable
 itemID = items_game.txt item ID index. Can take -1 if there is none.
	
 USE: CTFPlayer.DisableWeapon("tf_weapon_medigun", 998) //Disable only Vaccinator
 USE: CTFPlayer.DisableWeapon("secondary", -1) //Disable any secondary
*/

::CTFPlayer.DisableWeapon <- function(weapon, itemID)
{
	local DisableThis = weapon
	local YourGunWasTarnishedBySaxtonHale = null
	local wep = null
	local wep_itemID = -1
	
	local LOOPCOUNT_MAX = 1
	
	if ( this.GetPlayerClass() == 9 || this.GetPlayerClass() == 8 ) //Engineer and Spy ID#s
	{
		if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
		{
			LOOPCOUNT_MAX = 4	//setting to 3 for multiple PDAs, InvisWatch, Spellbook etc
		}
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null )
			{
				if ( weapon == "primary" || weapon == "PRIMARY" || weapon == "Primary" )
				{
					if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
					{
						DisableThis = wep.GetClassname()
					}
				}
				else if ( weapon == "secondary" || weapon == "SECONDARY" || weapon == "Secondary" )
				{
					if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
					{
						DisableThis = wep.GetClassname()
					}
				}
				else if ( weapon == "melee" || weapon == "MELEE" || weapon == "Melee" )
				{
					if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
					{
						DisableThis = wep.GetClassname()
					}
				}
				else if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
				{
					if ( SearchMiscWeapons.find(wep.GetClassname()) != null )
					{
						DisableThis = wep.GetClassname()
					}
				}
				if ( wep.GetClassname() == DisableThis && itemID < 0 || wep_itemID == itemID)
				{
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						DisableThis = wep.GetClassname().tostring()+"_disabled"
						
						wep.__KeyValueFromString("classname", wep.GetClassname().tostring()+"_disabled")
						wep.AddAttribute("disable weapon switch", 1, -1)
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
				break
			}
		}
	}
	return YourGunWasTarnishedBySaxtonHale
}


// FUNCTION: Returns weapon from player as a handle.

::CTFPlayer.ReturnWeapon <- function(searched_weapon, searched_itemID)
{
//putting "a" here so it doesn't error with nothing in array[0]
	local CheckIfAllButWeapon = split(searched_itemID.tostring()+"a",abs(searched_itemID).tostring())[0]
//a negative itemID is excluded in the search
	local ExcludeWeapon = false	//off by default
	if ( CheckIfAllButWeapon == "-" )	//if itemID is negative...
	{
		searched_itemID = abs(searched_itemID).tointeger()
		ExcludeWeapon = true
	}
	
	local GetThis = searched_weapon
	local YourGunFoundBySaxtonHale = null
	local LOOPCOUNT_MAX = 1
	
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			local wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
			
			if ( wep != null )
			{
				if ( searched_weapon == "primary" || searched_weapon == "PRIMARY" || searched_weapon == "Primary" )
				{
					if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
					{
						GetThis = wep.GetClassname()
					}
				}
				else if ( searched_weapon == "secondary" || searched_weapon == "SECONDARY" || searched_weapon == "Secondary" )
				{
					if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
					{
						GetThis = wep.GetClassname()
					}
				}
				else if ( searched_weapon == "melee" || searched_weapon == "MELEE" || searched_weapon == "Melee" )
				{
					if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
					{
						GetThis = wep.GetClassname()
					}
				}
				if ( ( wep.GetClassname() == GetThis && ExcludeWeapon == false && wep_itemID == searched_itemID ) || ( wep.GetClassname() == GetThis && ExcludeWeapon == true && wep_itemID != searched_itemID ) )
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

	if ( IsModelPrecached( weapon_model.tostring() ) )
	{
		weapon_model = GetModelIndex(weapon_model)
	}
	local HasGunslinger = this.FindEquipGunslinger()
	if ( HasGunslinger && baseitem == null || baseitem == main_viewmodel ) {
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
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	
	wearable_handle.SetAbsOrigin(this.GetLocalOrigin())
	wearable_handle.SetAbsAngles(this.GetLocalAngles())
	NetProps.SetPropInt(wearable_handle, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropEntity(wearable_handle, "m_hOwnerEntity", this)
	NetProps.SetPropInt(wearable_handle, "m_iTeamNum", this.GetTeam())
	NetProps.SetPropInt(wearable_handle, "m_Collision.m_usSolidFlags", Constants.SolidFlags.FSOLID_NOT_SOLID)
	NetProps.SetPropInt(wearable_handle, "m_CollisionGroup", 11)
	NetProps.SetPropInt(wearable_handle, "m_fEffects", 129)
	
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
	//	DoEntFire("!self", "ClearParent", "", 0, null, wearable_handle)	//potential cleanup
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
	}
//for world model
	else if ( baseitem != null && wearable_handle.GetClassname() == "tf_wearable" )
	{
		NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
		NetProps.SetPropEntity(baseitem, "m_hExtraWearable", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
	//	DoEntFire("!self", "ClearParent", "", 0, null, wearable_handle) //potential cleanup
		DoEntFire("!self", "SetParent", "!activator", 0, this, wearable_handle)
		DoEntFire("!self", "AddOutput", "rendermode 1", 0, this, wearable_handle)
		//DoEntFire("!self", "Color", "0 0 255", 0, this, wearable_handle)//colored weapons!
	//	DoEntFire("!self", "Clearparent", "", 0, null, baseitem)	//Disables the baseitem from appearing in thirdperson. However, various bugs like weapon appearing while taunting, or firing effecting origin messing up...
	}
// we name this for easy finding+cleanup
	wearable_handle.__KeyValueFromString("targetname", "tf_wearable_vscript")
//not needed but here
	return wearable_handle
}


/* FUNCTION: Sets a custom weapon model (!!!) on a player's weapon
 NOTE: Watch your map's ent count! It spawns 1 entity for the class_arms (tf_wearable_vm). It spawns 2 additional entities--one for the thirdperson model (tf_wearable), and another for firstperson (tf_wearable_vm)
 NOTE: Each weapon uses a think script to fix the weapon appearing when needed, and being invisible when not (i.e. taunting, not holding)
 baseitem = handle for the weapon. Accepts classnames. Accepts weapons by slot ("primary", "secondary", "melee", except "misc")
 custom_weapon_model = your new model over the old one. Appears in thirdperson as well as firstperson.
 OPTIONAL: custom_arms_model = custom first person animations.
 OPTIONAL: custom_draw_seq = Weapon's deploy sequence. Ties with above, required when using another custom arms model.

	// USE: handle.SetCustomWeapon("tf_weapon_knife", 4, "models/weapons/c_models/spy_sword.mdl", "models/weapons/c_models/c_scout_arms.mdl", "b_draw")
	// USE: handle.SetCustomWeapon("primary", -1, models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null, null)
*/

::CTFPlayer.SetCustomWeapon <- function(baseitem, custom_weapon_model, custom_arms_model, custom_draw_seq)
{
	local CUSTOM_WEAPON = null
	local BySlot = baseitem
	local ItemID	= null
	local Slot	= null
//searches for the correct item based on parameter 'baseitem'...
	local baseitem = FindByBaseItem(baseitem)
	
	CUSTOM_WEAPON = baseitem.className
	ItemID = baseitem.itemID
	Slot = baseitem.slot
	
	local wep = null
// Checks if our weapon is on the list of all weapons. If yes, search classname and turn it into a handle.
// This allows us to use classnames as a parameter.
	if ( SearchBySlotsParameters.find(BySlot) != null )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
			if ( wep != null )
			{
				if ( baseitem == "primary" || baseitem == "PRIMARY" || baseitem == "Primary" )
				{
					if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
					{
						CUSTOM_WEAPON = wep
						break
					}
				}
				else if ( baseitem == "secondary" || baseitem == "SECONDARY" || baseitem == "Secondary" )
				{
					if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
					{
						CUSTOM_WEAPON = wep
						break
					}
				}
				else if ( baseitem == "melee" || baseitem == "MELEE" || baseitem == "Melee" )
				{
					if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
					{
						CUSTOM_WEAPON = wep
						break
					}
				}
			}
		}
	}
	else if ( SearchAllWeapons.find(baseitem.className) != null )
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
	
/* uses itemID to check if this is the right weapon//putting "a" here so it doesn't error with nothing in array[0]
	local CheckIfAllButWeapon = split(itemID.tostring()+"a",abs(itemID).tostring())[0]
//a negative itemID is excluded in the search
	local ExcludeWeapon = false	//off by default
	if ( CheckIfAllButWeapon == "-" )	//if itemID is negative...
	{
		itemID = abs(itemID).tointeger()
		ExcludeWeapon = true
	} */
	
	local CUSTOM_WEAPON_ID = NetProps.GetPropInt(CUSTOM_WEAPON, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")

	//if ( CUSTOM_WEAPON_ID == itemID ) || ( ExcludeWeapon == true && CUSTOM_WEAPON_ID != itemID ) )
	if ( CUSTOM_WEAPON_ID == baseitem.itemID )
	{
		NetProps.SetPropInt(CUSTOM_WEAPON, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)	//marks it as a custom weapon
		this.UpdateArms(CUSTOM_WEAPON, custom_weapon_model, custom_arms_model, custom_draw_seq)
	}
	else
	{
		CUSTOM_WEAPON = null
	}
	
//returns handle back to script for adding new attributes
	return CUSTOM_WEAPON
}
