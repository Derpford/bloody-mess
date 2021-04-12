mixin class BloodyMonster 
{
	// All of Bloody Mess's monsters will drop a few armor bonuses on stagger and a burst of health bonuses on death.
	// They'll also have HP breakpoints for staggering.

	int staggerHealth;
	int staggerBonusAmt;
	int deathBonusAmt;

	Property StaggerHealth : staggerHealth;
	Property BonusDrops : staggerBonusAmt, deathBonusAmt;

	override int DamageMobj(Actor inf, Actor src, int dmg, Name mod, int flags, double ang)
	{
		double dropAng = 0.0;
		if(src)
		{
			dropAng = angleTo(src);
		}
		if(health-dmg < staggerHealth)
		{
			// We're not dead, but we're staggered.
			while(health-dmg < staggerHealth && staggerHealth > 5)
			{
				staggerHealth = floor(staggerHealth/2);
				for(int i = staggerBonusAmt; i > 0; i--)
				{
					A_SpawnItemEX("BloodyArmorBonus",radius,xvel:random(3,5),angle:dropAng+random(-5,5));
				}
			}
			if( health - damage > 0 ) { SetState(ResolveState("Stagger")); }
			return super.DamageMobj(inf,src,dmg,mod,flags|DMG_NO_PAIN,ang);
		}
		else
		{
			return super.DamageMobj(inf,src,dmg,mod,flags,ang);
		}

	}

	override void Die(Actor src, Actor inf, int flags, Name mod)
	{
		double dropAng = 0.0;
		if(src)
		{
			dropAng = angleTo(src);
		}
		for(int i = deathBonusAmt; i > 0; i--)
		{
			if(CountInv("Disintegrate")>0)
			{
				Array<String> dropList = {"Clip","Shell","RocketAmmo","Cell"}; // TODO: Get these dynamically
				A_SpawnItemEX(dropList[random(0,3)],radius,xvel:random(3,5),angle:dropAng+random(-5,5));
			}
			else
			{
				A_SpawnItemEX("BloodyHealBonus",radius,xvel:random(3,5),angle:dropAng+random(-5,5));
			}
		}
		super.Die(src,inf,flags,mod);
	}


}