#!/bin/bash
mkdir -p submission_reminder_app/{app,modules,assets,config}

touch submission_reminder_app/app/reminder.sh
touch submission_reminder_app/modules/functions.sh
touch submission_reminder_app/assets/submissions.txt
touch submission_reminder_app/config/config.env
touch submission_reminder_app/startup.sh

reminder=$(cat <<EOF
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
)

functions=$(cat <<EOF
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "\$student" | xargs)
        assignment=$(echo "\$assignment" | xargs)
        status=$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}

EOF
)

config=$(cat <<EOF
# This is the config file
ASSIGNMENT=Shell_Navigation
DAYS_REMAINING=2
EOF
)

echo "$reminder" > submission_reminder_app/app/reminder.sh
echo -e "$functions" > submission_reminder_app/modules/functions.sh
echo -e "$config" > submission_reminder_app/config/config.env
chmod u+x submission_reminder_app/app/reminder.sh
chmod u+x submission_reminder_app/modules/functions.sh
chmod u+x submission_reminder_app/config/config.env


 cat submissions.txt > submission_reminder_app/assets/submissions.txt 

 echo "Mahmat, alu-shell , not submitted"  >> submission_reminder_app/assets/submissions.txt
 echo "Hassan,alu-shell , submitted "  >> submission_reminder_app/assets/submissions.txt
 echo "Andrew, alu-shell , not submitted "  >> submission_reminder_app/assets/submissions.txt
 echo "Peace, alu-shell , submitted "  >> submission_reminder_app/assets/submissions.txt
 echo "Sara, alu-shell , submitted"  >> submission_reminder_app/assets/submissions.txt

 startup=$(cat <<EOF
#!/bin/bash
./app/reminder.sh
EOF
) 

echo "$startup" > submission_reminder_app/startup.sh
chmod u+x submission_reminder_app/startup.sh