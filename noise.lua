local noise = {}
local pngEncoder = require("pngencoder")
local perlin = require("perlin")
local function paintPixel(png, tbl, bgcolor)
    local w, h = png.width, png.height
    local backgroundColor = bgcolor or {0, 0, 0, 0}
    local colorMap = {}
    for x = 0, w - 1 do
        for y = 0, h - 1 do
            colorMap[(y * w + x) * 4 + 1] = backgroundColor[1]
            colorMap[(y * w + x) * 4 + 2] = backgroundColor[2]
            colorMap[(y * w + x) * 4 + 3] = backgroundColor[3]
            colorMap[(y * w + x) * 4 + 4] = backgroundColor[4]
        end
    end
    for _, item in ipairs(tbl) do
        local idx = (item.y * w + item.x) * 4
        colorMap[idx + 1] = item.color[1]
        colorMap[idx + 2] = item.color[2]
        colorMap[idx + 3] = item.color[3]
        colorMap[idx + 4] = item.color[4]
    end
    png:write(colorMap)
end

local function createAndSavePNG(width, height, colorMode, pixels, bgcolor, filename)
    local newPNG = pngEncoder(width, height, colorMode)
    paintPixel(newPNG, pixels, bgcolor)
    local file = io.open(filename, "wb") or error("Failed to open file")
    file:write(table.concat(newPNG.output))
    file:close()
end


function noise:generateWhiteNoise(width, height, filename)
    if not filename then
        filename = os.time()..".png"
    end
    width = width or 256
    height = height or 256
    local pixels = {}
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            local value = math.random(0, 255) 
            table.insert(pixels, {x = x, y = y, color = {value, value, value, 255}})
        end
    end
    createAndSavePNG(width, height, "rgba", pixels, {0, 0, 0, 0}, filename)
    return filename, pixels
end

function noise:generateColorNoise(width, height, filename)
    if not filename then
        filename = os.time()..".png"
    end
    width = width or 256
    height = height or 256
    local pixels = {}
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            local r,g,b = math.random(0, 255), math.random(0, 255), math.random(0, 255)
            table.insert(pixels, {x = x, y = y, color = {r, g, b, 255}})
        end
    end
    createAndSavePNG(width, height, "rgba", pixels, {0, 0, 0, 0}, filename)
    return filename, pixels
end

function noise:generateImage(width,height,color,filename)
    color = color:gsub("#","")
    color = {tonumber("0x"..color:sub(1,2)), tonumber("0x"..color:sub(3,4)), tonumber("0x"..color:sub(5,6)), 255}
    if not filename then
        filename = os.time()..".png"
    end
    width = width or 256
    height = height or 256
    local pixels = {}
    color = color or {0, 0, 0, 0}
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            table.insert(pixels, {x = x, y = y, color = color})
        end
    end
    createAndSavePNG(width, height, "rgba", pixels, {0, 0, 0, 0}, filename)
    return filename
end

function noise:generatePng(width, height, filename)
    if not filename then
        filename = os.time()..".png"
    end
    width = width or 256
    height = height or 256
    createAndSavePNG(width, height, "rgba",{}, {0, 0, 0, 0}, filename)
    return filename
end

function noise:randomizePerlinNoise()
    perlin:randomize()
end
function noise:generatePerlinNoise(width, height, scale,frequency, amplitude, filename)
    if not filename then
        filename = os.time()..".png"
    end
    width = width or 256
    height = height or 256
    scale = scale or 10
    frequency = frequency or 0.5
    amplitude = amplitude or 0.5

    local pixels = {}
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            local nx = x / width * scale * frequency
            local ny = y / height * scale * frequency
            local value = (perlin:noise(nx, ny, 0) * amplitude + 1) / 2
            local colorValue = math.floor(value * 255)
            table.insert(pixels, {x = x, y = y, color = {colorValue, colorValue, colorValue, 255}})
        end
    end
    createAndSavePNG(width, height, "rgba", pixels, {0, 0, 0, 0}, filename)
    return filename, pixels
end

function noise:generateNoiseFromPalette(width, height, palette, filename)
    if not filename then
        filename = os.time()..".png" 
    end
    width = width or 256
    height = height or 256
    local pixels = {}
    for x = 0, width - 1 do
        for y = 0, height - 1 do
            local color = palette[math.random(1, #palette)]
            table.insert(pixels, {x = x, y = y, color = color})
        end
    end
    createAndSavePNG(width, height, "rgba", pixels, {0, 0, 0, 0}, filename)
    return filename, pixels
end

return noise
