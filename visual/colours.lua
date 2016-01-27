local FunctionUtils = require('utils.function')

--- Returns the RGB representation of a hexidecimal string.
local hex_to_rgb = function(hex_str)
    local hex = hex_str:gsub('#', '')
    local r = tonumber('0x'..hex:sub(1, 2))
    local g = tonumber('0x'..hex:sub(3, 4))
    local b = tonumber('0x'..hex:sub(5, 6))
    return {r, g, b, 255}
end

--- Defines useful colours in hexadecimal format.
ColourCode = {
    background  = '#DFECE6',
    obstacle    = '#59A80F',
    collision   = '#99173C',
    vehicle     = '#028F76',
    pursuer     = '#1C2130'
}

-- Maps colours in ColourCode to RGB format.
FunctionUtils.imap(hex_to_rgb, ColourCode)

return ColourCode
