class WeaponSpawnHandler : EventHandler
{
	// Handles spawning certain weapons in edge cases.

	bool NeedsWeapon(string it)
	{
		// Takes a weapon classname and checks if any player currently lacks it.
		// Defaults to true if the player doesn't exist yet.
		if(players.size() < 1)
		{
			return true;
			console.printf("Found no players.");
		}

		for(int i = 0; i < MAXPLAYERS; i++)
		{
			if(!players[i].mo)
			{
				//console.printf("Player object "..i.." doesn't exist yet!");
				continue;
			}

			let item = players[i].mo.FindInventory(it);

			if(item)
			{
				//console.printf("player "..i.." had a "..it);
			}
			else
			{
				//console.printf("Player needs a "..it);
				return true;
			}
		}
		return false;
	}

	bool MonsterPresent(string it)
	{
		// Takes a monster classname and checks if that monster is present at all in the level
		let monIter = ThinkerIterator.Create(it,Thinker.STAT_DEFAULT);
		let mon = monIter.Next();
		if(mon)
		{
			// We have at least 1 monster of this type.
			//console.printf("Found a "..it);
			return true;
		}
		else
		{
			//console.printf("Didn't find any "..it);
			return false;
		}
	}

	override void WorldThingSpawned(WorldEvent e)
	{
		if(level.time > 3)
		{
			return; // we've already run the replace step
		}

		if(e.thing is "BloodPack")
		{
			if(NeedsWeapon("BloodWave"))
			{
				let newthing = e.thing.spawn("BloodWave",e.thing.pos);
				newthing.ChangeTID(e.thing.TID);
				e.thing.Destroy();
			}
		}

		if(e.thing is "CoilRepeater")
		{
			if(NeedsWeapon("CoilCarbine") && !MonsterPresent("BloodyZombie"))
			{
				let newthing = e.thing.spawn("CoilCarbine",e.thing.pos);
				newthing.ChangeTID(e.thing.TID);
				e.thing.Destroy();
			}
		}

		if(e.thing is "NailShotty")
		{
			if(!NeedsWeapon("NailShotty") || MonsterPresent("BloodyShotgunner"))
			{
				let newthing = e.thing.spawn("ThermiteGrinder",e.thing.pos);
				newthing.ChangeTID(e.thing.TID);
				e.thing.Destroy();
			}
		}
	}
}