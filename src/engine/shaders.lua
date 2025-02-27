local Shaders = {}

Shaders["GradientH"] = love.graphics.newShader([[
    extern vec3 from;
    extern vec3 to;
    extern number scale;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 froma = vec4(from.r, from.g, from.b, 1);
        vec4 toa = vec4(to.r, to.g, to.b, 1);
        return Texel(texture, texture_coords) * (froma + (toa - froma) * mod(texture_coords.x / scale, 1)) * color;
    }
]])

Shaders["GradientV"] = love.graphics.newShader([[
    extern vec3 from;
    extern vec3 to;
    extern number scale;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 froma = vec4(from.r, from.g, from.b, 1);
        vec4 toa = vec4(to.r, to.g, to.b, 1);
        return Texel(texture, texture_coords) * (froma + (toa - froma) * mod(texture_coords.y / scale, 1)) * color;
    }
]])

Shaders["GradientH"]:send("scale", 1)
Shaders["GradientV"]:send("scale", 1)

Shaders["White"] = love.graphics.newShader([[
    extern float whiteAmount;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 outputcolor = Texel(texture, texture_coords) * color;
        outputcolor.rgb += (vec3(1, 1, 1) - outputcolor.rgb) * whiteAmount;
        return outputcolor;
    }
]])

Shaders["AddColor"] = love.graphics.newShader([[
    extern vec3 inputcolor;
    extern float amount;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
    {
        vec4 outputcolor = Texel(texture, texture_coords) * color;
        outputcolor.rgb += (inputcolor.rgb - outputcolor.rgb) * amount;
        return outputcolor;
    }
]])

Shaders["Mask"] = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        if (Texel(texture, texture_coords).a == 0) {
            // a discarded pixel wont be applied as the stencil.
            discard;
        }
        return vec4(1.0);
    }
 ]]

return Shaders