local DarkTransitionParticle, super = Class(Object)

function DarkTransitionParticle:init(x, y)
    super:init(self, x, y)

    self.vspeed = -2
    self.image_xscale = 2
    self.image_yscale = 2
    self.friction = 0.07
    self.hspeed = (-1 + (math.random() * 2))

    self.depth = -100
    self.image_alpha = 1
end

function DarkTransitionParticle:update(dt)
    self.vspeed = self.vspeed - (self.friction * (dt * 30))
    self:move(self.hspeed * (dt * 30), self.vspeed * (dt * 30))

    self.image_alpha = self.image_alpha - 0.05
    if (self.image_alpha <= 0) then
        self:remove()
    end

    super:update(self, dt)
end

function DarkTransitionParticle:draw()
    love.graphics.setPointSize(2 * 2)
    love.graphics.setColor(1, 1, 1, self.image_alpha)
    love.graphics.points(0, 0)

    super:draw(self)
end

return DarkTransitionParticle