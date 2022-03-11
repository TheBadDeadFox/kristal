local item = HealItem{
    -- Item ID (optional, defaults to path)
    id = "lancer_cookie",
    -- Display name
    name = "LancerCookie",

    -- Item type (item, key, weapon, armor)
    type = "item",
    -- Item icon (for equipment)
    icon = nil,

    -- Battle description
    effect = "Heals\n50HP",
    -- Shop description
    shop = "",
    -- Menu description
    description = "A cookie shaped like Lancer's face.\nMaybe not a cookie. Heals 1 HP?",

    -- Amount healed (HealItem variable)
    heal_amount = 50,
    -- Amount healed in the overworld
    heal_amount_overworld = 1,

    -- Shop sell price
    price = 5,

    -- Consumable target mode (party, enemy, noselect, or none/nil)
    target = "party",
    -- Where this item can be used (world, battle, all, or none/nil)
    usable_in = "all",
    -- Item this item will get turned into when consumed
    result_item = nil,

    -- Equip bonuses (for weapons and armor)
    bonuses = {},
    -- Bonus name and icon (displayed in equip menu)
    bonus_name = nil,
    bonus_icon = nil,

    -- Equippable characters (default true for armors, false for weapons)
    can_equip = {},

    -- Character reactions (key = party member id)
    reactions = {
        susie = "Mmm... face",
        ralsei = "(uncomfortable)",
        noelle = "Umm, what is this? It's cute..."
    },
}

function item:onWorldUse(target)
    Game.world:heal(target, item.heal_amount_overworld)
    return true
end

return item