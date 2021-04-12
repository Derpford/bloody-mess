class PACannon : Weapon replaces PlasmaGun
{
	// The Photon Accelerator Cannon.
	// Fires a spread of shots which narrows as you hold down the trigger.
	// More powerful than Coil shots, less ammo.
	// Spread is entirely horizontal.
	mixin Spinner;

	int shotSpeed;
	int shotSpeedMax;
	Property FireRate : shotSpeedMax;
	default
	{
		Weapon.SlotNumber 5;
		PACannon.FireRate 16;
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
				A_StartSound("weapon/photi",flags:CHANF_NOSTOP);
				invoker.shotSpeed = invoker.shotSpeedMax;
			}
			Loop;
		Fire:
			BFPF A 3 
			{ 
				A_SetTics(max(floor(invoker.shotSpeed/2),1)); 
				A_StopSound(4);
				A_StartSound("weapon/photf",1,CHANF_OVERLAP);
				for(int i = -2; i < 3; i+=1)
				{
					A_FireProjectile("PhotonShot",invoker.shotSpeed*i*0.5);
				}
			} // Projectile fires here.
			BFPF BC 3 A_SetTics(max(floor(invoker.shotSpeed)/4,1));
			BFPS D 0 { invoker.shotSpeed = max(invoker.shotSpeed*0.90,1); }
			BFPS A 0 A_Refire;
			BFPS A 0 { if(invoker.shotSpeed > 8) { return ResolveState("Ready"); } else { return ResolveState(null); } }
		Cooldown:
			BFPS DBADBA 4 A_StartSound("weapon/photr",flags:CHANF_NOSTOP);
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
		Height 12;
		Radius 8;
	}

	states
	{
		Spawn:
			BAL1 A 4;
			BAL1 B 4 Bright;
			Loop;
		Death:
			BAL1 CDE 4 Bright;
			Stop;
	}
}