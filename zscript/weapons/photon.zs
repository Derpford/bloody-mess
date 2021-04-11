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
		PACannon.FireRate 4;
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
				shotSpeed = shotSpeedMax;
			}
			Loop;
		Fire:
			BFPF A 1 { A_SetTics(shotSpeed); A_StartSound("weapon/photf",1); } // Projectile fires here.
			BFPF BC 1 A_SetTics(shotSpeed);
			BFPS DCBA 1 { A_SetTics(floor(shotSpeed/2)); shotSpeed = shotSpeed/2; }
			BFPS A 0 A_Refire;
		Cooldown:
			BFPS DADA 4;
			Goto Ready;
	}
}