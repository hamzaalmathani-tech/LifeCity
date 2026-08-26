# Player System

## Core
- Third-person open-world player controller.
- Mobile virtual joystick + contextual action buttons.
- Sprint, crouch, jump, interact, enter/exit vehicle.
- Health, stamina, hunger, money, reputation and wanted state.
- Inventory/equipment slots.
- Save/load state.

## World interaction
The player can approach marked interactables and receive contextual actions. Missions never prevent free exploration.

## Vehicle interface
Vehicle entry transfers control to the vehicle controller while preserving the player state. Exiting places the player at a safe exit point.

## Mobile UX
- Left thumb: movement.
- Right side: camera/look area.
- Context buttons: interact, jump, sprint, enter/exit, vehicle brake/horn when driving.
- Optional simplified controls for accessibility.
