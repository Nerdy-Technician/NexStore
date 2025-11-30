#!/bin/bash
# @name: ???
# @description: What happened?

# THIS IS JUST A GAME, NOT A REAL DATA CENTER EMERGENCY!

STRESS_LEVEL=0
BATTERY_LEVEL=100
CURRENT_LOCATION="server_room"
GAME_OVER=0
FOUND_KEYCARD=0
FIXED_COOLING=0
BACKUP_RESTORED=0

HOSTNAME=$(hostname 2>/dev/null || echo "srv01")

@NEXTERM:MSGBOX "DATA CENTER EMERGENCY" "You wake up to the sound of blaring alarms. The server room is flashing with red emergency lights.\nWhat happened?"

@NEXTERM:MSGBOX "System Log" "===== AUTOMATED SYSTEM LOG =====\nDate: July 7, 2025 - 02:17 AM\nCritical failures detected in cooling systems\nUninterruptible Power Supply activated\nEstimated UPS runtime: 120 minutes\nMultiple services going offline\n==============================="

check_random_event() {
    local event_roll=$((RANDOM % 10))
    local new_stress=$((RANDOM % 5))+10
    if [[ $event_roll -lt 3 && $STRESS_LEVEL -lt 90 ]]; then
        STRESS_LEVEL=$((STRESS_LEVEL + new_stress))
        @NEXTERM:WARN "Your stress level increases as another server rack goes offline with a loud beep! (Stress: $STRESS_LEVEL%)"
    elif [[ $event_roll -eq 9 && $BATTERY_LEVEL -gt 10 ]]; then
        BATTERY_LEVEL=$((BATTERY_LEVEL - 5))
        @NEXTERM:WARN "Your emergency flashlight flickers briefly. (Battery: $BATTERY_LEVEL%)"
    fi
}

show_status() {
    @NEXTERM:SUMMARY "Current Status" "Location" "$CURRENT_LOCATION" "Stress Level" "$STRESS_LEVEL%" "Flashlight Battery" "$BATTERY_LEVEL%"
}

