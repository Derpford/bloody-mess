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
				if(invoker.shotCount % 4 == 0)
				{
					invoker.shotCount = 0;
					invoker.shotSpeed = max(invoker.shotSpeed-1,0);
				}
			}
			REPG E 0 { A_SetTics(invoker.shotSpeed); A_StartSound("weapon/repf",1); } // shot goes here
			REPG E 0 A_Refire();
			Goto SpinDown;
		FullAuto:
			REPG E 1 { A_StartSound("weapon/repf",1); } // and here
			REPG B 1;
			REPG F 1 { A_StartSound("weapon/repf",1); } // and here
			REPG C 1;
			REPG G 1 { A_StartSound("weapon/repf",1); } // and here
			REPG D 1;
			REPG H 1 { A_StartSound("weapon/repf",1); } // and here
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