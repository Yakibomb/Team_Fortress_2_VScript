-> OBSOLETE!
	Please use GIVE_TF_WEAPON.nut instead, found here:
	https://github.com/Yakibomb/Team_Fortress_2_VScript/blob/main/give_tf_weapon.nut
	https://github.com/Yakibomb/Team_Fortress_2_VScript/blob/main/give_tf_weapon_all.nut

/*vScript "giveweapon" framework, by Yaki
Special thanks ficool2 (found netprops and made first weapon giving function, AddWeapon)
Special thanks Super Zombie Fortress + SCP Secret Fortress for releasing source code (taught me what netprops were needed for custom viewmodels)

FIXME: Does not accout for weapons like mediguns, banners, shields, etc that add an extra wearable, so they aren't added to the player
NOTE: tf_weapon_builder lets you build on any class that has it
FIXME: tf_weapon_builder doesn't let you build sentries for some reason (even minisentries), but it does let you build dispensers/teleporters
TODO: Consolidate think scripts from each weapon and put it on viewmodel (somehow)
TODO: Add think scripts for all that can take them.
TODO: Add more support for weapons with unique animations (like Kunai, Southern Hospitality, etc)

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
		NOTE: Cannot use more than two weapons in a slot, unless using "hud_fastswitch 0".
	CTFPlayer.DeleteWeapon(weapon, itemID)
		Deletes a weapon from chosen player's inventory.
	CTFPlayer.GiveWeapon(weapon, itemID)
		Gives you a weapon. Any weapon, as long as the entity and ID match from items_game.txt.
	CTFPlayer.DisableWeapon(weapon, itemID)
		Makes a weapon non-functional on chosen player, meaning they can't switch to nor use it.
	CTFPlayer.ReturnWeapon(weapon, itemID)
		Searches weapon on player and returns a handle.
	CTFPlayer.SetCustomWeapon(baseitem, itemID, custom_weapon_model, custom_arms_model, custom_arms_model_draw_seq)
		MAKES YOU A NEW CUSTOM WEAPON! Does not include stats.
			
PRIVATE OPERATIONS
 Functions used only in this file. Not recommended unless you know what you're doing.
	CTFPlayer.AddWeapon(classname, slot, itemindex, useviewmodelfix)
		Use if you want a specific wearable or arms on a class.
	CTFPlayer.UpdateArms(weapon, useviewmodelfix, weapon_model, arms_model, arms_draw_seq)
		Updates the weapon's arm models
			Adds a think script to them if "useviewmodelfix" set to true.
			Optional params: arms_model, arms_draw_seq
	CTFPlayer.CreateCustomWeaponModel(wearabletype, wearable_handle, baseitem, weapon_model)
		Multiple functions.
			wearabletype = bool, true for making tf_wearable, false for making tf_wearable_vm
			wearable_handle = handle. Must be unique. Handle must start null.
			baseitem = your base item's handle. Accepts null or main_viewmodel handle for making class arms only.
			weapon_model = model.mdl

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
			OPTIONAL: custom_arms_model_draw_seq = Weapon's deploy sequence. Ties with above, required when using another custom arms model.
		
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
	CTFPlayer.SetCustomWeapon(baseitem, itemID, custom_weapon_model, custom_arms_model, custom_arms_model_draw_seq)
		USE: handle.SetCustomWeapon("tf_weapon_knife", 4, "models/weapons/c_models/spy_sword.mdl", "models/weapons/c_models/c_scout_arms.mdl", "b_draw")
			replaces stock knife with a custom spy sword, using Scout's bat animations.
		USE: handle.SetCustomWeapon("primary", -1, models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null, null)
			replaces all primaries with "c_demo_cannon.mdl"*/

const GLOBAL_WEAPON_COUNT = 10

enum SolidFlags
{
	FSOLID_CUSTOMRAYTEST		= 1,
	FSOLID_CUSTOMBOXTEST		= 2,
	FSOLID_NOT_SOLID			= 4,
	FSOLID_TRIGGER				= 8,
}

