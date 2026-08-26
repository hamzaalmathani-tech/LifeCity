# NPC Simulation System

## Data model
Each important NPC stores: identity, age category, occupation, schedule, needs, personality traits, goals, relationships, memories, current activity and location.

## Decision loop
1. Evaluate urgent needs.
2. Check schedule and job.
3. Consider goals and relationships.
4. Select a valid world activity.
5. Navigate to the activity.
6. Execute it and update memory/relationships.
7. Re-evaluate periodically.

## Population layers
- Background pedestrians: lightweight simulation.
- Active NPCs near the player: full behavior and navigation.
- Important story NPCs: persistent memory and relationship state.

## Traffic
Vehicles follow road lanes, avoid collisions, react to traffic signals and emergency vehicles, and can spawn/despawn by district streaming rules.
