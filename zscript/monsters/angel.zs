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
		RenderStyle "Translucent";
		BloodyAngel.RezCount 2;
	}

	states
	{
		See:
			VILE AABBCCDDEEFF 2 A_Chase(null,"Missile");
			Loop;

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

class RezCube: Actor
{
	default
	{
		+NOGRAVITY;
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
