class BloodyWeapon : Weapon
{
	// Adds a util function for checking the weapon's ammo.

	action void A_ReadyIfAmmo(int flags = 0)
	{
		int amt = invoker.owner.CountInv(invoker.AmmoType1);
		if(amt>invoker.MinSelAmmo1 || amt>invoker.AmmoUse1)
		{
			A_WeaponReady(flags);
		}
		else
		{
			A_WeaponReady(flags|WRF_NOFIRE);
		}
	}

	action void A_RefireIfAmmo(StateLabel st = "Fire",StateLabel backup = "Ready")
	{
		int amt = invoker.owner.CountInv(invoker.AmmoType1);
		if(amt>invoker.MinSelAmmo1 || amt>invoker.AmmoUse1)
		{
			A_Refire(st);
		}
		else
		{
			A_Refire(backup);
		}
	}
}