class CoilRepeater : Weapon
{
	// A heavy coilgun with full-auto capability. Spins up as it fires, shooting faster but less accurately.
	mixin Spinner;

	int shotSpeed;
	int shotCount;

	Property FireRate : shotSpeed;

	default
	{
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "Coil";
		Weapon.AmmoUse1 0;
		Weapon.AmmoGive1 25;
		CoilRepeater.FireRate 4;
	}

	action void A_FireCoil()
	{
		A_TakeInventory("Coil",1);
		A_FireProjectile("CoilTracer",frandom(-1,1)*(4 - invoker.shotSpeed),pitch:frandom(0,-1.5)*(4 - invoker.shotSpeed) );
	}

	states
	{
		Select:
			REPG DCBA 1 A_Raise(12);
			Loop;
		Deselect:
			REPG ABCD 1 A_Lower(12);
			Loop;
		Ready:
			REPG A 1 
			{
				if(CountInv("Coil")>0) { A_WeaponReady(); } else { A_WeaponReady(WRF_NOFIRE); }
			}
			Loop;
		Fire:
		FireHold:
			REPG A 0
			{
				if(invoker.shotSpeed == 0) { return ResolveState("FullAuto"); } else { return ResolveState(null); }
			}
			REPG ABCD 0 { A_SetTics(invoker.shotSpeed); A_StartSound("weapon/repsu",4,flags:CHANF_NOSTOP); }
			REPG E 0
			{
				A_StopSound(4);
				invoker.shotCount += 1;
				if((invoker.shotCount % 4 == 0 && invoker.shotSpeed > 2) || invoker.shotCount % 8 == 0)
				{
					invoker.shotCount = 0;
					invoker.shotSpeed = max(invoker.shotSpeed-1,0);
				}
			}
			REPG E 0 
			{ 
				A_SetTics(invoker.shotSpeed); 
				A_StartSound("weapon/repf",1); 
				A_FireCoil();
			} // shot goes here
			REPG E 0 A_Refire();
			Goto SpinDown;
		FullAuto:
			REPG E 1 { A_StartSound("weapon/repf",1); A_FireCoil();} // and here
			REPG A 1;
			REPG B 1;
			REPG F 1 { A_StartSound("weapon/repf",1); A_FireCoil();} // and here
			REPG B 1;
			REPG C 1;
			REPG G 1 { A_StartSound("weapon/repf",1); A_FireCoil();} // and here
			REPG C 1;
			REPG D 1;
			REPG H 1 { A_StartSound("weapon/repf",1); A_FireCoil();} // and here
			REPG D 1;
			REPG A 1;
			REPG E 0 A_Refire();
		SpinDown:
			REPG ABCD 0 { A_SetTics(invoker.shotSpeed); A_Refire(); A_StartSound("weapon/repsd",flags:CHANF_NOSTOP); }
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
		+THRUACTORS;
		Scale 0.5;
		RenderStyle "Add";
		DamageFunction 0;
		MissileType "CoilShockwave";
		MissileHeight 8;
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
		Scale 0.3;
		RenderStyle "Add";
		Alpha 0.3;
	}

	states
	{
		Spawn:
			RPUF A 0;
			RPUF A 0 { target = target.target; }
			// Normally, A_Explode does not hurt its owner.
			// However, its owner is tracked via the `target` var,
			// which for a FastProjectile's trail actors, is the FastProjectile.
			// We get around this by setting our target to our target's target, which is the player.
			RPUF FDBA 1;
			RPUF A 0 A_Explode(2,8,XF_NOSPLASH,true,4);
			RPUF ABCDEF 1;
			Stop;
	}
}