-- ============================================================
-- Rainbow Six Siege Recoil Helper
-- Logitech G HUB Lua Script
-- ============================================================
-- HOW TO USE:
--   - Hold MOUSE4 (side button) + scroll wheel to cycle operators
--   - Hold MOUSE4 + MOUSE5 to toggle attacker/defender
--   - Hold MOUSE4 + G-key (or keyboard key below) to select weapon slot
--   - Script activates on left mouse button hold while aiming (right mouse held)
--   - Set your in-game sensitivity and DPI at the top of this file
-- ============================================================

-- ============================================================
-- USER SETTINGS - EDIT THESE TO MATCH YOUR GAME SETTINGS
-- ============================================================
local SENSITIVITY   = 10     -- in-game sensitivity (1-100)
local DPI           = 800    -- your mouse DPI
local FOV           = 87     -- in-game FOV
local X_FACTOR      = 0.02   -- horizontal recoil multiplier (tweak 0.01-0.05)
local USE_VERT_GRIP = true   -- set true if using Vertical Grip
local USE_FLASHHIDER= false  -- set true if using Flash Hider (adds 20% compensation)

-- ============================================================
-- SENSITIVITY CALCULATION HELPERS
-- ============================================================
local function calcADS(modifier, fov_mult, ads_mult)
    local fov_adj = math.tan((fov_mult * FOV) * math.pi / 180 / 2)
                  / math.tan(FOV * math.pi / 180 / 2)
    return math.floor(modifier / (ads_mult / fov_adj) * X_FACTOR * ads_mult * SENSITIVITY + 0.5)
end

local function calcRecoil(ads_sens)
    local default_sens = 7
    local default_move = 3
    local k = default_sens * default_move
    return math.floor(k / ads_sens + 0.5)
end

-- x1 scope (1x red dot / holo): modifier = 25, fov_mult = 0.9, ads_mult = 0.6
-- x2.5 scope (ACOG):            modifier = 50, fov_mult = 0.42, ads_mult = 0.42
local function getRecoilForScope(scope)
    local ads
    if scope == "x1" then
        ads = calcADS(25, 0.9, 0.6)
    elseif scope == "acog" then
        ads = calcADS(50, 0.42, 0.42)
    else
        ads = calcADS(25, 0.9, 0.6)
    end
    if ads < 1 then ads = 1 end
    local pull = calcRecoil(ads)
    -- Vertical Grip removes 20% recoil, so reduce compensation
    if USE_VERT_GRIP then
        pull = math.floor(pull * 0.8 + 0.5)
    end
    -- Flash Hider removes 20% recoil, so reduce compensation
    if USE_FLASHHIDER then
        pull = math.floor(pull * 0.8 + 0.5)
    end
    if pull < 1 then pull = 1 end
    return pull
end

