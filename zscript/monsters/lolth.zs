class BloodyLolth : SpiderMastermind replaces SpiderMastermind
{
	mixin BloodyMonster;

	default
	{
		BloodyLolth.StaggerHealth 2000,-1;
		BloodyLolth.BonusDrops 2,10;
	}
}