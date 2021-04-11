class PACannon : Weapon replaces PlasmaGun
{
	// The Photon Accelerator Cannon.
	// Fires a spread of shots which narrows as you hold down the trigger.
	// More powerful than Coil shots, less ammo.
	// Spread is entirely horizontal.
	int shotSpeed;
	Property FireRate : shotSpeed;
	default
	{
		Weapon.SlotNumber 5;
		PACannon.FireRate 4;
	}

	states
	{

	}
}