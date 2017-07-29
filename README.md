# Abstract

Multi-monitor setup, AwesomeWM, Unity game (KSP, Pillars of Eternity):

Game fails to constrain mouse to game window.

Doesn't matter much for KSP, but makes it very annoying trying to move the viewport in PoE.

# Usage

clone to ~/.config/awesome

```
local constr = require("awesome-constrain-mouse")

-- bind CTRL-F10 to constrain mouse to the client below the cursor
-- pressing CTRL-F10 again releases

globalkeys = gears.table.join(
    ....
    awful.key({ "Control" }, "F10", constr.toggle)
    ....
)

-- also:

constr.constrain(c)  -- constrain mouse movement to client c
constr.constrain()   -- constrain to client under cursor
constr.release()     -- release the lock
```






