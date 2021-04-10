class Bolter : Weapon
{
	// Starting weapon. Infinite-ammo projectile weapon with reasonable accuracy.
	// Think Q2 blaster.
	default
	{
		Weapon.SlotNumber 1;
	}

	states
	{
		Select:
			PLBG A 1 A_Raise(18);
			Loop;
		Deselect:
			PLBG A 1 A_Lower(18);
			Loop;
		Ready:
			PLBG A 1 A_WeaponReady();
			Loop;
		Fire:
			PLBG B 3 Bright 
			{ 
				A_FireProjectile("BolterShot"); 
				A_StartSound("weapon/boltf"); 
				A_WeaponOffset(8,0,WOF_ADD);
			}
			PLBG A 3 A_WeaponOffset(8,6,WOF_ADD);
			PLBG C 4 A_WeaponOffset(4,4,WOF_ADD);
			PLBG A 3 A_WeaponOffset(-4,0,WOF_ADD);
			PLBG A 3 A_WeaponOffset(-16,-3,WOF_ADD);
			PLBG A 2 A_WeaponOffset(0,-7,WOF_ADD);
			Goto Ready;

	}
}

class BolterShot : FastProjectile
{
	// The bolter shot. 
	default
	{
		DamageFunction 10;
		MissileType "BolterTrail";
		+ROLLSPRITE;
		Speed 30;
		Projectile;
		Scale 0.5;
		Radius 6;
		Height 12;
		MissileHeight 8;
		RenderStyle "add";
	}
	states
	{
		Spawn:
			DLIT J 1 { roll += 12; }
			Loop;
		Death:
			DLIT O 1 A_StartSound("weapon/bolth");
			DLIT NMLKJ 1;
			DLIT JKLMNO 1;
			Stop;
	}
}

class BolterTrail : Actor
{
	// The trail from the bolter.
	default
	{
		RenderStyle "add";
		+ROLLSPRITE;
		+NOGRAVITY;
		Scale 0.5;
	}
	states
	{
		Spawn:
			DLIT K 0;
			DLIT K 0 { A_ChangeVelocity(0,random(-1,1),random(-1,1),CVF_RELATIVE); }
			DLIT KLMNO 2 { roll += 15; }
			Stop;
	}
}