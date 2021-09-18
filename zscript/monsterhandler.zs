// Event Handler that adds stagger-like behavior to non-Bloodwave monsters.

class BloodyMonsterHandler : EventHandler
{
	void TossDrop(Actor tosser, String it, double dropAng)
	{
		bool res; Actor thing;
		dropAng += frandom(-30.0,30.0);
		[ res, thing ] = tosser.A_SpawnItemEX(it,tosser.radius,xvel:random(1,3),zvel:random(5,9),angle:dropAng,flags:SXF_ABSOLUTEANGLE);
		let thingInv = Inventory(thing);
		let thingArm = ArmorBonus(thing);
		if(thingInv) { thingInv.Amount = ceil(thingInv.Amount*0.5); }
		if(thingArm) { thingArm.SaveAmount = ceil(thingArm.SaveAmount*0.5); }
	}	

	override void WorldThingDamaged(WorldEvent e)
	{
		if(e.Thing.CountInv("BloodyFlag")>0)
		{
			return; // This thing already handles its own stuff.
		}

		// Hitstun handling.
		if(e.DamageType != "Massacre" && e.Thing.CountInv("SuperArmor")<1) 
		{ 
			int hitStun = ceil(sqrt(e.Damage)); 
			hitStun = min(hitStun,35);
			e.Thing.A_GiveInventory("HitStunTok",hitStun);
		}

		// Stagger handling.
		if(e.Thing.CountInv("StaggerTok")<1 && e.Thing.Health-e.Damage < e.Thing.GetSpawnHealth()/2)
		{
			e.Thing.A_GiveInventory("StaggerTok");
			e.Thing.A_GiveInventory("PainTok",35);//TODO: Calculate how much stagger to give.
			double dropAng = 0.0;
			if(e.DamageSource)
			{
				dropAng = e.Thing.angleTo(e.DamageSource);
			}

			int armorBonusAmt = e.Thing.Radius/10;
			for(int i = 0; i < armorBonusAmt; i++)
			{
				if(e.DamageType == "Thermite")
				{
					TossDrop(e.Thing,"MiniThermite",dropAng);
				}
				else
				{
					TossDrop(e.Thing,"BloodyArmorBonus",dropAng);
				}
			}
		}

		if(e.Thing.CountInv("StaggerTok")>0)
		{
			//e.DamageFlags |= DMG_NO_PAIN;
			// Can't set damage flags to keep the target from paining during their stagger...
		}
	}

	override void WorldThingDied(WorldEvent e)
	{
		Array<String> initDropList = {"Coil","Nail","RocketPile","LightGem"}; // TODO: Get these dynamically
		Array<String> dropList;
		let src = e.Inflictor.target;
		if(src)
		{ 
			for(int i = 0; i < initDropList.size(); i++)
			{
				if(src.FindInventory(initDropList[i]))
				{
					if(src.CountInv(initDropList[i])<src.FindInventory(initDropList[i]).maxAmount)
					{
						dropList.push(initDropList[i]);
					}
				}
			}
		}

		double dropAng = 0.0;
		if(src)
		{
			dropAng = e.Thing.angleTo(src);
		}

		int deathBonusAmt = 3; // TODO: Calculate based on health.

		for(int i = 0; i < deathBonusAmt; i++)
		{
			if((e.thing.CountInv("Disintegrate")>0 || (e.inflictor && e.inflictor.DamageType == "Disintegrate")) 
			&& dropList.size() > 0)
			{
				TossDrop(e.Thing,dropList[random(0,dropList.size()-1)],dropAng);
			}
			else
			{
				TossDrop(e.Thing,"BloodyHealBonus",dropAng);
			}
		}
	}
}

class HitStunTok : Inventory
{
	int style;
	int oldStyle;
	double oldAlpha;
	// Exists to track hitstun.
	default
	{
		inventory.maxamount 999;
	}

	override void AttachToOwner(Actor other)
	{
		oldstyle = other.GetRenderStyle();
		oldAlpha = alpha;
	}

	override void DoEffect()
	{
		int stun = CountInv("HitStunTok");
		if(stun != 0 && owner.tics<owner.curState.tics)
		{
			owner.A_SetTics(owner.curState.tics+stun);
		}

		if(owner.tics>owner.curState.tics && owner.GetAge()%3==0)
		{
			style = owner.GetRenderStyle();
			A_SetRenderStyle(1.0,STYLE_Stencil);
			SetShade("Red");
		}
		else
		{
			if(oldStyle && oldAlpha) { A_SetRenderStyle(oldAlpha,oldStyle); }
		}

		owner.A_TakeInventory("HitStunTok",1000);
	}
}

class PainTok : Inventory
{
	// Inflicts pain.
	default
	{
		inventory.maxamount 999;
	}

	override void DoEffect()
	{
		if(owner && !owner.bCORPSE)
		{
			if(owner.ResolveState("Pain") && !owner.InStateSequence(owner.curstate,owner.ResolveState("Pain")))
			{
				owner.SetState(owner.ResolveState("Pain"));
			}
		}
		owner.A_TakeInventory("PainTok",1);
	}
}

class StaggerTok : Inventory
{
	// Tracks whether something has been staggered or not.
	default
	{
		inventory.maxamount 1;
	}
}