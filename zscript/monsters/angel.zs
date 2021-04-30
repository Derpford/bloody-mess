class BloodyAngel : Archvile replaces Archvile
{
	mixin BloodyMonster;

	int rezCount; int runTimer;
	Property RezCount: rezCount;
	default
	{
		BloodyAngel.StaggerHealth 700,3;
		BloodyAngel.BonusDrops 3,5;
		Health 1050;
		+BUDDHA;
		+NOTARGET;
		RenderStyle "Translucent";
		BloodyAngel.RezCount 2;
	}

	states
	{
		See:
			VILE AABBCCDDEEFF 2 A_Chase(null,"Missile");
			Loop;

		Missile:
			VILE G 10 Bright { A_FaceTarget(); A_StartSound("vile/start"); }
			VILE H 8 Bright;
			VILE IJKLMN 9 Bright A_FaceTarget();
			VILE N 7
			{
				A_StartSound("weapon/underf",1);
				A_FaceTarget();
				A_SpawnProjectile("VileTracer",8,flags:CMF_ABSOLUTEPITCH);
				A_SpawnProjectile("VileTracer",8,angle:-3,flags:CMF_ABSOLUTEPITCH);
				A_SpawnProjectile("VileTracer",8,angle:3,flags:CMF_ABSOLUTEPITCH);
			}
			VILE OP 6;
			Goto See;

		Stagger:
			VILE A 0
			{
				if(rezCount>0)
				{
					bTHRUACTORS = true;
					bFRIGHTENED = true;
					alpha = 0.5;
					runTimer = 87;
					for(int i = 5; i > 0; i--)
					{
						A_SpawnItemEX("RezCube");
					}
				}
			}
			VILE QR 12 A_Pain();
			VILE A 2;
			Goto Run;

		Run:
			VILE ABCDEF 2 
			{
				alpha = 0.5;
				A_Chase(null,null);
				runTimer--;
				if(runTimer < 1)
				{
					rezCount--;
					if(rezCount < 1)
					{
						bBUDDHA = false;
					}
					bFRIGHTENED = false;
					bTHRUACTORS = false;
					alpha = 1;
					return ResolveState("See");
				}
				else
				{
					return ResolveState(null);
				}
			}
			Loop;
	}
}

class VileTracer : CoilTracer
{
	// A flamey CoilTracer that does less damage and flies a bit slower.
	default
	{
		DamageFunction 2;
		Speed 50;
		+STEPMISSILE;
	}

	states
	{
		Spawn:
			FIRE ABCDCBA 1 Bright A_StartSound("weapon/mmisi",flags:CHANF_NOSTOP);
			Loop;
		Death:
			FIRE ABCDEFGH 3 Bright A_StopSound(4);
			Stop;
	}
}
class RezCube: Actor
{
	default
	{
		+NOGRAVITY;
		+FLOAT;
		Speed 15;
	}

	states
	{
		Spawn:
			BOSF ABCD 3 { A_Wander(); A_Chase(null,null,flags:CHF_RESURRECT|CHF_DONTMOVE); }
			Loop;
		Heal:
			MISL B 4;
			MISL C 5;
			MISL D 6;
			Stop;
	}
}
