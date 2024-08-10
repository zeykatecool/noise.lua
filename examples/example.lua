local noise = require("noise")

--Width:int,Height:int,Filename:string
noise:generatePng(256, 256, "empty.png") -- Creates a blank image

--Width:int,Height:int,Color:table,Filename:string
noise:generateImage(256, 256,{255, 0, 0,255}, "whiteImage.png") -- Creates an image filled with rgba(255,0,0,255)

--Width:int,Height:int,Filename:string
noise:generateColorNoise(256, 256, "colorNoise.png") -- Creates an image filled with random colors

--Width:int,Height:int,Filename:string
noise:generateWhiteNoise(256, 256, "whiteNoise.png") -- Creates an image filled with colors between 0 and 255 (black and white)

--Width:int,Height:int,Scale:int,Frequency:int,Amplitude:int,Filename:string
noise:generatePerlinNoise(256, 256, 10, 0.5, 0.5, "perlinNoise.png") -- Creates an image filled with perlin noise

--Width:int,Height:int,Palette:table,Filename:string
noise:generateNoiseFromPalette(256, 256, {{255, 0, 0,255},{0, 255, 0,255},{0, 0, 255,255}}, "noiseFromPalette.png") -- Creates an image filled with colors from the palette
