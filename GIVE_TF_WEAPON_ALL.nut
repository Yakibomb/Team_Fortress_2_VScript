
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
	ammoType	= null
	clip		= null
	reserve		= null
	wearable	= null
	
	constructor(TF_class, TF_slot, weapon, id, id2, item, item2, drawseq, ammoslot, prim, sec, extra_wearable)
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
		ammoType	= ammoslot
		clip		= prim
		reserve		= sec
		wearable	= extra_wearable
	}
}

TF_WEAPONS_ALL <- [
// Named shotgun is 199, for every class that has one
// No festives on the list yet
// Reskins are on the list
// Reserve shooter is multiclass (Soldier/Pyro)
// Panic attack is multi
// All
	TF_WEAPONS(0, 7, "spellbook", 1070, null, "Basic Spellbook", "Spellbook Magazine", "spell_draw", TF_AMMO.GRENADES3, -1, -1, null)
	TF_WEAPONS(0, 7, "spellbook", 1069, null, "Halloween Spellbook", "Fancy Spellbook", "spell_draw", TF_AMMO.GRENADES3, -1, -1, "models/player/items/all_class/hwn_spellbook_complete.mdl")
	TF_WEAPONS(0, 3, "saxxy", 423, null, "Saxxy", null, "melee_allclass_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(0, 3, "saxxy", 264, null, "Frying Pan", "Pan", "melee_allclass_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(0, 3, "saxxy", 30758, null, "Prinny Machete", "Machete", "melee_allclass_draw", TF_AMMO.NONE, -1, -1, null)
	
// Scout
	TF_WEAPONS(1, 1, "scattergun", 13, 200, "Scattergun", "Scatter Gun", "sg_draw", TF_AMMO.PRIMARY, 6, 32, null)
	TF_WEAPONS(1, 1, "scattergun", 45, null, "Force-A-Nature", "FAN", "db_draw", TF_AMMO.PRIMARY, 2, 32, null)
	TF_WEAPONS(1, 1, "handgun_scout_primary", 220, null, "Shortstop", null, "ss_draw", TF_AMMO.PRIMARY, 4, 32, null)
	TF_WEAPONS(1, 1, "soda_popper", 448, null, "Soda Popper", null, "db_draw", TF_AMMO.PRIMARY, 2, 32, null)
	TF_WEAPONS(1, 1, "pep_brawler_blaster", 772, null, "Baby Face's Blaster", "BFB", "sg_draw", TF_AMMO.PRIMARY, 4, 32, null)
	TF_WEAPONS(1, 1, "scattergun", 1103, null, "Back Scatter", null, "sg_draw", TF_AMMO.PRIMARY, 4, 32, null)
	
	TF_WEAPONS(1, 2, "pistol_scout", 23, 209, "Scout Pistol", null, "p_draw", TF_AMMO.SECONDARY, 12, 36, null)
	TF_WEAPONS(1, 2, "lunchbox_drink", 46, null, "Bonk! Atomic Punch", "Bonk", "ed_draw", TF_AMMO.GRENADES2, 1, -1, null)
	TF_WEAPONS(1, 2, "lunchbox_drink", 163, null, "Crit-a-Cola", "CAC", "ed_draw", TF_AMMO.GRENADES2, 1, -1, null)
	TF_WEAPONS(1, 2, "jar_milk", 222, null, "Mad Milk", null, "ed_draw", TF_AMMO.GRENADES2, 1, -1, null)
	TF_WEAPONS(1, 2, "handgun_scout_secondary", 449, null, "Winger", null, "p_draw", TF_AMMO.SECONDARY, 5, 36, null)
	TF_WEAPONS(1, 2, "handgun_scout_secondary", 773, null, "Pretty Boy's Pocket Pistol", "PBPP", "p_draw", TF_AMMO.SECONDARY, 9, 36, null)
	TF_WEAPONS(1, 2, "cleaver", 812, 833, "Flying Guillotine", "Cleaver", "cleave_draw", TF_AMMO.GRENADES2, 1, -1, null)
	TF_WEAPONS(1, 2, "pistol_scout", 160, 294, "Lugermorph", "Luger", "p_draw", TF_AMMO.SECONDARY, 12, 36, null)
	TF_WEAPONS(1, 2, "jar_milk", 1121, null, "Mutated Milk", null, "ed_draw", TF_AMMO.GRENADES2, 1, -1, null)
	
	TF_WEAPONS(1, 3, "bat", 0, 190, "Bat", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat_wood", 44, null, "Sandman", null, "wb_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(1, 3, "bat_fish", 221, null, "Holy Mackerel", "Fish", "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 317, null, "Candy Cane", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 325, null, "Boston Basher", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 349, null, "Sun-on-a-Stick", "SOAS", "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 355, null, "Fan O'War", "FOW", "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 450, null, "Atomizer", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat_giftwrap", 648, null, "Wrap Assassin", null, "wb_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(1, 3, "bat", 452, null, "Three-Rune Blade", "TRB", "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 572, null, "Unarmed Combat", "Spy Arm", "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(1, 3, "bat", 30667, null, "Batsaber", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	
// Solly
	TF_WEAPONS(3, 1, "rocketlauncher", 18, 205, "Rocket Launcher", "RL", "dh_draw", TF_AMMO.PRIMARY, 4, 20, null)
	TF_WEAPONS(3, 1, "rocketlauncher_directhit", 127, null, "Direct Hit", "DH", "dh_draw", TF_AMMO.PRIMARY, 4, 20, null)
	TF_WEAPONS(3, 1, "rocketlauncher", 228, null, "Black Box", null, "dh_draw", TF_AMMO.PRIMARY, 3, 20, null)
	TF_WEAPONS(3, 1, "rocketlauncher", 237, null, "Rocket Jumper", "RJ", "dh_draw", TF_AMMO.PRIMARY, 4, 60, null)
	TF_WEAPONS(3, 1, "rocketlauncher", 414, null, "Liberty Launcher", null, "dh_draw", TF_AMMO.PRIMARY, 5, 60, null)
	TF_WEAPONS(3, 1, "particle_cannon", 441, null, "Cow Mangler 5000", "Cow Mangler", "dh_draw", TF_AMMO.PRIMARY, 4, -1, null)
	TF_WEAPONS(3, 1, "rocketlauncher", 513, null, "Original", null, "dh_draw", TF_AMMO.PRIMARY, 4, 20, null)
	TF_WEAPONS(3, 1, "rocketlauncher", 730, null, "Beggar's Bazooka", "Beggars", "dh_draw", TF_AMMO.PRIMARY, 0, 20, null)
	TF_WEAPONS(3, 1, "rocketlauncher", 1104, null, "Air Strike", "Airstrike", "dh_draw", TF_AMMO.PRIMARY, 4, 20, null)

	TF_WEAPONS(3, 2, "shotgun_soldier", 10, null, "Soldier Shotgun", null, "draw", TF_AMMO.SECONDARY, 6, 32, null)
	TF_WEAPONS(3, 2, "buff_item", 129, null, "Buff Banner", "Buff", "bb_draw", TF_AMMO.NONE, -1, -1, "models/weapons/c_models/c_buffpack/c_buffpack.mdl")
	TF_WEAPONS(3, 2, "tf_wearable", 133, null, "Gunboats", null, "", TF_AMMO.NONE, -1, -1, "models/weapons/c_models/c_rocketboots_soldier.mdl")
	TF_WEAPONS(3, 2, "buff_item", 226, null, "Battalion's Backup", "Backup", "bb_draw", TF_AMMO.NONE, -1, -1, "models/workshop/weapons/c_models/c_battalion_buffpack/c_battalion_buffpack.mdl")
	TF_WEAPONS(3, 2, "buff_item", 354, null, "Concheror", "Conch", "wh_draw", TF_AMMO.NONE, -1, -1, "models/workshop_partner/weapons/c_models/c_shogun_warpack/c_shogun_warpack.mdl")
	TF_WEAPONS(3, 2, "shotgun", 415, null, "Reserve Shooter", null, "draw", TF_AMMO.SECONDARY, 4, 32, null)
	TF_WEAPONS(3, 2, "raygun", 442, null, "Righteous Bison", "Bison", "draw", TF_AMMO.SECONDARY, 4, -1, null)
	TF_WEAPONS(3, 2, "tf_wearable", 444, null, "Mantreads", null, "", TF_AMMO.NONE, -1, -1, "models/workshop/player/items/soldier/mantreads/mantreads.mdl")
	TF_WEAPONS(3, 2, "parachute_secondary", 1101, null, "B.A.S.E. Jumper Soldier", "Soldier Parachute", "", TF_AMMO.NONE, -1, -1, "models/workshop/weapons/c_models/c_paratooper_pack/c_paratrooper_pack.mdl")
	
	TF_WEAPONS(3, 3, "shovel", 6, 196, "Shovel", "Spade", "s_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(3, 3, "shovel", 128, null, "Equalizer", null, "s_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(3, 3, "shovel", 154, null, "Pain Train", null, "s_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(3, 3, "katana", 357, null, "Half-Zatoichi", "Katana", "s_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(3, 3, "shovel", 416, null, "Market Gardener", null, "s_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(3, 3, "shovel", 447, null, "Disciplinary Action", "DA", "s_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(3, 3, "shovel", 775, null, "Escape Plan", null, "s_draw", TF_AMMO.NONE, -1, -1, null)

// Pyro
	TF_WEAPONS(7, 1, "flamethrower", 21, 208, "Flame Thrower", "Flamethrower", "ft_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(7, 1, "flamethrower", 40, null, "Backburner", null, "ft_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(7, 1, "flamethrower", 215, null, "Degreaser", null, "ft_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(7, 1, "flamethrower", 594, null, "Phlogistinator", "Phlog", "ft_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(7, 1, "flamethrower", 741, null, "Rainblower", null, "ft_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(7, 1, "rocketlauncher_fireball", 1178, null, "Dragon's Fury", null, "ft_draw", TF_AMMO.PRIMARY, 200, -1, null)
	
	TF_WEAPONS(7, 2, "shotgun_pyro", 12, null, "Pyro Shotgun", null, "draw", TF_AMMO.SECONDARY, 6, 32, null)
	TF_WEAPONS(7, 2, "flaregun", 39, null, "Flare Gun", "Flaregun", "fg_draw", TF_AMMO.SECONDARY, 1, 16, null)
	TF_WEAPONS(7, 2, "flaregun", 351, null, "Detonator", null, "fg_draw", TF_AMMO.SECONDARY, 1, 16, null)
	TF_WEAPONS(7, 2, "flaregun_revenge", 595, null, "Manmelter", null, "mm_draw", TF_AMMO.SECONDARY, -1, -1, null)
	TF_WEAPONS(7, 2, "flaregun", 740, null, "Scorch Shot", null, "fg_draw", TF_AMMO.SECONDARY, 1, 16, null)
	TF_WEAPONS(7, 2, "rocketpack", 1179, null, "Thermal Thruster", null, "rocketpack_draw", TF_AMMO.GRENADES1, 2, -1, "models/weapons/c_models/c_rocketpack/c_rocketpack.mdl")
	TF_WEAPONS(7, 2, "jar_gas", 1180, null, "Gas Passer", null, "gascan_draw", TF_AMMO.GRENADES1, 1, -1, null)
	
	TF_WEAPONS(7, 3, "fireaxe", 2, 192, "Fire Axe", "Fireaxe", "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 38, null, "Axtinguisher", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 153, null, "Homewrecker", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 214, null, "Powerjack", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 326, null, "Back Scratcher", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 348, null, "Sharpened Volcano Fragment", "SVF", "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 457, null, "Postal Plummeler", "Mailbox", "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 466, null, "Maul", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 593, null, "Third-Degree", "Third Degree", "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "fireaxe", 739, null, "Lollichop", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "breakable_sign", 813, 834, "Neon Annihilator", null, "fa_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(7, 3, "slap", 1181, null, "Hot Hand", "Slap Glove", "slap_draw", TF_AMMO.NONE, -1, -1, null)

// Demo
	TF_WEAPONS(4, 1, "grenadelauncher", 19, 206, "Grenade Launcher", null, "g_draw", TF_AMMO.PRIMARY, 4, 16, null)
	TF_WEAPONS(4, 1, "grenadelauncher", 308, null, "Loch-n-Load", "Loch", "g_draw", TF_AMMO.PRIMARY, 3, 16, null)
	TF_WEAPONS(4, 1, "tf_wearable", 405, null, "Ali Baba's Wee Booties", "Booties", "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 1, "tf_wearable", 608, null, "Bootlegger", null, "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 1, "cannon", 996, null, "Loose Cannon", null, "", TF_AMMO.PRIMARY, 4, 16, null)
	TF_WEAPONS(4, 2, "parachute_primary", 1101, null, "B.A.S.E. Jumper Demo", "Demo Parachute", "", TF_AMMO.NONE, -1, -1, "models/workshop/weapons/c_models/c_paratooper_pack/c_paratrooper_pack.mdl")
	TF_WEAPONS(4, 1, "grenadelauncher", 1151, null, "Iron Bomber", null, "", TF_AMMO.PRIMARY, 4, 16, null)
	
	TF_WEAPONS(4, 2, "pipebomblauncher", 20, 207, "Stickybomb Launcher", null, "sb_draw", TF_AMMO.SECONDARY, 8, 24, null)
	TF_WEAPONS(4, 2, "pipebomblauncher", 130, null, "Scottish Resistance", "Sticky Resistance", "sb_draw", TF_AMMO.SECONDARY, 8, 36, null)
	TF_WEAPONS(4, 2, "pipebomblauncher", 265, null, "Sticky Jumper", null, "sb_draw", TF_AMMO.SECONDARY, 8, 72, null)
	TF_WEAPONS(4, 2, "pipebomblauncher", 1150, null, "Quickiebomb Launcher", null, "sb_draw", TF_AMMO.SECONDARY, 8, 72, null)
	TF_WEAPONS(4, 2, "demoshield", 131, null, "Chargin' Targe", "Targe", "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 2, "demoshield", 406, null, "Splendid Screen", null, "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 2, "demoshield", 1099, null, "Tide Turner", null, "", TF_AMMO.NONE, -1, -1, null)
	
	TF_WEAPONS(4, 3, "bottle", 1, 191, "Bottle", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "sword", 132, null, "Eyelander", null, "cm_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "sword", 172, null, "Scotsman's Skullcutter", "Skullcutter", "cm_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "stickbomb", 307, null, "Ullapool Caber", "Caber", "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "sword", 327, null, "Claidheamh Mor", "Claid", "cm_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(0, 3, "sword", 404, null, "Persian Persuader", "Persuader", "melee_allclass_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "sword", 266, null, "Horseless Headless Horseman's Headtaker", "HHHH", "cm_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "sword", 482, null, "Nessie's Nine Iron", "Golf Club", "cm_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "bottle", 609, null, "Scottish Handshake", null, "b_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(4, 3, "sword", 1082, null, "Festive Eyelander", null, "cm_draw", TF_AMMO.NONE, -1, -1, null)


// Heavy
	TF_WEAPONS(6, 1, "minigun", 15, 202, "Minigun", "Sasha", "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(6, 1, "minigun", 41, null, "Natascha", null, "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(6, 1, "minigun", 298, null, "Iron Curtain", null, "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(6, 1, "minigun", 312, null, "Brass Beast", null, "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(6, 1, "minigun", 424, null, "Tomislav", null, "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(6, 1, "minigun", 811, 832, "Huo-Long Heater", "Heater", "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	TF_WEAPONS(6, 1, "minigun", 850, null, "Deflector", null, "m_draw", TF_AMMO.PRIMARY, 200, -1, null)
	
	TF_WEAPONS(6, 2, "shotgun_hwg", 11, null, "Heavy Shotgun", null, "draw", TF_AMMO.SECONDARY, 6, 32, null)
	TF_WEAPONS(6, 2, "lunchbox", 42, null, "Sandvich", null, "sw_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(6, 2, "lunchbox", 159, null, "Dalokohs Bar", "Dalokohs", "sw_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(6, 2, "lunchbox", 311, null, "Buffalo Steak Sandvich", "Steak", "sw_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(6, 2, "shotgun", 425, null, "Family Business", null, "draw", TF_AMMO.SECONDARY, 8, 32, null)
	TF_WEAPONS(6, 2, "lunchbox", 433, null, "Fishcake", null, "sw_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(6, 2, "lunchbox", 863, null, "Robo-Sandvich", "Robo Sandvich", "sw_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(6, 2, "lunchbox", 1190, null, "Second Banana", "Banana", "sw_draw", TF_AMMO.GRENADES1, 1, -1, null)
	
	TF_WEAPONS(6, 3, "fists", 5, 195, "Fists", null, "f_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 43, null, "Killing Gloves of Boxing", "KGB", "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 239, null, "Gloves of Running Urgently", "GRU", "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 310, null, "Warrior's Spirit", "WS", "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 331, null, "Fists of Steel", "FOS", "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 426, null, "Eviction Notice", "EN", "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 587, null, "Apoco-Fists", null, "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 656, null, "Holiday Punch", null, "bg_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 1100, null, "Bread Bite", "Bread GRU", "breadglove_draw_A", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(6, 3, "fists", 1184, null, "Gloves of Running Urgently MvM", "GRU MVM", "bg_draw", TF_AMMO.NONE, -1, -1, null)
	
// Engineer
	TF_WEAPONS(9, 1, "shotgun_primary", 9, 199, "Shotgun Primary", "Engineer Shotgun", "fj_draw", TF_AMMO.PRIMARY, 6, 32, null)
	TF_WEAPONS(9, 1, "sentry_revenge", 141, null, "Frontier Justice", "FJ", "fj_draw", TF_AMMO.PRIMARY, 3, 32, null)
	TF_WEAPONS(9, 1, "shotgun_primary", 527, null, "Widowmaker", null, "fj_draw", TF_AMMO.METAL, 200, -1, null)
	TF_WEAPONS(9, 1, "drg_pomson", 588, null, "Pomson 6000", "Pomson", "pomson_draw", TF_AMMO.PRIMARY, 4, -1, null)
	TF_WEAPONS(9, 1, "shotgun_building_rescue", 997, null, "Rescue Ranger", null, "fj_draw", TF_AMMO.PRIMARY, 4, 20, null)
	
	TF_WEAPONS(9, 2, "pistol", 22, 209, "Engineer Pistol", null, "pstl_draw", TF_AMMO.SECONDARY, 12, 200, null)
	TF_WEAPONS(9, 2, "laser_pointer", 140, null, "Wrangler", null, "wgl_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 2, "mechanical_arm", 528, null, "Short Circuit", null, "pstl_draw", TF_AMMO.METAL, 200, -1, null)
	
	TF_WEAPONS(9, 3, "wrench", 7, 197, "Wrench", null, "pdq_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 3, "robot_arm", 142, null, "Gunslinger", null, "gun_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 3, "wrench", 155, null, "Southern Hospitality", null, "spk_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 3, "wrench", 329, null, "Jag", null, "pdq_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 3, "wrench", 589, null, "Eureka Effect", null, "pdq_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 3, "wrench", 169, null, "Golden Wrench", null, "pdq_draw", TF_AMMO.NONE, -1, -1, null)
	
	TF_WEAPONS(9, 4, "pda_engineer_build", 25, 737, "Build PDA", null, "bld_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 5, "pda_engineer_destroy", 26, null, "Destruction PDA", "Destroy PDA", "pda_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(9, 6, "builder", 28, null, "Engineer Toolbox", "Toolbox", "box_draw", TF_AMMO.NONE, -1, -1, null)
	
// Medic
	TF_WEAPONS(5, 1, "syringegun_medic", 17, 204, "Syringe Gun", "Syringegun", "sg_draw", TF_AMMO.PRIMARY, 40, 150, null)
	TF_WEAPONS(5, 1, "syringegun_medic", 36, null, "Blutsauger", null, "sg_draw", TF_AMMO.PRIMARY, 40, 150, null)
	TF_WEAPONS(5, 1, "crossbow", 305, null, "Crusader's Crossbow", "Crossbow", "sg_draw", TF_AMMO.PRIMARY, 1, 38, null)
	TF_WEAPONS(5, 1, "syringegun_medic", 412, null, "Overdose", null, "sg_draw", TF_AMMO.PRIMARY, 40, 150, null)
	
	TF_WEAPONS(5, 2, "medigun", 29, 211, "Medigun", null, "draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(5, 2, "medigun", 35, null, "Kritzkrieg", null, "draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(5, 2, "medigun", 441, null, "Quick-Fix", null, "draw", TF_AMMO.NONE, -1, -1, "models/weapons/c_models/c_proto_backpack/c_proto_backpack.mdl")
	TF_WEAPONS(5, 2, "medigun", 998, null, "Vaccinator", null, "draw", TF_AMMO.NONE, -1, -1, "models/workshop/weapons/c_models/c_medigun_defense/c_medigun_defensepack.mdl")
	
	TF_WEAPONS(5, 3, "bonesaw", 8, 198, "Bonesaw", null, "bs_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(5, 3, "bonesaw", 37, null, "Ubersaw", null, "bs_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(5, 3, "bonesaw", 173, null, "Vita-Saw", null, "bs_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(5, 3, "bonesaw", 304, null, "Amputator", null, "bs_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(0, 3, "bonesaw", 413, null, "Solemn Vow", null, "melee_allclass_draw", TF_AMMO.NONE, -1, -1, null)

// Sniper
	TF_WEAPONS(2, 1, "sniperrifle", 14, 201, "Sniper Rifle", null, "draw", TF_AMMO.PRIMARY, 25, -1, null)
	TF_WEAPONS(2, 1, "compound_bow", 56, null, "Huntsman", null, "bw_draw", TF_AMMO.PRIMARY, 1, 12, null)
	TF_WEAPONS(2, 1, "sniperrifle", 230, null, "Sydney Sleeper", null, "draw", TF_AMMO.PRIMARY, 25, -1, null)
	TF_WEAPONS(2, 1, "sniperrifle_decap", 402, null, "Bazaar Bargain", null, "draw", TF_AMMO.PRIMARY, 25, -1, null)
	TF_WEAPONS(2, 1, "sniperrifle", 526, null, "Machina", null, "draw", TF_AMMO.PRIMARY, 25, -1, null)
	TF_WEAPONS(2, 1, "sniperrifle", 752, null, "Hitman's Heatmaker", null, "draw", TF_AMMO.PRIMARY, 25, -1, null)
	TF_WEAPONS(2, 1, "sniperrifle", 851, null, "AWPer Hand", "AWP", "draw", TF_AMMO.PRIMARY, 25, -1, null)
	TF_WEAPONS(2, 1, "compound_bow", 1092, null, "Fortified Compound", null, "bw_draw", TF_AMMO.PRIMARY, 1, 12, null)
	TF_WEAPONS(2, 1, "sniperrifle_classic", 1098, null, "Classic", null, "draw", TF_AMMO.PRIMARY, 25, -1, null)
	
	TF_WEAPONS(2, 2, "smg", 16, 203, "SMG", null, "smg_draw", TF_AMMO.SECONDARY, 25, 75, null)
	TF_WEAPONS(2, 2, "razorback", 57, null, "Razorback", null, "", TF_AMMO.NONE, 1, -1, null)
	TF_WEAPONS(2, 2, "jar", 58, null, "Jarate", null, "pj_draw", TF_AMMO.GRENADES1, 1, -1, null)
	TF_WEAPONS(2, 2, "tf_wearable", 231, null, "Darwin's Danger Shield", "DDS", "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(2, 2, "tf_wearable", 642, null, "Cozy Camper", null, "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(2, 2, "charged_smg", 751, null, "Cleaner's Carbine", null, "", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(2, 2, "jar", 1105, null, "Self-Aware Beauty Mark", "Bread Jarate", "pj_draw", TF_AMMO.GRENADES1, 1, -1, null)
	
	TF_WEAPONS(2, 3, "club", 3, 193, "Kukri", null, "m_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(2, 3, "club", 171, null, "Tribalman's Shiv", null, "m_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(2, 3, "club", 232, null, "Bushwacka", null, "m_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(2, 3, "club", 401, null, "Shahanshah", null, "m_draw", TF_AMMO.NONE, -1, -1, null)
		
// Spy
	TF_WEAPONS(8, 1, "revolver", 24, 210, "Revolver", null, "draw", TF_AMMO.SECONDARY, 6, 24, null)
	TF_WEAPONS(8, 1, "revolver", 61, null, "Ambassador", null, "draw", TF_AMMO.SECONDARY, 6, 24, null)
	TF_WEAPONS(8, 1, "revolver", 161, null, "Big Kill", null, "draw", TF_AMMO.SECONDARY, 6, 24, null)
	TF_WEAPONS(8, 1, "revolver", 224, null, "L'Etranger", null, "draw", TF_AMMO.SECONDARY, 6, 24, null)
	TF_WEAPONS(8, 1, "revolver", 460, null, "Enforcer", null, "draw", TF_AMMO.SECONDARY, 6, 24, null)
	TF_WEAPONS(8, 1, "revolver", 525, null, "Diamondback", null, "draw", TF_AMMO.SECONDARY, 6, 24, null)
	
	TF_WEAPONS(8, 6, "builder", 735, 736, "builder_spy", "Sapper", "c_sapper_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 6, "sapper", 810, 831, "Red-Tape Recorder", "Red Tape", "c_sd_sapper_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 6, "sapper", 933, null, "Ap-Sap", null, "c_sapper_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 6, "sapper", 1102, null, "Snack Attack", "Bread Sapper", "c_breadmonster_sapper_draw", TF_AMMO.NONE, -1, -1, null)
	
	TF_WEAPONS(8, 3, "knife", 4, 194, "Knife", null, "knife_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 225, null, "Your Eternal Reward", "YER", "eternal_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 356, null, "Conniver's Kunai", "Kunai", "eternal_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 461, null, "Big Earner", null, "eternal_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 574, null, "Wanga Prick", null, "eternal_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 638, null, "Sharp Dresser", null, "acr_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 649, null, "Spy-cicle", null, "eternal_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 3, "knife", 727, null, "Black Rose", null, "knife_draw", TF_AMMO.NONE, -1, -1, null)
	
	TF_WEAPONS(8, 4, "pda_spy", 947, null, "Disguise Kit PDA", "Disguise Kit", "offhand_draw", TF_AMMO.NONE, -1, -1, null)
	
	TF_WEAPONS(8, 5, "invis", 30, 212, "Invis Watch", "Invis", "offhand_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 5, "invis", 59, null, "Dead Ringer", null, "offhand_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 5, "invis", 60, null, "Cloak and Dagger", "CAD", "offhand_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 5, "invis", 297, null, "Enthusiast's Timepiece", "Timepiece", "offhand_draw", TF_AMMO.NONE, -1, -1, null)
	TF_WEAPONS(8, 5, "invis", 947, null, "Quackenbirdt", null, "offhand_draw", TF_AMMO.NONE, -1, -1, null)
]
