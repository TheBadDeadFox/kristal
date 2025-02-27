local HealSparkle, super = Class(Sprite)

function HealSparkle:init(x, y)
    super:init(self, "effects/spare/star", x, y)

    self:play(4/30, true)

    self:setColor(0, 1, 0)
    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self:fadeOutAndRemove(0.1)

    self.rotation = love.math.random() * math.rad(360)

    self.physics.speed_x = 2 - (love.math.random() * 2)
    self.physics.speed_y = -3 - (love.math.random() * 2)
    self.physics.friction = 0.2

    self.alpha = 2
    self.spin = -10
end

function HealSparkle:update(dt)
    self.rotation = self.rotation + (math.rad(self.spin) * DTMULT)

    super:update(self, dt)
end

return HealSparkle