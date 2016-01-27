# GAX Steering Demonstrations

![Screenshot](screenshot.gif)

## Overview

This software demonstrates autonomous steering using the goal-aligned xetrov (GAX) system. Character steering is achieved using [steering behaviours](http://www.red3d.com/cwr/steer/gdc99/). Collision avoidance is achieved using the GAX system, which uses the concept of artificial potential to guide characters around nearby obstacles.

## Requirements

Developed using [Lua](http://www.lua.org/) v5.2.3. Depends on [Love2D](https://love2d.org/) v0.9.2.

## Running the demonstrations

Run the love executable in the root of the project; e.g. `love ./`. If a scenario identifier is provided - i.e. `love ./ survive` - the identified scenario will be run. The software includes the following scenarios:

* `ambulate`: Pedestrian simulation.
* `escape`: A prey character attempts to escape from numerous predators.
* `flock`: Flocking behaviour.
* `panic`: A group of characters attempts to leave a small room with a single exit.
* `survive`: Foraging prey are startled and pursued by a predator.
