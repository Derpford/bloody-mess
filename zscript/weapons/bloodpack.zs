class BloodPack : Berserk replaces Berserk
{
	// BLOOD FOR THE BLOODWAVE
	mixin Spinner;

	default
	{
		Inventory.PickupMessage "Demonic blood sample! Powerful stuff!";
	}

	states
	{
		Spawn:
			BPAK B -1;
			Stop;
	}
}