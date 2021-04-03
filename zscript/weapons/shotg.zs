class NailShotty : Weapon replaces Shotgun
{
	// A nail-firing shotgun. Shoots a square pattern of nails.

	default
	{
		Weapon.SlotNumber 2;
		Weapon.AmmoType1 "Nail";
		Weapon.AmmoUse1 0;
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
			TACT A 1 A_Raise(18);
			Loop;
		Ready:
			TACT A 1 A_WeaponReady;
			Loop;
		Fire:
			TACT E 2 
			{ 
				A_StartSound("weapons/shotgf");
				// Technically, I could do this with a loop, but I don't want to deal with that.
				A_FireProjectile("NailShot",-2.3,spawnheight: 8, pitch: -2.3); 
				A_FireProjectile("NailShot",2.3,spawnheight: 8, pitch: -2.3); 
				A_FireProjectile("NailShot",-2.3,spawnheight: 8, pitch: 2.3); 
				A_FireProjectile("NailShot",2.3,spawnheight: 8, pitch: 2.3); 
			}
			TACT F 2 { A_FireProjectile("NailShot",0,spawnheight: 8); }
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
			NLPJ BC 1 Bright { A_SetRenderStyle(1.0,STYLE_Add); }
			NLPJ DEFG 1;
			Stop;
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