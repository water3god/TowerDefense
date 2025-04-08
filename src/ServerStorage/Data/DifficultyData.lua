--!strict

-- By Wa1er_God --

export type Data = {
	Health: number;
	HealthRatio: number;
	HeathIncrRatio: number;
	SpeedAdditive: number;
};

local DifficultyData: {[string]: Data} = {
	Normal = {
		Health = 200;
		HealthRatio = 1;
		HeathIncrRatio = 1.02;
		SpeedAdditive = 0.01;
	};
	Hard = {
		Health = 100;
		HealthRatio = 1.25;
		HeathIncrRatio = 1.03;
		SpeedAdditive = 0.015;
	};
	Insane = {
		Health = 50;
		HealthRatio = 1.5;
		HeathIncrRatio = 1.04;
		SpeedAdditive = 0.02;
	};
};

return table.freeze(DifficultyData);