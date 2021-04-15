class ThermiteGrinder : Weapon replaces SuperShotgun
{
	// A device that grinds iron scrap into thermite, lobbing molten firebombs.
	// Like a GL, but like, on fire.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "Nail";
		Weapon.AmmoGive1 12;
		Weapon.AmmoUse1 0;
		Weapon.MinSelectionAmmo1 3;
		Inventory.PickupMessage "Tracked down a Thermite Grinder!";
	}

	states
	{
		Spawn:
			NLSG D -1;
			Stop;
		Select:
			NLSG A 1 A_Raise(18);
			Loop;
		Deselect:
			NLSG A 1 A_Lower(18);
			Loop;
		Ready:
			NLSG A 1 
			{ 
				if(CountInv("Nail")>=2) { A_WeaponReady(); } Else { A_WeaponReady(WRF_NOFIRE); }
			}
			Loop;
		Fire:
			NLSG B 2
			{
				// Shot goes here.
				A_TakeInventory("Nail",3);
				for ( int i = -1; i <= 1; i++ )
				{
					A_FireProjectile("ThermiteBall",angle:i*10,pitch:-10);
				}
				A_WeaponOffset(0,12,WOF_ADD);
				A_StartSound("weapon/thermf");
			}
			NLSG C 2 A_WeaponOffset(0,8,WOF_ADD);
			NLSG A 5;
			NLSG A 8 A_WeaponOffset(0,-10,WOF_ADD);
			NLSG A 5;
			NLSG A 6 A_WeaponOffset(0,-10,WOF_ADD);
			Goto Ready;
	}
	
}

class ThermiteBall : Actor
{
	// A ball of ignited thermite.

	default
	{
		+FLATSPRITE;
		PROJECTILE;
		-NOGRAVITY;
		RenderStyle "Add";
		Speed 25;
		Height 8;
		Radius 8;
		DamageFunction 12;
		DamageType "Thermite";
	}

	states
	{
		Spawn:
			MANF AB 3 Bright
			{
				pitch = -5*vel.z;
			}
			Loop;
		Death:
			MISL B 8 Bright
			{
				bNOGRAVITY = true;
				A_StartSound("weapon/macrox");
				A_Explode(36,40,flags:0,fulldamagedistance:20);
				for (int i = 0; i < 360; i += 90)
				{
					A_SpawnItemEX("ThermiteFlame",xofs:8,xvel:1,angle:i);
				}
			}
			MISL C 6 Bright;
			MISL D 4 Bright;
			Stop;
	}

}

class ThermiteFlame : Actor
{
	// A special effect.

	default
	{
		+WALLSPRITE;
		+NOINTERACTION;
		RenderStyle "Add";
	}

	states
	{
		Spawn:
			FIRE ABCDEFGH 3 Bright;
			Stop;
	}
}