make_phone_call() {
    @NEXTERM:INPUT PHONE_NUMBER "Enter the phone number or extension to call:" ""

    case "$PHONE_NUMBER" in
        "5309" | "ext 5309" | "ext. 5309")
            @NEXTERM:STEP "Calling Emergency Contact"
            @NEXTERM:INFO "Dialing extension 5309..."
            sleep 1
            @NEXTERM:INFO "Ring... Ring... Ring..."
            sleep 1
            @NEXTERM:SUCCESS "Connected!"

            @NEXTERM:MSGBOX "Phone Call - Emergency Contact" "Voice: \"This is DB Tech emergency line. Who is this?\"\n\nYou: \"This is the night technician at the data center. We have a critical situation.\"\n\nDB Tech: \"Hold on, let me pause my recording... OK, what's going on?\""

            @NEXTERM:MSGBOX "Phone Call - Emergency Contact" "DB Tech: \"What's the nature of the emergency?\"\n\nYou: \"Complete cooling system failure. Multiple server racks are overheating and systems are going offline.\""

            @NEXTERM:MSGBOX "Phone Call - Emergency Contact" "DB Tech: \"How long has this been happening? What's the current status?\"\n\nYou: \"Started about 20 minutes ago. We're running on UPS power with about 90 minutes left.\""

            if [[ $FIXED_COOLING -eq 1 ]]; then
                @NEXTERM:MSGBOX "Phone Call - Emergency Contact" "You: \"I've managed to bypass the failed cooling components and restored partial function.\"\n\nDB Tech: \"Excellent work! That should buy us time.\""
            fi

            if [[ $BACKUP_RESTORED -eq 1 ]]; then
                @NEXTERM:MSGBOX "Phone Call - Emergency Contact" "You: \"I've also completed backup restoration for critical systems.\"\n\nDB Tech: \"Perfect. You're handling this well.\""
            fi

            if [[ $FIXED_COOLING -eq 1 && $BACKUP_RESTORED -eq 1 ]]; then
                @NEXTERM:MSGBOX "Phone Call - Victory!" "DB Tech: \"We're dispatching a team with replacement parts - they'll be there in 30 minutes.\"\n\nYou: \"Thank you. I'll monitor the systems until you arrive.\"\n\nDB Tech: \"You've prevented what could have been a catastrophic failure. Well done!\""
                @NEXTERM:SUCCESS "MISSION ACCOMPLISHED! You've successfully stabilized the data center emergency. The off-site team arrives in time to prevent major data loss."
                GAME_OVER=1
            else
                @NEXTERM:MSGBOX "Phone Call - Emergency Contact" "DB Tech: \"We're sending a team, but they won't arrive for 30 minutes. You need to stabilize things until then. Can you handle it?\"\n\nYou: \"I'll do my best.\"\n\nDB Tech: \"Good luck. Call back if you need guidance.\""
            fi
            ;;

        "911" | "emergency" | "Emergency")
            @NEXTERM:STEP "Calling Emergency Services"
            @NEXTERM:INFO "Dialing 911..."
            sleep 1
            @NEXTERM:INFO "Ring... Ring..."
            sleep 1
            @NEXTERM:SUCCESS "Connected!"

            @NEXTERM:MSGBOX "Phone Call - 911" "Operator: \"911, what's your emergency?\"\n\nYou: \"I'm at a data center and we have a critical cooling system failure. No immediate danger to people, but we might need fire department standby.\""

            @NEXTERM:MSGBOX "Phone Call - 911" "Operator: \"Are there any fire hazards or electrical dangers?\"\n\nYou: \"Server equipment is overheating, but no active fires. We're on backup power.\""

            @NEXTERM:MSGBOX "Phone Call - 911" "Operator: \"We'll have a unit on standby nearby. Call immediately if the situation escalates.\"\n\nYou: \"Thank you, I will.\""

            @NEXTERM:INFO "Emergency services are now on standby. This gives you some peace of mind."
            STRESS_LEVEL=$((STRESS_LEVEL - 10))
            if [[ $STRESS_LEVEL -lt 0 ]]; then
                STRESS_LEVEL=0
            fi
            ;;

        "" | "0" | "operator")
            @NEXTERM:STEP "Calling Operator"
            @NEXTERM:INFO "Dialing operator..."
            sleep 1
            @NEXTERM:SUCCESS "Connected!"

            @NEXTERM:MSGBOX "Phone Call - Operator" "Operator: \"How may I help you?\"\n\nYou: \"I need to reach the emergency contact for this data center. Do you have directory information?\""

            @NEXTERM:MSGBOX "Phone Call - Operator" "Operator: \"I can connect you to directory assistance, but for emergencies, you should use extension 5309 for your facility's emergency line.\"\n\nYou: \"Thank you, that's exactly what I needed.\""
            ;;

        *)
            @NEXTERM:STEP "Calling $PHONE_NUMBER"
            @NEXTERM:INFO "Dialing $PHONE_NUMBER..."
            sleep 1
            @NEXTERM:INFO "Ring... Ring... Ring..."
            sleep 2

            local call_result=$((RANDOM % 4))
            case $call_result in
                0)
                    @NEXTERM:WARN "No answer. The line keeps ringing."
                    ;;
                1)
                    @NEXTERM:WARN "Busy signal. The line is occupied."
                    ;;
                2)
                    @NEXTERM:WARN "The number you have dialed is not in service."
                    ;;
                3)
                    @NEXTERM:WARN "Voicemail: 'You have reached a non-emergency line. Please hang up and dial the appropriate extension.'"
                    ;;
            esac
            ;;
    esac
}

server_room_actions() {
    @NEXTERM:SELECT CHOICE "You're in the main server room. Red emergency lights are flashing. What do you do?" "Check the monitoring console" "Search for the emergency manual" "Try to access the cooling control system" "Move to the hallway" "Check your status"

    case "$CHOICE" in
        "Check the monitoring console")
            @NEXTERM:INFO "The monitoring console shows multiple server racks overheating. Core systems are failing one by one."
            @NEXTERM:TABLE "Server Status" "Rack,Temperature,Status" "Web-01,92°C,CRITICAL" "DB-01,88°C,CRITICAL" "Storage-01,85°C,WARNING" "$HOSTNAME,75°C,STABLE"
            ;;

        "Search for the emergency manual")
            if [[ $FOUND_KEYCARD -eq 0 ]]; then
                @NEXTERM:SUCCESS "You found a keycard! This might be useful later."
                FOUND_KEYCARD=1
            fi
            @NEXTERM:MSGBOX "Emergency Manual" "DATACENTER EMERGENCY PROCEDURES\n\n1. Assess the situation\n2. Check cooling systems in Maintenance Room\n3. If necessary, initiate backup restoration from Backup Room\n4. Contact off-site team"
            ;;

        "Try to access the cooling control system")
            @NEXTERM:INFO "The main cooling controls are locked. A note says: 'Full controls available in Maintenance Room'"
            ;;

        "Move to the hallway")
            CURRENT_LOCATION="hallway"
            @NEXTERM:INFO "You enter the dimly lit hallway. Emergency lights provide minimal illumination."
            ;;

        "Check your status")
            show_status
            ;;
    esac
}

