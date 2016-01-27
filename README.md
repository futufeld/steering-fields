# GAX Steering Demonstrations

![Screenshot](screenshot.gif)

## Overview

This software demonstrates autonomous steering using the goal-aligned xetrov (GAX) system. Character steering is achieved using steering behaviours. Collision avoidance is achieved using the GAX system, which uses the concept of artificial potential to guide characters around nearby obstacles.

## Requirements

Developed using Lua v5.2. Depends on Love2D v0.9.2.

## Running the demonstrations

Run the love executable in the root of the project; e.g. `love ./`. If a scenario identifier is provided - i.e. `love ./ survive` - the identified scenario will be run. The software includes the following scenarios:

* `ambulate`: Pedestrian simulation.
* `escape`: A prey character attempts to escape from numerous predators.
* `flock`: Flocking behaviour.
* `panic`: A group of characters attempts to leave a small room with a single exit.
* `survive`: Foraging prey are startled and pursued by a predator.
