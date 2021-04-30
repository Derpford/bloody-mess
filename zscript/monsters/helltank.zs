class BloodyHelltank : Cyberdemon replaces Cyberdemon
{
	mixin BloodyMonster;

	default
	{
		BloodyHelltank.StaggerHealth 3000,-1;
		BloodyHelltank.BonusDrops 3,10;
	}

	action void A_HelltankShot()
	{
		Actor shot; 
		shot = invoker.Spawn("MacrossMissile",Vec3Angle(48,angle,height/2.0));
		shot.master = invoker;
		shot.target = invoker;
		FLineTraceData point;
		LineTrace(invoker.angle,2048,invoker.pitch,TRF_THRUACTORS,32,data:point);
		invoker.tracer = Spawn("TargetDummy",point.HitLocation);
		shot.A_GiveInventory("SignalItem");
	}

	States
	{
		Stagger:
			CYBR GGGG 8 A_Pain();
			Goto Missile;

		Missile:
			CYBR E 10 A_FaceTarget();
			CYBR F 8 Bright A_HelltankShot();
			CYBR E 10 A_FaceTarget();
			CYBR F 8 Bright A_HelltankShot();
			CYBR E 10 A_FaceTarget();
			CYBR F 8 Bright A_HelltankShot();
			Goto See;
	}
}