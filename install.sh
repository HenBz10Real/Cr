source "$FUNCTION"
source "$(dirname "$0")/axeron.prop"

print() {
    local text="$1"
    local len=${#text}
    local i=0
    while [ $i -lt $len ]; do
        echo -n "${text:$i:1}"
        sleep 0.02
        i=$((i+1))
    done
    echo ""
}

if [ -z "$renderer" ]; then
    if [ -n "$(getprop ro.hardware.vulkan)" ]; then
        renderer="vulkan"
    elif [ -n "$(getprop ro.hardware.opengl)" ]; then
        renderer="skiagl"
    else
        renderer="skiavk"
    fi
fi

set_performance_mode() {
    if [ -n "$(command -v set-performance-mode)" ]; then
        set-performance-mode "$1"
    fi
}

set_performance_mode "performance"

print "Starting app with renderer: $renderer"

setprop debug.hwui.renderer "$renderer"

apply_properties() {
    setprop debug.sf.hw 1
    setprop debug.egl.swapinterval 0
    setprop debug.gr.numframebuffers 5
    setprop debug.overlayui.enable 1
    setprop debug.egl.hw 1
    setprop debug.egl.sync 0
    setprop debug.composition.type gpu
    setprop debug.sf.early_phase_offset_ns 500
    setprop debug.sf.early_gl_phase_offset_ns 500
    setprop debug.sf.high_fps_late_app_phase_offset_ns 2000
    setprop debug.sf.high_fps_late_sf_phase_offset_ns 2000
    setprop debug.sf.high_fps_early_phase_offset_ns 500
    setprop debug.sf.high_fps_early_gl_phase_offset_ns 500
    settings put system pointer_speed 7  
    settings put system game_mode 2
    settings put secure speed_mode_enable 1
    settings put system speed_mode 1
    settings put global game_mode_for_package $runPackage 2
    settings put global window_animation_scale 0.5
    settings put global transition_animation_scale 0.5
    settings put global animator_duration_scale 0.5
    settings put global always_finish_activities 1
}

main() {
    apply_properties > /dev/null 2>&1
}

echo ""
echo ""
sleep 0.5
echo -e "\e[38;2;255;80;0m __________________________________\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m|    ＣＯＲＥ－ＦＬＥＸ V. 5           |\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m|__________________________________|\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m| Developer / @Chermodsc           |\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m| Thanks to / @fahrezone           |\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m| Version Module / 5.0             |\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m|__________________________________|\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m|\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m --------------------------\e[0m"
echo -e "\e[38;2;255;80;0m -> Modules: Online        |\e[0m"
echo -e "\e[38;2;255;80;0m --------------------------\e[0m"
echo -e "\e[38;2;255;80;0m|\e[0m"
sleep 0.5
echo -e "\e[38;2;255;80;0m -> $(date) \e[0m"
echo ""
sleep 1
echo ""
print "Automatically selects Renderer ---[ $renderer ]---"
echo ""
sleep 1
echo ""
sleep 2
echo "Optimize and open applications [ $runPackage ]"
sleep 1
echo ""
print "Wait.."
sleep 1
echo ""
sleep 0.5
(
    main
    am force-stop "$runPackage"
    id=($(cmd package dump "$runPackage" | awk '/MAIN/{getline; print $2}'))
    if [ -n "$id" ];then
        am start -n "${id[0]}" &
        am kill "$runPackage"
    else
        echo ""
    fi

    if command -v cmd > /dev/null 2>&1; then
        cmd power set-fixed-performance-mode-enabled true
        cmd power set-adaptive-power-saver-enabled false
        cmd activity kill-all
        cmd power set-mode 0
        cmd thermalservice override-status 0
        cmd game set --mode performance --downscale 0.6 --fps 90 --user 0 $runPackage
        cmd package bg-dexopt-job -f $runPackage
        cmd shortcut reset-throttling "$package_name"
        cmd game set --priority high $runPackage
        cmd game set --networkmode low_latency $runPackage
    fi
)> /dev/null 2>&1