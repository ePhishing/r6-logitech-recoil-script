# Logitech G HUB Lua Script - Educational Research

## ⚠️ DISCLAIMER

**THIS SCRIPT IS PROVIDED FOR EDUCATIONAL PURPOSES ONLY**

This is a **learning resource** demonstrating:
- Logitech G HUB scripting syntax and API
- Mathematical algorithms for sensitivity calculations
- Lua programming patterns
- Configuration management in gaming peripherals

---

## 🎓 Educational Purpose

This code teaches:
- **Lua scripting** for Logitech devices
- **Game mechanics research** (sensitivity, FOV calculations)
- **Mathematical functions** (trigonometry, timing algorithms)
- **State management** in embedded scripts
- **Event handling** patterns

---

## ⚖️ Legal Notice

### Important Acknowledgments

1. **Not for Active Gameplay**: This script is **NOT intended for use during online gameplay**

2. **Terms of Service**: Using automation tools during gameplay may violate:
   - Ubisoft Terms of Use
   - Rainbow Six Siege EULA
   - BattlEye Anti-Cheat Policy

3. **User Responsibility**: You are solely responsible for:
   - Understanding applicable Terms of Service
   - Any consequences of using this code
   - Compliance with game publisher policies

4. **Potential Consequences**:
   - Permanent account bans
   - Hardware ID bans  
   - Loss of game access
   - Forfeiture of purchased content

5. **No Warranty**: This code is provided "AS IS" without any warranty

6. **No Liability**: The author is NOT responsible for:
   - Account suspensions or bans
   - Loss of access to games
   - Any damages resulting from use of this code

---

## 📚 What This Demonstrates

### Technical Concepts

**Logitech G HUB API:**
- `OnEvent()` - Event handling
- `IsMouseButtonPressed()` - Input state checking
- `MoveMouseRelative()` - Programmatic mouse control
- `Sleep()` - Timing control
- `OutputLogMessage()` - Debug logging

**Mathematical Algorithms:**
- FOV-based sensitivity normalization
- ADS (Aim Down Sights) multiplier calculations
- Timing derivation from RPM (Rounds Per Minute)
- Randomization for variance

**Data Structures:**
- Weapon database organization
- Operator loadout tables
- State management patterns

**Programming Patterns:**
- Event-driven architecture
- Configuration-based behavior
- Modular function design

---

## 📖 Intended Use

This code is intended for:

✅ **Learning Lua programming**  
✅ **Studying Logitech G HUB scripting**  
✅ **Understanding game mechanics calculations**  
✅ **Educational research on input systems**  
✅ **Programming reference material**  
✅ **Academic study of gaming peripherals**  

This code is **NOT** intended for:

❌ Gaining unfair advantages in games  
❌ Violating Terms of Service  
❌ Circumventing anti-cheat systems  
❌ Use during competitive online play  
❌ Any form of cheating or unfair gameplay  

---

## 🔒 Compliance

### Before Using This Code

Users must:
1. Read and understand [Ubisoft Terms of Use](https://legal.ubi.com/termsofuse/)
2. Read and understand [Rainbow Six Siege Code of Conduct](https://www.ubisoft.com/en-us/game/rainbow-six/siege/news-updates/7KCYpawBBfZbOLEkh4B6cC/code-of-conduct)
3. Understand BattlEye anti-cheat policies
4. Use only for educational purposes in offline environments
5. Never use during online multiplayer gameplay

### Ethical Use

This code should be used **ONLY** for:
- Studying programming concepts
- Learning about peripheral scripting
- Understanding mathematical game calculations
- Educational research purposes
- Personal offline experimentation

---

## 📋 Technical Overview

### What This Code Does (Educational Analysis)

**Input:** 
- User configuration (DPI, sensitivity, FOV)
- Weapon selection from database
- Scope type selection

**Processing:**
- Calculates ADS sensitivity modifiers
- Computes timing based on weapon RPM
- Applies FOV-based normalization
- Adds randomization for variance

**Output:**
- Mouse movement commands via Logitech API
- Timing delays between movements
- Debug messages to G HUB console

### Key Algorithms

**Sensitivity Calculation:**
```lua
fov_adj = tan((fov_mult * FOV) * π / 180 / 2) / tan(FOV * π / 180 / 2)
```

**Timing Derivation:**
```
timing_ms = RPM / 6000
```

**Randomization:**
```lua
variance = random(-2, 2)
jitter = random(-1, 1)
```

---

## 🎯 Educational Value

### Learning Objectives

Students can learn about:

1. **Peripheral Programming**
   - Device-specific scripting APIs
   - Event-driven programming
   - State management

2. **Game Mechanics**
   - Sensitivity systems
   - FOV calculations
   - Weapon timing mechanics

3. **Mathematics**
   - Trigonometric functions
   - Normalization algorithms
   - Randomization techniques

4. **Software Engineering**
   - Configuration management
   - Modular design
   - Data structure organization

### Academic Applications

This code can be referenced in:
- Computer Science courses
- Game Development curriculum
- Human-Computer Interaction studies
- Peripheral device programming courses

---

## ⚠️ Final Warning

**BY DOWNLOADING OR VIEWING THIS CODE, YOU ACKNOWLEDGE:**

1. This is for **educational purposes only**
2. You will **NOT** use this during online gameplay
3. You understand the **risks** (bans, loss of access)
4. You take **full responsibility** for any consequences
5. The author assumes **NO LIABILITY** for your actions

**USE AT YOUR OWN RISK**

If you plan to use Logitech macros in any game, ensure they comply with the game's Terms of Service. When in doubt, **don't use it**.

---

## 📞 Takedown Request

If you represent Ubisoft, Rainbow Six Siege, or BattlEye and wish this repository removed, please contact me directly for immediate action.

---

## 📄 License

MIT License (Educational Use Only)

Permission granted for educational and research purposes only.  
Use of this code in violation of any game's Terms of Service is prohibited.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.

**THE AUTHOR BEARS NO RESPONSIBILITY FOR CONSEQUENCES OF USING THIS CODE.**

---

*Last Updated: 2026*  
*For Educational and Research Purposes Only*  
*Not Affiliated With Ubisoft, Rainbow Six Siege, or Logitech*
