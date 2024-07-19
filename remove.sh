source $FUNCTION
source $(dirname $0)/axeron.prop

echo ""
echo "[ • ]Process of Removing CoreFlexV5 Module."
echo ""
echo ""

uninstall() {
am force-stop "$runPackage"
setprop debug.sf.hw 0
setprop debug.egl.swapinterval 1
setprop debug.gr.numframebuffers 3
setprop debug.overlayui.enable 0
setprop debug.egl.hw 0
setprop debug.egl.sync 1
setprop debug.composition.type cpu
setprop debug.sf.early_phase_offset_ns 1000
setprop debug.sf.early_gl_phase_offset_ns 1000
setprop debug.sf.high_fps_late_app_phase_offset_ns 3000
setprop debug.sf.high_fps_late_sf_phase_offset_ns 3000
setprop debug.sf.high_fps_early_phase_offset_ns 1000
setprop debug.sf.high_fps_early_gl_phase_offset_ns 1000
settings put system pointer_speed 1
settings put system game_mode 0
settings put global window_animation_scale 1.0
settings put global transition_animation_scale 1.0
settings put global animator_duration_scale 1.0
settings put global always_finish_activities 0
cmd power set-fixed-performance-mode-enabled false
cmd power set-adaptive-power-saver-enabled true
}
uninstall > /dev/null 2>&1
echo ""
echo ""
sleep 2
echo "Close the application [$runPackage]"
echo ""
echo ""
sleep 2
echo "[ + ] Uninstall Succes"
sleep 0.5
echo ""
echo ""
echo "{•} Don't forget to Reboot!"
echo ""
