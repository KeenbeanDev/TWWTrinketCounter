SLASH_TWWTRINKETCOUNTER1, SLASH_TWWTRINKETCOUNTER2 = '/trinketcount', '/tcount'
SlashCmdList['TWWTRINKETCOUNTER'] = function(msg, editBox)
    local tLooted = TrinketsDropped -- This is the total number of Trinket Drops
    local gLooted = TotalDrops -- This is the total number of  Drops
    local calc = (tLooted/gLooted)*100 -- Gets % figure of trinket to drop ratio
    
    if(tostring(calc) == '-nan(ind)') then calc = 0 end -- If dividing 0/0, this handles the error.
    local result = tonumber(string.format('%.2f', calc))
    print('You have looted '..tLooted..' trinkets out of '..gLooted..' drops ('..result..'%).')

    if calc == 0 then print('Go do some content!') end
end

local LaunchFrame = CreateFrame('Frame')
LaunchFrame:RegisterEvent('ADDON_LOADED')
LaunchFrame:SetScript('OnEvent', 
    function(self, event, ...)
        if event == 'ADDON_LOADED' then
            if TrinketsDropped == nil then TrinketsDropped = 0 end
            if TotalDrops == nil then TotalDrops = 0 end
        end
    end
)

local Loot_EncounterLootReceivedFrame = CreateFrame('Frame')
Loot_EncounterLootReceivedFrame:RegisterEvent('ENCOUNTER_LOOT_RECEIVED')
Loot_EncounterLootReceivedFrame:SetScript('OnEvent', 
    function(self, event, ...)
        -- Get loot details from Encounter Loot
        local p_encounterID, p_itemID, p_itemLink, p_quantity, p_playerName, p_classFileName = ...
        -- Lookup ItemID in database for item details
        local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, sellPrice, classID, subclassID, bindType, expacID, setID, isCraftingReagant = C_Item.GetItemInfo(p_itemID)
 
        -- If the loot dropped is not from War Within, end
        if expacID ~= 10 then return end
        local playerInfoName = UnitName('player') -- Get local player information
        -- If the loot dropped for someone else, end
        if playerInfoName ~= p_playerName then return end

        -- At this stage, the loot is the players and is from TWW. Therefore, we can assume this is a genuine drop.

        -- If the loot dropped is not a trinket, store in NonTrinketsDropped
        if itemEquipLoc == 'INVTYPE_TRINKET' then 
            TrinketsDropped = TrinketsDropped + 1
            TotalDrops = TotalDrops + 1

            -- Add code for logging which trinkets here?

            print('Congratulations, you got a Trinket drop!')
        else 
            TotalDrops = TotalDrops + 1
        end
    end
)