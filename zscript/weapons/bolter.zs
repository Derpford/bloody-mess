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
			PLBG B 2 { A_FireProjectile("BolterShot"); A_StartSound("weapon/boltf"); }
			PLBG C 5;
			PLBG A 4;
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
			DLIT ONMLKJ 1;
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