-- ============================================================
-- WEAPON DATA
-- timing = ms delay between mouse moves (from RPM / 6000)
-- has_acog = whether this weapon supports ACOG scope
-- ============================================================
local weapons = {
    -- ARs
    ["416-C CARBINE"]   = { timing = 8,  has_acog = false },
    ["552 COMMANDO"]    = { timing = 8,  has_acog = true  },
    ["556XI"]           = { timing = 8,  has_acog = true  },
    ["AK-12"]           = { timing = 7,  has_acog = true  },
    ["AK-74M"]          = { timing = 9,  has_acog = true  },
    ["AR33"]            = { timing = 8,  has_acog = true  },
    ["ARX200"]          = { timing = 8,  has_acog = true  },
    ["AUG A2"]          = { timing = 8,  has_acog = true  },
    ["C7E"]             = { timing = 7,  has_acog = true  },
    ["C8-SFW"]          = { timing = 7,  has_acog = true  },
    ["COMMANDO 9"]      = { timing = 7,  has_acog = false },
    ["F2"]              = { timing = 6,  has_acog = true  },
    ["F90"]             = { timing = 7,  has_acog = true  },
    ["G36C"]            = { timing = 7,  has_acog = true  },
    ["L85A2"]           = { timing = 8,  has_acog = true  },
    ["M4"]              = { timing = 8,  has_acog = true  },
    ["M762"]            = { timing = 8,  has_acog = true  },
    ["MK17 CQB"]        = { timing = 10, has_acog = true  },
    ["PARA-308"]        = { timing = 9,  has_acog = true  },
    ["PCX-33"]          = { timing = 8,  has_acog = false },
    ["POF-9"]           = { timing = 8,  has_acog = true  },
    ["R4-C"]            = { timing = 6,  has_acog = true  },
    ["SC3000K"]         = { timing = 7,  has_acog = true  },
    ["SPEAR .308"]      = { timing = 8,  has_acog = true  },
    ["TYPE-89"]         = { timing = 7,  has_acog = true  },
    ["V308"]            = { timing = 8,  has_acog = true  },
    -- SMGs
    ["9mm C1"]          = { timing = 10, has_acog = true  },
    ["9x19VSN"]         = { timing = 8,  has_acog = true  },
    ["AUG A3"]          = { timing = 8,  has_acog = false },
    ["FMG-9"]           = { timing = 7,  has_acog = true  },
    ["K1A"]             = { timing = 8,  has_acog = false },
    ["M12"]             = { timing = 10, has_acog = false },
    ["MP5"]             = { timing = 7,  has_acog = true  },
    ["MP5K"]            = { timing = 7,  has_acog = false },
    ["MP5SD"]           = { timing = 7,  has_acog = true  },
    ["MP7"]             = { timing = 6,  has_acog = true  },
    ["MPX"]             = { timing = 7,  has_acog = false },
    ["Mx4 Storm"]       = { timing = 6,  has_acog = false },
    ["P10 RONI"]        = { timing = 6,  has_acog = false },
    ["P90"]             = { timing = 6,  has_acog = true  },
    ["PDW9"]            = { timing = 7,  has_acog = true  },
    ["SCORPION EVO 3 A1"]={ timing = 5,  has_acog = false },
    ["T-5 SMG"]         = { timing = 6,  has_acog = false },
    ["UMP45"]           = { timing = 10, has_acog = true  },
    ["UZK50GI"]         = { timing = 8,  has_acog = false },
    ["VECTOR .45 ACP"]  = { timing = 5,  has_acog = true  },
    -- LMGs
    ["6P41"]            = { timing = 8,  has_acog = true  },
    ["ALDA 5.56"]       = { timing = 6,  has_acog = false },
    ["DP27"]            = { timing = 10, has_acog = false }, -- needs 12ms per source but table says 10
    ["G8A1"]            = { timing = 7,  has_acog = true  },
    ["LMG-E"]           = { timing = 8,  has_acog = true  },
    ["M249 SAW"]        = { timing = 9,  has_acog = true  },
    ["M249"]            = { timing = 9,  has_acog = true  },
    ["T-95 LSW"]        = { timing = 9,  has_acog = true  },
    -- DMRs (semi-auto, no RCS needed but included for completeness)
    ["417"]             = { timing = 13, has_acog = true  },
    ["AR-15.50"]        = { timing = 13, has_acog = true  },
    ["CAMRS"]           = { timing = 14, has_acog = true  },
    ["Mk 14 EBR"]       = { timing = 13, has_acog = true  },
    ["OTs-03"]          = { timing = 15, has_acog = true  },
    ["SR-25"]           = { timing = 13, has_acog = true  },
    -- MPs (pistol-class full-auto)
    ["BEARING 9"]       = { timing = 5,  has_acog = false },
    ["C75 Auto"]        = { timing = 6,  has_acog = false },
    ["SMG-11"]          = { timing = 4,  has_acog = false },
    ["SMG-12"]          = { timing = 4,  has_acog = false },
    ["SPSMG9"]          = { timing = 6,  has_acog = false },
}

