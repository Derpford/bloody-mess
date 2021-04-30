class BloodySpider : Arachnotron replaces Arachnotron
{
	mixin BloodyMonster;

	default
	{
		BloodySpider.StaggerHealth 300,4;
		BloodySpider.BonusDrops 2,2;
	}

	states
	{
		Stagger:
			BSPI IAIAIAIAI 4 A_Pain();
			Goto See;

		Missile:
			BSPI A 20 A_FaceTarget();
		MissileLoop:
			BSPI G 4 Bright
			{
				A_StartSound("weapon/carf");
				A_SpawnProjectile("PhotonShot");
				A_SpawnProjectile("PhotonShot",flags:CMF_OFFSETPITCH,pitch:-2);
				A_SpawnProjectile("PhotonShot",flags:CMF_OFFSETPITCH,pitch:2);
			}
			BSPI H 8;
			BSPI H 4 A_SpidRefire();
			Loop;
	}
}