TF_GIVEWEAPON_MODEL_ARMS <-
[
	"models/weapons/c_models/c_medic_arms.mdl",	//DUMMY
	"models/weapons/c_models/c_scout_arms.mdl",
	"models/weapons/c_models/c_sniper_arms.mdl",
	"models/weapons/c_models/c_soldier_arms.mdl",
	"models/weapons/c_models/c_demo_arms.mdl",
	"models/weapons/c_models/c_medic_arms.mdl",
	"models/weapons/c_models/c_heavy_arms.mdl",
	"models/weapons/c_models/c_pyro_arms.mdl",
	"models/weapons/c_models/c_spy_arms.mdl",
	"models/weapons/c_models/c_engineer_arms.mdl",
	"models/weapons/c_models/c_medic_arms.mdl",	//CIVILIAN
]

::TF_GIVEWEAPON_CLASS <-
[
	0,	//DUMMY
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
	"DUMMY",
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

::GiveWeapon_TFClass_DrawAnims <-
{
	PYRO =
	{
		tf_weapon_flamethrower = "ft_draw"
	}
	HEAVY = 
	{
		tf_weapon_minigun	= "m_draw"
	}
	MEDIC =
	{
		tf_weapon_crossbow	= "sg_draw",
		tf_weapon_syringegun_medic	= "sg_draw",
		tf_weapon_medigun	= "draw",
	}
	SPY =
	{
		tf_weapon_revolver	= "draw",
		tf_weapon_builder	= "c_sapper_draw",
		tf_weapon_sapper	= "c_sapper_draw",
		tf_weapon_knife		= "knife_draw",
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

::SearchAllWeaponsArray <-
[
	1,	//"tf_weapon_bat"
	1,	//"tf_weapon_bat_fish"
	1,	//"tf_weapon_bat_giftwrap"
	1,	//"tf_weapon_bat_wood"
	5,	//"tf_weapon_bonesaw"
	4,	//"tf_weapon_bottle"
	7,	//"tf_weapon_breakable_sign"
	3,	//"tf_weapon_buff_item"
	0,	//"tf_weapon_builder"		// Uses 0 for multiclass
	4,	//"tf_weapon_cannon"
	2,	//"tf_weapon_charged_smg"
	1,	//"tf_weapon_cleaver"
	2,	//"tf_weapon_club"
	2,	//"tf_weapon_compound_bow"
	5,	//"tf_weapon_crossbow"
	9,	//"tf_weapon_drg_pomson"
	7,	//"tf_weapon_fireaxe"
	6,	//"tf_weapon_fists"
	7,	//"tf_weapon_flamethrower"
	7,	//"tf_weapon_flaregun"
	7,	//"tf_weapon_flaregun_revenge"
	0,	//"tf_weapon_grapplinghook"		// Uses 0 for multiclass
	4,	//"tf_weapon_grenadelauncher"
	1,	//"tf_weapon_handgun_scout_primary"
	1,	//"tf_weapon_handgun_scout_secondary"
	8,	//"tf_weapon_invis"
	2,	//"tf_weapon_jar"
	1,	//"tf_weapon_jar_milk"
	7,	//"tf_weapon_jar_gas"
	0,	//"tf_weapon_katana"		// Uses 0 for multiclass
	8,	//"tf_weapon_knife"
	9,	//"tf_weapon_laser_pointer"
	6,	//"tf_weapon_lunchbox"
	1,	//"tf_weapon_lunchbox_drink"
	9,	//"tf_weapon_mechanical_arm"
	5,	//"tf_weapon_medigun"
	6,	//"tf_weapon_minigun"
	0,	//"tf_weapon_parachute"		// Uses 0 for multiclass
	4,	//"tf_weapon_parachute_primary"
	3,	//"tf_weapon_parachute_secondary"
	3,	//"tf_weapon_particle_cannon"
	0,	//"tf_weapon_passtime_gun"		// Uses 0 for multiclass
	9,	//"tf_weapon_pda_engineer_build"
	9,	//"tf_weapon_pda_engineer_destroy"
	8,	//"tf_weapon_pda_spy"
	1,	//"tf_weapon_pep_brawler_blaster"
	4,	//"tf_weapon_pipebomblauncher"
	9,	//"tf_weapon_pistol"
	1,	//"tf_weapon_pistol_scout"
	3,	//"tf_weapon_raygun"
	8,	//"tf_weapon_revolver"
	9,	//"tf_weapon_robot_arm"
	3,	//"tf_weapon_rocketlauncher"
	3,	//"tf_weapon_rocketlauncher_airstrike"
	3,	//"tf_weapon_rocketlauncher_directhit"
	7,	//"tf_weapon_rocketlauncher_fireball"
	7,	//"tf_weapon_rocketpack"
	8,	//"tf_weapon_sapper"
	1,	//"tf_weapon_scattergun"
	9,	//"tf_weapon_sentry_revenge"
	6,	//"tf_weapon_shotgun_hwg"
	9,	//"tf_weapon_shotgun_primary"
	7,	//"tf_weapon_shotgun_pyro"
	9,	//"tf_weapon_shotgun_building_rescue"
	3,	//"tf_weapon_shotgun_soldier"
	3,	//"tf_weapon_shovel"
	7,	//"tf_weapon_slap"
	2,	//"tf_weapon_smg"
	2,	//"tf_weapon_sniperrifle"
	2,	//"tf_weapon_sniperrifle_classic"
	2,	//"tf_weapon_sniperrifle_decap"
	1,	//"tf_weapon_soda_popper"
	0,	//"tf_weapon_spellbook"		// Uses 0 for multiclass
	4,	//"tf_weapon_stickbomb"
	4,	//"tf_weapon_sword"
	5,	//"tf_weapon_syringegun_medic"
	9,	//"tf_weapon_wrench"
]

class TF_WEAPON
{
	static prefix = "tf_weapon_" // static variables are read-only!
	
	// For instance-individual variables it's best to declare
	// them with anything and overwrite them on construction.
	name    = null
	itemID  = null
	drawnim	= null
	primMax = null
	secMax  = null
	
	// Containers and instances are not copied per instance, just
	// the reference. count[0] is the same for all of instances.
	count = [0]
	
	constructor(weapon, id, drawseq, prim, sec)
	{
		name    = prefix + weapon
		itemID  = id
		drawanim = drawseq
		primMax = prim
		secMax  = sec
		count[0]++
	}
	
	function GetEntities()
	{
		local list = []
		local wep = null
		while ( wep = Entities.FindByClassname(wep, name) )
		{
			list.append(wep)
		}
		return list
	}
	
	// ... more useful functions ...
}
// can access class variables and functions
// with awp.primMax, awp.GetEntities(), etc.

// FUNCTION: Used by AddWeapon(). Don't use on its own

::CTFPlayer.UpdateArms <- function(weapon, useviewmodelfix, weapon_model, arms_model, arms_draw_seq)
{
	if ( useviewmodelfix && weapon_model != null )
	{
		AddThinkToEnt(weapon, null)
		
		local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
		local main_viewmodel_class_arms = TF_GIVEWEAPON_MODEL_ARMS[this.GetPlayerClass()]
		local weapons_arms = SearchAllWeaponsArray[SearchAllWeapons.find(weapon.GetClassname())]
		local class_arms = TF_GIVEWEAPON_MODEL_ARMS[weapons_arms]
		local draw_seq = main_viewmodel.LookupSequence( GiveWeapon_TFClass_DrawAnims[TF_GIVEWEAPON_CLASS_BY_NAME[weapons_arms]][weapon.GetClassname()] )
		if ( arms_model != null )
		{
			main_viewmodel.SetModel( arms_model )
			class_arms = arms_model
			draw_seq = main_viewmodel.LookupSequence( arms_draw_seq )
		}
	
	// adds a class arms model if nothing has parented to the main_viewmodel
		if ( main_viewmodel.FirstMoveChild() == null )
		{
			this.CreateCustomWeaponModel(false, null, null, main_viewmodel_class_arms)	// creates class arms, parents and does all that stuff
			
			weapon.SetModel( class_arms )
	//updates class arms if not using new weapon's class arms
	// setting this all the time breaks deploy animations
			if ( this.GetPlayerClass() != weapons_arms )
			{
				main_viewmodel.SetModel( class_arms )
				local draw_seq = main_viewmodel.LookupSequence( GiveWeapon_TFClass_DrawAnims[TF_GIVEWEAPON_CLASS_BY_NAME[weapons_arms]][weapon.GetClassname()] )
			}
		}
		local NEW_WEAPON_VIEWMODEL = null
		this.CreateCustomWeaponModel(false, NEW_WEAPON_VIEWMODEL, weapon, weapon_model)	// creates viewmodel, parents and does all that stuff
		
		local NEW_WEAPON_THIRDPERSON = null
		this.CreateCustomWeaponModel(true, NEW_WEAPON_THIRDPERSON, weapon, weapon_model)	// creates third person world model, parents and does all that stuff

		if( weapon.ValidateScriptScope() )
		{
			const THINK_VMFIX_DELAY = 0
			local WEAPON_ACTIVE = this.GetActiveWeapon()
			if ( this.GetActiveWeapon() == weapon )
			{
				main_viewmodel.DisableDraw()		//makes weapon invisible
				main_viewmodel.SetModel( class_arms )
				main_viewmodel.SetSequence( draw_seq )
			}
			local entscriptname = "THINK_"+TF_GIVEWEAPON_CLASS_BY_NAME[this.GetPlayerClass()]+"_"+weapon.GetClassname().tostring()+"_VMFix"
			local player = this
			local entityscript = weapon.GetScriptScope()
			entityscript[entscriptname] <- function()
			{
				if ( player.InCond("TF_COND_TAUNTING") )
				{
					weapon.DisableDraw()		//makes thirdperson weapon invisible
					WEAPON_ACTIVE = null
				}
				if ( player.GetActiveWeapon() != WEAPON_ACTIVE && !player.InCond("TF_COND_TAUNTING"))
				{
					if ( player.GetActiveWeapon() == weapon )
					{
					//	printl("WEAPON ACTIVE "+weapon)
					//	printl( class_arms )
					//	printl ( GiveWeapon_TFClass_DrawAnims[TF_GIVEWEAPON_CLASS_BY_NAME[weapons_arms]][weapon.GetClassname()] )
						WEAPON_ACTIVE = weapon
						main_viewmodel.DisableDraw()		//makes firstperson weapon invisible
						main_viewmodel.SetModel( class_arms )
						main_viewmodel.SetSequence( draw_seq )
					}
					else if ( player.GetActiveWeapon() != weapon )
					{
						WEAPON_ACTIVE = null
					}
				}
				return 
			}
			AddThinkToEnt(weapon, entscriptname)
		}
	}
	else
	{
		weapon.SetModel( TF_GIVEWEAPON_MODEL_ARMS[this.GetPlayerClass()] )
	}
}


::CTFPlayer.AddWeapon <- function(classname, slot, itemindex, useviewmodelfix)
{
	local weapon = Entities.CreateByClassname(classname)

	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", itemindex)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityQuality", 0)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iEntityLevel", 1)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bInitialized", 1)
	weapon.SetAbsOrigin(Vector(0,0,0))
	weapon.SetAbsAngles(QAngle(0,0,0))
	
	Entities.DispatchSpawn(weapon)
	
	local solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags | SolidFlags.FSOLID_NOT_SOLID);
	
	NetProps.SetPropEntityArray(this, "m_hMyWeapons", weapon, slot)
	NetProps.SetPropInt(weapon, "m_iTeamNum", this.GetTeam())
	
	solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags & ~(SolidFlags.FSOLID_TRIGGER));
	
	DoEntFire("!self", "SetParent", "!activator", 0, this, weapon)
	NetProps.SetPropInt(weapon, "m_MoveType", 0)
	
	weapon.SetLocalOrigin(this.GetLocalOrigin())
	weapon.SetLocalAngles(this.GetLocalAngles())
	
	NetProps.SetPropInt(weapon, "m_bClientSideAnimation", 1)
	NetProps.SetPropInt(weapon, "m_fEffects", 129)
	
	NetProps.SetPropEntity(weapon, "m_iState", 0)
	NetProps.SetPropEntity(weapon, "m_hOwnerEntity", this)
	NetProps.SetPropEntity(weapon, "LocalActiveWeaponData.m_hOwner", this)
	NetProps.SetPropInt(weapon, "m_CollisionGroup", 11)
	
	local curTime = Time()
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextPrimaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextSecondaryAttack", curTime)
	NetProps.SetPropInt(weapon, "LocalActiveWeaponData.m_flTimeWeaponIdle", curTime)	//is an INTEGER when it says fl
	
	NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity", 3)
	
	local weapon_model = NetProps.GetPropInt(weapon, "m_iWorldModelIndex")
	
	this.UpdateArms(weapon, useviewmodelfix, weapon_model, null, null)

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
	return weapon
}

