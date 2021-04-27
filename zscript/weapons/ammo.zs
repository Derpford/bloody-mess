class Nail : Ammo replaces Shell
{
	// Individual nails.

	mixin Spinner;
	mixin ShowAmount;

	default
	{
		Scale 0.5;
		Inventory.Amount 2;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 2;
		Ammo.BackpackMaxAmount 100;
		Inventory.PickupMessage "Grabbed some nails.";
	}

	states
	{
		Spawn:
			NAMO A -1;
			Stop;
	}
}

class NailBox : Nail replaces ShellBox
{
	// Box o' Nails.

	//mixin Spinner;

	default
	{
		Scale 1;
		Inventory.Amount 10;
		Inventory.PickupMessage "Got a box of nails.";
	}

	states
	{
		Spawn:
			NBOX A -1;
			Stop;
	}
}

class Coil : Ammo replaces Clip
{
	// A small coilgun ammo pack.
	mixin Spinner;
	mixin ShowAmount;

	default
	{
		Scale 1;
		Inventory.Amount 7;
		Inventory.MaxAmount 300;
		Ammo.BackpackAmount 30;
		Ammo.BackpackMaxAmount 600;
		Inventory.PickupMessage "Grabbed a coil charge pack.";
	}

	states
	{
		Spawn:
			WAMC AB 4;
			Loop;
	}
}

class CoilCase : Coil replaces ClipBox

{
	// A case of coilgun charges.
	//mixin Spinner;

	default
	{
		Scale 1;
		Inventory.Amount 35;
		Inventory.PickupMessage "Grabbed a case of coil charges.";
	}

	states
	{
		Spawn:
			WAMC CD 4;
			Loop;
	}
}

class LightGem : Ammo replaces Cell
{
	// A glowy rock to feed your PACannon with.
	mixin Spinner;
	mixin ShowAmount;

	default
	{
		Inventory.Amount 10;
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 40;
		Ammo.BackpackMaxAmount 400;
		Inventory.PickupMessage "Grabbed a Light Gem.";
	}

	states
	{
		Spawn:
			KGZS B 4;
			KGZS B 4 Bright;
			Loop;
	}
}

class PowerOrb : LightGem replaces CellPack
{
	// A bigger, glowier rock.

	default
	{
		Scale 1.5;
		Inventory.Amount 50;
		Inventory.PickupMessage "Grabbed a Power Orb.";
	}

	states
	{
		Spawn:
			KGZS A 4;
			KGZS A 4 Bright;
			Loop;
	}
}

class RocketPile : Ammo replaces RocketAmmo
{
	// A small pile of mini-rockets.

	mixin Spinner;
	mixin ShowAmount;

	default
	{
		Inventory.Amount 3;
		Inventory.MaxAmount 150;
		Ammo.BackpackAmount 6;
		Ammo.BackpackMaxAmount 300;
		Inventory.PickupMessage "Grabbed some mini-rockets.";
	}

	states
	{
		Spawn:
			RKTA A -1;
			Stop;
	}
}

class RocketCrate : RocketPile replaces RocketBox
{
	// A decently-large rocket crate.

	default
	{
		Inventory.Amount 15;
		Inventory.PickupMessage "Grabbed a crate of mini-rockets.";
	}

	states
	{
		Spawn:
			HSAM B -1;
			Stop;
	}
}