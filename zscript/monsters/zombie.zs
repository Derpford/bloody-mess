class BloodyZombie : Zombieman replaces Zombieman
{
	mixin BloodyMonster;
	// If I'm right, I should be able to basically re-use the stock Zombie definition without having to rewrite it, while ALSO keeping all my other behavior.
	default
	{
		BloodyZombie.StaggerHealth 15;
		BloodyZombie.BonusDrops 1, 1;
	}

	states
	{
		Stagger:
			POSS G 3 { angle += 15 * random(-2,2); }
			POSS H 5;
			POSS G 5 A_Pain();
			POSS A 3;
			Goto See;
	}
}