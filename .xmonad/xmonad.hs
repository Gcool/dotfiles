-- Imports
import XMonad  
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Config.Azerty  
import XMonad.Hooks.DynamicLog  
import XMonad.Hooks.ManageDocks  
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace  
import XMonad.Layout.Named
import XMonad.Util.Font
import XMonad.Util.Run(spawnPipe)
import qualified Data.Map as M
import qualified XMonad.StackSet as W  
import System.IO  
import System.Exit

-- Main
main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/gcool/scripts/xmobarrc" 
    xmonad $ azertyConfig
      { manageHook = myManageHook <+> manageHook defaultConfig
      , layoutHook = avoidStruts $ myLayout
      , logHook = dynamicLogWithPP customPP { ppOutput = hPutStrLn xmproc} 
      , keys = myKeys
      , modMask = myModMask
      , workspaces = myWorkspaces
      , normalBorderColor = "#000000"
      , focusedBorderColor = "#00FF00"
      , borderWidth = 1
       }

-- Workspace/Layout
myWorkspaces = ["1:main","2:web","3:shells","4:media","5:files","6:misc"] ++ map show [7..9]  
myLayout = onWorkspaces ["2:web", "4:media"] nobordersLayout $ tiled ||| mtiled ||| tab ||| nobordersLayout
tiled = named "[]" $ Tall nmaster delta ratio
nmaster = 1  
ratio = 1/2
delta = 5/100  
mtiled = named "M[]" $ smartBorders $ Mirror tiled 
tab = named "[T]" $ noBorders $ tabbed shrinkText tabTheme 
nobordersLayout = named "[F]" $ smartBorders $ Full  

-- Managehook
myManageHook = composeAll [ className =? "File Operation Progress"   --> doFloat  
  , className =? "Vlc"     --> doFloat
  , className =? "Firefox" --> doShift "2:web"  
  , className =? "Gimp"    --> doShift "6:misc"  
  , className =? "Vlc"     --> doShift "4:media"  
  , className =? "Gimp"    --> doFloat      ]  

-- Loghook
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }

-- Bar
customPP :: PP
customPP = defaultPP { 
                      ppHidden = xmobarColor "#308014" ""
                      , ppHiddenNoWindows = xmobarColor "#308014" ""
                      , ppTitle = xmobarColor "#32CD32" "" . shorten 50
                      , ppCurrent = xmobarColor "#00FF00" "" . wrap "[" "]"
                      , ppLayout = xmobarColor "#308014" "" 
                      , ppSep = xmobarColor "#FFFFFF" "" " | "
                     }

-- Tabs
tabTheme = defaultTheme { decoHeight = 16
                         , activeColor = "#000000"
                         , activeBorderColor = "#00FF00"
                         , activeTextColor = "#00FF00"
                         , inactiveColor = "#000000"
                         , inactiveBorderColor = "#FFFFFF"
                         , inactiveTextColor = "#FFFFFF"
                         }
myModMask :: KeyMask
myModMask = mod4Mask

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

-- Open dmenu
        [ ((modMask, xK_r), spawn "exe=`dmenu_run -b -nb black -nf green -sb black` && eval \"exec $exe\"")

-- Open programs
          , ((modMask, xK_Return), spawn "urxvt")
          , ((modMask, xK_f), spawn "firefox")
          , ((mod1Mask, xK_F4), kill)
          , ((modMask, xK_m), spawn "urxvt -e mc")
          , ((modMask, xK_t), spawn "truecrypt")
          , ((modMask, xK_w), spawn "wireshark")
          , ((modMask, xK_c), spawn "celestia")
          , ((modMask, xK_x), spawn "xfburn")
          , ((modMask, xK_l), spawn "libreoffice")
          , ((modMask, xK_h), spawn "handbrake")
          , ((modMask, xK_v), spawn "vlc")

-- Shutdown/reboot
          , ((modMask .|. mod1Mask, xK_F4), spawn "urxvt -e sudo shutdown -h now")
          , ((modMask .|. mod1Mask, xK_r), spawn "urxvt -e sudo reboot")

-- Hetzner ssh
          , ((modMask, xK_s), spawn "/home/gcool/Hetzner/clean.sh")
 
-- Lock screen
          , ((modMask .|. mod1Mask, xK_l), spawn "xscreensaver-command --lock")
 
-- Resizing/Moving
          , ((controlMask, xK_Up), windows W.swapUp)
          , ((controlMask, xK_Down), windows W.swapDown)
          , ((controlMask, xK_Right), sendMessage Expand)
          , ((controlMask, xK_Left), sendMessage Shrink)

--WS cycle
         , ((modMask,xK_Right),  nextWS)
         , ((modMask, xK_Left),    prevWS)

--Gridselect
          , ((modMask, xK_g), goToSelected defaultGSConfig)

-- Change Layout
          , ((modMask, xK_space), sendMessage NextLayout)
          , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
 
-- Logout/restart
          , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
          , ((modMask , xK_q), spawn "xmonad --recompile; xmonad --restart")

-- Take screenshot      
          , ((0, xK_Print), spawn "scrot")
         ]
         
         ++
         -- mod-[1..9] %! Switch to workspace N
         -- mod-shift-[1..9] %! Move client to workspace N
         [((m .|. modMask, k), windows $ f i)
             | (i, k) <- zip (XMonad.workspaces conf) [0x26,0xe9,0x22,0x27,0x28,0xa7,0xe8,0x21,0xe7,0xe0]
             , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
