local Follower, super = Class(Character)

function Follower:init(chara, x, y, target)
    super:init(self, chara, x, y)

    self.index = 1
    self.target = target

    self.state_manager = StateManager("WALK", self, true)
    self.state_manager:addState("WALK")
    self.state_manager:addState("SLIDE", {enter = self.beginSlide, leave = self.endSlide})

    self.history_time = 0
    self.history = {}

    self.needs_slide = false

    self.following = true
    self.returning = false
end

function Follower:onRemove(parent)
    self.index = nil
    self:updateIndex()
    if self.index then
        table.remove(self.world.followers, self.index)
    end

    super:onRemove(self, parent)
end

function Follower:onAdd(parent)
    super:onAdd(self, parent)

    local target = self:getTarget()
    if target then
        self:copyHistoryFrom(target)
    end
end

function Follower:updateIndex()
    for i,v in ipairs(self.world.followers) do
        if v == self then
            self.index = i
        end
    end
end

function Follower:getTarget()
    return self.target or self.world.player
end

function Follower:getTargetPosition()
    local tx, ty, facing, state = self.x, self.y, self.facing, nil
    for i,v in ipairs(self.history) do
        tx, ty, facing, state = v.x, v.y, v.facing, v.state
        local upper = self.history_time - v.time
        if upper > (FOLLOW_DELAY * self.index) then
            if i > 1 then
                local prev = self.history[i - 1]
                local lower = self.history_time - prev.time

                local t = ((FOLLOW_DELAY * self.index) - lower) / (upper - lower)

                tx = Utils.lerp(prev.x, v.x, t)
                ty = Utils.lerp(prev.y, v.y, t)
            end
            break
        end
    end
    return tx, ty, facing, state
end

function Follower:interprolate(slow)
    if self:getTarget() and self:getTarget().history then
        local ex, ey = self:getExactPosition()
        local tx, ty, facing, state = self:getTargetPosition()

        local dx, dy = tx - ex, ty - ey

        if slow then
            local speed = 9 * DTMULT

            dx = Utils.approach(ex, tx, speed) - ex
            dy = Utils.approach(ey, ty, speed) - ey
        end

        self:move(dx, dy)

        if facing then
            self:setFacing(facing)
        end

        if state and self.state_manager:hasState(state) then
            self.state_manager:setState(state)
        end

        return dx, dy
    else
        return 0, 0
    end
end

function Follower:beginSlide()
    self.needs_slide = false
    self.sprite:setAnimation("slide")
end
function Follower:endSlide()
    self.sprite:resetSprite()
end

function Follower:copyHistoryFrom(target)
    self.history_time = target.history_time
    self.history = Utils.copy(target.history)
end
function Follower:updateHistory(dt, moved)
    local target = self:getTarget()
    if target.state == "SLIDE" and self.state ~= "SLIDE" then
        self.needs_slide = true
    end

    if moved or self.state == "SLIDE" or self.needs_slide then
        self.history_time = self.history_time + dt

        local ex, ey = target:getExactPosition()

        table.insert(self.history, 1, {x = ex, y = ey, facing = target.facing, time = self.history_time, state = target.state})
        while (self.history_time - self.history[#self.history].time) > (Game.max_followers * FOLLOW_DELAY) do
            table.remove(self.history, #self.history)
        end

        if self.following then
            self:interprolate()
        end
    end
end

function Follower:update(dt)
    self:updateIndex()

    if #self.history == 0 then
        local ex, ey = self:getExactPosition()
        table.insert(self.history, {x = ex, y = ey, time = 0})
    end

    if self.returning then
        local dx, dy = self:interprolate(true)
        if dx == 0 and dy == 0 then
            self.returning = false
        end
    end

    super:update(self, dt)
end

return Follower