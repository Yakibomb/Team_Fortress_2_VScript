		
::TF_AMMO_PER_CLASS_ <- [
	0,
	32,
	25,
	20
	16,
	150
	200,
	200,
	20,
	32,
	0,
]

::TF_AMMO_PER_CLASS_ <- [
	0,
	36,
	75,
	32,
	24,
	150,
	32,
	32,
	24,
	200,
	0,
]
class TF_C_WEPS
{
	static prefix = "tf_weapon_"
	itemName	= null
	className	= null
	slot		= null
	itemID		= null
	func		= null	
	class_arms	= null
	draw_seq	= null
	ammoType	= null
	clip		= null
	reserve		= null
	model		= null
	wearable	= null
	
	constructor(name, weapon, Slot, id, Function, classarms, drawseq, ammoslot, prim, sec, wep_model, extra_wearable)
	{
		itemName	= name
		if ( weapon == "demoshield" )
		{
			className = "tf_wearable_demoshield"
		}
		else if ( weapon == "razorback" )
		{
			className = "tf_wearable_razorback"
		}
		else if ( weapon == "tf_wearable" )
		{
			className = weapon
		}
		else { className = prefix + weapon }
		slot		= Slot
		itemID		= id
		func		= Function
		class_arms	= classarms
		draw_seq	= drawseq
		ammoType	= ammoslot
		clip		= prim
		reserve		= sec
		model		= wep_model
		wearable	= extra_wearable
	}
}
// Unlike other registries, this one can only be searched by item name.
::TF_CUSTOM_WEAPONS_REGISTRY <- [
	TF_C_WEPS("Musk of Mann", "grenadelauncher", 1, 206, "GTFW_CW_Stats_test()", GTFW_ARMS.MEDIC, "sg_draw", TF_AMMO.PRIMARY, 4, 16, null, null)
	TF_C_WEPS("Build Scroll", "pda_engineer_build", 4, 737, "GTFW_CW_Stats_test()", GTFW_ARMS.ENGINEER, "bld_draw", TF_AMMO.NONE, -1, -1, "models/weapons/w_models/w_scroll_engineer/w_scroll_build.mdl", null)
	TF_C_WEPS("Build Scroll", "pda_engineer_destroy", 5, 26, "GTFW_CW_Stats_test()", GTFW_ARMS.ENGINEER, "pda_draw", TF_AMMO.NONE, -1, -1, "models/weapons/w_models/w_scroll_engineer/w_scroll_destroy.mdl", null)
]

::GTFW_CW_Stats_test <- function()
{
}

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

class TF_WEAPONS
{
	static prefix = "tf_weapon_"
	tf_class	= null
	slot		= null
	className	= null
	itemID		= null
	itemID2 	= null
	itemString	= null
	itemString2	= null
	draw_seq	= null
	clip		= null
	reserve		= null
	wearable	= null
	
	constructor(TF_class, TF_slot, weapon, id, id2, item, item2, drawseq, prim, sec, extra_wearable)
	{
		tf_class	= TF_class
		slot		= TF_slot
		if ( weapon == "demoshield" )
		{
			className = "tf_wearable_demoshield"
		}
		else if ( weapon == "razorback" )
		{
			className = "tf_wearable_razorback"
		}
		else if ( weapon == "tf_wearable" )
		{
			className = weapon
		}
		else { className = prefix + weapon }
		itemID		= id
		itemID2		= id2
		itemString	= item
		itemString2	= item2
		draw_seq	= drawseq
		clip		= prim
		reserve		= sec
		wearable	= extra_wearable
	}
}
class TF_WEAPONS_RESKIN
{
	static prefix = "tf_weapon_"
	tf_class	= null
	slot		= null
	className	= null
	itemID		= null
	itemID2 	= null
	itemID3		= null
	itemID4		= null
	itemID5 	= null
	itemID6 	= null
	itemID7 	= null
	itemID8 	= null
	itemID9 	= null
	itemID10 	= null
	itemID11	= null
	itemID12 	= null
	itemID13 	= null
	
	draw_seq	= null
	clip		= null
	reserve		= null
	wearable	= null
	
	constructor(TF_class, TF_slot, weapon, id, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, drawseq, prim, sec)
	{
		tf_class	= TF_class
		slot		= TF_slot
		if ( weapon == "demoshield" )
		{
			className = "tf_wearable_demoshield"
		}
		else if ( weapon == "razorback" )
		{
			className = "tf_wearable_razorback"
		}
		else if ( weapon == "tf_wearable" )
		{
			className = weapon
		}
		else { className = prefix + weapon }
		itemID		= id
		itemID2		= id2
		itemID3		= id3
		itemID4		= id4
		itemID5		= id5
		itemID6		= id6
		itemID7		= id7
		itemID8		= id8
		itemID9		= id9
		itemID10	= id10
		itemID11	= id11
		itemID12	= id12
		itemID13	= id13

		draw_seq	= drawseq
		clip		= prim
		reserve		= sec
	}
}
class TF_WEP_FEST
{
	static prefix = "tf_weapon_"
	tf_class	= null
	slot		= null
	className	= null
	itemID		= null
	itemString	= null
	itemString2	= null
	
	draw_seq	= null
	clip		= null
	reserve		= null
	wearable	= null
	
	constructor(TF_class, TF_slot, weapon, id, item, item2, drawseq, prim, sec, extra_wearable)
	{
		tf_class	= TF_class
		slot		= TF_slot
		if ( weapon == "demoshield" )
		{
			className = "tf_wearable_demoshield"
		}
		else if ( weapon == "razorback" )
		{
			className = "tf_wearable_razorback"
		}
		else if ( weapon == "tf_wearable" )
		{
			className = weapon
		}
		else { className = prefix + weapon }
		itemID		= id
		itemString	= item
		itemString2	= item2

		draw_seq	= drawseq
		clip		= prim
		reserve		= sec
		wearable	= extra_wearable
	}
}