-- ============================================================
-- OPERATOR LOADOUTS
-- ============================================================
local attackers = {
    { name="Striker",    p={ "M4", "M249" },              s={ "5.7 USG", "ITA12S" }     },
    { name="Sledge",     p={ "M590A1", "L85A2" },         s={ "P226 MK 25" }            },
    { name="Thatcher",   p={ "AR33", "L85A2", "M590A1" }, s={ "P226 MK 25" }            },
    { name="Ash",        p={ "G36C", "R4-C" },            s={ "M45 MEUSOC", "5.7 USG" } },
    { name="Thermite",   p={ "M1014", "556XI" },          s={ "M45 MEUSOC", "5.7 USG" } },
    { name="Twitch",     p={ "F2", "417", "SG-CQB" },     s={ "P9", "LFP586" }          },
    { name="Montagne",   p={ "Shield" },                  s={ "P9", "LFP586" }          },
    { name="Glaz",       p={ "OTs-03" },                  s={ "PMM", "GONNE-6", "BEARING 9" } },
    { name="Fuze",       p={ "Shield", "6P41", "AK-12" }, s={ "PMM", "GSH-18" }         },
    { name="Blitz",      p={ "Shield" },                  s={ "P12" }                   },
    { name="IQ",         p={ "AUG A2", "552 COMMANDO", "G8A1" }, s={ "P12" }            },
    { name="Buck",       p={ "C8-SFW", "CAMRS" },         s={ "MK1 9mm" }               },
    { name="Blackbeard", p={ "Shield" },                  s={ "MK17 CQB", "SR-25" }     },
    { name="Capitao",    p={ "PARA-308", "M249" },        s={ "PRB92", "GONNE-6" }       },
    { name="Hibana",     p={ "TYPE-89", "SUPERNOVA" },    s={ "P229", "BEARING 9" }      },
    { name="Jackal",     p={ "C7E", "PDW9", "ITA12L" },   s={ "USP40", "ITA12S" }        },
    { name="Ying",       p={ "T-95 LSW", "SIX12" },       s={ "Q-929" }                  },
    { name="Zofia",      p={ "LMG-E", "M762" },           s={ "RG15" }                   },
    { name="Dokkaebi",   p={ "Mk 14 EBR", "BOSG.12.2" }, s={ "SMG-12", "C75 Auto", "GONNE-6" } },
    { name="Lion",       p={ "V308", "417", "SG-CQB" },   s={ "LFP586", "P9" }           },
    { name="Finka",      p={ "SPEAR .308", "6P41", "SASG-12" }, s={ "PMM", "GSH-18" }   },
    { name="Maverick",   p={ "AR-15.50", "M4" },          s={ "1911 TACOPS" }             },
    { name="Nomad",      p={ "AK-74M", "ARX200" },        s={ ".44 Mag Semi-Auto", "PRB92" } },
    { name="Gridlock",   p={ "F90", "M249 SAW" },         s={ "SUPER SHORTY", "SDP 9mm" } },
    { name="Nokk",       p={ "FMG-9", "SIX12 SD" },       s={ "5.7 USG", "D-50" }        },
    { name="Amaru",      p={ "G8A1", "SUPERNOVA" },       s={ "SMG-11", "ITA12S", "GONNE-6" } },
    { name="Kali",       p={ "CSRX 300" },                s={ "SPSMG9", "C75 Auto", "P226 MK 25" } },
    { name="Iana",       p={ "ARX200", "G36C" },          s={ "MK1 9mm", "GONNE-6" }     },
    { name="Ace",        p={ "AK-12", "M1014" },          s={ "P9" }                      },
    { name="Zero",       p={ "SC3000K", "MP7" },          s={ "5.7 USG", "GONNE-6" }     },
    { name="Flores",     p={ "AR33", "SR-25" },           s={ "GSH-18" }                  },
    { name="Osa",        p={ "556XI", "PDW9" },           s={ "PMM" }                     },
    { name="Sens",       p={ "POF-9", "417" },            s={ "SDP 9mm" }                 },
    { name="Grim",       p={ "552 COMMANDO", "SG-CQB" },  s={ "P229", "Bailiff 410" }     },
    { name="Brava",      p={ "PARA-308", "CAMRS" },       s={ "SUPER SHORTY", "USP40" }   },
    { name="Ram",        p={ "R4-C", "LMG-E" },           s={ "MK1 9mm", "ITA12S" }       },
    { name="Deimos",     p={ "AK-74M", "M590A1" },        s={ ".44 Vendetta" }             },
}

