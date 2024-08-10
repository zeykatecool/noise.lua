local perlin = {}
perlin.p = {}
local bit32 = require("bit")

local permutation = {}

for i=0,255 do
    permutation[i+1] = math.random(0, 255)
end

for i=0,255 do
    perlin.p[i] = permutation[i+1]
    perlin.p[i+256] = permutation[i+1]
end

function perlin:randomize()
    for i=0,255 do
        permutation[i+1] = math.random(0, 255)
        perlin.p[i] = permutation[i+1]
    end
end

function perlin:noise(x, y, z)
    y = y or 0
    z = z or 0
    local xi = bit32.band(math.floor(x),255)
    local yi = bit32.band(math.floor(y),255)
    local zi = bit32.band(math.floor(z),255)

    x = x - math.floor(x)
    y = y - math.floor(y)
    z = z - math.floor(z)

    local u = self.fade(x)
    local v = self.fade(y)
    local w = self.fade(z)

    local p = self.p
    local A, AA, AB, AAA, ABA, AAB, ABB, B, BA, BB, BAA, BBA, BAB, BBB
    A   = p[xi  ] + yi
    AA  = p[A   ] + zi
    AB  = p[A+1 ] + zi
    AAA = p[ AA ]
    ABA = p[ AB ]
    AAB = p[ AA+1 ]
    ABB = p[ AB+1 ]

    B   = p[xi+1] + yi
    BA  = p[B   ] + zi
    BB  = p[B+1 ] + zi
    BAA = p[ BA ]
    BBA = p[ BB ]
    BAB = p[ BA+1 ]
    BBB = p[ BB+1 ]


    return self.lerp(w,
        self.lerp(v,
            self.lerp(u,
                self:grad(AAA,x,y,z),
                self:grad(BAA,x-1,y,z)
            ),
            self.lerp(u,
                self:grad(ABA,x,y-1,z),
                self:grad(BBA,x-1,y-1,z)
            )
        ),
        self.lerp(v,
            self.lerp(u,
                self:grad(AAB,x,y,z-1), self:grad(BAB,x-1,y,z-1)
            ),
            self.lerp(u,
                self:grad(ABB,x,y-1,z-1), self:grad(BBB,x-1,y-1,z-1)
            )
        )
    )
end

perlin.dot_product = {
    [0x0]=function(x,y,z) return  x + y end,
    [0x1]=function(x,y,z) return -x + y end,
    [0x2]=function(x,y,z) return  x - y end,
    [0x3]=function(x,y,z) return -x - y end,
    [0x4]=function(x,y,z) return  x + z end,
    [0x5]=function(x,y,z) return -x + z end,
    [0x6]=function(x,y,z) return  x - z end,
    [0x7]=function(x,y,z) return -x - z end,
    [0x8]=function(x,y,z) return  y + z end,
    [0x9]=function(x,y,z) return -y + z end,
    [0xA]=function(x,y,z) return  y - z end,
    [0xB]=function(x,y,z) return -y - z end,
    [0xC]=function(x,y,z) return  y + x end,
    [0xD]=function(x,y,z) return -y + z end,
    [0xE]=function(x,y,z) return  y - x end,
    [0xF]=function(x,y,z) return -y - z end
}
function perlin:grad(hash, x, y, z)
    return self.dot_product[bit32.band(hash,0xF)](x,y,z)
end

function perlin.fade(t)
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function perlin.lerp(t, a, b)
    return a + t * (b - a)
end
return perlin