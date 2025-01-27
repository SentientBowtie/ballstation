/datum/game_mode/dynamic
	/// Number of antagonists that count towards the traitor limit.
	/// (Generally, antagonists that spawn as members of the crew, aside from thieves.)
	var/traitor_limit_antag_count = 0
	/// Theoretical percentage of crew that can become traitors at 100 threat.
	/// Used to calculate maximum traitor count for current population and threat level.
	/// Remember that threat level generally falls somewhere around 50.
	/// Configurable in dynamic.json.
	var/max_threat_traitor_percent = 0.5
	/// Minimum amount of threat allowed to generate.
	var/min_threat_level = 30
	/// Chance that the roundstart threat report will be wrong about the threat level.
	var/fake_report_chance = 5
	/// Potential positive deviance from the actual threat level in the roundstart threat report.
	var/pos_shown_threat_deviance = 10
	/// Potential negative deviance from the actual threat level in the roundstart threat report.
	var/neg_shown_threat_deviance = -10

/// Calculates the limit for midround/latejoin traitor spawns based on current population and threat level.
/// Returns TRUE or FALSE depending on if more traitors can spawn or not.
/datum/game_mode/dynamic/proc/calculate_traitor_limit()
	var/traitor_limit = round(((threat_level / 100) * max_threat_traitor_percent) * GLOB.alive_player_list.len, 1)

	if(traitor_limit_antag_count >= traitor_limit)
		return FALSE

	return TRUE

/datum/game_mode/dynamic/generate_threat()
	..()
	threat_level = max(min_threat_level, threat_level)

/datum/game_mode/dynamic/setup_shown_threat()
	if(threat_level == 100) // if the threat level is somehow at 100 we want the game to always print out the "Impending Doom" report because it's funny
		shown_threat = 100
	else if (prob(fake_report_chance))
		shown_threat = rand(min_threat_level, max_threat_level)
	else
		shown_threat = clamp(threat_level + rand(neg_shown_threat_deviance, pos_shown_threat_deviance), 0, 100)

/datum/dynamic_ruleset
	/// If set to TRUE, the game will count antags spawned by this ruleset when limiting how many midround/latejoin traitors can spawn.
	var/counts_toward_traitor_limit = FALSE
