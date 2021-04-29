class CoilCarbine : BloodyWeapon replaces Pistol
{
	// A rifle fitted to fire Coil rounds.
	// Slower than the Coil Repeater's max ROF, slightly less accurate than the Coil Repeater's initial shots, has no piercing...
	//...but higher ROF than the Coil Repeater starts at, good single-target damage, and maintains a steady fire rate.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 2;
		Weapon.SlotPriority 0.1;
		Weapon.AmmoType1 "Coil";
		Weapon.AmmoUse1 0;
		Weapon.MinSelectionAmmo1 2;
		Weapon.AmmoGive1 18;
		Inventory.PickupMessage "Collected a Coil Carbine!";
	}

	states
	{
		Spawn:
			PLZM E -1;
			Stop;
		Select:
			PLZM D 1 A_Raise(18);
			Loop;
		Deselect:
			PLZM D 1 A_Lower(18);
			Loop;
		Ready:
			PLZM A 1 A_ReadyIfAmmo();
			Loop;
		Fire:
			PLZM B 1
			{
				A_StartSound("weapon/carf",1);
				A_TakeInventory("Coil",2);
				A_FireProjectile("CoilCarbineShot",frandom(-2.0,2.0),pitch:frandom(0,-0.8));
			}
			PLZM C 2 A_WeaponOffset(0,12,WOF_ADD);
			PLZM CD 2 A_WeaponOffset(0,-4,WOF_ADD);
			PLZM A 1 A_WeaponOffset(0,-4,WOF_ADD);
			Goto Ready;
	}
}

class CoilCarbineShot : FastProjectile
{
	// The Coil Carbine's projectile.

	default
	{
		DamageFunction 20;
		MissileType "CoilCarbTrail";
		MissileHeight 8;
		RenderStyle "Add";
		Speed 60;
	}

	states
	{
		Spawn:
			PLZM MN 4 Bright;
			Loop;
		Death:
			PLZM F 0 A_StartSound("weapon/carh");
			PLZM FGHIJKLM 2 Bright;
			Stop;
	}
}

class CoilCarbTrail : Actor
{
	default
	{
		+NOINTERACTION;
		scale 0.5;
		RenderStyle "Add";
	}

	states
	{
		Spawn:
			PLZM GF 1 Bright 
			{ 
				A_SetScale(scale.x-0.02);
				if(scale.x<0.1)
				{
					return ResolveState("Death");
				}
				else
				{
					return ResolveState(null);
				}
			}
			Loop;
		Death:
			PLZM HIJKLM 1;
			Stop;
	}
}