class BloodyCaco : Cacodemon replaces Cacodemon
{
	mixin BloodyMonster;

	int spinangle;

	default
	{
		BloodyCaco.StaggerHealth 200;
		BloodyCaco.BonusDrops 2,1;
	}

	states
	{
		Stagger:
			HEAD E 3 { A_Pain(); random(0,1)? (spinangle = 20) : (spinangle = -20); }
			HEAD EEFFEEFF 3 
			{ 
				State res;
				angle += spinangle; spinangle *= 0.5;
				(abs(spinangle)>1)? (res = ResolveState(null)) : (res = ResolveState("see"));
				return res;
			}
			Loop;
	}
}