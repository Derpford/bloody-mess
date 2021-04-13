class BloodyCaco : Cacodemon replaces Cacodemon
{
	mixin BloodyMonster;

	double spinangle;

	default
	{
		BloodyCaco.StaggerHealth 200;
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
	}
}