class Bolter : BloodyWeapon
{
	// Starting weapon. Infinite-ammo projectile weapon with reasonable accuracy.
	// Think Q2 blaster.
	default
	{
		Weapon.SlotNumber 1;
	}

	states
	{
		Select:
			PLBG A 1 A_Raise(24);
			Loop;
		Deselect:
			PLBG A 1 A_Lower(24);
			Loop;
		Ready:
			PLBG A 1 A_WeaponReady();
			Loop;
		Fire:
			PLBG B 3 Bright 
			{ 
				if(CountInv("PowerStrength")>0)
				{
					A_FireProjectile("BolterShot",1,spawnofs_xy:-1); 
					A_FireProjectile("BolterShot",-1,spawnofs_xy:1); 
				}
				else
				{
					A_FireProjectile("BolterShot"); 
				}
				A_StartSound("weapon/boltf"); 
				A_WeaponOffset(8,0,WOF_ADD);
				A_OverlayScale(1,0.5,0.5,WOF_ADD);
			}
			PLBG A 3 A_WeaponOffset(8,6,WOF_ADD);
			PLBG C 4 A_WeaponOffset(4,4,WOF_ADD);
			PLBG A 3 A_OverlayScale(1,-0.5,-0.5,WOF_ADD);//A_WeaponOffset(-4,0,WOF_ADD);
			PLBG A 3 A_WeaponOffset(-16,-3,WOF_ADD);
			PLBG A 2 A_WeaponOffset(-4,-7,WOF_ADD);
			Goto Ready;

	}
}

class BolterShot : FastProjectile
{
	// The bolter shot. 
	override int DoSpecialDamage(Actor tgt, int dmg, name mod)
	{
		tgt.A_GiveInventory("Disintegrate",70);
		double rangeMax = tgt.SpawnHealth();
		double rangeMin = rangeMax * 0.2;
		double mult = min(max(tgt.health - rangeMin,0)/max(rangeMax-rangeMin,1),1);
		mult = 2 - mult;
		return floor(dmg*mult);
	}
	default
	{
		DamageFunction 10;
		DamageType "Disintegrate";
		MissileType "BolterTrail";
		+ROLLSPRITE;
		+HITTRACER;
		Speed 30;
		Projectile;
		Scale 0.5;
		Radius 4;
		Height 6;
		MissileHeight 8;
		RenderStyle "add";
	}
	states
	{
		Spawn:
			DLIT J 1 { roll += 12; }
			Loop;
		Death:
			DLIT O 1 
			{ 
				A_StartSound("weapon/bolth"); 
			}
			DLIT NMLKJ 1;
			DLIT JKLMNO 1;
			Stop;
	}
}

class Disintegrate : Inventory
{
	// Enemies that die while this is present will drop random ammunition.
	default
	{
		Inventory.MaxAmount 70;
	}
	override void DoEffect()
	{
		// We just track the time limit here.
		owner.A_SpawnItemEX("BolterTrail",xofs:owner.radius,zofs:owner.height/2,xvel:3,angle:frandom(0,360));
		owner.A_TakeInventory("Disintegrate",1);
	}
}

class BolterTrail : Actor
{
	// The trail from the bolter.
	default
	{
		RenderStyle "add";
		+NOINTERACTION;
		+ROLLSPRITE;
		+NOGRAVITY;
		Scale 0.5;
	}
	states
	{
		Spawn:
			DLIT K 0;
			DLIT K 0 { A_ChangeVelocity(0,random(-1,1),random(-1,1),CVF_RELATIVE); }
			DLIT KLMNO 2 { roll += 15; }
			Stop;
	}
}