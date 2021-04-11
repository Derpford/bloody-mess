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
			BFPF A 1 
			{ 
				A_SetTics(max(floor(invoker.shotSpeed/2),1)); 
				A_StartSound("weapon/photf",1,CHANF_OVERLAP);
				for(int i = -2; i < 3; i+=1)
				{
					A_FireProjectile("PhotonShot",invoker.shotSpeed*i);
				}
			} // Projectile fires here.
			BFPF BC 1 A_SetTics(max(floor(invoker.shotSpeed),1));
			BFPS D 1 { A_SetTics(floor(invoker.shotSpeed/2)); invoker.shotSpeed = max(invoker.shotSpeed-1,1); }
			BFPS B 1 { A_SetTics(floor(invoker.shotSpeed/2)); }
			BFPS A 0 A_Refire;
		Cooldown:
			BFPS DBADBA 4;
			Goto Ready;
	}
}

class PhotonShot : FastProjectile
{
	// A ball of light.
	default
	{
		DamageFunction 10;
		RenderStyle "add";
		Speed 60;
	}

	states
	{
		Spawn:
			BAL1 AB 4 Bright;
			Loop;
		Death:
			BAL1 CDE 4 Bright;
			Stop;
	}
}