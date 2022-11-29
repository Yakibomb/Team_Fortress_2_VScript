//NOTE: These events need to be in your game for this to work properly.
// However, there can only be one event listener stored total. Paste the the part in the "CTFPlayer.GTFW_Cleanup()" part in the beginning of each event.

//"player_death" event is sent when a player dies.
function OnGameEvent_player_death(params)
{
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params.userid)
		player.GTFW_Cleanup() //<-Add this to your own player_death event. It must be at the beginning!
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)
	
//"post_inventory_application" event is sent when a player gets a whole new set of items, aka touches a resupply locker / respawn cabinet or spawns in.
function OnGameEvent_post_inventory_application(params)
{
	if ("userid" in params)
	{
		local player = GetPlayerFromUserID(params.userid)
		player.GTFW_Cleanup()	//<-Add this to your own player_death event. It must be at the beginning!
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)
	
// The prior should be deleted if using those events already. //
// Include the rest of this script! //

IncludeScript("give_tf_weapon_all.nut")

//vscript cvars. Adjust how you like, to customize the script easily.
::CVAR_GTFW_GIVEWEAPON_REPLACE_WEAPONS <- true	//if true, overwrites current weapon in slot. NOTE: Cannot use more than two weapons in a slot, unless using "hud_fastswitch 0".
::CVAR_GTFW_USE_VIEWMODEL_FIX <- true	//automatically fixes any and all viewmodel arms to match the class you're playing as.
//::CVAR_GTFW_GIVEWEAPON_DROP_WEAPONS <- false		//Would drops your weapon in favor of the new one. Non-functional
//::CVAR_GTFW_USE_RESUPPLY_FIX	<- true		//Would fix resupply lockers destroying custom weapons. Non-functional

/*vScript "GIVE_TF_WEAPON" (originally giveweapon.nut) framework for Team Fortress 2, by Yaki
Special thanks ficool2 for finding the netprops to make the first weapon giving function, AddWeapon().
Special thanks Mr.Burguers (TF2Maps) for being a wealth of knowledge, teaching me how to use vscript
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
	CTFPlayer.EnableWeapon(weapon)
		- Enables a weapon if it was disabled by the prior command
	CTFPlayer.ReturnWeapon(weapon)
		- Searches weapon on player and returns as handle.
	CTFPlayer.SetCustomWeapon(baseitem, custom_weapon_model, custom_arms_model)
		- MAKES YOU A NEW CUSTOM WEAPON! Does not include stats.
		- Returns handle so you can add the stats yourself!
		
		
PRIVATE OPERATIONS
 Functions used only in this file. Don't use unless you know what you're doing.
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
		Returns handle of the entity it creates
	CTFPlayer.HasGunslinger()
		Checks if wearer is using the Gunslinger.
	CTFPlayer.AddThinkToViewModel()
		Updates the think script on tf_viewmodel. Branches from AddWeapon.
	CTFPlayer.SwitchToActive(NewGun)
		Forcefully switches to given weapon. If null, switches to first weapon it finds.
	CTFPlayer.GTFW_FindEquipByStringOrID(string_or_id)
		Find item by string or item ID
	GTFW_FindEquipBySlot(slot, weapon)
		Finds equip if it has parameters like "primary", "secondary", etc.
		Returns true if it found anything, or false if not
	CheckIfEquipOnPlayer(item_classname)
		Returns true if classname ent is on player, or false if not
	GTFW_WepFix(exists)
		Updates classnames for shotguns, pistols, saxxy, etc, before creating the weapon.
		Returns exists

Examples of Uses
	CheckItems()
		USE: In console, type "script CheckItems()" (without quotes)
	CTFPlayer.GiveWeapon(weapon_classname_or_id_or_string)
		USE: hPlayer.GiveWeapon("Minigun")
			Gives player the stock minigun.
		USE: hPlayer.GiveWeapon(132)
			Gives player the Eyelander
	CTFPlayer.GiveWeaponEx(searched_weapon, searched_itemID, new_weapon, new_itemID)
		USE: hPlayer.GiveWeaponEx("tf_weapon_wrench", -7, "tf_weapon_knife", 4)
			Replaces all non-stock wrenches with stock knife
		USE: hPlayer.GiveWeaponEx("melee", -1, "tf_weapon_robot_arm", 142)
			Replaces all melees with Gunslinger
		USE: hPlayer.GiveWeaponEx("Brass Beast", -1, "Buff Banner", -1)
			Replaces just the Brass Beast with the Buff Banner.
	CTFPlayer.DeleteWeapon(weapon_classname_or_id_or_string)
		USE: hPlayer.DeleteWeapon("Medigun")
			Deletes only the stock Medigun
		USE: hPlayer.DeleteWeapon("misc")
			Deletes all misc items (PDAs, watches, spellbooks, grappling hooks, etc)
		USE: hPlayer.DeleteWeapon(15)
			Deletes just the stock minigun with this ID
	CTFPlayer.DisableWeapon(weapon_classname_or_id_or_string)
		USE: hPlayer.DisableWeapon("Vaccinator")
			Disable only Vaccinator
		USE: hPlayer.DisableWeapon("secondary")
			Disable any secondary
		USE: hPlayer.DisableWeapon("tf_weapon_bottle")
			Disables any tf_weapon_bottle entity
		USE: hPlayer.DisableWeapon(7)
			Disables only the stock Wrench (item ID#7)
	CTFPlayer.SetCustomWeapon(baseitem, custom_weapon_model, custom_arms_model)
		USE: hPlayer.SetCustomWeapon("Knife", "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl", "models/weapons/c_models/c_scout_arms.mdl")
			Replaces stock knife with the Horseman's REAL Headtaker, using Scout's bat animations.
		USE: hPlayer.SetCustomWeapon("primary", models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null)
			replaces all primaries with "c_demo_cannon.mdl"
			
			
Notes/Clarification
	-> CTFPlayer = handle ID for your player's entity (aka player's serial number), called hPlayer all throughout examples.
	The following list are acceptable parameters for searching for weapons*:
		-> Handles (aka the weapon ID's serial number)
		-> Classnames of weapons (i.e. tf_weapon_wrench)
		(in quotes) "Primary", "Secondary", "Melee", "Misc", "Slot4", "Slot5", "Slot6", "Slot7"
			-> These terms can be lowercase or ALL CAPS (i.e. "PRIMARY", "melee").
			"misc" = anything that isn't melee, secondary, or primary (like spellbooks, grappling hooks, PDAs, watches, etc)
			"slot4" = Engineer's "Build PDA", Spy's "Disguise Kit PDA"
			"slot5" = Engineer's "Destroy PDA", Spy's watches
			"slot6" = Engineer toolbox, sapper (stock are both "tf_weapon_builder", sapper unlocks are "tf_weapon_sapper")
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

///-------------------------------------///
::PlayerLoadoutGlobal_DrawSeq <- {}
::PlayerLoadoutGlobal_ClassArms <- {}
::PlayerLoadoutGlobal_BonemergedArms <- {}
::PlayerLoadoutGlobal_CustomWeaponModels_VM <- {}
::PlayerLoadoutGlobal_CustomWeaponModels_TP <- {}

PrecacheModel("models/weapons/c_models/c_engineer_gunslinger.mdl")

const GLOBAL_WEAPON_COUNT = 10

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
	CIVILIAN=	"models/weapons/c_models/c_engineer_gunslinger.mdl",
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
	"models/weapons/c_models/c_engineer_gunslinger.mdl",	//CIVILIAN/Gunslinger
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

::CTFPlayer.GTFW_Cleanup <- function()
{
	// Deletes any viewmodels that the script has created
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	AddThinkToEnt(main_viewmodel, null)	//clears script if it was being used
	if ( main_viewmodel != null && main_viewmodel.FirstMoveChild() != null )
	{
		main_viewmodel.FirstMoveChild().Kill()
	}
	main_viewmodel.SetModelSimple( GTFW_MODEL_ARMS[this.GetPlayerClass()] )
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
//clears all custom weapons
	::PlayerLoadoutGlobal_CustomWeaponModels_VM[this] <- {}
	::PlayerLoadoutGlobal_CustomWeaponModels_TP[this] <- {}
	if ( this in PlayerLoadoutGlobal_BonemergedArms ) {
		delete PlayerLoadoutGlobal_BonemergedArms[this]
	}
//fixes dropped weapons
	for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_dropped_weapon"); )
	{
		if ( EntityOutputs.HasAction(weapon, "OnIgnite") == false )
		{
			EntityOutputs.AddOutput(weapon, "OnIgnite", "", "", "", 0.0, -1)	//used to flag this so it can never get OnCacheInteraction output twice
		//	printl(NetProps.GetPropInt(weapon, "m_Item.m_bOnlyIterateItemViewAttributes"))
		//	weapon.AddAttribute("texture_wear_default", 2, -1)
		//	weapon.SetModelSimple("models/weapons/w_models/w_rapier_spy/w_rapier.mdl")
		}
	}
	for (local test; test = Entities.FindByClassname(test, "tf_player_manager"); )
	{
		printl(ME)
		printl(NetProps.GetPropIntArray(test, "m_iUserID", 1))
	}
}

::CTFPlayer.GTFW_FindEquip <- function(weapon)
{
	local baseitem = this.GTFW_FindEquipByStringOrID(weapon)
	local ItemID = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	
	if ( baseitem != null ) {
		return baseitem
	} else if ( ItemID != null ) {
		baseitem = this.GTFW_FindEquipByStringOrID(ItemID)
		if ( baseitem != null ) {
			return baseitem
		}
	}
	return null
}

::CTFPlayer.GTFW_FindEquipByStringOrID <- function(baseitem)
{
	local truefalse = true
	foreach (exists in TF_WEAPONS_ALL)
	{
		if ( exists.itemString == baseitem || exists.itemString2 == baseitem )
		{
			exists = GTFW_WepFix(exists)
			
			truefalse = true
			return exists
		}
		else if ( exists.itemID == baseitem || exists.itemID2 == baseitem )
		{
			if ( exists.itemID == baseitem ) {
				exists.itemID = exists.itemID
			}
			else if ( exists.itemID2 == baseitem ) {
				exists.itemID = exists.itemID2
			}
			
			exists = GTFW_WepFix(exists)
			
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
				exists = GTFW_WepFix(exists)
				
				truefalse = false
				return exists
			}
			else if ( exists.itemID == baseitem )
			{
				exists = GTFW_WepFix(exists)

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
					
					exists = GTFW_WepFix(exists)

					return exists
				}
			}
		}
	}
}
::GTFW_WepFix <- function(exists)
{
	if ( exists.className == "tf_weapon_saxxy" ) {
		exists.className = GTFW_Saxxy[this.GetPlayerClass()]
	}
	else if ( exists.className == "tf_weapon_pistol" ) {
		if ( this.GetPlayerClass() == 1 ) {
			exists.className = "tf_weapon_pistol_scout"
			exists.draw_seq = "p_draw"
			exists.reserve		= 36
		}
		else {
			exists.draw_seq = "pstl_draw"
			exists.reserve		= 200
		}
	}
	else if ( exists.className == "tf_weapon_shotgun" ) {
		if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_ENGINEER ) {
			exists.className = "tf_weapon_shotgun_primary"
			exists.draw_seq = "fj_draw"
			exists.ammoType = TF_AMMO.PRIMARY
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_HEAVYWEAPONS ) {
			exists.className = "tf_weapon_shotgun_hwg"
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_SOLDIER ) {
			exists.className = "tf_weapon_shotgun_soldier"
		}
		else if ( this.GetPlayerClass() == Constants.ETFClass.TF_CLASS_PYRO ) {
			exists.className = "tf_weapon_shotgun_pyro"
		}
	}
	return exists
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

//FUNCTION: Don't use by itself. Used to find switch to a gun forcefully.
// -> See top of script for info
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
				return wep
			}
		}
	}
	else {
		NetProps.SetPropEntity(this, "m_hActiveWeapon", NewGun)
		NetProps.SetPropInt(NewGun, "m_iState", 2)
		local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
		main_viewmodel.EnableDraw()	//Fixes VM weapon not showing up when giving unintended weapon -> intended weapon to tfclass
		return NewGun
	}
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

// FUNCTION: Used to update viewmodel arms. Don't use on its own
::CTFPlayer.UpdateArms <- function(weapon, weapon_model, arms_model, draw_anim)
{
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	
// USE: Updates arms if the class holding it is the owner
// Checks if not a custom weapon, then does *not* use special VM fix for it.
	local is_custom = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes")
	local is_unintended = NetProps.GetPropInt(weapon, "m_bValidatedAttachedEntity")
	if ( is_custom == 0 && is_unintended == 0 )
	{
		if ( this.HasGunslinger() ) {
			weapon.SetModelSimple( GTFW_MODEL_ARMS[10] )	//Gunslinger arms
		}
		else { weapon.SetModelSimple( GTFW_MODEL_ARMS[this.GetPlayerClass()] ) }
		return arms_model
	}
	
// USE: This is the special VM fix.
// it creates class arms that bonemerge with VM, and adds the weapon in the VM as a tf_wearable_vm.
// It creates the world model, as well.
	local class_arms = null
	
	local weapon_id = NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
	local baseitem = this.GTFW_FindEquip(weapon_id)
	if ( baseitem == null ) {
		return null
	}

	local baseitemClassname = baseitem.className
	local is_tfclass = baseitem.tf_class
	local Slot = baseitem.slot
	local draw_seq = baseitem.draw_seq
	
	if ( weapon.GetClassname() != "tf_wearable" && weapon.GetClassname() != "tf_wearable_demoshield"  && weapon.GetClassname() != "tf_wearable_razorback" ) {
		if ( CVAR_GTFW_USE_VIEWMODEL_FIX )
		{
		// adds a class arms model if nothing has parented to the main_viewmodel
		// this is used as a flag for initializing tables for the weapons
			if ( !( this in PlayerLoadoutGlobal_BonemergedArms ) ) {
				local wearable_handle = this.CreateCustomWeaponModel(false, null, GTFW_MODEL_ARMS[this.GetPlayerClass()])	// creates player class' arms, parents and does all that stuff
			// PURPOSE: Gunslinger/Short Circuit Fix
			// Puts into a table "player = arms model" for easy tracking
			// And so we don't create more arms than necessary
				::PlayerLoadoutGlobal_BonemergedArms[this] <- wearable_handle
			}
			class_arms = GTFW_MODEL_ARMS[is_tfclass]
			
			if ( is_tfclass == 0 )
			{
				class_arms = GTFW_MODEL_ARMS[this.GetPlayerClass()]
			}
			else if ( is_tfclass == 9 && this.HasGunslinger() )
			{
				class_arms = GTFW_MODEL_ARMS[10]
			}
			
		//updates class arms if not using new weapon's class arms
			if ( arms_model != null && draw_anim != null)
			{
				class_arms = arms_model
				main_viewmodel.SetModelSimple( class_arms )
				draw_seq = main_viewmodel.LookupSequence( draw_anim )
			}
			else
			{
				main_viewmodel.SetModelSimple( class_arms )
				draw_seq = main_viewmodel.LookupSequence( draw_seq )
			}
			
			if ( weapon_model != null && weapon_model != 0 )
			{
				local wearable_handle = this.CreateCustomWeaponModel(false, weapon, weapon_model)	// creates weapon in viewmodel, parents and does all that stuff
			
			//Mr. Burguers helped me with this part. Thanks Mr B!
				local wepClassname = weapon.GetClassname()
				
				if (!(this in PlayerLoadoutGlobal_CustomWeaponModels_VM)) {
					PlayerLoadoutGlobal_CustomWeaponModels_VM[this] <- {}
				}
				
				if ( wepClassname in PlayerLoadoutGlobal_CustomWeaponModels_VM[this] )
				{
					local wepModel = PlayerLoadoutGlobal_CustomWeaponModels_VM[this][wepClassname]
					wepModel.Kill()
					delete PlayerLoadoutGlobal_CustomWeaponModels_VM[this][wepClassname]
				}
				else
				{
					PlayerLoadoutGlobal_CustomWeaponModels_VM[this][weapon.GetClassname()] <- wearable_handle
				}
				
				if ( NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes") )	//only make third person model if weapon is custom
				{
					wearable_handle = this.CreateCustomWeaponModel(true, weapon, weapon_model)	// creates thirdperson/world model, parents and does all that stuff
				}
			}
		}
	}

//testing to see if this works
	return class_arms
}

// FUNCTION: Clears and updates the viewmodel think script for weapon switching, enabling/disabling visibility of custom weapons.

::CTFPlayer.AddThinkToViewModel <- function(armz)
{
	local class_arms = armz
	if ( CVAR_GTFW_USE_VIEWMODEL_FIX == false) {
		return
	}
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	local wearable_handle = null
		
		
	local Global_ClassArms = null
	local Global_DrawSeq = null
	if ( !( this in PlayerLoadoutGlobal_ClassArms ) ) {
		::PlayerLoadoutGlobal_ClassArms[this] <- {}
	}
	if ( !( this in PlayerLoadoutGlobal_DrawSeq ) ) {
		::PlayerLoadoutGlobal_DrawSeq[this] <- {}
	}
	
// FUNCTION: writes to the tables, which keep the class arms the weapon needs to update to when switched to,
// and the draw sequence. All draw sequences were found in the qc arms files, and are documented in GIVE_TF_WEAPON_ALL.nut.
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		local wepID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
		
		if ( wep != null )
		{
			local baseitem = this.GTFW_FindEquip(wepID)
			if ( baseitem != null) {
				PlayerLoadoutGlobal_DrawSeq[this][wep.GetClassname()] <- baseitem.draw_seq
				if ( baseitem.tf_class == this.GetPlayerClass() ||  baseitem.tf_class == 0 )
				{
					PlayerLoadoutGlobal_ClassArms[this][wep.GetClassname()] <- GTFW_MODEL_ARMS[this.GetPlayerClass()]
					wep.SetModelSimple( GTFW_MODEL_ARMS[this.GetPlayerClass()] )
				}
				else if ( this.HasGunslinger() )
				{
					PlayerLoadoutGlobal_ClassArms[this][wep.GetClassname()] <- GTFW_MODEL_ARMS[10]
					wep.SetModelSimple( GTFW_MODEL_ARMS[10] )
				}
				else if ( class_arms != null ) {
					PlayerLoadoutGlobal_ClassArms[this][wep.GetClassname()] <- class_arms
					wep.SetModelSimple( class_arms )
				}
				else {
					PlayerLoadoutGlobal_ClassArms[this][wep.GetClassname()] <- GTFW_MODEL_ARMS[baseitem.tf_class]
					wep.SetModelSimple( GTFW_MODEL_ARMS[baseitem.tf_class] )
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
		
		//debug messages
				printl("WEAPON ACTIVE "+wep)
				printl( PlayerLoadoutGlobal_ClassArms[player][wep.GetClassname()] )
				printl( PlayerLoadoutGlobal_DrawSeq[player][wep.GetClassname()] )
			//*/
				
			// This updates the viewmodel.
			// Remember, the weapon's sequences are decided by tf_viewmodel (or this handle, main_viewmodel)
				main_viewmodel.SetModelSimple( PlayerLoadoutGlobal_ClassArms[player][wep.GetClassname()] )
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
				if ( this in PlayerLoadoutGlobal_BonemergedArms ) {
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
			}
			return THINK_VMFIX_DELAY
		}
		AddThinkToEnt(main_viewmodel, entscriptname)	//adds think script
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
	//NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_iAccountID", -1)
	
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
	/*NetProps.SetPropEntity(weapon, "m_AttributeManager.m_Item.m_iAccountID", this)
	printl ( NetProps.GetPropEntity(weapon, "m_AttributeManager.m_Item.m_iAccountID") )
	printl ( NetProps.GetPropEntity(weapon, "m_iAccountID") )
	printl ( NetProps.GetPropEntity(weapon, "m_Item.m_iAccountID") )*/
	
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