local defenders = {
    { name="Sentry",      p={ "COMMANDO 9", "M870" },        s={ "C75 Auto", "SUPER SHORTY" }    },
    { name="Smoke",       p={ "FMG-9", "M590A1" },           s={ "P226 MK 25", "SMG-11" }        },
    { name="Mute",        p={ "MP5K", "M590A1" },            s={ "P226 MK 25", "SMG-11" }        },
    { name="Castle",      p={ "UMP45", "M1014" },            s={ "5.7 USG", "SUPER SHORTY", "M45 MEUSOC" } },
    { name="Pulse",       p={ "M1014", "UMP45" },            s={ "M45 MEUSOC", "5.7 USG" }       },
    { name="Doc",         p={ "SG-CQB", "MP5", "P90" },      s={ "P9", "LFP586", "Bailiff 410" } },
    { name="Rook",        p={ "P90", "MP5", "SG-CQB" },      s={ "LFP586", "P9" }                },
    { name="Kapkan",      p={ "9x19VSN", "SASG-12" },        s={ "PMM", "GSH-18" }               },
    { name="Tachanka",    p={ "DP27", "9x19VSN" },           s={ "GSH-18", "PMM", "BEARING 9" }  },
    { name="Jager",       p={ "M870", "416-C CARBINE" },     s={ "P12" }                          },
    { name="Bandit",      p={ "MP7", "M870" },               s={ "P12" }                          },
    { name="Frost",       p={ "SUPER 90", "9mm C1" },        s={ "MK1 9mm", "ITA12S" }           },
    { name="Valkyrie",    p={ "MPX", "SPAS-12" },            s={ "D-50" }                         },
    { name="Caveira",     p={ "M12", "SPAS-15" },            s={ "LUISON" }                       },
    { name="Echo",        p={ "SUPERNOVA", "MP5SD" },        s={ "P229", "BEARING 9" }            },
    { name="Mira",        p={ "VECTOR .45 ACP", "ITA12L" },  s={ "USP40", "ITA12S" }              },
    { name="Lesion",      p={ "SIX12 SD", "T-5 SMG" },       s={ "Q-929" }                        },
    { name="Ela",         p={ "SCORPION EVO 3 A1", "FO-12" }, s={ "RG15" }                        },
    { name="Vigil",       p={ "K1A", "BOSG.12.2" },          s={ "C75 Auto", "SMG-12" }           },
    { name="Maestro",     p={ "ALDA 5.56", "ACS12" },        s={ "Bailiff 410", "KERATOS .357" }  },
    { name="Alibi",       p={ "Mx4 Storm", "ACS12" },        s={ "KERATOS .357", "Bailiff 410" }  },
    { name="Clash",       p={},                              s={ "SUPER SHORTY", "SPSMG9", "P-10C" } },
    { name="Kaid",        p={ "AUG A3", "TCSG12" },          s={ ".44 Mag Semi-Auto", "LFP586" }  },
    { name="Mozzie",      p={ "COMMANDO 9", "P10 RONI" },    s={ "SDP 9mm" }                      },
    { name="Warden",      p={ "M590A1", "MPX" },             s={ "P-10C", "SMG-12" }              },
    { name="Goyo",        p={ "VECTOR .45 ACP", "TCSG12" },  s={ "P229" }                         },
    { name="Wamai",       p={ "AUG A2", "MP5K" },            s={ "KERATOS .357", "P12" }          },
    { name="Oryx",        p={ "T-5 SMG", "SPAS-12" },        s={ "Bailiff 410", "USP40" }         },
    { name="Melusi",      p={ "MP5", "SUPER 90" },           s={ "RG15", "ITA12S" }               },
    { name="Aruni",       p={ "P10 RONI", "Mk 14 EBR" },     s={ "PRB92" }                        },
    { name="Thunderbird", p={ "SPEAR .308", "SPAS-15" },     s={ "Q-929", "BEARING 9", "ITA12S" } },
    { name="Thorn",       p={ "UZK50GI", "M870" },           s={ "1911 TACOPS", "C75 Auto" }      },
    { name="Azami",       p={ "9x19VSN", "ACS12" },          s={ "D-50" }                         },
    { name="Solis",       p={ "P90", "ITA12L" },             s={ "SMG-11" }                       },
    { name="Fenrir",      p={ "MP7", "SASG-12" },            s={ "Bailiff 410", "5.7 USG" }       },
    { name="Tuberao",     p={ "MPX", "AR-15.50" },           s={ "P226 MK 25" }                   },
    { name="Skopos",      p={ "PCX-33" },                    s={ "P229" }                         },
}

-- ============================================================
-- STATE
-- ============================================================
local state = {
    side          = "attacker",   -- "attacker" or "defender"
    op_index      = 1,
    weapon_slot   = "p1",         -- "p1", "p2", "p3", "s1", "s2", "s3"
    scope         = "x1",         -- "x1" or "acog"
    rcs_active    = false,
    mouse4_held   = false,
}

local function getCurrentOps()
    if state.side == "attacker" then return attackers else return defenders end
end

local function getCurrentOp()
    local ops = getCurrentOps()
    local idx = state.op_index
    if idx < 1 then idx = #ops end
    if idx > #ops then idx = 1 end
    return ops[idx]
end

local function getCurrentWeapon()
    local op = getCurrentOp()
    local slot = state.weapon_slot
    local list, num

    if slot:sub(1,1) == "p" then
        list = op.p
        num  = tonumber(slot:sub(2))
    else
        list = op.s
        num  = tonumber(slot:sub(2))
    end

    if not list or not list[num] then return nil end
    local wname = list[num]
    return wname, weapons[wname]
end

local function printStatus()
    local op    = getCurrentOp()
    local wname, wdata = getCurrentWeapon()
    local info  = "[R6S RCS] Side: " .. state.side
                .. " | Op: " .. op.name
                .. " | Slot: " .. state.weapon_slot
    if wname then
        info = info .. " | Weapon: " .. wname
               .. " | Scope: " .. state.scope
    else
        info = info .. " | Weapon: (none/shield)"
    end
    OutputLogMessage(info .. "\n")
