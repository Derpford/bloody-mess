class BloodySoul : LostSoul replaces LostSoul
{
	mixin BloodyMonster;
	int step;
	double ang;

	default
	{
		BloodySoul.StaggerHealth 80,0;
		BloodySoul.BonusDrops 0,0; // No soulspam 4 u!
	}

	states
	{
		Stagger:
			SKUL E 2 A_Pain();
			SKUL EEEEEEEEEEEE 4
			{
				angle += 360.0/6.0;
			}
			Goto See;

		Death.Disintegrate:
			SKUL F 0 { if(CountInv("Disintegrate")> 0) {return ResolveState(null);} else {return ResolveState("Death");}}
			SKUL F 0 { A_StartSound("skul/egg"); step = 0; ang = Normalize180(angle+90); }
			SKUL FFFFFF 4
			{
				vel.x = 0; vel.y = 0;
				if(step % 2 == 0) {thrust(12,ang);} else {thrust(-12,ang);}
				step += 1;
			}
			SKUL GHIJK 6 Bright;
			Stop;
	}
}