hallway_actions() {
    check_random_event

    @NEXTERM:SELECT CHOICE "You're in the hallway. Several doors lead to different rooms. Where do you go?" "Maintenance Room" "Backup Room" "Server Room" "Communication Room" "Check your status"

    case "$CHOICE" in
        "Maintenance Room")
            if [[ $FOUND_KEYCARD -eq 1 ]]; then
                CURRENT_LOCATION="maintenance_room"
                @NEXTERM:SUCCESS "You use the keycard to unlock the Maintenance Room door."
            else
                @NEXTERM:WARN "The Maintenance Room door is locked. You need a keycard."
            fi
            ;;
        "Backup Room")
            CURRENT_LOCATION="backup_room"
            ;;
        "Server Room")
            CURRENT_LOCATION="server_room"
            ;;
        "Communication Room")
            CURRENT_LOCATION="communication_room"
            ;;
        "Check your status")
            show_status
            ;;
    esac
}

maintenance_room_actions() {
    check_random_event
    @NEXTERM:SELECT CHOICE "You're in the maintenance room. Various control panels line the walls." "Check cooling system controls" "Look at electrical panels" "Search maintenance logs" "Return to hallway" "Check your status"

    case "$CHOICE" in
        "Check cooling system controls")
            if [[ $FIXED_COOLING -eq 0 ]]; then
                @NEXTERM:STEP "Cooling System Repair"
                @NEXTERM:INFO "The cooling system interface shows multiple failures. You'll need to restore the primary cooling circuit."
                @NEXTERM:SELECT COOLING_FIX "How do you want to approach this?" "Restart the entire cooling system" "Bypass failed components" "Recalibrate temperature sensors"

                if [[ "$COOLING_FIX" == "Bypass failed components" ]]; then
                    @NEXTERM:SUCCESS "Good choice! You've successfully bypassed the failed components and restored partial cooling function."
                    FIXED_COOLING=1
                    STRESS_LEVEL=$((STRESS_LEVEL - 30))
                    if [[ $STRESS_LEVEL -lt 0 ]]; then
                        STRESS_LEVEL=0
                    fi
                else
                    @NEXTERM:WARN "That didn't work. The system remains in critical condition."
                    STRESS_LEVEL=$((STRESS_LEVEL + 15))
                fi
            else
                @NEXTERM:INFO "The cooling system is functioning at reduced capacity after your bypass. It should hold for now."
            fi
            ;;

        "Look at electrical panels")
            @NEXTERM:INFO "The electrical panels show the UPS is running. You have approximately 90 minutes of power remaining."
            ;;

        "Search maintenance logs")
            @NEXTERM:MSGBOX "Maintenance Logs" "Last entry (July 6, 2025):\n\nReported unusual temperature fluctuations in cooling system. Requested parts for replacement, but approval is still pending. Temporary fix applied, but this won't hold for long.\n\n~ DB Tech (Day Shift Technician, ext 5309)"
            ;;

        "Return to hallway")
            CURRENT_LOCATION="hallway"
            ;;

        "Check your status")
            show_status
            ;;
    esac
}

