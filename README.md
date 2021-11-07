# game idea: wide open (temporary name)

the current name comes from a sneak attack game mechanic, similar to "flanked" in Slay the Spire (more on it later).

gacha roguelike. mainly dungeon crawling with characters you unlock.

## OVERVIEW

main game scene is top-down, grid-based, like pokemon but the movement is step-by-step.

every character is like its own separate run. you pick a playable character from the roster of unlocked characters,  
send them on an expedition, and explore the random dungeon that comes up. for example,  
you choose character A, hit "exploration", start walking in a randomly generated "overworld" in the top-down style,  
chart some territory, maybe find some villages etc, eventually find a dungeon structure (e.g. Swamp Dungeon), 
make a camp there (which is like your savepoint), then enter the dungeon for exploration.

dungeon crawling itself: main navigation scene is again top-down with chibi character sprites  
(22x10 or 22x20, depending on character). you can interact with objects that have their own inventories,  
some of them you can move around (puzzles?), there are npcs around (not necessarily hostile),  
if you're detected by a hostile npc, a pokemon-style "!" appears, and the screen transitions to interaction screen  
(maybe a pop-up, maybe a screen change).

interaction screen is side-view (like Slay the Spire). it doesn't necessarily mean combat. you can switch between  
interaction and combat HUDs at any time, but if you're in combat, it doesn't stop combat. Interaction is with  
buttons available depending on the type of actor (merchant has trade button, every npc has talk button etc),  
whereas combat HUD is WASD and ARROWS, maybe 1-2-3-4 etc are different tabs you can access skills in.

the combat itself is semi-realtime (size-matters-style), as in, each actor has their own action timer (visible).  
you prepare the next action that's gonna happen on your next timer tick, and the main deciding factor is  
your opponent's queued action / timer.

combat starts off with super slow timers in the beginning of the game (for the player to get used to it),  
but as you progress and level up, you speed up, and opponents speed up, so it essentially transitions  
from turn-based to real-time combat, reaction times start to matter.

## FUNDAMENTAL WORKINGS

### sizes and alignment

Basic unit of measurement is a **full-square**: 22x20px.  
A full-square is sliced in half horizontally to have a **half-square** (22x10px),  
which is the size of small characters and objects, roughly.  

Walls, terrain etc. have a tile size of full-squares. If there is no wall or full-square sized object,  
there can be two objects/characters in one square (upper-half and lower-half).

Ground line sits at 4px, raycasts and colliders function at that point.

### map & minimap

Map generation uses full-squares as a unit. Rooms can be no smaller than 4x3 rectangle.  
Rooms are defined by the "empty space" inside (every room has min. 88x60px free space).

**Idea:** step procedures. at every step, return array with rooms generated. starting room 4x3.  
from there, walk N/S to create two (or more) other rooms. From the rooms created (array return),  
pick x, and walk W/E. Every room generated shares one wall with previous room.

### combat

**Idea:** every skill has various "time windows": preparation (anticipation?), action, recoil. For example,  
if the opponent is doing a simple attack, and it lines up with your timer, you can pull off a parry/intercept,  
which will stun the opponent. if it does not, then you prepare yourself the turn before by blocking, which has  
basically no prep and recoil, and is all action.  

that way, huge attacks have longer preparations (telegraphed) and recoils (opening). if you manage to dodge,  
you can then attack while it's vulnerable (wide open mechanic).

### detection & sneaking

if you walk into a hostile NPC's "detection zone" (visible if you have a certain perk),  
the camera focuses on the NPC, which goes "!", and then transition to interaction scene, directly into combat.

if you sneak up from behind and interact, the interaction scene now draws differently: instead of  
facing you, the NPC is looking the other way. the "wide open" buff and an awareness meter are visible.  
awareness might already be kind of filled up, depending on your sneaking skills (sneaky characters vs brute).  
everything you do will fill the awareness meter. if you fill the awareness before you finish preps,  
you enter combat. if you fill the awareness _while_ attacking, you get intercepted and stunned for 1 turn.  
if you manage to sneak up and attack, you get a special "wide open" effect (stun, vuln, whatever).  
you can rush hard-to-beat opponents this way

### inventory

doubt: are items and inventory .tres resources?  

example: InventoryTab.tres  
- name (drawer, pocket...)
- maxVolume, maxMass
- slots (load items here)