//If added weapon is not intended to be used by player's tfclass, mark it as unintended for the class, to fix VM arms
	local addedWep = this.GTFW_FindEquip(itemindex)
	if ( this.GetPlayerClass() != addedWep.tf_class )
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

	local armz = this.UpdateArms(weapon, weapon_model, null, null)
	this.AddThinkToViewModel(armz)
	return weapon
}


/*FUNCTION: Finds an empty weapon equipment slot and gives weapon to the player
	-> See top of script for more info

 USE: hPlayer.GiveWeapon(15) // Gives the stock minigun
 USE: hPlayer.GiveWeapon("SMG")
*/

::CTFPlayer.GiveWeapon <- function(weapon)
{
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")
	AddThinkToEnt(main_viewmodel, null)	//clears script if it was being used
	main_viewmodel.SetModelSimple( GTFW_MODEL_ARMS[this.GetPlayerClass()] )
	
	
	local YourNewGunSaxtonApproved = null
	local DeletedWeapon = null

//searches for the correct item based on parameter 'baseitem'...
	local baseitem = this.GTFW_FindEquip(weapon)
	if ( baseitem == null ) {
		return null
	}
	local NewWeapon = baseitem.className
	local ItemID = baseitem.itemID
	local Slot = baseitem.slot
	local AmmoType = baseitem.ammoType
	local AmmoReserve = baseitem.reserve
	local Extra_Wearable = baseitem.wearable
	local draw_seq = baseitem.draw_seq
	
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
		if ( Slot == SlotNew ) {
			this.SwitchToActive(YourNewGunSaxtonApproved)
		}
		else {
			this.SwitchToActive(null)
		}
	}
	
	if ( NewWeapon == "tf_weapon_revolver" && this.GetPlayerClass != 8 ) //Forcefully changes ammo type to primary if not Spy
	{
		NetProps.SetPropInt( YourNewGunSaxtonApproved, "LocalWeaponData.m_iPrimaryAmmoType", TF_AMMO.PRIMARY)
	}
	
	//YourNewGunSaxtonApproved.AddAttribute("maxammo primary reduced", 0.1, -1)
	if ( AmmoType != TF_AMMO.NONE ) {
		local aThreshold = 0
		if ( AmmoType == TF_AMMO.PRIMARY ) {
			aThreshold = TF_AMMO_PER_CLASS_PRIMARY[this.GetPlayerClass()]
			YourNewGunSaxtonApproved.AddAttribute("hidden primary max ammo bonus", (AmmoReserve.tofloat() / aThreshold.tofloat()), -1)
		}
		else if ( AmmoType == TF_AMMO.SECONDARY ) {
			aThreshold = TF_AMMO_PER_CLASS_SECONDARY[this.GetPlayerClass()]
			YourNewGunSaxtonApproved.AddCustomAttribute("hidden secondary max ammo penalty", (AmmoReserve.tofloat() / aThreshold.tofloat()), -1)
		}
		else if ( AmmoType == TF_AMMO.METAL && this.GetPlayerClass() != 9 )
		{
		}
		NetProps.SetPropIntArray(this, "m_iAmmo", AmmoReserve, AmmoType)
	}
	//this.GetAmmo()
	
	return YourNewGunSaxtonApproved
}

