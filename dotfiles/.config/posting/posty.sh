#!/usr/bin/env bash

# Define custom colors using NEWT_COLORS
export NEWT_COLORS='
    root=green,black;
    border=green,black;
    title=green,black;
    shadow=black,gray;
    window=green,black;
    textbox=green,gray;
    entry=green,black;
    button=black,green;
    actbutton=white,green;
    listbox=green,black;
    actlistbox=yellow,black;
'


# Confirm root dir has been Defined
[[ -z "$POSTING_ROOT" ]] && echo "POSTING_ROOT must be Defined. Exitin.g" && exit 0

if whiptail --title "Collections" --yesno "Would you like create a new collection?" 8 78; then


    NAME=$(whiptail --inputbox "What is the name of your new collection?" 8 39   --title "New Collection" 3>&1 1>&2 2>&3)
                                                                            # A trick to swap stdout and stderr.
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        echo "User selected Ok and entered " $NAME

        if [[ ! -z "$NAME" ]]
        then
                
            # Create dir
            mkdir $NAME

            # Create .env title
            ENV_FILE=$POSTING_ROOT$NAME/.env
            touch  $ENV_FILE

            # Prompt for collection variables
            API_KEY=$(whiptail --inputbox "Enter API Key" 8 39 --title "Collection variable (key)" 3>&1 1>&2 2>&3)
            BASE_URL=$(whiptail --inputbox "Enter Base URL" 8 39 --title "Collection variable (url)" 3>&1 1>&2 2>&3)

            # Save collection variables
            echo "API_KEY=$API_KEY" >> $ENV_FILE
            echo "URL=$BASE_URL" >> $ENV_FILE

        fi

    else
        echo "User selected Cancel."
    fi

else

    # User decided not to create new collection, Prompt to choose existing collection


    OPTIONS_FULLPATHS=("placeholder")
    OPTIONS=()
    i=1
    for collection in $(find $POSTING_ROOT* -maxdepth 1 -type d -exec realpath '{}' \;)
    do
        line=$(basename ${collection})
        OPTIONS+=("$i" "$line")
        OPTIONS_FULLPATHS+=("$collection")
        ((i++))
    done

    # Add an exit option
    OPTIONS+=("$i" "Exit")

    # Create a menu using whiptail and store the selection
    CHOICE=$(whiptail --nocancel --title "Collection Menu" \
        --menu "Choose a collection:" \
        15 60 5 \
        "${OPTIONS[@]}" \
        3>&1 1>&2 2>&3)

    # Selction is full path of collection
    SELECTION=${OPTIONS_FULLPATHS[${CHOICE}]}
    # echo "[+] i: $i"
    # echo "[+] CHOICE: $CHOICE"
    # echo "[+] SELECTION: $SELECTION"
    # echo "[+] FULLARRAY: ${OPTIONS_FULLPATHS[@]}"

    # Get array length
    length=${#OPTIONS_FULLPATHS[@]}

    # Check if num is not a valid index
    if [ "$CHOICE" -gt 0 ] && [ "$CHOICE" -lt "$length" ]; then

        if [[ -z ./.shared.env ]]
        then
            posting --env $SELECTION/.env --env $POSTING_ROOT.shared.env --collection $SELECTION
        else
            posting --env $SELECTION/.env --collection $SELECTION
        fi

    fi


fi




