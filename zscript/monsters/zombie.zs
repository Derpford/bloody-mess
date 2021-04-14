class BloodyZombie : Zombieman replaces Zombieman
{
	mixin BloodyMonster;
	// If I'm right, I should be able to basically re-use the stock Zombie definition without having to rewrite it, while ALSO keeping all my other behavior.
	default
	{
		BloodyZombie.StaggerHealth 15,-1;
		BloodyZombie.BonusDrops 1, 1;
	}

	double turnAngle;

	states
	{
		Stagger:
			POSS G 3 
			{
				turnAngle = 0.0;
				if(random(0,1) == 1)
				{ turnAngle = 30.0; } else { turnAngle = -30.0; }
				angle += turnAngle; 
			}
			POSS H 5 A_Pain();
			POSS G 5;
			POSS A 4;
			POSS AA 3 { angle -= turnAngle; }
			Goto See;
	}
}