class NailShotty : Weapon replaces Shotgun
{
	// A nail-firing shotgun. Shoots a square pattern of nails.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 2;
		Weapon.AmmoType1 "Nail";
		Weapon.AmmoUse1 0;
		Weapon.MinSelectionAmmo1 2;
		Weapon.AmmoGive 4;
		Inventory.PickupMessage "Snagged a Nail Shotgun!";
	}

	states
	{
		Spawn:
			TACT I -1;
			Stop;
		Select:
			TACT A 1 A_Raise(18);
			Loop;
		Deselect:
			TACT A 1 A_Lower(18);
			Loop;
		Ready:
			TACT A 1 
			{
				if(CountInv("Nail") > 0) { A_WeaponReady(); } else { A_WeaponReady(WRF_NOFIRE); }
			}
			Loop;
		Fire:
			TACT E 2 Bright 
			{ 
				A_TakeInventory("Nail",2);
				A_StartSound("weapons/shotgf");
				// Technically, I could do this with a loop, but I don't want to deal with that.
				A_FireProjectile("NailShot",-1.3,spawnheight: 8, pitch: -1.3); 
				A_FireProjectile("NailShot",1.3,spawnheight: 8, pitch: -1.3); 
				A_FireProjectile("NailShot",-1.3,spawnheight: 8, pitch: 1.3); 
				A_FireProjectile("NailShot",1.3,spawnheight: 8, pitch: 1.3); 
				A_FireProjectile("NailShot",-1.8,spawnheight: 8);
				A_FireProjectile("NailShot",1.8,spawnheight: 8);
				A_FireProjectile("NailShot2",0,spawnheight: 8);
			}
			TACT F 2 Bright; 
			TACT A 5;
			TACT BC 4;
			TACT D 3 A_StartSound("weapon/shotr");
			TACT CB 3;
			TACT A 2;
			Goto Ready;

	}
}

class NailShot : FastProjectile
{
	// A heavy iron nail. Does just a little less damage than a blaster shot by itself, but a group of 5...

	default
	{
		Speed 40;
		DamageFunction 7;
		Radius 3;
		Height 6;
		MissileHeight 8;
		MissileType "SmokeTrail";
	}

	states
	{
		Spawn:
			NLPJ A 1;
			Loop;
		Death:
			NLPJ BC 1 Bright { A_SetRenderStyle(1.0,STYLE_Add); A_StartSound("weapon/nailh",flags:CHANF_OVERLAP); }
			NLPJ DEFG 1;
			Stop;
		XDeath:
			BLUD A 1 { A_StartSound("weapon/nailhx",flags:CHANF_OVERLAP); }
			BLUD BCD 1;
			Stop;
	}
}

class NailShot2 : NailShot
{
	// Faster, deadlier center nail.
	default
	{
		Speed 50;
		DamageFunction 12;
	}
}

class SmokeTrail : Actor
{
	// The smoky trail off a flying nail.

	default
	{
		RenderStyle "add";
		Scale 0.5;
		Alpha 0.3;
		+NOGRAVITY;
	}

	states
	{
		Spawn:
			NLPJ BCDEFG 1;
			Stop;
	}
}