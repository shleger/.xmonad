import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Actions.CycleWS
import System.IO


-- NOTES: 0.10 works much better than 0.9, unfortunately distros mostly package 0.9 atm
-- xmobar and fullscreen flash vids (youtube): http://code.google.com/p/xmobar/issues/detail?id=41

-- TODO: would still like fullscreen flash vids to not crop and leave xmobar drawn
-- TODO: remove the red border when doing fullscreen? tried adding 'smartBorders' to the layoutHook but that didn't work
-- TODO: hook in TopicSpaces, start specific apps on specific workspaces
--
-- Dont foget to link for xmobar --recompile && xmobar --restart:
-- sudo ln -s ~/.local/bin/xmonad /usr/bin 
--

main = do
  xmproc <- spawnPipe "~/.local/bin/xmobar ~/.xmonad/.xmobarrc"
  --xmproc <- spawnPipe "stalonetray"
  xmonad $ defaultConfig {
    modMask = mod4Mask, 
    terminal = "kitty",
    manageHook = manageDocks <+> manageHook defaultConfig,
    layoutHook = avoidStruts $ layoutHook defaultConfig,
    handleEventHook = mconcat [ docksEventHook, handleEventHook defaultConfig ],

    logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc,
                          ppTitle = xmobarColor "green" "" . shorten 50
                        }
  } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_p), spawn "~/my/lockOut.sh"),
      ((mod4Mask .|. shiftMask, xK_s), spawn "flameshot gui"), 
      ((mod4Mask, xK_d), spawn "rofi -show run -lines 5 -opacity \"65\""),
      ((mod4Mask, xK_comma), toggleWS),
--      ((mod4Mask .|. shiftMask, xK_r ), spawn "xmonad --recompile && xmonad --restart"), -- similar to mod+q
      ((mod4Mask .|. shiftMask, xK_x ), spawn "xterm"),
      ((mod4Mask, xK_c), spawn "google-chrome-stable --force-device-scale-factor=1.3 --password-store=gnome") 
    ]