backup_room_actions() {
    check_random_event
    @NEXTERM:SELECT CHOICE "You're in the backup room. Backup servers hum quietly, seemingly unaffected by the crisis." "Check backup status" "Initiate backup restoration" "Check backup logs" "Return to hallway" "Check your status"

    case "$CHOICE" in
        "Check backup status")
            @NEXTERM:TABLE "Backup Status" "System,Last Backup,Status" "Web Services,6 hours ago,AVAILABLE" "Database,8 hours ago,AVAILABLE" "User Data,12 hours ago,AVAILABLE" "System Config,24 hours ago,AVAILABLE"
            ;;

        "Initiate backup restoration")
            if [[ $FIXED_COOLING -eq 0 ]]; then
                @NEXTERM:WARN "Restoration might fail without stable cooling. Fix the cooling system first."
            else
                if [[ $BACKUP_RESTORED -eq 0 ]]; then
                    @NEXTERM:CONFIRM "Are you sure you want to initiate backup restoration? This will temporarily take systems offline."

                    if [[ $NEXTERM_CONFIRM_RESULT = "Yes" ]]; then
                        @NEXTERM:STEP "Backup Restoration"
                        @NEXTERM:PROGRESS 10
                        sleep 1
                        @NEXTERM:PROGRESS 30
                        sleep 1
                        @NEXTERM:PROGRESS 50
                        sleep 1
                        @NEXTERM:PROGRESS 70
                        sleep 1
                        @NEXTERM:PROGRESS 90
                        sleep 1
                        @NEXTERM:PROGRESS 100

                        @NEXTERM:SUCCESS "Backup restoration complete! Critical systems are coming back online."
                        BACKUP_RESTORED=1
                        STRESS_LEVEL=$((STRESS_LEVEL - 20))
                        if [[ $STRESS_LEVEL -lt 0 ]]; then
                            STRESS_LEVEL=0
                        fi
                    else
                        @NEXTERM:INFO "Backup restoration cancelled."
                    fi
                else
                    @NEXTERM:INFO "Backup restoration has already been completed."
                fi
            fi
            ;;

        "Check backup logs")
            @NEXTERM:MSGBOX "Backup Logs" "Automated backup completed successfully at 8:00 PM\nAll systems backed up with no errors\nNext scheduled backup: 8:00 AM"
            ;;

        "Return to hallway")
            CURRENT_LOCATION="hallway"
            ;;

        "Check your status")
            show_status
            ;;
    esac
}

communication_room_actions() {
    check_random_event
    @NEXTERM:SELECT CHOICE "You're in the communication room. Various phones and communication equipment are available." "Make a phone call" "Check email system" "Send alert to management" "Return to hallway" "Check your status"

    case "$CHOICE" in
        "Make a phone call")
            make_phone_call
            ;;

        "Check email system")
            @NEXTERM:INFO "The email system shows multiple automated alerts about the server failures."
            @NEXTERM:MSGBOX "Email System" "URGENT: Cooling System Failure (2:05 AM)\nURGENT: Multiple Systems Offline (2:10 AM)\nURGENT: UPS Activated (2:12 AM)\n\nNo responses from the night team yet."
            ;;

        "Send alert to management")
            @NEXTERM:STEP "Sending Alert"
            @NEXTERM:INPUT ALERT_MESSAGE "Compose your message to management:" "Critical data center emergency. Cooling system failure. Working on resolution."
            @NEXTERM:SUCCESS "Alert sent to management team."
            ;;

        "Return to hallway")
            CURRENT_LOCATION="hallway"
            ;;

        "Check your status")
            show_status
            ;;
    esac
}

while [[ $GAME_OVER -eq 0 && $STRESS_LEVEL -lt 100 && $BATTERY_LEVEL -gt 0 ]]; do
    case "$CURRENT_LOCATION" in
        "server_room")
            server_room_actions
            ;;
        "hallway")
            hallway_actions
            ;;
        "maintenance_room")
            maintenance_room_actions
            ;;
        "backup_room")
            backup_room_actions
            ;;
        "communication_room")
            communication_room_actions
            ;;
    esac

    if [[ $((RANDOM % 5)) -eq 0 ]]; then
        BATTERY_LEVEL=$((BATTERY_LEVEL - 1))
    fi
done

if [[ $STRESS_LEVEL -ge 100 ]]; then
    @NEXTERM:MSGBOX "Game Over" "Your stress level reached 100%!\n\nOverwhelmed, you make a critical error that leads to complete system failure. The off-site team arrives too late to prevent major data loss."
elif [[ $BATTERY_LEVEL -le 0 ]]; then
    @NEXTERM:MSGBOX "Game Over" "Your emergency flashlight died, leaving you in complete darkness!\n\nUnable to navigate the facility, you have to wait for the off-site team to arrive. Unfortunately, critical systems fail before help arrives."
fi

exit 0