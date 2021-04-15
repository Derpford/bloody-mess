class Undertaker : BloodyWeapon replaces BFG9000
{
	// A powerful demontech weapon that corrupts light gems to fire exploding balls of hellish power.

	mixin Spinner;

	default
	{
		Weapon.SlotNumber 5;
		Weapon.AmmoType1 "LightGem";
		Weapon.AmmoUse1 0;
		Weapon.MinSelectionAmmo1 1;
		Weapon.AmmoGive1 20;
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
				A_ReadyIfAmmo();

				if(random(0,16)<1) { return ResolveState("Idle"); } else { return ResolveState(null); }
			}
			Loop;
		Idle:
			UNMK ABCOCOCBCBA 3 A_ReadyIfAmmo();
			Goto Ready;
		Fire:
			UNMK D 2
			{
				//Shot goes here.
				A_StartSound("weapon/underf");
				A_FireProjectile("UndertakerShot");
				A_TakeInventory("LightGem",4);
				A_WeaponOffset(16,16,WOF_ADD);
			}
			UNMK OB 3 A_WeaponOffset(8,8,WOF_ADD);
			UNMK OCA 2 A_WeaponOffset(-8,-8,WOF_ADD);
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
		DamageFunction 80;
		DamageType "Disintegrate";
		RenderStyle "Add";
	}

	states
	{
		Spawn:
			REDT A 1 Bright;
			Loop;
		Death:
			REDB A 4 Bright A_StartSound("weapon/underx");
			REDE A 5 Bright A_Explode(80);
			REDE B 6 Bright;
			REDE C 8 Bright;
			REDE D 4 Bright;
			Stop;
	}
}