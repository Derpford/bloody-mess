class BloodyLolth : SpiderMastermind replaces SpiderMastermind
{
	mixin BloodyMonster;

	int runTimer;

	default
	{
		BloodyLolth.StaggerHealth 2000,-1;
		BloodyLolth.BonusDrops 2,10;
	}

	states
	{
		Stagger:
			SPID I 3 { A_Pain(); A_GiveInventory("SuperArmor",100); }
			SPID I 5;
			TNT1 A 3;
			SPID I 5;
			TNT1 A 3;
			SPID I 5;
			TNT1 A 3;
			SPID I 4;
			TNT1 A 3;
			SPID I 3;
			TNT1 A 3;
			SPID I 2;
			TNT1 A 3;
		Run:
			TNT1 A 1 { runTimer = 35 * 3; }
		RunLoop:
			TNT1 A 1 
			{
				speed = 36;
				A_Wander();
				runTimer--;
				if(runTimer < 1) { return ResolveState("Uncloak"); } else { return ResolveState(null); }
			}
			loop;
		Uncloak:
			TNT1 A 5 { speed = 12; }
			SPID A 4;
			TNT1 A 5;
			SPID A 4;
			TNT1 A 5;
			SPID A 4 A_TakeInventory("SuperArmor",100);
			Goto See;

	}
}