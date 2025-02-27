local Virovirus, super = Class(Bullet)

function Virovirus:init(x, y)
    super:init(self, x, y)

    self:setSprite("bullets/viro_virus", 3/30, true)
    self:setHitbox(5, 5, 6, 6)

    self.physics.speed = 0.1
    self.physics.friction = -0.1
    self.physics.direction = Utils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
end

return Virovirus