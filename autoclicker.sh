

#!/usr/bin/env bash
#!/bin/bash
# xinput --list for the id of the device
#mouse="$(xinput --list | awk -F 'id=|\\[' '/mouse|Mouse/ {print $2}')"
#mouse="${mouse//[[:space:]]}"
mouse=10

read -n1 -p "Which mouse button? left or right: [l,r] " mbutton


case $mbutton in
    l | L) export mbutton=1 ;;
    r | R) export mbutton=3 ;;
    *) tput setaf 1; printf " \njust l or r\n"; exit ;;
esac

printf " \n"
read -n4 -p "How many clicks do you want per click? 10 to 10000. Press Enter for the default of 100:  " cpc
if [[ "$cpc" -eq 0 ]]; then
    cpc=100
    echo $cpc
fi
printf " \n"
read -n5 -p "What delay would you like after each click? (More delay = less cps) Press Enter for the default of 10 " delaytime
if [[ "$delaytime" -eq 0 ]]; then
    delaytime=10
    echo $delaytime
fi

means=$(expr 1000 / $delaytime )
printf " \n you will have $means clicks per second each click you make. Attention: if you click multiple times, the cps will add up \n"

show=$(expr \( $cpc \* $delaytime \) / 1000)
if [[ $show -eq 1 ]]; then
    sing="second"
else
    sing="seconds"
fi


while :; do
    state="$(xinput --query-state "$mouse")"

    # If mouse 1 pressed.
    if [[ "$state" == *"button[$mbutton]=down"* ]]; then

        echo sending $cpc clicks in $show $sing
        xdotool click --repeat $cpc --delay $delaytime $mbutton &
    fi

sleep .1s
done