::CTFPlayer.GiveWeaponCleanup_post_inventory_application <- function()
{
	// Deletes any viewmodels that the script has created
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	if ( main_viewmodel != null && main_viewmodel.FirstMoveChild() != null )
	{
		main_viewmodel.FirstMoveChild().Destroy()
	}
	for (local i = 0; i < 5; i++)
	{
		local wearable = Entities.FindByClassnameWithin(this, "tf_wearable", this.GetLocalOrigin(), 64)

		if ( wearable != null && NetProps.GetPropEntity(wearable, "m_hOwnerEntity") )
		{
			wearable.Destroy()
		}
		else
		{
			break
		}
	}
	for (local i = 0; i < 5; i++)
	{
		local wearable = Entities.FindByClassnameWithin(this, "tf_wearable_vm", this.GetLocalOrigin(), 64)
		
		if ( wearable != null && NetProps.GetPropEntity(wearable, "m_hOwnerEntity") == this )
		{
			wearable.Destroy()
		}
		else
		{
			break
		}
	}
}


::CTFPlayer.GiveWeaponCleanup_player_death <- function()
{
	
//Deletes all viewmodels from the player
	local viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	viewmodel.Destroy()
	
// deletes all weapons on the player
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep != null )
		{
			wep.Destroy()
		}
	}
	for (local i = 0; i < 5; i++)
	{
		local wearable = Entities.FindByClassnameWithin(this, "tf_wearable", this.GetLocalOrigin(), 64)

		if ( wearable != null && NetProps.GetPropEntity(wearable, "m_hOwnerEntity") )
		{
			wearable.Destroy()
		}
		else
		{
			break
		}
	}
	for (local i = 0; i < 5; i++)
	{
		local wearable = Entities.FindByClassnameWithin(this, "tf_wearable_vm", this.GetLocalOrigin(), 64)
		
		if ( wearable != null && NetProps.GetPropEntity(wearable, "m_hOwnerEntity") == this )
		{
			wearable.Destroy()
		}
		else
		{
			break
		}
	}
}

