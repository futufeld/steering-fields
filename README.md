# Demonstrations of the Steering Fields System

![Screenshot](screenshot.gif)

## Overview

This software demonstrates autonomous steering using the steering fields system. Character steering is achieved using variants of the behaviour algorithms in the [steering behaviours framework](http://www.red3d.com/cwr/steer/gdc99/). Collision avoidance is achieved using xetrov fields, which use the concept of artificial potential to guide characters around nearby obstacles.

## Requirements

Developed using [Lua](http://www.lua.org/) v5.2.3. Depends on [Love2D](https://love2d.org/) v0.10.1.

## Running the demonstrations

Run the love executable in the root of the project; e.g. `love ./`. If a scenario identifier is provided - i.e. `love ./ survive` - the identified scenario will be run. The software includes the following scenarios:

* `ambulate`: Two groups of pedestrians travel through a toroidal corridor.
* `escape`: A prey character attempts to escape from numerous predators.
* `flock`: Two groups of characters perform flocking behaviour.
* `panic`: A group of characters attempt to leave a small room with a single exit.
* `survive`: Foraging prey are pursued by a predator.
