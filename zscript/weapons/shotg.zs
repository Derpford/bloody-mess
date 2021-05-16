class NailShotty : BloodyWeapon replaces Shotgun
{
	// A nail-firing shotgun. Shoots a square pattern of nails.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 2;
		Weapon.SlotPriority 0.5;
		Weapon.AmmoType1 "Nail";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive 4;
		Inventory.PickupMessage "Snagged a Nail Shotgun!";
	}

	action void A_FireNails()
	{
		//invoker.owner.A_TakeInventory("Nail",1);
		invoker.owner.A_StartSound("weapon/shotf");
		double j = GetAge()%360;
		for(int i = 0; i<=360; i+=120)
		{
			A_FireProjectile("NailShot",cos(i+j)*1.1,false,spawnheight: 8,pitch:sin(i+j)*1.1);
		}
		A_FireProjectile("NailShot2",0,spawnheight: 8);
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
				A_WeaponReady();
				A_OverlayPivot(1,wy:0);
			}
			Loop;
		Fire:
			TACT E 2 Bright 
			{ 
				A_FireNails();
				A_OverlayScale(1,1.8,1.8,WOF_INTERPOLATE);
				A_WeaponOffset();
				A_OverlayRotate(1,0);
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
			}
			TACT A 4 A_WeaponOffset(0,-5,WOF_ADD);
			TACT A 0 A_Refire();
		Pump:
			TACT A 5 
			{
				A_OverlayRotate(1,10,WOF_ADD);
				A_WeaponOffset(0,15,WOF_ADD);
				A_Refire();
			}
			TACT BC 4 
			{
				A_WeaponOffset(0,15,WOF_ADD);
				A_Refire();
			}
			TACT D 6 
			{
				A_StartSound("weapon/shotr");
				A_Refire();
			}
			TACT CB 4 
			{
				A_OverlayRotate(1,-5,WOF_ADD);
				A_WeaponOffset(0,-15,WOF_ADD);
				A_Refire();
			}
			TACT A 4 A_Refire();
			Goto Ready;

	}
}

class NailShot : FastProjectile
{
	// A heavy iron nail, doing about as much damage as a bolter blast would to a healthy enemy.
	default
	{
		Speed 40;
		DamageFunction 10;
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