// FUNCTION: Deletes a weapon equipped on player
// weapon = weapon classname (i.e. "tf_weapon_knife"). Also takes "Primary", "Secondary", "Melee", or "Misc"
// itemID = items_game.txt index

// USE: CTFPlayer.DeleteWeapon("tf_weapon_minigun", 15)	//deletes only stock minigun with matching ID#15
// USE: CTFPlayer.DeleteWeapon ("SECONDARY", -1)	//deletes all secondaries

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
					wep.Destroy()
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


// FUNCTION: Overwrites a weapon with another weapon
// CTFPlayer = handle for your player's entity
// searched_weapon = weapon classname to be replaced (i.e. "tf_weapon_wrench"). Also takes "Primary", "Secondary", "Melee", or "Misc"
// searched_itemID = items_game.txt index. Can take -1 if none exists.
// new_weapon = weapon classname to be equipped (i.e. "tf_weapon_knife")
// new_itemID = items_game.txt index

// USE: CTFPlayer.ReplaceWeapon("tf_weapon_wrench", -7, "tf_weapon_knife", 4)
// USE: CTFPlayer.ReplaceWeapon("melee", -1, "tf_weapon_robot_arm", 142)

::CTFPlayer.ReplaceWeapon <- function(searched_weapon, searched_itemID, new_weapon, new_itemID, useviewmodelfix)
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
					wep.Destroy()
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						YourNewGunSaxtonApproved = this.AddWeapon(new_weapon, i, new_itemID, useviewmodelfix)
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



