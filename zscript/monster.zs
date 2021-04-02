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
		if(!InStateSequence(CurState,ResolveState("Death")) && !InStateSequence(CurState,ResolveState("XDeath")) && health-dmg > 0 && health-dmg < staggerHealth)
		{
			// We're not dead, but we're staggered.
			staggerHealth = floor(staggerHealth/2);
			SetState(ResolveState("Stagger"));
			for(int i = staggerBonusAmt; i > 0; i--)
			{
				A_SpawnItemEX("BloodyArmorBonus",radius,xvel:random(3,5),angle:angleTo(src)+random(-5,5));
			}
		}
		return super.DamageMobj(inf,src,dmg,mod,flags,ang);
	}

	override void Die(Actor src, Actor inf, int flags, Name mod)
	{
		for(int i = deathBonusAmt; i > 0; i--)
		{
			A_SpawnItemEX("BloodyHealthBonus",radius,xvel:random(3,5),angle:angleTo(src)+random(-5,5));
		}
		super.Die(src,inf,flags,mod);
	}


}