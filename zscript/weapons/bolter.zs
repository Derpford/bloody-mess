class Bolter : Weapon
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
			PLBG A 1 A_Raise(18);
			Loop;
		Deselect:
			PLBG A 1 A_Lower(18);
			Loop;
		Ready:
			PLBG A 1 A_WeaponReady();
			Loop;
		Fire:
			PLBG B 3 Bright 
			{ 
				A_FireProjectile("BolterShot"); 
				A_StartSound("weapon/boltf"); 
				A_WeaponOffset(8,0,WOF_ADD);
			}
			PLBG A 3 A_WeaponOffset(8,6,WOF_ADD);
			PLBG C 4 A_WeaponOffset(4,4,WOF_ADD);
			PLBG A 3 A_WeaponOffset(-4,0,WOF_ADD);
			PLBG A 3 A_WeaponOffset(-16,-3,WOF_ADD);
			PLBG A 2 A_WeaponOffset(0,-7,WOF_ADD);
			Goto Ready;

	}
}

class BolterShot : FastProjectile
{
	// The bolter shot. 
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
		Radius 6;
		Height 12;
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
				if(tracer)
				{
					tracer.A_GiveInventory("Disintegrate",70); 
					int dmg = floor(10.0*(1.0-((10+tracer.health)/Float(tracer.spawnHealth()))));
					tracer.DamageMobj(self,target,dmg,"Disintegrate");
					console.printf("Disintegrating! "..dmg);
				}
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