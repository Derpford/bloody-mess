class BloodyGhost : BloodyWurm replaces Spectre
{
	default
	{
		+SHADOW;
		RenderStyle "OptFuzzy";
		Alpha 0.5;
		Obituary "$OB_SPECTREHIT";
		Tag "$FN_SPECTRE";
	}
}