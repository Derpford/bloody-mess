class Undertaker : BloodyWeapon replaces BFG9000
{
	// A powerful demontech weapon that corrupts light gems to fire exploding balls of hellish power.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 0.5;
		Weapon.AmmoType1 "LightGem";
		Weapon.AmmoUse1 4;
		//Weapon.MinSelectionAmmo1 1;
		Weapon.AmmoGive1 20;
		Inventory.PickupMessage "Unearthed the Undertaker! God as my witness, this thing is broken.";
	}

	action void A_UndertakerReady()
	{
		A_OverlayPivot(1,0.2,0.2);
		A_WeaponReady();
	}

	states
	{
		Spawn:
			UNMA A -1;
			Stop;
		Select:
			UNMK A 1 A_Raise(18);
			Loop;
		Deselect:
			UNMK A 1 A_Lower(18);
			Loop;
		Ready:
			UNMK A 1 
			{
				A_UndertakerReady();

				if(random(0,16)<1) { return ResolveState("Idle"); } else { return ResolveState(null); }
			}
			Loop;
		Idle:
			UNMK ABCOCOCBCBA 3 A_UndertakerReady();
			Goto Ready;
		Fire:
			UNMK D 2
			{
				//Shot goes here.
				A_StartSound("weapon/underf");
				A_FireProjectile("UndertakerShot");
				//A_TakeInventory("LightGem",4);
				A_WeaponOffset(16,16,WOF_ADD);
				A_OverlayScale(1,1.6,1.6,WOF_INTERPOLATE);
			}
			UNMK OB 3 A_WeaponOffset(8,8,WOF_ADD);
			UNMK OCA 2 
			{
				A_WeaponOffset(-8,-8,WOF_ADD);
				A_OverlayScale(1,-0.2,-0.2,WOF_ADD);
			}
			Goto Ready;
	}
}

class UndertakerShot : FastProjectile
{
	// A ball of awful nasty stuff.

	default
	{
		Speed 60;
		Radius 8;
		Height 4;
		MissileType "UndertakerTrail";
		MissileHeight 8;
		DamageFunction 80;
		DamageType "Disintegrate";
		RenderStyle "Add";
	}

	states
	{
		Spawn:
			REDT AB 3 Bright;
			Loop;
		Death:
			REDB A 4 Bright { A_StartSound("weapon/underx",1); A_StartSound("weapon/underxd"); } 
			REDE A 5 Bright A_Explode(80);
			REDE B 6 Bright;
			REDE C 8 Bright;
			REDE D 4 Bright;
			Stop;
	}
}

class UndertakerTrail : Actor
{
	default
	{
		+NOINTERACTION;
		Scale 0.5;
		RenderStyle "Add";
	}

	states
	{
		Spawn:
			DBLD ABCD 1 Bright;
			Stop;
	}
}