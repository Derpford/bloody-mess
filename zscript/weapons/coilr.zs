class CoilRepeater : BloodyWeapon replaces Chaingun
{
	// A heavy coilgun with full-auto capability. Spins up as it fires, shooting faster but less accurately.
	mixin Spinner;

	int shotSpeed;
	int shotCount;

	Property FireRate : shotSpeed;

	default
	{
		Weapon.SlotNumber 4;
		Weapon.AmmoType1 "Coil";
		Weapon.AmmoUse1 2;
		Weapon.MinSelectionAmmo1 1;
		Weapon.AmmoGive1 25;
		CoilRepeater.FireRate 4;
		Inventory.PickupMessage "Retrieved a Coil Repeater!";
	}

	action void A_FireCoil(int used = 1)
	{
		A_TakeInventory("Coil",used);
		A_WeaponOffset(0,16,WOF_ADD);
		A_OverlayScale(1,1.4,1.4,WOF_INTERPOLATE);
		A_FireProjectile("CoilTracer",frandom(-2.2,2.2)*(4 - invoker.shotSpeed),false,pitch:frandom(0.1,-0.15)*(4 - invoker.shotSpeed) );
	}

	states
	{
		Spawn:
			REPG I -1;
			Stop;
		Select:
			REPG DCBA 1 A_Raise(24);
			Loop;
		Deselect:
			REPG ABCD 1 A_Lower(24);
			Loop;
		Ready:
			REPG AAABBBCCCDDD 3 
			{
				int offs = -2;
				if(GetAge() % 2 == 0) { offs = 2; }
				A_WeaponOffset(0,offs+24,WOF_INTERPOLATE);
				if(GetAge() % 2 == 0) { A_StartSound("weapon/repi"); }
				A_WeaponReady(WRF_NOBOB);
				A_OverlayPivot(1,0.7);
				A_OverlayScale(1,1.0,1.0,WOF_INTERPOLATE);
				if(invoker.shotspeed<4) { return ResolveState("SpinDown"); } else { return ResolveState(null); }
			}
			Loop;
		Fire:
			REPG ABCD 0 { A_SetTics(invoker.shotSpeed); A_StartSound("weapon/repsu",4,flags:CHANF_NOSTOP); }
			Goto FireReal;
		Hold:
			REPG A 0
			{
				if(invoker.shotSpeed == 0) { return ResolveState("FullAuto"); } else { return ResolveState(null); }
			}
			REPG ABCD 0 
			{ 
				A_WeaponOffset(0,-4,WOF_ADD); 
				A_OverlayScale(1,-0.1,-0.1,WOF_ADD);
				A_SetTics(invoker.shotSpeed); 
				A_StartSound("weapon/repsu",4,flags:CHANF_NOSTOP); 
			}
		FireReal:
			REPG E 0
			{
				A_StopSound(4);
				invoker.shotCount += 1;
				if(invoker.shotCount % (10 - (2*invoker.shotSpeed) ) == 0)//&& invoker.shotSpeed > 2) || invoker.shotCount % 8 == 0)
				{
					invoker.shotCount = 0;
					invoker.shotSpeed = max(invoker.shotSpeed-1,0);
				}
			}
			REPG E 1 Bright 
			{ 
				A_SetTics(invoker.shotSpeed); 
				A_StartSound("weapon/repf",1); 
				A_FireCoil(2);
			} // shot goes here
			REPG E 0 { A_Refire("Hold"); }
			Goto SpinDown;
		FullAuto:
			REPG E 1 Bright { A_StartSound("weapon/repf",1); A_FireCoil(); } // and here
			REPG AB 1 { A_WeaponOffset(0,-8,WOF_ADD); A_OverlayScale(1,-0.2,-0.2,WOF_ADD); }
			REPG F 1 Bright { A_StartSound("weapon/repf",1); A_FireCoil(); } // and here
			REPG BC 1 { A_WeaponOffset(0,-8,WOF_ADD); A_OverlayScale(1,-0.2,-0.2,WOF_ADD); }
			REPG G 1 Bright { A_StartSound("weapon/repf",1); A_FireCoil(); } // and here
			REPG CD 1 { A_WeaponOffset(0,-8,WOF_ADD); A_OverlayScale(1,-0.2,-0.2,WOF_ADD); }
			REPG H 1 Bright { A_StartSound("weapon/repf",1); A_FireCoil(); } // and here
			REPG DA 1 { A_WeaponOffset(0,-8,WOF_ADD); A_OverlayScale(1,-0.2,-0.2,WOF_ADD); }
			REPG E 0 { A_Refire("Hold"); }
		SpinDown:
			REPG ABCD 0 { A_SetTics(invoker.shotSpeed); A_WeaponOffset(0,32,WOF_INTERPOLATE); A_Refire(); A_StartSound("weapon/repsd",flags:CHANF_NOSTOP); }
			REPG A 0
			{
				if(invoker.shotSpeed < 4)
				{
					invoker.shotSpeed += 1;
					return ResolveState("SpinDown");
				}
				else
				{
					return ResolveState("Ready");
				}
			}
			goto Ready;
	}
}

class CoilTracer : FastProjectile
{
	// The tracer that the Coil Repeater fires.
	// Does no damage! Damage is handled by the shockwave.
	default
	{
		+RIPPER;
		Scale 0.5;
		RenderStyle "Add";
		DamageFunction 4;
		MissileType "CoilShockwave";
		MissileHeight 3;
		Radius 4;
		Speed 80;
	}

	states
	{
		Spawn:
			RPUF A 1;
			Loop;
		Death:
			RPUF ABCDEF 1;
			Stop;
	}
}

class CoilShockwave : Actor
{
	// The shockwave left in the tracer's wake.
	// Does the actual damage.
	default
	{
		+NOGRAVITY;
		+NOINTERACTION;
		Scale 0.3;
		RenderStyle "Add";
		Alpha 0.3;
	}

	states
	{
		Spawn:
			RPUF A 0;
			RPUF A 0; //{ if(target) { target = target.target; } }
			// Normally, A_Explode does not hurt its owner.
			// However, its owner is tracked via the `target` var,
			// which for a FastProjectile's trail actors, is the FastProjectile.
			// We get around this by setting our target to our target's target, which is the player.
			RPUF FDBA 1;
			//RPUF A 0 A_Explode(4,8,XF_NOSPLASH,true,4);
			RPUF BCDEF 1;
			Stop;
	}
}