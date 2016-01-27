local ColourCode = require('visual.colours')

-- Set random number generator seed.
math.randomseed(23052014)

-- Define world instance in package-level scope.
local world = nil

-- Set loadable scenarios.
local scenarios = {}
scenarios['ambulate'] = 'scenarios.ambulate.scenario'
scenarios['escape']   = 'scenarios.escape.scenario'
scenarios['flock']    = 'scenarios.flock.scenario'
scenarios['panic']    = 'scenarios.panic.scenario'
scenarios['survive']  = 'scenarios.survive.scenario'

--- Callback for initialising Love2D.
function love.load(arg)
    -- Set scenario.
    local selection = scenarios[arg[2]]
    if selection == nil then
        arg[2] = 'survive'
        print('No scenario selected; presenting default')
    else
        print('Presenting ' .. arg[2] .. ' scenario')
    end
    world = require(scenarios[arg[2]])

    -- Configure window.
    local window_flags = {}
    window_flags['fsaa'] = 4
    window_flags['vsync'] = false
    window_flags['fullscreen'] = false
    love.window.setMode(world.width, world.height, window_flags)

    -- Set graphical options.
    love.filesystem.setIdentity('gax')
    love.window.setTitle('GAX ' .. arg[2])
    love.mouse.setVisible(false)
    love.graphics.setPointSize(5)
    love.graphics.setBackgroundColor(ColourCode.background)
end

--- Callback for responding to user input through Love2D.
function love.keypressed(key, isrepeat)
    if key == 'escape' then
        -- Quit the game.
        love.event.quit()
    end

    if key == 'p' and not isrepeat then
        -- Take a screenshot.
        local date = os.date('%d%m%Y-%H%M%S')
        local name = string.format('screenshot-%s.png', date)
        love.graphics.newScreenshot():encode(name)
    end
end

--- Callback for responding to the update step in Love2D's main loop.
function love.update(delta_time)
    delta_time = math.min(delta_time, 0.0167)
    world:update(delta_time * 2)
end

--- Callback for responding to the drawing step in Love2D's main loop.
function love.draw()
    love.graphics.origin()
    world:draw()

    -- Take a screenshot.
    local date = os.date('%d%m%Y-%H%M%S')
    local name = string.format('screenshot-%s.png', date)
    love.graphics.newScreenshot():encode(name)
end