// FUNCTION: Finds an empty weapon equipment slot and gives weapon to the player
// weapon = weapon classname (i.e. "tf_weapon_knife")
// itemID = items_game.txt index (i.e. 4)

// USE: CTFPlayer.GiveWeapon("tf_weapon_minigun", 15)

::CTFPlayer.GiveWeapon <- function(weapon, itemID, useviewmodelfix)
{
	local YourNewGunSaxtonApproved = null
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
		if ( wep == null )
		{
			YourNewGunSaxtonApproved = this.AddWeapon(weapon, i, itemID, useviewmodelfix)
			break
		}
	}
	return YourNewGunSaxtonApproved
}


// FUNCTION: Debug. Shows in console all equips on host of listen server.

// USE: CTFPlayer.CheckItems()

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
}

// FUNCTION: disables being able to switch to a weapon.
// weapon = weapon to disable
// itemID = items_game.txt item ID index. Can take -1 if there is none.
	
// USE: CTFPlayer.DisableWeapon("tf_weapon_medigun", 998) //Disable only Vaccinator
// USE: CTFPlayer.DisableWeapon("secondary", -1) //Disable any secondary

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


//Notes (UNFINISHED)
// main_viewmodel (tf_viewmodel) needs to be the class arms model for bonemerging with weapon_arms. Cannot be unparented without complication. Cannot arbitrarily set "m_hWeapon" (netprop for current weapon entity seen by player).
// weapon_arms (tf_wearable_vm) are the new class' hands that bonemerge with main_viewmodel.
// baseitem (the weapon entity) displays the thirdperson model but the model it uses is the class arms.
// When baseitem is unparented, it unparents the third person model from the player. However, doing this makes the weapon stay visible with taunts. (A think script fixes this)
// baseitem's viewmodel animation sequences are taken from main_viewmodel.
// baseitem's modelindex are the /class_arms/. Changing this changes what sequences are read by main_viewmodel.
// baseitem netprop "m_iViewModelIndex" is viewmodel index. Cannot change arbitrarily.
// baseitem netprop "m_iWorldModelIndex" is thirdperson index. Cannot change arbitrarily.

