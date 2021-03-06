-- Imports
import XMonad  
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Config.Azerty  
import XMonad.Hooks.DynamicLog  
import XMonad.Hooks.ManageDocks  
import XMonad.Hooks.ManageHelpers
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
    bottomBar <- spawnPipe "/usr/bin/xmobar /home/gcool/scripts/xmobarrc" 
    topBar <- spawnPipe "/usr/bin/conky -c /home/gcool/scripts/.conkyrc1 | dzen2 -bg '#000000' -fg '#ffffff' -h 16 -y 1080 -w 1920 -ta c" 
    xmonad $ azertyConfig
      { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig
      , layoutHook = avoidStruts $ myLayout
      , logHook = dynamicLogWithPP customPP { ppOutput = hPutStrLn bottomBar} 
      , focusFollowsMouse = True
      , keys = myKeys
      , modMask = myModMask
      , workspaces = myWorkspaces
      , terminal = myTerminal
      , normalBorderColor = "#000000"
      , focusedBorderColor = "#1c4582"
      , borderWidth = 1
}

-- Workspace/Layout
myWorkspaces = ["1:main","2:web","3:shells","4:media","5:files","6:misc"] ++ map show [7..9]  
myLayout = onWorkspaces ["2:web", "4:media"] fullscreen $ tiled ||| mtiled ||| tab ||| fullscreen
tiled = named "[]" $ Tall nmaster delta ratio
nmaster = 1  
ratio = 1/2
delta = 5/100  
mtiled = named "M[]" $ smartBorders $ Mirror tiled 
tab = named "[T]" $ noBorders $ tabbed shrinkText tabTheme 
fullscreen = named "[F]" $ noBorders $ Full  

-- Managehook
myManageHook = composeAll [ className =? "File Operation Progress"   --> doFloat  
  , className =? "Downloads"  --> doFloat
  , className =? "Vlc"        --> doFloat
  , className =? "Firefox"    --> doShift "2:web"  
  , className =? "Gimp"       --> doShift "6:misc"  
  , className =? "Vlc"        --> doShift "4:media"  
  , className =? "Gimp"       --> doFloat        
  , className =? "Virtualbox" --> doFullFloat
  , className =? "Xcalc"      --> doFloat
  , isFullscreen              --> doFullFloat   ]

-- Loghook
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ customPP { ppOutput = hPutStrLn h }

-- Bar
customPP :: PP
customPP = defaultPP { 
                      ppHidden = xmobarColor "#5365a6" "#000000"
                      , ppHiddenNoWindows = xmobarColor "#bdbdbd" "#000000"
                      , ppTitle = xmobarColor "#5365a6" "#000000" . shorten 75 
                      , ppCurrent = xmobarColor "#1c4582" "#000000" . wrap "[" "]"
                      , ppLayout = xmobarColor "#1c4582" "#000000" 
                      , ppSep = xmobarColor "#1c4582" "" " | "
                     }

-- Tabs
tabTheme = defaultTheme { decoHeight = 16
                         , activeColor = "#000000"
                         , activeBorderColor = "#1c4582"
                         , activeTextColor = "#1c4582"
                         , inactiveColor = "#000000"
                         , inactiveBorderColor = "#FFFFFF"
                         , inactiveTextColor = "#FFFFFF"
                         }

-- GridSelect colors
myColors = colorRangeFromClassName
        (0x00, 0x00, 0x00) -- lowest inactive bg -- black
	(0x00, 0x00, 0x00) -- highest inactive bg -- black
	(0x00, 0x00, 0x00) -- active bg -- black
	(0xff, 0xff, 0xff) -- inactive fg -- white
	(0x1c, 0x45, 0x82) -- active fg -- blue 

-- GridSelect theme
myGSConfig colors = (buildDefaultGSConfig myColors)
 	{ gs_cellheight  = 60
	, gs_cellwidth   = 250
	, gs_cellpadding = 10
	}

--Terminal
myTerminal = "urxvt"

--Keys
myModMask :: KeyMask
myModMask = mod4Mask

myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

-- Open dmenu
        [ ((modMask, xK_d), spawn "exe=`dmenu_run -b -nb black -nf blue -sb black` && eval \"exec $exe\"")

-- Refresh
          , ((modMask, xK_r), refresh)  

-- Float
          , ((modMask .|. shiftMask, xK_f), withFocused $ windows . W.sink)

-- Open programs
          , ((modMask, xK_Return), spawn $ XMonad.terminal conf)
          , ((modMask .|. shiftMask, xK_Return), spawn "xterm")
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
	  , ((modMask, xK_i), spawn "virtualbox")
          , ((modMask, xK_z), spawn "filezilla")
          , ((modMask, xK_n), spawn "nxclient")

-- Shutdown/reboot
          , ((modMask .|. mod1Mask, xK_F4), spawn "sudo systemctl poweroff")
          , ((modMask .|. mod1Mask, xK_r), spawn "sudo systemctl reboot")

-- Hetzner ssh
          , ((modMask, xK_s), spawn "/home/gcool/Hetzner/clean.sh")
 
-- Lock screen
          , ((modMask .|. mod1Mask, xK_l), spawn "xscreensaver-command --lock")
 
-- Resizing/Moving
          , ((modMask, xK_Up), windows W.swapUp)
          , ((modMask, xK_Down), windows W.swapDown)
          , ((controlMask, xK_Right), sendMessage Expand)
          , ((controlMask, xK_Left), sendMessage Shrink)

-- Increase/decrease Master windows 
        , ((controlMask, xK_Up ), sendMessage (IncMasterN 1))
	, ((controlMask, xK_Down), sendMessage (IncMasterN (-1)))

-- Change focus
        , ((modMask, xK_Tab), windows W.focusDown)
        , ((modMask .|. shiftMask, xK_Tab), windows W.focusUp)

--WS cycle
         , ((modMask, xK_Right),  nextWS)
         , ((modMask, xK_Left),  prevWS)

--Gridselect
          , ((modMask, xK_g), goToSelected $ myGSConfig myColors)

-- Change Layout
          , ((modMask, xK_space), sendMessage NextLayout)
          , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
 
-- Logout/restart
          , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
          , ((modMask, xK_q), spawn "xmonad --recompile; xmonad --restart")

-- Take screenshot      
          , ((0, xK_Print), spawn "scrot")
         ]
         
         ++
         -- mod-[1..9] %! Switch to workspace N
         -- mod-shift-[1..9] %! Move client to workspace N
         [((m .|. modMask, k), windows $ f i)
             | (i, k) <- zip (XMonad.workspaces conf) [0x26,0xe9,0x22,0x27,0x28,0xa7,0xe8,0x21,0xe7,0xe0]
             , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
