class BloodyCaco : Cacodemon replaces Cacodemon
{
	mixin BloodyMonster;

	double spinangle;

	default
	{
		BloodyCaco.StaggerHealth 200,5;
		BloodyCaco.BonusDrops 2,1;
	}

	states
	{
		Stagger:
			HEAD E 3 { A_Pain(); random(0,1)? (spinangle = 20) : (spinangle = -20); }
		StaggerLoop:
			HEAD EEFFEEFF 3 
			{ 
				angle += spinangle; spinangle *= 0.80;
				if(abs(spinangle)>1) 
				{ return ResolveState(null); } else { return ResolveState("see"); }
			}
			Loop;

		Missile:
			HEAD B 4 Bright A_FaceTarget();
			HEAD B 3 Bright { A_SpawnProjectile("BloodyCacoBall"); A_SpawnProjectile("BloodyCacoBall2"); }
			HEAD CD 4;
			Goto See;
	}
}

class BloodyCacoBall : CacodemonBall replaces CacodemonBall
{
	// Slow, wiggly projectile.

	default
	{
		Speed 5;
		DamageFunction 15;
	}

	states
	{
		Spawn:
			BAL2 AB 3 A_Weave(3,0,4.0,0.0);
			Loop;
		Death:
			BAL2 CDE 4;
			Stop;
	}
}

class BloodyCacoBall2 : BloodyCacoBall
{
	default
	{
		WeaveIndexXY 32;
		SeeSound "";
	}
}