end

-- ============================================================
-- RECOIL LOOP
-- ============================================================
local function doRecoil()
    local wname, wdata = getCurrentWeapon()
    if not wdata then return end
    -- Skip shotguns, snipers, shields, revolvers (no useful RCS)
    if wdata.timing > 20 then return end

    local base_pull = getRecoilForScope(state.scope)
    local delay     = wdata.timing

    -- Only compensate while LMB is held
    while IsMouseButtonPressed(1) do
        -- Randomize pull by +/- 0-2 pixels so output is never perfectly uniform
        local variance = math.random(-2, 2)
        local pull     = math.max(1, base_pull + variance)
        MoveMouseRelative(0, pull)
        -- Randomize delay by +/- 1ms for the same reason
        local jitter = math.random(-1, 1)
        Sleep(math.max(1, delay + jitter))
    end
end

-- ============================================================
-- EVENT HANDLER
-- ============================================================
function OnEvent(event, arg)
    -- Track MOUSE4 (side button 1) as modifier
    if event == "MOUSE_BUTTON_PRESSED" and arg == 4 then
        state.mouse4_held = true
    end
    if event == "MOUSE_BUTTON_RELEASED" and arg == 4 then
        state.mouse4_held = false
    end

    -- MOUSE4 + scroll up: next operator
    if event == "MOUSE_BUTTON_PRESSED" and arg == 5 and state.mouse4_held then
        local ops = getCurrentOps()
        state.op_index = state.op_index + 1
        if state.op_index > #ops then state.op_index = 1 end
        state.weapon_slot = "p1"
        printStatus()
        return
    end

    -- MOUSE4 + scroll down: previous operator
    -- (G HUB maps scroll wheel as buttons 6/7 depending on version; adjust if needed)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 6 and state.mouse4_held then
        local ops = getCurrentOps()
        state.op_index = state.op_index - 1
        if state.op_index < 1 then state.op_index = #ops end
        state.weapon_slot = "p1"
        printStatus()
        return
    end

    -- MOUSE4 + MOUSE5 (button 5 without scroll context): toggle side
    -- Using G-keys or keyboard keys below is more reliable; see key mappings.

    -- Keyboard key mappings while MOUSE4 is held:
    -- F1 = weapon slot p1, F2 = p2, F3 = p3
    -- F4 = secondary s1, F5 = s2, F6 = s3
    -- F7 = toggle attacker/defender
    -- F8 = toggle scope x1/acog

    if event == "G_PRESSED" then
        if state.mouse4_held then
            if arg == 1 then state.weapon_slot = "p1"; printStatus()
            elseif arg == 2 then state.weapon_slot = "p2"; printStatus()
            elseif arg == 3 then state.weapon_slot = "p3"; printStatus()
            elseif arg == 4 then state.weapon_slot = "s1"; printStatus()
            elseif arg == 5 then state.weapon_slot = "s2"; printStatus()
            elseif arg == 6 then state.weapon_slot = "s3"; printStatus()
            elseif arg == 7 then
                state.side = (state.side == "attacker") and "defender" or "attacker"
                state.op_index = 1
                state.weapon_slot = "p1"
                printStatus()
            elseif arg == 8 then
                state.scope = (state.scope == "x1") and "acog" or "x1"
                printStatus()
            end
        end
    end

    -- Activate RCS: LMB pressed while RMB (aim) is also held
    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 then
        if IsMouseButtonPressed(3) then   -- RMB = button 3 = ADS
            state.rcs_active = true
            doRecoil()
            state.rcs_active = false
        end
    end
end
-- ============================================================
-- END OF SCRIPT
-- ============================================================
-- NOTES:
-- 1. Paste this entire script into G HUB -> Macros -> Scripting
--    and assign it to your Siege profile.
-- 2. G-keys (G1-G8) refer to dedicated G-keys on supported mice/keyboards.
--    If your device lacks G-keys, remap the G_PRESSED block to
--    keyboard keys using KEY_PRESSED events and the key name strings.
--    Example: replace "G_PRESSED" with "KEY_PRESSED" and arg with
--    the key name e.g. "f1", "f2", etc.
-- 3. The horizontal recoil (X_FACTOR) defaults to a conservative 0.02.
--    Increase it slightly if you want left/right sway correction.
-- 4. DMRs (417, SR-25, OTs-03, etc.) fire semi-auto so the LMB hold
--    loop exits immediately after one move; they are effectively a no-op.
-- 5. Shotguns and snipers (timing > 20ms) are excluded from RCS.
-- ============================================================
