class BloodyWeapon : Weapon
{
	// Adds a util function for checking the weapon's ammo.

	action void A_ReadyIfAmmo(int flags = 0)
	{
		int amt = invoker.owner.CountInv(invoker.AmmoType1);
		if(amt>invoker.MinSelAmmo1 || amt>invoker.AmmoUse1)
		{
			A_WeaponReady(flags);
		}
		else
		{
			A_WeaponReady(flags|WRF_NOFIRE);
		}
	}

	action void A_RefireIfAmmo(StateLabel st = "Fire")
	{
		int amt = invoker.owner.CountInv(invoker.AmmoType1);
		if(amt>invoker.MinSelAmmo1 || amt>invoker.AmmoUse1)
		{
			A_Refire(st);
		}
		//else
		//{
		//	invoker.SetState(invoker.ResolveState(backup));
		//}
	}
}

class BloodWave : Inventory replaces Chainsaw
{
	// A powerful inventory item that fires a bloody shockwave
	// with disintegrating properties.
	// On a reasonably long cooldown.

	mixin Spinner;

	default
	{
		//+INVENTORY.UNDROPPABLE;
		+INVENTORY.INVBAR;
		+INVENTORY.KEEPDEPLETED;
		+INVENTORY.PERSISTENTPOWER;
		Inventory.InterHubAmount 100;
		Inventory.Amount 100;
		Inventory.MaxAmount 100;
		Inventory.PickupMessage "Bagged the Blood Wave Device!";
	}

	override void DoEffect()
	{
		// Tick amount upward.
		if( GetAge() % 4 == 0 || (CountInv("PowerStrength")>0 && GetAge() % 2 == 0) ) { owner.A_GiveInventory("BloodWave",1); }
	}

	override bool Use(bool pickup)
	{
		if(owner.CountInv("BloodWave")>99)
		{
			owner.A_TakeInventory("BloodWave",100);
			//owner.A_SpawnItemEX("BloodBlast",xofs:16,zofs:32,xvel:10,flags:SXF_SETTARGET);
			Vector3 newPos = owner.Vec3Offset(0,0,32);
			let it = owner.spawn("BloodBlast",newPos);
			if(it)
			{
				it.target = owner;
				it.Vel3DFromAngle(15,owner.angle,owner.pitch);
			}
			A_ThrustZ(-10,owner.angle,owner.pitch,owner);
			return true;
		}
		else
		{
			return false;
		}
	}

	action void A_ThrustZ(double speed, double angle, double pitch, actor victim = null)
	{
		if(victim == null)
		{
			victim = invoker;
		}
		victim.Thrust(cos(pitch)*speed,angle);
		victim.vel.z -= sin(pitch)*speed;
	}

	states
	{
		Spawn:
			PSTR A -1;
			Stop;
	}
}

class BloodBlast : Actor
{
	// The bloodwave's shockwave.

	default
	{
		+NOGRAVITY;
		+THRUACTORS;
		Speed 30;
		DamageFunction 30;
		Radius 20;
		Height 8;
		RenderStyle "Add";
		DamageType "Disintegrate";
	}

	states
	{
		Spawn:
		Death:
			REDT A 0;
			REDT A 0 A_StartSound("weapon/underx");
			REDE DCBA 2 Bright A_Explode(20,128,flags:0,fulldamagedistance:128);
			REDE ABCD 4 Bright A_Explode(20,128,flags:0,fulldamagedistance:128);
			Stop;
	}
}