every inventory has tabs (min. 1). player has pocket 1, pocket 2, backpack etc. wardrobes have compartments.  
chests have only 1 compartment. npcs have tabs too, and they can be picked (varying difficulty).

you load InventoryTab.tres only if you decide that something has an inventory (no preload).

maybe also: Item.tres
- name
- description
- volume, mass
- image

more specific items inherit those attributes and adds others (power etc etc).

### game time

everytime your character moves, game time advances. parent node keeps track and updates a file.  
combat also advances game time, with a formula based on number of player turns and their duration.  
in very rudimentary form: __n * turn_duration__ (or n / speed)

when char dies, it needs a certain amount of game time to pass until it respawns at closest camp.  
also auto-traveling etc takes time. time passes also while you're playing other characters, so it's a loop  
unless you want to speed things up, want to grind the same character, or all characters are incapacitated.  
enter TIME RESOURCE: in-game currency kind of equivalent to gacha crystals.

you use the time currency to "pass time instantly" which affects all game characters. so even if it is just  
to revive one character, you might want to keep all characters on an "auto-work", so that idling chars  
have a _positive effect on your account_, like resources, exploration etc.

### headquarters

this is your base, which is like generic char selection menu meets Necrodancer main menu / FFXIV barracks  
as in: you walk around as a character in your base (you pick who is the captain of your group).

(ESCAPE brings up pop-up main menu, there's "save and exit", "options" etc)

you start out with just two rooms: the HALL (for now, just a desk and a chair?),  
and one ROOM with a bunk bed and two lockers (first two characters' rooms).  

the other character is just idling around in the hall (IDLE state).  
when they come back from an expedition, they coop up in their room for some time (REST state).  
the lockers are your characters' loadouts. you can change the loadout there before heading out.

you can improve the base by adding rooms, changing furniture etc etc.  
giving each char their own room would make them happier, but you can also have bunk bed arrangements

using the desk will bring out the character sheet (in the form of a notebook). separators on the top will take you to different menus:

- ROSTER: portrait icons of unlocked characters. clicking on them takes you to the relative char log page)
- LOGS: one char per page. current activity, character screen as buttons)
- CURRENT ACTIVITY: character's "load page". if resting, spend time

### exploration

exploring: setting out from the base and exploring the map until you find a town, dungeon or whatever.

walking around in the dungeon: you explore, move through procedurally generated rooms, with various levels, and final treasure in the end. then you leave and it resets.

city: going to the smithy, tavern etc etc.


## ROADMAP

### 0.0 — PROOF OF CONCEPT

one character walking around in an endless cave with procedurally generated rooms.  
there are NPCs around. some of them aggressive. you can sneak up on them or face them.  
facing will do a pokemon ! moment without the walking, just transition to fight scene  
working fight scene: semi-realtime combat (size matters style). if sneaking up, "wide open" = special effect for every kind of attack.  
basic fight with attack and defend  
you can also use buffs but they fill an "awareness" meter  
there are objects with inventories, some you can push, some not  
player has "moved" signal which the parent scene receives and does the turn mechanic

#### 0.0.01

Initial commit.

- basic sprites
- hand drawn map (just objects, no walls)
- player and object nodes
- player animated sprite (move)
- player and camera movement (with objects around)
- working player WASD arrows HUD
- player can move in empty spaces and cannot move in full ones

Main Scene: DemoScene

#### 0.0.02

Inventory first implementation.

Main Scene: DemoScene

#### 0.0.03

NPC first implementation.

- NPCs as interactables: different dialogue 
- area of detection: player moves inside area, gets detected
- no combat yet, even when hostile npcs detect you, you go into interaction view, and say goodbye (lol)

#### 0.0.04

Map generation implementation.

- minimap that counts 2x2 grid squares
- walker?

#### 0.0.05

Basic combat implementation.

### 0.1 — FIRST PROTOTYPE

- all the previous implementations with working UI, acts like an actual game and not PoC
- procedurally generated rooms with mobs and neutral NPCs spawning in them
- combat, inventories, loot etc

### 0.2 — FIRST FULL RELEASE 

tbd.
		

## NOTES

when to implement the game time? for sure first a rudimentary version, just tracking time,  
later as an actual currency parallel to it (total time is always tracked)