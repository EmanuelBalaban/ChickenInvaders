# Chicken Invaders

Chicken Invaders game built with Flutter Flame.

## Journal

- Extracted original assets by using https://github.com/LockBlock-dev/ChickenInvaders-re/tree/master tool.
  - Cannot use original assets due to resolution and background
- For building assets, Figma can be used: https://www.figma.com/

## To-do

- [x] Add sound effects
- [x] Add support for all guns and ship customizations
  - [x] Speed based on the projectile
  - [ ] Missiles should build up velocity
- [ ] Add support for ship shields
- [x] Add HUD
  - [x] Use SVGs for joystick 
  - [ ] In-game HUd
  - [ ] Main menu
    - [ ] Game over menu
    - [ ] Paused menu
- [x] Add controller support
- [ ] Fixed dt updates for cross-platform builds

## Commands

Sort imports:

```shell
dart run import_sorter:main
```

Format files:

```shell
dart format lib
```

Rebuild models:

```shell
dart run build_runner build --delete-conflicting-outputs
```