//How the weapon's VIEWMODEL changes visibility depending on when player is holding the weapon:
// new_weapon_viewmodel (tf_wearable_vm) is another entity model parented to the existing viewmodel.
// new_weapon_viewmodel links itself to the baseitem (w/ netprop "m_hWeaponAssociatedWith")
// baseitem links itself to the new_weapon_viewmodel (w/ netprop "m_hExtraWearableViewModel")

//How the weapon's THIRDPERSON/WORLD MODEL changes visibility depending on when player is holding the weapon:
// new_weapon_thirdperson (tf_wearable) is another entity model parented on the player.
// new_weapon_thirdperson links itself to the baseitem (w/ netprop "m_hWeaponAssociatedWith")
// baseitem links itself to the new_weapon_thirdperson (w/ netprop "m_hExtraWearable")

//viewmodel hierarchy:
// main_viewmodel sequences [become]-> baseitem's sequences
// main_viewmodel (tf_viewmodel) sequences are used by weapon_arms (tf_wearable_vm) for bonemerging
// weapon_arms bonemerge with baseitem to complete the effect that class is holding the baseitem
// baseitem's sequences MUST MATCH main_viewmodel's

//If you intend to update the weapon's animation sequences:
// Can set Sequence of weapon via main_viewmodel. Example for Scout's Bat:
// main_viewmodel.SetSequence(main_viewmodel.LookupSequence("b_draw") )

// You can change which sequence list by changing the model itself to a different class arms model.
// change the main_viewmodel using main_viewmodel.SetModel() to change to new set of class arms
// change the baseitem's modelindex (which are class_arms) to the animations you want to use for the new weapon


