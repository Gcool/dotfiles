-- Imports
import XMonad  
import XMonad.Config.Azerty  
import XMonad.Util.Font
import XMonad.Hooks.DynamicLog  
import XMonad.Hooks.ManageDocks  
import XMonad.Util.Run(spawnPipe)  
import XMonad.Util.EZConfig  
import XMonad.Layout.NoBorders(smartBorders)  
import XMonad.Layout.PerWorkspace  
import XMonad.Layout.Spacing
import XMonad.Layout.IM  
import XMonad.Layout.Grid  
import XMonad.Actions.GridSelect  
import Data.Ratio ((%))  
import XMonad.Actions.CycleWS  
import qualified XMonad.StackSet as W  
import System.IO  

-- Layout
myWorkspaces  = ["1:main","2:web","3:shells","4:media","5:misc","6:test"]  
myLayout = onWorkspaces ["2:web", "4:media"] nobordersLayout $ tiled ||| Mirror tiled ||| nobordersLayout
tiled = Tall nmaster delta ratio
nmaster = 1  
ratio = 1/2
delta = 5/100  
nobordersLayout = smartBorders $ Full  
myManageHook = composeAll [ className =? "File Operation Progress"   --> doFloat  
  , className =? "Firefox" --> doShift "2:web"  
  , className =? "Gimp"    --> doShift "5:misc"  
  , className =? "Vlc"     --> doShift "4:media"  
      ]  

-- Main
main = do  
   xmproc <- spawnPipe "/usr/bin/xmobar /home/gcool/scripts/xmobarrc"  
   xmonad $ azertyConfig  
     { manageHook = manageDocks <+> myManageHook  
             <+> manageHook defaultConfig  
     , layoutHook = avoidStruts $ myLayout  
     , logHook = dynamicLogWithPP xmobarPP  
             { ppOutput = hPutStrLn xmproc  
             , ppTitle = xmobarColor "#0033FF" "" . shorten 50  
                , ppLayout = const ""  
             }  
     , modMask = mod4Mask -- modmask 
      , workspaces     = myWorkspaces  
     , normalBorderColor = "#000000"  
     , focusedBorderColor = "#0033FF"  
      , borderWidth    = 1
      }`additionalKeys` 

-- Open dmenu
        [ ((mod4Mask, xK_r), spawn "exe=`dmenu_run -b -nb black -nf blue -sf white` && eval \"exec $exe\"")
-- Open programs
          , ((mod4Mask, xK_Return), spawn "urxvt")
          , ((mod4Mask, xK_f), spawn "firefox")
          , ((mod1Mask, xK_F4), kill)
          , ((mod4Mask, xK_v), spawn "virtualbox")
          , ((mod4Mask, xK_t), spawn "truecrypt")
          , ((mod4Mask, xK_w), spawn "wireshark")
          , ((mod4Mask, xK_c), spawn "celestia")
          , ((mod4Mask, xK_x), spawn "xfburn")
          , ((mod4Mask, xK_l), spawn "libreoffice")
          , ((mod4Mask, xK_h), spawn "handbrake")
          , ((mod4Mask, xK_v), spawn "vlc")
          , ((mod4Mask, xK_g), spawn "gimp")
-- Shutdown/reboot
          , ((mod4Mask .|. mod1Mask, xK_F4), spawn "urxvt -e sudo shutdown -h now")
          , ((mod4Mask .|. mod1Mask, xK_r), spawn "urxvt -e sudo reboot")
 
-- Lock screen
          , ((mod4Mask .|. mod1Mask, xK_l), spawn "xscreensaver-command --lock")
 
-- Resizing/Moving
          , ((mod4Mask, xK_Up), windows W.swapUp)
          , ((mod4Mask, xK_Down), windows W.swapDown)
          , ((mod4Mask, xK_Right), sendMessage Expand)
          , ((mod4Mask, xK_Left), sendMessage Shrink)
 
-- Take screenshot      
          , ((0, xK_Print), spawn "scrot")
         ] 
