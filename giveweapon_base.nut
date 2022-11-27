// FUNCTION: All weapon properties. List gathered by ficool2.
 
::CTFPlayer.AddWeapon <- function(classname, itemindex, slot)
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
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags | 4);

	NetProps.SetPropEntityArray(this, "m_hMyWeapons", weapon, slot)
	NetProps.SetPropInt(weapon, "m_iTeamNum", this.GetTeam())
	
	solidFlags = NetProps.GetPropInt(weapon, "m_Collision.m_usSolidFlags");
	NetProps.SetPropInt(weapon, "m_Collision.m_usSolidFlags", solidFlags & ~(4));
	
	DoEntFire("!self", "SetParent", "!activator", 0, this, weapon)
	NetProps.SetPropInt(weapon, "m_MoveType", 0)
	
	weapon.SetLocalOrigin(this.GetLocalOrigin())
	weapon.SetLocalAngles(this.GetAbsAngles())
	
	NetProps.SetPropInt(weapon, "m_bClientSideAnimation", 1)
	NetProps.SetPropInt(weapon, "m_fEffects", 129)
	NetProps.SetPropInt(weapon, "m_iState", 2)
	NetProps.SetPropInt(weapon, "m_CollisionGroup", 11)
	
	NetProps.SetPropEntity(weapon, "m_hOwnerEntity", this)
	NetProps.SetPropEntity(weapon, "LocalActiveWeaponData.m_hOwner", this)
	
	local curTime = Time()
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextPrimaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flNextSecondaryAttack", curTime)
	NetProps.SetPropFloat(weapon, "LocalActiveWeaponData.m_flTimeWeaponIdle", curTime)
	
	NetProps.SetPropInt(weapon, "m_bValidatedAttachedEntity", 1)
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_iReapplyProvisionParity", 3)
	
	NetProps.SetPropInt(weapon, "m_AttributeManager.m_Item.m_bOnlyIterateItemViewAttributes", 1)
	
}


/*FUNCTION: Finds an empty weapon equipment slot and gives weapon to the player
*/

::CTFPlayer.GiveWeapon <- function(weapon, itemID)
{
	local YourNewGunSaxtonApproved = null

	for (local i = 0; i < 10; i++)
	{
		local wep = NetProps.GetPropEntityArray(this, "m_hMyWeapons", i)

		if ( wep == null ) {
			YourNewGunSaxtonApproved = this.AddWeapon(weapon, itemID, i)
			break
		}
	}
}

// OPTIONAL FUNCTION: Shows all equips and item IDs in chat.

// USE: CheckItems()

::CheckItems <- function()
{
	local ActiveWeapon = GetListenServerHost().GetActiveWeapon()
	local ActiveWeapon_itemID = NetProps.GetPropInt(ActiveWeapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")

	Say(GetListenServerHost(), " ", false)
	Say(GetListenServerHost(), "Active "+" ["+ActiveWeapon.GetClassname()+"] (ItemID = "+ActiveWeapon_itemID+")", false)
	
	for (local i = 0; i < 10; i++)
	{
		local wep = NetProps.GetPropEntityArray(GetListenServerHost(), "m_hMyWeapons", i)
		local wep_itemID = NetProps.GetPropInt(wep, "m_AttributeManager.m_Item.m_iItemDefinitionIndex")
		if ( wep != null && wep != ActiveWeapon)
		{
			Say(GetListenServerHost(), "["+wep.GetClassname()+"] (ItemID = "+wep_itemID+")", false)
		}
	}
}

//Yaki was here
