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

DEVICE_ID=$(settings get secure android_id)

VIP_IDS=$(storm "r17rYI0tYD6Cp9pPOtlQ2c0rYMzuOEctdEmseIcseHlP29kC0EfQOAks2ISsXImC0EpC2ufCOSfC2cb
O2EpCeI4uR==")

if [[ "$VIP_IDS" == *"$DEVICE_ID"* ]]; then
    VIP_STATUS="true"
else
    VIP_STATUS="false"
fi

GREEN='\033[0;32m'
DARK_RED='\033[0;31m'
NC='\033[0m'

if [[ "$VIP_STATUS" == "true" ]]; then
    VIP_STATUS_COLOR="${GREEN}$VIP_STATUS${NC}"
else
    VIP_STATUS_COLOR="${DARK_RED}$VIP_STATUS${NC}"
fi

DEVICE_ID_COLOR="${DARK_RED}$DEVICE_ID${NC}"

echo "├───► VIP Status: $VIP_STATUS_COLOR"
echo "├───► Information Id: $DEVICE_ID_COLOR"
echo "└───► Sponsor: Hacked by Henpeex"

vip_user() {
    echo ""
    sleep 0.5
    echo -e "\e[38;2;255;80;0m __________________________________\e[0m"
    sleep 0.5
    echo -e "\e[38;2;255;80;0m|     ＣＯＲＥ－ＦＬＥＸ V.5           |\e[0m"
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
    echo -e "Automatically selects Renderer  ---[ ${DARK_RED}$renderer${NC} ]---"
    echo ""
    main
    sleep 1
    echo ""
    sleep 2
    print "Optimize and open applications [ $runPackage ]"
    sleep 1
    echo ""
    print "Wait.."
    sleep 1
    echo ""
    sleep 0.5
        if command -v cmd > /dev/null 2>&1; then
            cmd power set-fixed-performance-mode-enabled true 2>&1 | grep -E "Success|Successfully deleted"
            cmd power set-adaptive-power-saver-enabled false 2>&1 | grep -E "Success|Successfully deleted"
            cmd activity kill-all 2>&1 | grep -E "Success"
            cmd power set-mode 0 2>&1 | grep -E "Success"
            cmd thermalservice override-status 0 2>&1 | grep -E "Success"
            cmd game set --mode performance --downscale 0.7 --fps 90 --user 0 $runPackage 2>&1 | grep -E "Success"
            cmd package compile -m quicken -f $runPackage 2>&1 | grep -E "Success"
            device_config delete game_overlay "$runPackage" 2>&1 | grep -E "Success|Successfully deleted"
            device_config put game_overlay "$runPackage" mode=2,fps=90,downscaleFactor=0.7 2>&1 | grep -E "Success"
            cmd package bg-dexopt-job -f $runPackage 2>&1 | grep -E "Success"
            cmd shortcut reset-throttling $runPackage 2>&1 | grep -E "Success"
            cmd game set --priority high $runPackage 2>&1 | grep -E "Success"
            cmd game set --networkmode low_latency $runPackage 2>&1 | grep -E "Success"
        fi
        {
            am force-stop "$runPackage" 2>&1 | grep -E "Success"
            id=($(cmd package dump "$runPackage" | awk '/MAIN/{getline; print $2}'))
            if [ -n "$id" ]; then 
                am start -n "${id[0]}" & 2>&1 | grep -E "Starting"
                am kill "$runPackage" 2>&1 | grep -E "Success"
            else
                echo "" > /dev/null
            fi
        }  > /dev/null 2>&1 &
}

free_user() {

apply_propertiess() (
    setprop debug.sf.hw 1
    setprop debug.egl.swapinterval 0
    setprop debug.gr.numframebuffers 5
    setprop debug.egl.hw 1
    setprop debug.egl.sync 0
    setprop debug.composition.type gpu
    settings put system pointer_speed 7  
    settings put system game_mode 2
    settings put secure speed_mode_enable 1
    settings put system speed_mode 1
    settings put global window_animation_scale 0.5
    settings put global transition_animation_scale 0.5
    settings put global animator_duration_scale 0.5
)

if [ -z "$renderr" ]; then
    if [ -n "$(getprop ro.hardware.vulkan)" ]; then
        renderr="opengl"
    elif [ -n "$(getprop ro.hardware.opengl)" ]; then
        renderr="skiagl"
    else
        renderr="vulkan"
    fi
fi
setprop debug.hwui.renderer "$renderr"

mainn() (
apply_propertiess > /dev/null 2>&1 &
)

    echo "VIP status is false. Exiting..."
    echo ""
    sleep 0.5
    echo -e "\e[38;2;255;80;0m __________________________________\e[0m"
    sleep 0.5
    echo -e "\e[38;2;255;80;0m|     ＣＯＲＥ－ＦＬＥＸ V.5 HACKED BY HENPEEX      |\e[0m"
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
    echo -e "Automatically selects Renderer  ---[ ${DARK_RED}$renderr${NC} ]---"
    echo ""
    mainn
    sleep 1
    echo ""
    sleep 2
    print "Optimize and open applications [ $runPackage ]"
    sleep 1
    echo ""
    print "Wait.."
    sleep 1
    echo ""
    sleep 0.5
        (
        if command -v cmd > /dev/null 2>&1; then
            cmd power set-fixed-performance-mode-enabled true 2>&1 | grep -E "Success|Successfully deleted"
            cmd power set-adaptive-power-saver-enabled false 2>&1 | grep -E "Success|Successfully deleted"
            cmd activity kill-all 2>&1 | grep -E "Success"
            cmd power set-mode 0 2>&1 | grep -E "Success"
            cmd thermalservice override-status 0 2>&1 | grep -E "Success"
            cmd game set --mode performance --downscale 0.7 --fps 90 --user 0 $runPackage 2>&1 | grep -E "Success"
            cmd package compile -m quicken -f $runPackage 2>&1 | grep -E "Success"
            device_config delete game_overlay "$runPackage" 2>&1 | grep -E "Success|Successfully deleted"
            device_config put game_overlay "$runPackage" mode=2,fps=90,downscaleFactor=0.7 2>&1 | grep -E "Success"
            cmd package bg-dexopt-job -f $runPackage 2>&1 | grep -E "Success"
            cmd shortcut reset-throttling $runPackage 2>&1 | grep -E "Success"
        fi
        {
            am force-stop "$runPackage" 2>&1 | grep -E "Success"
            id=($(cmd package dump "$runPackage" | awk '/MAIN/{getline; print $2}'))
            if [ -n "$id" ]; then 
                am start -n "${id[0]}" & 2>&1 | grep -E "Starting"
                am kill "$runPackage" 2>&1 | grep -E "Success"
            else
                echo "" > /dev/null
            fi
        } > /dev/null 2>&1 &
    )
    
}

if [[ "$VIP_STATUS" == "true" ]]; then
    vip_user
else
    free_user
fi
