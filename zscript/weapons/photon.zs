class PACannon : Weapon replaces PlasmaGun
{
	// The Photon Accelerator Cannon.
	// Fires a spread of shots which narrows as you hold down the trigger.
	// More powerful than Coil shots, less ammo.
	// Spread is entirely horizontal.
	int shotSpeed;
	int shotSpeedMax;
	Property FireRate : shotSpeedMax;
	default
	{
		Weapon.SlotNumber 5;
		PACannon.FireRate 6;
	}

	states
	{
		Spawn:
			BRPO A -1;
			Stop;
		Select:
			BFPS ABCD 1 A_Raise(12);
			Loop;
		Deselect:
			BFPS DCBA 1 A_Lower(12);
			Loop;
		Ready:
			BFPI ABCDEFGHIJJIHGFEDCBA 1 
			{
				A_WeaponReady();
				invoker.shotSpeed = invoker.shotSpeedMax;
			}
			Loop;
		Fire:
			BFPF A 1 { A_SetTics(invoker.shotSpeed); A_StartSound("weapon/photf",1); } // Projectile fires here.
			BFPF BC 1 A_SetTics(invoker.shotSpeed);
			BFPS D 1 { A_SetTics(floor(invoker.shotSpeed/2)); invoker.shotSpeed = max(invoker.shotSpeed-1,1); }
			BFPS CBA 1 { A_SetTics(floor(invoker.shotSpeed/2)); }
			BFPS A 0 A_Refire;
		Cooldown:
			BFPS DADA 4;
			Goto Ready;
	}
}