::CTFPlayer.CreateCustomWeaponModel <- function(wearabletype, wearable_handle, baseitem, weapon_model)
{
	if ( IsModelPrecached( weapon_model.tostring() ) )
	{
		weapon_model = GetModelIndex(weapon_model)
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
	NetProps.SetPropInt(wearable_handle, "m_Collision.m_usSolidFlags", SolidFlags.FSOLID_NOT_SOLID)
	NetProps.SetPropInt(wearable_handle, "m_CollisionGroup", 11)
	NetProps.SetPropInt(wearable_handle, "m_fEffects", 129)
	
	NetProps.SetPropInt(wearable_handle, "m_nModelIndex", weapon_model)
	
		
	if ( baseitem == null || baseitem == main_viewmodel)
	{
		wearable_handle.SetBodygroup(main_viewmodel.FindBodygroupByName("rightarm"), main_viewmodel.FindBodygroupByName("rightarm"))	//fixed bodygroup for Engineer+Gunslinger
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
	}
	else if ( baseitem != null && wearable_handle.GetClassname() == "tf_wearable_vm" )
	{
		NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
		NetProps.SetPropEntity(baseitem, "m_hExtraWearableViewModel", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, main_viewmodel, wearable_handle)
	}
	else if ( baseitem != null && wearable_handle.GetClassname() == "tf_wearable" )
	{
		NetProps.SetPropEntity(wearable_handle, "m_hWeaponAssociatedWith", baseitem)
		NetProps.SetPropEntity(baseitem, "m_hExtraWearable", wearable_handle)
		Entities.DispatchSpawn(wearable_handle)
		DoEntFire("!self", "SetParent", "!activator", 0, this, wearable_handle)
		DoEntFire("!self", "Clearparent", "", 0, null, baseitem)	//Disables the baseitem from appearing in thirdperson. However, weapon appears while taunting.
	}

	return wearable_handle
}


// FUNCTION: Sets a custom weapon model (!!!) on a player's weapon
// NOTE: Watch your map's ent count! It spawns 1 entity for the class_arms (tf_wearable_vm). It spawns 2 additional entities--one for the thirdperson model (tf_wearable), and another for firstperson (tf_wearable_vm)
// NOTE: Each weapon uses a think script to fix the weapon appearing when needed, and being invisible when not (i.e. taunting, not holding)
// baseitem = handle for the weapon. Accepts classnames. Accepts weapons by slot ("primary", "secondary", "melee", except "misc")
// itemID = OPTIONAL items_game.txt item ID index. Use if replacing a certain weapon. Use -1 to ignore this parameter.
// custom_weapon_model = your new model over the old one. Appears in thirdperson as well as firstperson.
// OPTIONAL: custom_arms_model = custom first person animations.
// OPTIONAL: custom_arms_model_draw_seq = Weapon's deploy sequence. Ties with above, required when using another custom arms model.

	// USE: handle.SetCustomWeapon("tf_weapon_knife", 4, "models/weapons/c_models/spy_sword.mdl", "models/weapons/c_models/c_scout_arms.mdl", "b_draw")
	// USE: handle.SetCustomWeapon("primary", -1, models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null, null)

::CTFPlayer.SetCustomWeapon <- function(baseitem, itemID, custom_weapon_model, custom_arms_model, custom_arms_model_draw_seq)
{
// Sets CUSTOM_WEAPON to use our base item if it's a handle
	local CUSTOM_WEAPON = baseitem
	local wep = null
// Checks if our weapon is on the list of all weapons. If yes, search classname and turn it into a handle.
// This allows us to use classnames as a parameter.
	if ( SearchBySlotsParameters.find(baseitem) != null )
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
	else if ( SearchAllWeapons.find(baseitem) != null )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
			if ( SearchAllWeapons.find(baseitem) != null )
			{
				CUSTOM_WEAPON = wep
				break
			}
		}
	}
// uses itemID to check if this is the right weapon
	local CUSTOM_WEAPON_ID = NetProps.GetPropInt(CUSTOM_WEAPON, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")

	if ( itemID == CUSTOM_WEAPON_ID )
	{
		this.UpdateArms(CUSTOM_WEAPON, true, custom_weapon_model, custom_arms_model, custom_arms_model_draw_seq)
	}
	else
	{
		CUSTOM_WEAPON = null
	}
	
//returns handle back to script for adding new attributes
	return CUSTOM_WEAPON
}