/*FUNCTION: Deletes a weapon equipped on player
	-> See top of script for more info
 Accepts handles, entity classnames, strings, slots
 USE: hPlayer.DeleteWeapon("tf_weapon_minigun")	//deletes only stock minigun
 USE: hPlayer.DeleteWeapon("SECONDARY")	//deletes all secondaries
*/

::CTFPlayer.DeleteWeapon <- function(weapon)
{
//converts our weapon from string/ID to a classname...
	local baseitem = this.GTFW_FindEquip(weapon)
	if ( baseitem == null ) {
		return null
	}
	local DeleteThis = baseitem.className
	
	if ( this.CheckIfEquipOnPlayer(DeleteThis) ) {
		return null
	}
	
	local DeletedWeapon = null
	local LOOPCOUNT_MAX = 1
	
	if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
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
				if ( GTFW_FindEquipBySlot(weapon, wep) )
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
//converts our weapon from string/ID to a classname...
	local baseitem = this.GTFW_FindEquip(searched_weapon)
	if ( baseitem == null ) {
		return null
	}
	local ReplaceThis = baseitem.className
//cancels the operation if we don't have this weapon...
	if ( this.CheckIfEquipOnPlayer(ReplaceThis) ) {
		return null
	}
	
//putting "a" here so it doesn't error with nothing in array[0]
	local ReplaceThisID = searched_itemID
	local CheckIfAllButWeapon = split(ReplaceThisID.tostring()+"a",abs(ReplaceThisID).tostring())[0]
//a negative itemID is excluded in the search
	local ExcludeWeapon = false	//off by default
	if ( CheckIfAllButWeapon == "-" )	//if itemID is negative...
	{
		ReplaceThisID = abs(searched_itemID).tointeger()
		ExcludeWeapon = true
	}
//searches for the correct item based on parameter 'baseitem'...
	baseitem = this.GTFW_FindEquip(new_weapon)
	if ( baseitem == null ) {
		return null
	}
	local GiveThisID = baseitem.itemID
	
	local YourNewGunSaxtonApproved = null
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
				if ( GTFW_FindEquipBySlot(searched_weapon, wep) )
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
	Say(GetListenServerHost(), format("Active %s [%s] (ItemID = %i)", slot, ActiveWeapon.GetClassname(), ActiveWeaponID), false)
	
	for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
	{
		local wep = NetProps.GetPropEntityArray(GetListenServerHost(), "m_hMyWeapons", i)
		local wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
		printl(i+" "+wep+" (ItemID = "+wep_itemID+")" )
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
			Say(GetListenServerHost(), format("Active %s [%s] (ItemID = %i)", slot, wep.GetClassname(), wep_itemID), false)
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
function GTFW_FindEquipBySlot(slot, wep)
{
	if ( slot == "primary" || slot == "PRIMARY" || slot == "Primary" )
	{
		if ( SearchPrimaryWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "secondary" || slot == "SECONDARY" || slot == "Secondary" )
	{
		if ( SearchSecondaryWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "melee" || slot == "MELEE" || slot == "Melee" )
	{
		if ( SearchMeleeWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "misc" || slot == "MISC" || slot == "Misc" )
	{
		if ( SearchMiscWeapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "slot4" || slot == "SLOT4" || slot == "Slot4" )
	{
		if ( SearchSlot4Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "slot5" || slot == "SLOT5" || slot == "Slot5" )
	{
		if ( SearchSlot5Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "slot6" || slot == "SLOT6" || slot == "Slot6" )
	{
		if ( SearchSlot6Weapons.find(wep.GetClassname()) != null )
		{
			return true
		}
	}
	else if ( slot == "slot7" || slot == "SLOT7" || slot == "Slot7" )
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
	
 USE: hPlayer.DisableWeapon("tf_weapon_medigun", 998) //Disable only Vaccinator
 USE: hPlayer.DisableWeapon("secondary", -1) //Disable any secondary
*/

::CTFPlayer.DisableWeapon <- function(weapon)
{
//searches for the correct item based on parameter 'baseitem'...
	local baseitem = this.GTFW_FindEquip(weapon)
	if ( baseitem == null ) {
		return null
	}
	local DisableThis = baseitem.className
//cancels the operation if we don't have this weapon...
	if ( this.CheckIfEquipOnPlayer(DisableThis) ) {
		return null
	}
	
	local BrokenGun = null
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
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
			if ( wep != null )
			{
				if ( GTFW_FindEquipBySlot(weapon, wep) )
				{
					DisableThis = wep.GetClassname()
				}
				if ( wep.GetClassname() == DisableThis )
				{
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						DisableThis = wep.GetClassname().tostring()+"_disabled"
						
						BrokenGun = wep.__KeyValueFromString("classname", wep.GetClassname().tostring()+"_disabled") //works but visually buggy
					//	wep.AddAttribute("disable weapon switch", 1, -1) //doesn't work??
						break
					}
				}
			}
		}
	}
	
// switches to another weapon if active one was disabled
	this.SwitchToActive(null)
	
	return BrokenGun
}

/*//FUNCTION: Enables weapon if it was disabled.

	USE: hPlayer.EnableWeapon("primary")
*/
::CTFPlayer.EnableWeapon <- function(weapon)
{
//searches for the correct item based on parameter 'baseitem'...
	local baseitem = this.GTFW_FindEquip(weapon)
	if ( baseitem == null ) {
		return null
	}
	local FixThis = baseitem.className
//cancels the operation if we don't have this weapon...
	if ( this.CheckIfEquipOnPlayer(FixThis) ) {
		return null
	}
	
	local FixedGun = null
	local LOOPCOUNT_MAX = 1
	
	if ( weapon == "misc" || weapon == "MISC" || weapon == "Misc" )
	{
		LOOPCOUNT_MAX = 4	//setting to 4 for multiple PDAs, InvisWatch, Spellbook etc
	}
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
			if ( wep != null )
			{
				if ( GTFW_FindEquipBySlot(weapon, wep) )
				{
					FixThis = wep.GetClassname()
				}
				if ( wep.GetClassname() == FixThis )
				{
					if ( LOOPCOUNT_CURRENT == LOOPCOUNT_MAX - 1 )
					{
						for ( local CheckIfAllButWeapon = split(wep.GetClassname().tostring(),"_").len(); CheckIfAllButWeapon = CheckIfAllButWeapon[CheckIfAllButWeapon.len()]; ) {
							if ( CheckIfAllButWeapon == "disabled"  )
							{
								FixedGun = wep.__KeyValueFromString("classname", FixThis.tostring())
							}
						}
						break
					}
				}
			}
		}
	}
	
// switches to another weapon if active one was disabled
	this.SwitchToActive(FixedGun)
	
	return FixedGun
}

/* FUNCTION: Returns weapon from player as a hPlayer.
	-> See top of script for more info
*/

::CTFPlayer.ReturnWeapon <- function(searched_weapon)
{
//searches for the correct item based on parameter 'searched_weapon'...
	local baseitem = this.GTFW_FindEquip(searched_weapon)
	if ( baseitem == null ) {
		return null
	}
	local GetThis = baseitem.className

//cancels the operation if we don't have this weapon...
	if ( this.CheckIfEquipOnPlayer(GetThis) ) {
		return null
	}

	local YourGunFoundBySaxtonHale = null
	local LOOPCOUNT_MAX = 1
	
	for (local LOOPCOUNT_CURRENT = 0; LOOPCOUNT_CURRENT < LOOPCOUNT_MAX; LOOPCOUNT_CURRENT++)
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
			
			if ( wep != null )
			{
				if ( GTFW_FindEquipBySlot(searched_weapon, wep) )
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
change the main_viewmodel using main_viewmodel.SetModelSimple() to change to new set of class arms
change the baseitem's modelindex (which are class_arms) to the animations you want to use for the new weapon
*/


::CTFPlayer.CreateCustomWeaponModel <- function(wearabletype, baseitem, weapon_model)
{
	local main_viewmodel = NetProps.GetPropEntity(this, "m_hViewModel")

	if ( type( weapon_model ) == "string" )
	{
		PrecacheModel(weapon_model)
		weapon_model = GetModelIndex(weapon_model)
	}
	if ( this.HasGunslinger() && baseitem == null || baseitem == main_viewmodel ) {
		PrecacheModel(GTFW_MODEL_ARMS[10])
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

	// USE: hPlayer.SetCustomWeapon("tf_weapon_knife", "models/weapons/c_models/spy_sword.mdl", "models/weapons/c_models/c_scout_arms.mdl", null)
	// USE: hPlayer.SetCustomWeapon("primary", models/workshop/weapons/c_models/c_demo_cannon/c_demo_cannon.mdl, null, null)
*/

::CTFPlayer.SetCustomWeapon <- function(weapon, custom_weapon_model, custom_arms_model)
{
//searches for the correct item based on parameter 'weapon'...
	local baseitem = this.GTFW_FindEquip(weapon)
	if ( baseitem == null ) {
		return null
	}
	local CUSTOM_WEAPON = baseitem.className
	local ItemID = baseitem.itemID
	local Slot = baseitem.slot
	local draw_seq = baseitem.draw_seq

//cancels the operation if we don't have this weapon...
	if ( this.CheckIfEquipOnPlayer(CUSTOM_WEAPON) ) {
		return null
	}

// Checks if our weapon is on the list of all weapons. If yes, search classname and turn it into a handle.
// This allows us to use classnames as a parameter.
	if ( SearchBySlotsParameters.find(CUSTOM_WEAPON) != null )
	{
		for (local i = 0; i < GLOBAL_WEAPON_COUNT; i++)
		{
			local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)
		
			if ( wep != null && GTFW_FindEquipBySlot(weapon, wep) )
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
	
	/*	local wearable = custom_extra_wearable
		if ( wearable != null ) {
			this.CreateCustomWeaponModel(true, this, custom_extra_wearable)	// creates thirdperson/world model for wearables, parents and does all that stuff
		}
	*/
	NetProps.SetPropInt(CUSTOM_WEAPON, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)	//marks our weapon as custom
	local armz = this.UpdateArms(CUSTOM_WEAPON, custom_weapon_model, custom_arms_model, draw_seq)
	this.AddThinkToViewModel(armz)
	
//returns handle back to script for adding new attributes
	return CUSTOM_WEAPON
}
::CTFPlayer.RegisterCustomWeapon <- function(item_name, weapon, custom_weapon_model, custom_arms_model)
{
//searches for the correct item based on parameter 'weapon'...
	local baseitem = this.GTFW_FindEquip(weapon)
	if ( baseitem == null ) {
		return null
	}
	local CUSTOM_WEAPON = baseitem.className
	local ItemID = baseitem.itemID
	local Slot = baseitem.slot
	local draw_seq = baseitem.draw_seq
}



/*//Dev Notes//
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
TODO: Add DisableWeaponEx, ReactivateWeaponEx
TODO: GiveWeapon not playing draw sequences for given weapon
TODO: m_bOnlyIterateItemViewAttributes sets to 1 on tf_dropped_weapon
WIP: Give weapon, set custom model, give another new weapon, first weapon resets arms
WIP: Fix bug with GiveWeapon into SetCustomWeapon
WIP: Custom weapon database (basically just a table with stats)
WIP: RegisterCustomWeapon

*/

/*
 //Debug Stuff
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
			player.GiveWeapon("Revolver")
		//	local melee = player.GiveWeapon("Crossbow")
		//	player.SetCustomWeapon(melee, GTFW_MODELS_CUSTOM_WEAPONS.SCOUT_DARTGUN, GTFW_ARMS.MEDIC)
		}
		if ( player.GetPlayerClass() == 9 )
		{
		//	local melee = player.ReturnWeapon(tf_weapon_wrench)
		//	melee.AddAttribute("disable weapon switch", 1, -1)
			//melee.AddAttribute("force weapon switch", 1, -1)
		//	local melee = player.GiveWeapon("Eyelander")
		//	player.SetCustomWeapon(melee, -1, GTFW_MODELS_CUSTOM_WEAPONS.DEMO_BIGAXE, GTFW_ARMS.DEMO )
			player.SetCustomWeapon("Build PDA", "models/weapons/w_models/w_scroll_engineer/w_scroll_build.mdl", null )
			player.SetCustomWeapon("Destroy PDA", "models/weapons/w_models/w_scroll_engineer/w_scroll_destroy.mdl", null )
		}
	//	player.GiveWeapon("Festive Buff Banner")
	//		player.GiveWeapon("Short Circuit")
	//		player.GiveWeapon("Gunslinger")
	//	local sword = player.GiveWeapon("Eyelander")
	//	local SpySword = player.SetCustomWeapon(knife, -1, "models/weapons/w_models/w_rapier_spy/w_rapier.mdl", GTFW_ARMS.SPY, "knife_draw" )
	//	NetProps.SetPropInt(player,"m_PlayerClass.m_iClass", 9)
		
	//	player.GiveWeapon(45)
	//	player.GiveWeapon(449)
	//	player.GiveWeapon(221)
	//	for (local weapon; weapon = Entities.FindByClassname(weapon, "tf_drop*"); )
	//	{
	//		weapon.SetModelSimple("models/weapons/w_models/w_rapier_spy/w_rapier.mdl")
	//	}
	}
}
	__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

::CTFPlayer.GetAmmo <- function()
{
	local active = this.GetActiveWeapon()
	printl(NetProps.GetPropInt( active, "LocalWeaponData.m_iClip1") )
	printl(NetProps.GetPropInt( active, "LocalWeaponData.m_iClip2") )
	printl(NetProps.GetPropInt( active, "LocalWeaponData.m_iPrimaryAmmoType") )
	printl(NetProps.GetPropInt( active, "LocalWeaponData.m_iSecondaryAmmoType") )
	
	printl("LINE")
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

// End debug stuff */
