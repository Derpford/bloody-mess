mixin class BloodyMonster 
{
	// All of Bloody Mess's monsters will drop a few armor bonuses on stagger and a burst of health bonuses on death.
	// They'll also have HP breakpoints for staggering.

	int staggerHealth;
	int staggerBonusAmt;
	int deathBonusAmt;
	int maxStaggers;
	int hitStun;
	int style;
	double oldAlpha;

	Property StaggerHealth : staggerHealth,maxStaggers;
	Property BonusDrops : staggerBonusAmt, deathBonusAmt;

	void TossDrop(String it, double dropAng)
	{
		bool res; Actor thing;
		dropAng += frandom(-30.0,30.0);
		[ res, thing ] = A_SpawnItemEX(it,radius,xvel:random(1,3),zvel:random(5,9),angle:dropAng,flags:SXF_ABSOLUTEANGLE);
		let thingInv = Inventory(thing);
		if(thingInv) { thingInv.Amount = floor(thingInv.Amount*0.5); }
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		style = GetRenderStyle();
		oldAlpha = alpha;
	}

	override void Tick()
	{
		if(hitStun != 0 && tics<curState.tics)
		{
			A_SetTics(curState.tics+hitStun);
			hitStun = 0;
		}

		if(tics>curState.tics && GetAge()%3==0)
		{
			style = GetRenderStyle();
			oldAlpha = alpha;
			A_SetRenderStyle(1.0,STYLE_Stencil);
			SetShade("Red");
		}
		else
		{
			if(style && oldAlpha) { A_SetRenderStyle(oldAlpha,style); }
		}
		super.Tick();
	}

	override int DamageMobj(Actor inf, Actor src, int dmg, Name mod, int flags, double ang)
	{
		hitStun = max(hitStun, ceil(sqrt(dmg)));
		if(health-dmg < staggerHealth)
		{
			double dropAng = 0.0;
			if(src)
			{
				dropAng = angleTo(src);
			}
			// We're not dead, but we're staggered.
			while(health-dmg < staggerHealth && staggerHealth > 5)
			{
				staggerHealth = floor(staggerHealth/2);
				if(maxStaggers != 0)
				{
					for(int i = staggerBonusAmt; i > 0; i--)
					{
						if(mod == "Thermite")
						{
							//Spawn bomblets here.
							TossDrop("MiniThermite",dropAng);
						}
						else
						{
							TossDrop("BloodyArmorBonus",dropAng);
						}
					}
					if(maxStaggers > 0) { maxStaggers -= 1; }
				}
			}
			if( health - damage > 0 && !InStateSequence(curState,resolveState("Stagger"))) { SetState(ResolveState("Stagger")); }
		}

		if(InStateSequence(curstate, resolvestate("stagger")))
		{
			return super.DamageMobj(inf,src,dmg,mod,flags|DMG_NO_PAIN,ang);
		}
		else
		{
			return super.DamageMobj(inf,src,dmg,mod,flags,ang);
		}


	}

	override void Die(Actor src, Actor inf, int flags, Name mod)
	{
		Array<String> initDropList = {"Coil","Nail","RocketPile","LightGem"}; // TODO: Get these dynamically
		Array<String> dropList;
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

		//Inventory Next = src.Inv;
		//while (Next)
		//{
			//if (Next is 'Ammo')
			//{
				//dropList.push(Next.GetClassName());
			//}
			//Next = Next.Inv;
		//}
		// Doesn't work right when you pick up a backpack.
		double dropAng = 0.0;
		if(src)
		{
			dropAng = angleTo(src);
		}
		for(int i = deathBonusAmt; i > 0; i--)
		{
			if((CountInv("Disintegrate")>0 || mod == "Disintegrate") && dropList.size() > 0)
			{
				TossDrop(dropList[random(0,dropList.size()-1)],dropAng);
			}
			else
			{
				TossDrop("BloodyHealBonus",dropAng);
			}
		}
		super.Die(src,inf,flags,mod);
	}

}

class MiniThermite : Actor
{
	// A thermite bomblet. Produced by staggering an enemy with the Thermite Grinder.
	// Shoot it to pop it, producing an explosion.

	default
	{
		Scale 0.5;
		Health 10;
		Height 24;
		Radius 8;
		DamageFactor "Thermite",0;
		+SHOOTABLE;
		+STEPMISSILE;
		+DROPOFF;
		+NOEXPLODEFLOOR;
		+THRUSPECIES;
		+BUDDHA;
	}

	override int DamageMobj(Actor inf, Actor src, int dmg, Name mod, int flags, double ang)
	{
		// When damaged, the can actually starts flying away from the actor that smacked it.
		if(mod != "Thermite" && !bMISSILE)
		{
			target = inf;
			bMISSILE = true;
			A_FaceTarget();
			return 0;
		}
		else
		{
			return super.DamageMobj(inf, src, dmg, mod, flags, ang);
		}
	}


	states
	{
		Spawn:
			FCAN ABCB 4 Bright
			{
				if(bMISSILE)
				{
					A_Explode(1,32,XF_NOTMISSILE,fulldamagedistance:32);
					Thrust(-4,angle);
				}
			}
			Loop;
		Death:
			MISL B 5 Bright { A_Explode(64); A_StartSound("world/barrelx"); A_SetRenderStyle(1.0,STYLE_ADD); }
			MISL BC 5 Bright A_SetScale(1,1);
			MISL D 10 Bright;
			Stop;
	}
}