::TF_WEAPONS_ALL <- [
// Named shotgun is 199, for every class that has one
// Reserve shooter is multiclass (Soldier/Pyro)
// Panic attack is multi
// Missing grappling hook/Mannpower things
//-----------------------------------------------------------------------------
// All
//-----------------------------------------------------------------------------
	TF_WEAPONS(0, 0, "shotgun", 199, null, "Shotgun", null, "draw", 6, 32, null)
	TF_WEAPONS(0, 0, "shotgun", 415, null, "Reserve Shooter", null, "draw", 4, 32, null)
	TF_WEAPONS(0, 0, "shotgun", 1153, null, "Panic Attack", null, "draw", 6, 32, null)
	TF_WEAPONS(0, 1, "pistol", 22, 209, "Pistol", null, "p_draw", 12, 36, null)
	TF_WEAPONS(0, 1, "pistol", 30666, null, "C.A.P.P.E.R.", "CAPPER", "p_draw", 12, 36, null)
	TF_WEAPONS(0, 1, "pistol", 160, 294, "Lugermorph", "Luger", "pstl_draw", 12, 36, null)
	TF_WEAPONS(0, 5, "spellbook", 1070, null, "Basic Spellbook", "Spellbook Magazine", "spell_draw", -1, -1, null)
	TF_WEAPONS(0, 5, "spellbook", 1069, null, "Halloween Spellbook", "Fancy Spellbook", "spell_draw", -1, -1, "models/player/items/all_class/hwn_spellbook_complete.mdl")
	TF_WEAPONS(0, 2, "saxxy", 264, null, "Frying Pan", "Pan", "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 423, null, "Saxxy", null, "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 474, null, "Conscientious Objector", "Sign", "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 880, null, "Freedom Staff", null, "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 939, null, "Bat Outta Hell", null, "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 954, null, "Memory Maker", null, "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 1013, null, "Ham Shank", null, "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 1071, null, "Gold Frying Pan", "Gold Pan", "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 1127, null, "Crossing Guard", null, "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 1123, null, "Necro Smasher", "Smasher", "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "saxxy", 30758, null, "Prinny Machete", "Machete", "melee_allclass_draw", -1, -1, null)
	
//-----------------------------------------------------------------------------
// Scout
//-----------------------------------------------------------------------------
	TF_WEAPONS(1, 0, "scattergun", 13, 200, "Scattergun", "Scatter Gun", "sg_draw", 6, 32, null)
	TF_WEAPONS(1, 0, "scattergun", 45, null, "Force-A-Nature", "FAN", "db_draw", 2, 32, null)
	TF_WEAPONS(1, 0, "handgun_scout_primary", 220, null, "Shortstop", null, "ss_draw", 4, 32, null)
	TF_WEAPONS(1, 0, "soda_popper", 448, null, "Soda Popper", null, "db_draw", 2, 32, null)
	TF_WEAPONS(1, 0, "pep_brawler_blaster", 772, null, "Baby Face's Blaster", "BFB", "sg_draw", 4, 32, null)
	TF_WEAPONS(1, 0, "scattergun", 1103, null, "Back Scatter", null, "sg_draw", 4, 32, null)
	
	TF_WEAPONS(1, 1, "lunchbox_drink", 46, null, "Bonk! Atomic Punch", "Bonk", "ed_draw", 1, -1, null)
	TF_WEAPONS(1, 1, "lunchbox_drink", 163, null, "Crit-a-Cola", "CAC", "ed_draw", 1, -1, null)
	TF_WEAPONS(1, 1, "jar_milk", 222, null, "Mad Milk", null, "ed_draw", 1, -1, null)
	TF_WEAPONS(1, 1, "handgun_scout_secondary", 449, null, "Winger", null, "p_draw", 5, 36, null)
	TF_WEAPONS(1, 1, "handgun_scout_secondary", 773, null, "Pretty Boy's Pocket Pistol", "PBPP", "p_draw", 9, 36, null)
	TF_WEAPONS(1, 1, "cleaver", 812, 833, "Flying Guillotine", "Cleaver", "cleave_draw", 1, -1, null)
	TF_WEAPONS(1, 1, "jar_milk", 1121, null, "Mutated Milk", null, "ed_draw", 1, -1, null)
	
	TF_WEAPONS(1, 2, "bat", 0, 190, "Bat", null, "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat_wood", 44, null, "Sandman", null, "wb_draw", 1, -1, null)
	TF_WEAPONS(1, 2, "bat_fish", 221, null, "Holy Mackerel", "Fish", "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 317, null, "Candy Cane", null, "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 325, null, "Boston Basher", null, "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 349, null, "Sun-on-a-Stick", "SOAS", "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 355, null, "Fan O'War", "FOW", "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 450, null, "Atomizer", null, "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat_giftwrap", 648, null, "Wrap Assassin", null, "wb_draw", 1, -1, null)
	TF_WEAPONS(1, 2, "bat", 452, null, "Three-Rune Blade", "TRB", "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 572, null, "Unarmed Combat", "Spy Arm", "b_draw", -1, -1, null)
	TF_WEAPONS(1, 2, "bat", 30667, null, "Batsaber", null, "b_draw", -1, -1, null)
	
//-----------------------------------------------------------------------------
// Solly
//-----------------------------------------------------------------------------
	TF_WEAPONS(3, 0, "rocketlauncher", 18, 205, "Rocket Launcher", "RL", "dh_draw", 4, 20, null)
	TF_WEAPONS(3, 0, "rocketlauncher_directhit", 127, null, "Direct Hit", "DH", "dh_draw", 4, 20, null)
	TF_WEAPONS(3, 0, "rocketlauncher", 228, null, "Black Box", null, "dh_draw", 3, 20, null)
	TF_WEAPONS(3, 0, "rocketlauncher", 237, null, "Rocket Jumper", "RJ", "dh_draw", 4, 60, null)
	TF_WEAPONS(3, 0, "rocketlauncher", 414, null, "Liberty Launcher", null, "dh_draw", 5, 60, null)
	TF_WEAPONS(3, 0, "particle_cannon", 441, null, "Cow Mangler 5000", "Cow Mangler", "dh_draw", 4, -1, null)
	TF_WEAPONS(3, 0, "rocketlauncher", 513, null, "Original", null, "dh_draw", 4, 20, null)
	TF_WEAPONS(3, 0, "rocketlauncher", 730, null, "Beggar's Bazooka", "Beggars", "dh_draw", 0, 20, null)
	TF_WEAPONS(3, 0, "rocketlauncher", 1104, null, "Air Strike", "Airstrike", "dh_draw", 4, 20, null)

	TF_WEAPONS(3, 1, "shotgun_soldier", 10, null, "Soldier Shotgun", null, "draw", 6, 32, null)
	TF_WEAPONS(3, 1, "buff_item", 129, null, "Buff Banner", "Buff", "bb_draw", -1, -1, "models/weapons/c_models/c_buffpack/c_buffpack.mdl")
	TF_WEAPONS(3, 1, "tf_wearable", 133, null, "Gunboats", null, "", -1, -1, "models/weapons/c_models/c_rocketboots_soldier.mdl")
	TF_WEAPONS(3, 1, "buff_item", 226, null, "Battalion's Backup", "Backup", "bb_draw", -1, -1, "models/workshop/weapons/c_models/c_battalion_buffpack/c_battalion_buffpack.mdl")
	TF_WEAPONS(3, 1, "buff_item", 354, null, "Concheror", "Conch", "wh_draw", -1, -1, "models/workshop_partner/weapons/c_models/c_shogun_warpack/c_shogun_warpack.mdl")
	TF_WEAPONS(3, 1, "raygun", 442, null, "Righteous Bison", "Bison", "draw", 4, -1, null)
	TF_WEAPONS(3, 1, "tf_wearable", 444, null, "Mantreads", null, "", -1, -1, "models/workshop/player/items/soldier/mantreads/mantreads.mdl")
	TF_WEAPONS(3, 1, "parachute_secondary", 1101, null, "B.A.S.E. Jumper Secondary", "Soldier Parachute", "", -1, -1, "models/workshop/weapons/c_models/c_paratooper_pack/c_paratrooper_pack.mdl")
	
	TF_WEAPONS(3, 2, "shovel", 6, 196, "Shovel", "Spade", "s_draw", -1, -1, null)
	TF_WEAPONS(3, 2, "shovel", 128, null, "Equalizer", null, "s_draw", -1, -1, null)
	TF_WEAPONS(3, 2, "shovel", 154, null, "Pain Train", null, "s_draw", -1, -1, null)
	TF_WEAPONS(3, 2, "katana", 357, null, "Half-Zatoichi", "Katana", "s_draw", -1, -1, null)
	TF_WEAPONS(3, 2, "shovel", 416, null, "Market Gardener", null, "s_draw", -1, -1, null)
	TF_WEAPONS(3, 2, "shovel", 447, null, "Disciplinary Action", "DA", "s_draw", -1, -1, null)
	TF_WEAPONS(3, 2, "shovel", 775, null, "Escape Plan", null, "s_draw", -1, -1, null)

//-----------------------------------------------------------------------------
// Pyro
//-----------------------------------------------------------------------------
	TF_WEAPONS(7, 0, "flamethrower", 21, 208, "Flame Thrower", "Flamethrower", "ft_draw", 200, -1, null)
	TF_WEAPONS(7, 0, "flamethrower", 40, null, "Backburner", null, "ft_draw", 200, -1, null)
	TF_WEAPONS(7, 0, "flamethrower", 215, null, "Degreaser", null, "ft_draw", 200, -1, null)
	TF_WEAPONS(7, 0, "flamethrower", 594, null, "Phlogistinator", "Phlog", "ft_draw", 200, -1, null)
	TF_WEAPONS(7, 0, "flamethrower", 741, null, "Rainblower", null, "ft_draw", 200, -1, null)
	TF_WEAPONS(7, 0, "rocketlauncher_fireball", 1178, null, "Dragon's Fury", null, "ft_draw", 200, -1, null)
	TF_WEAPONS(7, 0, "flamethrower", 30474, null, "Nostromo Napalmer", "Alien Flamethrower", "ft_draw", 200, -1, null)
	
	TF_WEAPONS(7, 1, "shotgun_pyro", 12, null, "Pyro Shotgun", null, "draw", 6, 32, null)
	TF_WEAPONS(7, 1, "flaregun", 39, null, "Flare Gun", "Flaregun", "fg_draw", 1, 16, null)
	TF_WEAPONS(7, 1, "flaregun", 351, null, "Detonator", null, "fg_draw", 1, 16, null)
	TF_WEAPONS(7, 1, "flaregun_revenge", 595, null, "Manmelter", null, "mm_draw", -1, -1, null)
	TF_WEAPONS(7, 1, "flaregun", 740, null, "Scorch Shot", null, "fg_draw", 1, 16, null)
	TF_WEAPONS(7, 1, "rocketpack", 1179, null, "Thermal Thruster", null, "rocketpack_draw", 2, -1, "models/weapons/c_models/c_rocketpack/c_rocketpack.mdl")
	TF_WEAPONS(7, 1, "jar_gas", 1180, null, "Gas Passer", null, "gascan_draw", 1, -1, null)
	
	TF_WEAPONS(7, 2, "fireaxe", 2, 192, "Fire Axe", "Fireaxe", "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 38, null, "Axtinguisher", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 153, null, "Homewrecker", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 214, null, "Powerjack", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 326, null, "Back Scratcher", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 348, null, "Sharpened Volcano Fragment", "SVF", "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 457, null, "Postal Plummeler", "Mailbox", "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 466, null, "Maul", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 593, null, "Third-Degree", "Third Degree", "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "fireaxe", 739, null, "Lollichop", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "breakable_sign", 813, 834, "Neon Annihilator", null, "fa_draw", -1, -1, null)
	TF_WEAPONS(7, 2, "slap", 1181, null, "Hot Hand", "Slap Glove", "slap_draw", -1, -1, null)

//-----------------------------------------------------------------------------
// Demo
//-----------------------------------------------------------------------------
	TF_WEAPONS(4, 0, "grenadelauncher", 19, 206, "Grenade Launcher", null, "g_draw", 4, 16, null)
	TF_WEAPONS(4, 0, "grenadelauncher", 308, null, "Loch-n-Load", "Loch", "g_draw", 3, 16, null)
	TF_WEAPONS(4, 0, "tf_wearable", 405, null, "Ali Baba's Wee Booties", "Booties", "", -1, -1, null)
	TF_WEAPONS(4, 0, "tf_wearable", 608, null, "Bootlegger", null, "", -1, -1, null)
	TF_WEAPONS(4, 0, "cannon", 996, null, "Loose Cannon", null, "", 4, 16, null)
	TF_WEAPONS(4, 0, "parachute_primary", 1101, null, "B.A.S.E. Jumper Primary", "Demo Parachute", "", -1, -1, "models/workshop/weapons/c_models/c_paratooper_pack/c_paratrooper_pack.mdl")
	TF_WEAPONS(4, 0, "grenadelauncher", 1151, null, "Iron Bomber", null, "", 4, 16, null)
	
	TF_WEAPONS(4, 1, "pipebomblauncher", 20, 207, "Stickybomb Launcher", null, "sb_draw", 8, 24, null)
	TF_WEAPONS(4, 1, "pipebomblauncher", 130, null, "Scottish Resistance", "Sticky Resistance", "sb_draw", 8, 36, null)
	TF_WEAPONS(4, 1, "pipebomblauncher", 265, null, "Sticky Jumper", null, "sb_draw", 8, 72, null)
	TF_WEAPONS(4, 1, "pipebomblauncher", 1150, null, "Quickiebomb Launcher", null, "sb_draw", 8, 72, null)
	TF_WEAPONS(4, 1, "demoshield", 131, null, "Chargin' Targe", "Targe", "", -1, -1, null)
	TF_WEAPONS(4, 1, "demoshield", 406, null, "Splendid Screen", null, "", -1, -1, null)
	TF_WEAPONS(4, 1, "demoshield", 1099, null, "Tide Turner", null, "", -1, -1, null)
	
	TF_WEAPONS(4, 2, "bottle", 1, 191, "Bottle", null, "b_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "sword", 132, null, "Eyelander", null, "cm_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "sword", 172, null, "Scotsman's Skullcutter", "Skullcutter", "cm_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "stickbomb", 307, null, "Ullapool Caber", "Caber", "b_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "sword", 327, null, "Claidheamh Mor", "Claid", "cm_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "sword", 404, null, "Persian Persuader", "Persuader", "melee_allclass_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "sword", 266, null, "Horseless Headless Horseman's Headtaker", "HHHH", "cm_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "sword", 482, null, "Nessie's Nine Iron", "Golf Club", "cm_draw", -1, -1, null)
	TF_WEAPONS(4, 2, "bottle", 609, null, "Scottish Handshake", null, "b_draw", -1, -1, null)


//-----------------------------------------------------------------------------
// Heavy
//-----------------------------------------------------------------------------
	TF_WEAPONS(6, 0, "minigun", 15, 202, "Minigun", "Sasha", "m_draw", 200, -1, null)
	TF_WEAPONS(6, 0, "minigun", 41, null, "Natascha", null, "m_draw", 200, -1, null)
	TF_WEAPONS(6, 0, "minigun", 298, null, "Iron Curtain", null, "m_draw", 200, -1, null)
	TF_WEAPONS(6, 0, "minigun", 312, null, "Brass Beast", null, "m_draw", 200, -1, null)
	TF_WEAPONS(6, 0, "minigun", 424, null, "Tomislav", null, "m_draw", 200, -1, null)
	TF_WEAPONS(6, 0, "minigun", 811, 832, "Huo-Long Heater", "Heater", "m_draw", 200, -1, null)
	TF_WEAPONS(6, 0, "minigun", 850, null, "Deflector", null, "m_draw", 200, -1, null)
	
	TF_WEAPONS(6, 1, "shotgun_hwg", 11, null, "Heavy Shotgun", null, "draw", 6, 32, null)
	TF_WEAPONS(6, 1, "lunchbox", 42, null, "Sandvich", null, "sw_draw", 1, -1, null)
	TF_WEAPONS(6, 1, "lunchbox", 159, null, "Dalokohs Bar", "Dalokohs", "sw_draw", 1, -1, null)
	TF_WEAPONS(6, 1, "lunchbox", 311, null, "Buffalo Steak Sandvich", "Steak", "sw_draw", 1, -1, null)
	TF_WEAPONS(6, 1, "shotgun", 425, null, "Family Business", null, "draw", 8, 32, null)
	TF_WEAPONS(6, 1, "lunchbox", 433, null, "Fishcake", null, "sw_draw", 1, -1, null)
	TF_WEAPONS(6, 1, "lunchbox", 863, null, "Robo-Sandvich", "Robo Sandvich", "sw_draw", 1, -1, null)
	TF_WEAPONS(6, 1, "lunchbox", 1190, null, "Second Banana", "Banana", "sw_draw", 1, -1, null)
	
	TF_WEAPONS(6, 2, "fists", 5, 195, "Fists", null, "f_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 43, null, "Killing Gloves of Boxing", "KGB", "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 239, null, "Gloves of Running Urgently", "GRU", "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 310, null, "Warrior's Spirit", "WS", "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 331, null, "Fists of Steel", "FOS", "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 426, null, "Eviction Notice", "EN", "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 587, null, "Apoco-Fists", null, "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 656, null, "Holiday Punch", null, "bg_draw", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 1100, null, "Bread Bite", "Bread GRU", "breadglove_draw_A", -1, -1, null)
	TF_WEAPONS(6, 2, "fists", 1184, null, "Gloves of Running Urgently MvM", "GRU MVM", "bg_draw", -1, -1, null)
	
//-----------------------------------------------------------------------------
// Engineer
//-----------------------------------------------------------------------------
	TF_WEAPONS(9, 0, "shotgun_primary", 9, null, "Shotgun ", "Engineer Shotgun", "fj_draw", 6, 32, null)
	TF_WEAPONS(9, 0, "sentry_revenge", 141, null, "Frontier Justice", "FJ", "fj_draw", 3, 32, null)
	TF_WEAPONS(9, 0, "shotgun_primary", 527, null, "Widowmaker", null, "fj_draw", 200, -1, null)
	TF_WEAPONS(9, 0, "drg_pomson", 588, null, "Pomson 6000", "Pomson", "pomson_draw", 4, -1, null)
	TF_WEAPONS(9, 0, "shotgun_building_rescue", 997, null, "Rescue Ranger", null, "fj_draw", 4, 20, null)
	
	TF_WEAPONS(0, 1, "pistol", 22, null, "Engineer Pistol", null, "pstl_draw", 12, 200, null)	//ID doesn't exist
	TF_WEAPONS(9, 1, "laser_pointer", 140, null, "Wrangler", null, "wgl_draw", -1, -1, null)
	TF_WEAPONS(9, 1, "mechanical_arm", 528, null, "Short Circuit", null, "pstl_draw", 200, -1, null)
	
	TF_WEAPONS(9, 2, "wrench", 7, 197, "Wrench", null, "pdq_draw", -1, -1, null)
	TF_WEAPONS(9, 2, "robot_arm", 142, null, "Gunslinger", null, "gun_draw", -1, -1, null)
	TF_WEAPONS(9, 2, "wrench", 155, null, "Southern Hospitality", null, "spk_draw", -1, -1, null)
	TF_WEAPONS(9, 2, "wrench", 329, null, "Jag", null, "pdq_draw", -1, -1, null)
	TF_WEAPONS(9, 2, "wrench", 589, null, "Eureka Effect", null, "pdq_draw", -1, -1, null)
	TF_WEAPONS(9, 2, "wrench", 169, null, "Golden Wrench", null, "pdq_draw", -1, -1, null)
	
	TF_WEAPONS(9, 3, "pda_engineer_build", 25, 737, "Build PDA", null, "bld_draw", -1, -1, null)
	TF_WEAPONS(9, 4, "pda_engineer_destroy", 26, null, "Destruction PDA", "Destroy PDA", "pda_draw", -1, -1, null)
	TF_WEAPONS(9, 5, "builder", 28, null, "Engineer Toolbox", "Toolbox", "box_draw", -1, -1, null)
	
//-----------------------------------------------------------------------------
// Medic
//-----------------------------------------------------------------------------
	TF_WEAPONS(5, 0, "syringegun_medic", 17, 204, "Syringe Gun", "Syringegun", "sg_draw", 40, 150, null)
	TF_WEAPONS(5, 0, "syringegun_medic", 36, null, "Blutsauger", null, "sg_draw", 40, 150, null)
	TF_WEAPONS(5, 0, "crossbow", 305, null, "Crusader's Crossbow", "Crossbow", "sg_draw", 1, 38, null)
	TF_WEAPONS(5, 0, "syringegun_medic", 412, null, "Overdose", null, "sg_draw", 40, 150, null)
	
	TF_WEAPONS(5, 1, "medigun", 29, 211, "Medigun", "Medi Gun", "draw", -1, -1, null)
	TF_WEAPONS(5, 1, "medigun", 35, null, "Kritzkrieg", null, "draw", -1, -1, null)
	TF_WEAPONS(5, 1, "medigun", 441, null, "Quick-Fix", null, "draw", -1, -1, "models/weapons/c_models/c_proto_backpack/c_proto_backpack.mdl")
	TF_WEAPONS(5, 1, "medigun", 998, null, "Vaccinator", null, "draw", -1, -1, "models/workshop/weapons/c_models/c_medigun_defense/c_medigun_defensepack.mdl")
	
	TF_WEAPONS(5, 2, "bonesaw", 8, 198, "Bonesaw", null, "bs_draw", -1, -1, null)
	TF_WEAPONS(5, 2, "bonesaw", 37, null, "Ubersaw", null, "bs_draw", -1, -1, null)
	TF_WEAPONS(5, 2, "bonesaw", 173, null, "Vita-Saw", null, "bs_draw", -1, -1, null)
	TF_WEAPONS(5, 2, "bonesaw", 304, null, "Amputator", null, "bs_draw", -1, -1, null)
	TF_WEAPONS(0, 2, "bonesaw", 413, null, "Solemn Vow", null, "melee_allclass_draw", -1, -1, null)

//-----------------------------------------------------------------------------
// Sniper
//-----------------------------------------------------------------------------
	TF_WEAPONS(2, 0, "sniperrifle", 14, 201, "Sniper Rifle", null, "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "compound_bow", 56, null, "Huntsman", null, "bw_draw", 1, 12, null)
	TF_WEAPONS(2, 0, "sniperrifle", 230, null, "Sydney Sleeper", null, "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "sniperrifle_decap", 402, null, "Bazaar Bargain", null, "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "sniperrifle", 526, null, "Machina", null, "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "sniperrifle", 752, null, "Hitman's Heatmaker", null, "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "sniperrifle", 851, null, "AWPer Hand", "AWP", "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "compound_bow", 1092, null, "Fortified Compound", null, "bw_draw", 1, 12, null)
	TF_WEAPONS(2, 0, "sniperrifle_classic", 1098, null, "Classic", null, "draw", 25, -1, null)
	TF_WEAPONS(2, 0, "sniperrifle", 30665, null, "Shooting Star", null, "draw", 25, -1, null)
	
	TF_WEAPONS(2, 1, "smg", 16, 203, "SMG", null, "smg_draw", 25, 75, null)
	TF_WEAPONS(2, 1, "razorback", 57, null, "Razorback", null, "", 1, -1, null)
	TF_WEAPONS(2, 1, "jar", 58, null, "Jarate", null, "pj_draw", 1, -1, null)
	TF_WEAPONS(2, 1, "tf_wearable", 231, null, "Darwin's Danger Shield", "DDS", "", -1, -1, null)
	TF_WEAPONS(2, 1, "tf_wearable", 642, null, "Cozy Camper", null, "", -1, -1, null)
	TF_WEAPONS(2, 1, "charged_smg", 751, null, "Cleaner's Carbine", null, "", -1, -1, null)
	TF_WEAPONS(2, 1, "jar", 1105, null, "Self-Aware Beauty Mark", "Bread Jarate", "pj_draw", 1, -1, null)
	
	TF_WEAPONS(2, 2, "club", 3, 193, "Kukri", null, "m_draw", -1, -1, null)
	TF_WEAPONS(2, 2, "club", 171, null, "Tribalman's Shiv", null, "m_draw", -1, -1, null)
	TF_WEAPONS(2, 2, "club", 232, null, "Bushwacka", null, "m_draw", -1, -1, null)
	TF_WEAPONS(2, 2, "club", 401, null, "Shahanshah", null, "m_draw", -1, -1, null)
		
//-----------------------------------------------------------------------------
// Spy
//-----------------------------------------------------------------------------
	TF_WEAPONS(8, 0, "revolver", 24, 210, "Revolver", null, "draw", 6, 24, null)
	TF_WEAPONS(8, 0, "revolver", 61, null, "Ambassador", null, "draw", 6, 24, null)
	TF_WEAPONS(8, 0, "revolver", 161, null, "Big Kill", null, "draw", 6, 24, null)
	TF_WEAPONS(8, 0, "revolver", 224, null, "L'Etranger", null, "draw", 6, 24, null)
	TF_WEAPONS(8, 0, "revolver", 460, null, "Enforcer", null, "draw", 6, 24, null)
	TF_WEAPONS(8, 0, "revolver", 525, null, "Diamondback", null, "draw", 6, 24, null)
	
	//testing to see what slot2 does; need to test if it reacts well on Engineer (who already has a tf_weapon_builder)
	TF_WEAPONS(8, 1, "builder", 735, 736, "builder_spy", "Sapper", "c_sapper_draw", -1, -1, null)
	TF_WEAPONS(8, 1, "sapper", 810, 831, "Red-Tape Recorder", "Red Tape", "c_sd_sapper_draw", -1, -1, null)
	TF_WEAPONS(8, 1, "sapper", 933, null, "Ap-Sap", null, "c_sapper_draw", -1, -1, null)
	TF_WEAPONS(8, 1, "sapper", 1102, null, "Snack Attack", "Bread Sapper", "c_breadmonster_sapper_draw", -1, -1, null)
	
	TF_WEAPONS(8, 2, "knife", 4, 194, "Knife", null, "knife_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 225, null, "Your Eternal Reward", "YER", "eternal_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 356, null, "Conniver's Kunai", "Kunai", "eternal_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 461, null, "Big Earner", null, "eternal_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 574, null, "Wanga Prick", null, "eternal_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 638, null, "Sharp Dresser", null, "acr_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 649, null, "Spy-cicle", null, "eternal_draw", -1, -1, null)
	TF_WEAPONS(8, 2, "knife", 727, null, "Black Rose", null, "knife_draw", -1, -1, null)
	
	TF_WEAPONS(8, 3, "pda_spy", 947, null, "Disguise Kit PDA", "Disguise Kit", "offhand_draw", -1, -1, null)
	
	TF_WEAPONS(8, 4, "invis", 30, 212, "Invis Watch", "Invis", "offhand_draw", -1, -1, null)
	TF_WEAPONS(8, 4, "invis", 59, null, "Dead Ringer", null, "offhand_draw", -1, -1, null)
	TF_WEAPONS(8, 4, "invis", 60, null, "Cloak and Dagger", "CAD", "offhand_draw", -1, -1, null)
	TF_WEAPONS(8, 4, "invis", 297, null, "Enthusiast's Timepiece", "Timepiece", "offhand_draw", -1, -1, null)
	TF_WEAPONS(8, 4, "invis", 947, null, "Quackenbirdt", null, "offhand_draw", -1, -1, null)
]

::TF_WEAPONS_ALL_WARPAINTSnBOTKILLERS <- [
//Botkillers listed first, then warpaints
	TF_WEAPONS_RESKIN(0, 0, "shotgun", 15003, 15016, 15044, 15047, 15085, 15109, 15132, 15133, 15152, null, null, null, null, "draw", 6, 32)
	TF_WEAPONS_RESKIN(0, 1, "pistol", 15013, 15018, 15035, 15041, 15046, 15056, 15060, 15061, 15100, 15101, 15102, 15126, 15148, "p_draw", 12, 36)
	
	TF_WEAPONS_RESKIN(1, 0, "scattergun", 799, 808, 888, 897, 906, 915, 966, 973, null, null, null, null, 15157, "sg_draw", 6, 32)
	TF_WEAPONS_RESKIN(1, 0, "scattergun", 15002, 15015, 15021, 15029, 15036, 15053, 15065, 15069, 15106, 15107, 15108, 15131, 15151, "sg_draw", 6, 32)
	
	TF_WEAPONS_RESKIN(3, 0, "rocketlauncher", 800, 809, 889, 898, 907, 916, 965, 974, null, null, null, null, null, "dh_draw", 4, 20)
	TF_WEAPONS_RESKIN(3, 0, "rocketlauncher", 15006, 15014, 15028, 15043, 15052, 15057, 15081, 15104, 15105, 15129, 15130, 15150, null, "dh_draw", 4, 20)
	
	TF_WEAPONS_RESKIN(7, 0, "flamethrower", 798, 807, 887, 896, 905, 914, 963, 972, null, null, null, null, null, "f_draw", 200, -1)
	TF_WEAPONS_RESKIN(7, 0, "flamethrower", 15005, 15017, 15030, 15034, 15049, 15054, 15066, 15067, 15068, 15089, 15090, 15115, 15141, "f_draw", 200, -1)
	
	TF_WEAPONS_RESKIN(4, 0, "grenadelauncher", 15077, 15079, 15091, 15092, 15116, 15117, 15142, 15158, null, null, null, null, null, "g_draw", 4, 16)
	TF_WEAPONS_RESKIN(4, 1, "pipebomblauncher", 797, 806, 886, 895, 904, 913, 962, 971, null, null, null, null, null, "sb_draw", 8, 24)
	TF_WEAPONS_RESKIN(4, 1, "pipebomblauncher", 15009, 15012, 15024, 15038, 15045, 15048, 15082, 15083, 15084, 15113, 15137, 15138, 15155, "sb_draw", 8, 24)
	
	TF_WEAPONS_RESKIN(6, 0, "minigun", 882, 891, 900, 909, 958, 967, null, null, null, null, null, 15125, 15147, "m_draw", 200, -1)
	TF_WEAPONS_RESKIN(6, 0, "minigun", 15004, 15020, 15026, 15031, 15040, 15055, 15086, 15087, 15088, 15098, 15099, 15123, 15124, "m_draw", 200, -1)
	
	TF_WEAPONS_RESKIN(9, 2, "wrench", 795, 804, 884, 893, 902, 911, 960, 969, null, null, null, null, null, "spk_draw", -1, -1)
	TF_WEAPONS_RESKIN(9, 2, "wrench", 15073, 15074, 15075, 15139, 15140, 15114, 15156, 15158, null, null, null, null, null, "spk_draw", -1, -1)
	
	TF_WEAPONS_RESKIN(5, 1, "medigun", 796, 805, 885, 894, 903, 912, 961, 970, null, null, null, null, null, "draw", -1, -1)
	TF_WEAPONS_RESKIN(5, 1, "medigun", 15008, 15010, 15025, 15039, 15050, 15078, 15097, 15121, 15122, 15123, 15145, 15146, null, "draw", -1, -1)
	
	TF_WEAPONS_RESKIN(2, 0, "sniperrifle", 792, 801, 851, 881, 890, 899, 908, 957, 966, null, null, null, 15154, "draw", 25, -1)
	TF_WEAPONS_RESKIN(2, 0, "sniperrifle", 15000, 15007, 15019, 15023, 15033, 15059, 15070, 15071, 15072, 15111, 15112, 15135, 15136, "draw", 25, -1)
	TF_WEAPONS_RESKIN(2, 1, "smg", 15001, 15022, 15032, 15037, 15058, 15076, 15110, 15134, 15153, null, null, null, null, "smg_draw", 25, 75)
	
	TF_WEAPONS_RESKIN(8, 0, "revolver", 15011, 15027, 15042, 15051, 15062, 15063, 15064, 15103, 15127, 15128, 15149, null, null, "draw", 6, 24)
	TF_WEAPONS_RESKIN(8, 2, "knife", 794, 803, 883, 892, 901, 910, 959, 968, null, null, null, null, null, "knife_draw", -1, -1)
	TF_WEAPONS_RESKIN(8, 2, "knife", 15062, 15094, 15095, 15096, 15118, 15119, 15143, 15144, null, null, null, null, null, "knife_draw", -1, -1)
	
]

::TF_WEAPONS_ALL_FESTIVE <- [

	//shotgun 1141
	//pistol? 
	
	TF_WEP_FEST(1, 0, "scattergun", 669, "Festive Scattergun", "Festive Scatter Gun", "sg_draw", 6, 32, null)
	TF_WEP_FEST(1, 0, "scattergun", 1078, "Festive Force-A-Nature", "Festive FAN", "sg_draw", 2, 32, null)
	TF_WEP_FEST(1, 1, "lunchbox_drink", 46, "Festive Bonk!", "Festive Bonk", "ed_draw", 1, -1, null)
	TF_WEP_FEST(1, 2, "bat", 660, "Festive Bat", null, "b_draw", -1, -1, null)
	TF_WEP_FEST(1, 2, "bat_fish", 999, "Festive Holy Mackerel", "Festive Fish", "b_draw", -1, -1, null)
	
	TF_WEP_FEST(3, 0, "rocketlauncher", 669, "Festive Rocketlauncher", "Festive RL", "sg_draw", 4, 20, null)
	TF_WEP_FEST(3, 0, "rocketlauncher", 1085, "Festive Black Box", null, "sg_draw", 3, 20, null)
	TF_WEP_FEST(3, 1, "buff_item", 1001, "Festive Buff Banner", "Festive Buff", "bb_draw", -1, -1, "models/weapons/c_models/c_buffpack/c_buffpack_xmas.mdl")
	
	TF_WEP_FEST(7, 0, "flamethrower", 669, "Festive Flame Thrower", "Festive Flamethrower", "f_draw", 200, -1, null)
	TF_WEP_FEST(7, 0, "flamethrower", 1146, "Festive Backburner", null, "f_draw", 200, -1, null)
	TF_WEP_FEST(7, 1, "flaregun", 1081, "Festive Flare Gun", "Festive Flaregun", "fg_draw", 16, -1, null)
	TF_WEP_FEST(7, 2, "flaregun", 1000, "Festive Axtinguisher", null, "fa_draw", -1, -1, null)
	
	TF_WEP_FEST(4, 2, "grenadelauncher", 1007, "Festive Grenade Launcher", null, "g_draw", 4, 16, null)
	TF_WEP_FEST(4, 2, "pipebomblauncher", 661, "Festive Stickybomb Launcher", null, "sb_draw", 8, 24, null)
	TF_WEP_FEST(4, 2, "sword", 1082, "Festive Eyelander", null, "cm_draw", -1, -1, null)
	
	TF_WEP_FEST(6, 0, "minigun", 654, "Festive Minigun", null, "m_draw", 200, -1, null)
	TF_WEP_FEST(6, 1, "lunchbox", 1002, "Festive Sandvich", null, "sw_draw", 1, -1, null)
	TF_WEP_FEST(6, 2, "fists", 1084, "Festive Gloves of Running Urgently", "Festive GRU", "bg_draw", -1, -1, null)
	
	TF_WEP_FEST(9, 0, "shotgun_primary", 1004, "Festive Frontier Justice", null, "fj_draw", 3, 32, null)
	TF_WEP_FEST(9, 1, "laser_pointer", 1086, "Festive Wrangler", null, "fj_draw", -1, -1, null)
	TF_WEP_FEST(9, 2, "wrench", 662, "Festive Wrench", null, "spk_draw", -1, -1, null)
	
	TF_WEP_FEST(5, 0, "crossbow", 1079, "Festive Crusader's Crossbow", "Festive Crossbow", "sg_draw", 1, 38, null)
	TF_WEP_FEST(5, 1, "medigun", 663, "Festive Medigun", "Festive Medi Gun", "draw", -1, -1, null)
	TF_WEP_FEST(5, 2, "bonesaw", 1143, "Festive Bonesaw", null, "bs_draw", -1, -1, null)
	TF_WEP_FEST(5, 2, "bonesaw", 1003, "Festive Ubersaw", null, "bs_draw", -1, -1, null)
	
	TF_WEP_FEST(2, 0, "sniperrifle", 664, "Festive Sniper Rifle", null, "draw", 25, -1, null)
	TF_WEP_FEST(2, 0, "compound_bow", 1005, "Festive Huntsman", null, "bw_draw", 1, 12, null)
	TF_WEP_FEST(2, 1, "smg", 1083, "Festive SMG", null, "smg_draw", 25, 75, null)
	TF_WEP_FEST(2, 1, "jar", 1149, "Festive Jarate", null, "pj_draw", 1, -1, null)
	
	TF_WEP_FEST(8, 0, "revolver", 1142, "Festive Revolver", null, "draw", 6, 24, null)
	TF_WEP_FEST(8, 0, "revolver", 1006, "Festive Ambassador", null, "draw", 6, 24, null)
	TF_WEP_FEST(8, 1, "builder", 1080, "Festive Sapper", null, "c_sapper_draw", -1, -1, null) //testing to see what slot2 does; need to test if it reacts well on Engineer (who already has a tf_weapon_builder)
	TF_WEP_FEST(8, 2, "knife", 665, "Festive Knife", null, "knife_draw", -1, -1, null)
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
]
::SearchSlot3Weapons <-
[
	"tf_weapon_pda_spy",
	"tf_weapon_pda_engineer_build",
]
::SearchSlot4Weapons <-
[
	"tf_weapon_invis",
	"tf_weapon_pda_engineer_destroy",
]
::SearchSlot5Weapons <-
[
	"tf_weapon_builder",
	"tf_weapon_sapper",
]
::SearchSlot6Weapons <-
[
	"tf_weapon_grapplinghook",
	"tf_weapon_passtime_gun",
	"tf_weapon_spellbook",
]
