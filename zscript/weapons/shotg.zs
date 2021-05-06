class NailShotty : BloodyWeapon replaces Shotgun
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
				A_ReadyIfAmmo();
				A_OverlayPivot(1,wy:0);
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
				A_OverlayScale(1,1.8,1.8,WOF_INTERPOLATE);
			}
			TACT F 2 Bright A_OverlayScale(1,1.5,1.5,WOF_INTERPOLATE); 
			TACT A 3 
			{	
				A_OverlayScale(1,1.25,1.25,WOF_INTERPOLATE);
				A_WeaponOffset(0,5,WOF_ADD);
			}
			TACT A 2 
			{
				A_OverlayScale(1,1.0,1.0,WOF_INTERPOLATE);
				A_OverlayRotate(1,10,WOF_ADD);
			}
			TACT BC 3 
			{
				A_WeaponOffset(0,5,WOF_ADD);
			}
			TACT D 5 A_StartSound("weapon/shotr");
			TACT CB 3 
			{
				A_OverlayRotate(1,-5,WOF_ADD);
				A_WeaponOffset(0,-5,WOF_ADD);
			}
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
		DamageFunction 8;
		Radius 3;
		Height 3;
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
		+NOINTERACTION;
	}

	states
	{
		Spawn:
			NLPJ BCDEFG 1;
			Stop;
	}
}