# My_Defence
	Author: Nicolai Theis Rolin
	Email: Nicolaieno@msn.com
	school Email: cph-nr140@cphbusiness.dk
	
# Quick Notes
	This is alpha and has no balance and isn't really in a playable state yet.

# How to Play
	TAB     - changes the speed of the game between 3 states.
	QE      - zooms out and in respectively.
	WASD    - moves the camera.
	SPACE   - pauses and unpauses the game.
	
	your clicks does different things depending on what you click and the situation.
	* expansion square (the empty squares at the end of a road)
		*starts the next level and spawn enemies.
	
	* map while having a tower in the cursor
		* places the tower
	
# Mechanics
	Spawn rate and points increases as levels progress
		*TO DO: different enemies spawn depending on points given, randomness and which enemy last spawned
	The more gates are in play, the slower each path spawns enemies, but each path has it's own cooldown.
	the closer a path is to you tower the higher cooldown it has.
	projectiles find new enemies in range of it's tower if it's target dies
		*TO DO: make it independent of the tower so they don't fly around so much.
	Tower Types are loaded dynamicly so can be modded in Data/tower.csv file
	
# Cheats as inventory hasn't been implimented we cheat
	cheat keys:
	*G      - puts a tower in your cursor
	
	