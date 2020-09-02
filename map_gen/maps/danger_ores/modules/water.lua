local Perlin = require 'map_gen.shared.perlin_noise'
local seed_provider = require 'map_gen.maps.danger_ores.modules.seed_provider'
local b = require 'map_gen.shared.builders'

local perlin_noise = Perlin.noise

return function(config)
    local scale = config.water_scale or 1 / 96
    local water_threshold = config.water_threshold or 0.5
    local deepwater_threshold = config.deepwater_threshold or 0.55
    local no_water_shape = config.no_water_shape or b.circle(96)
    local seed = config.water_seed or seed_provider()

    return function(x, y)
        if no_water_shape(x, y) then
            return false
        end

        local water_noise = perlin_noise(x * scale, y * scale, seed)
        if water_noise >= deepwater_threshold then
            return 'deepwater'
        elseif water_noise >= water_threshold then
            return 'water'
        end

        return false
    end
end
