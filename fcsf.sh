#!/bin/bash


# Initialize variables
current_time=0
start_column=1
total_waiting_time=0
total_process_time=0
num_processes=0

# Find the first and last rows in the process column
first_row=$(grep -n ".*" input_file.csv | cut -d ":" -f 1 | head -n 1)
last_row=$(grep -n ".*" input_file.csv | cut -d ":" -f 1 | tail -n 1)


# Clear the console
clear

# Set text color to green
echo -e "\033[32m"

# Move cursor to row 1, column 2
tput cup 1 2

# Write Process Name
echo "Process Name |"

# Move cursor to row 1, column 17
tput cup 1 17

# Write Arrival time
echo "Arrival Time |"

# Move cursor to row 1, column 32
tput cup 1 32
# Write Process time
echo "Process Time |"

# Move cursor to row 1, column 47
tput cup 1 47
# Write Waiting time
echo "Waiting Time | "

# Move cursor to row 1, column 62
tput cup 1 62
# Write Total Processing Time
echo "Total Processing Time |"
# Move cursor to row 1, column 86
tput cup 1 86
# Write Total Processing Time
echo "Average waiting Time |"
# Move cursor to row 1, column 109
tput cup 1 109
# Write Total Processing Time
echo "Average Processing Time"

# Reset text color to default
echo -e "\033[0m"

# Loop through each process and print its Gantt char^Z

num_rows=$last_row
num_columns=3
current_row=3
total_waiting_time=0
total_processing_time=0
current_process=0
current_time=0
waiting_time=0

tail -n +2 input_file.csv | while IFS=',' read -r process start_time process_time
do

    #display current process name
    tput cup $current_row 2
    echo $process
    #display process start time
    tput cup $current_row 17
    echo $start_time
    #display process running time
    tput cup $current_row 32
    echo $process_time
    # Calculate waiting time
    waiting_time=$((current_time - start_time))
    #display waiting time
    tput cup $current_row 47
    echo $waiting_time


    tput cup $(( last_row+5+current_process)) $start_time
    echo -e "\033[48;5;208m \033[0m"
    sleep 1

    for ((i=1; i<=waiting_time; i++))
    do
        tput cup $((last_row+5+current_process)) $((start_time+i))
        echo -e "\033[48;5;226m \033[0m"
        #sleep 1

    done

    for ((i=1; i<=process_time; i++))
    do
       tput cup $((last_row+2)) $((total_processing_time+i))
       echo  $(((current_time+i)/10))
       tput cup $((last_row+3)) $((total_processing_time+i))
       echo  $(((current_time+i)%10))

   #    echo $((current_time+i))
       tput cup $((last_row+4)) $((total_processing_time+i))
       echo $process
       tput cup $((last_row+5+current_process)) $((total_processing_time+i))
       echo -e "\033[48;5;28m \033[0m"
       sleep 1
    done

    # Update current time and total times
    current_time=$((start_time + process_time + waiting_time))
    total_waiting_time=$((total_waiting_time + waiting_time))
    total_processing_time=$((total_processing_time + process_time))
    #display running time
    tput cup $current_row 62
    echo $total_processing_time

   (( current_process++ ))
   (( current_row++ ))

    # Calculate average waiting time and average process time
    #result=$(echo "scale=2; $dividend / $divisor" | bc -l)
    avg_waiting_time=$(echo "scale=2; $total_waiting_time / $current_process" | bc -l)
    avg_process_time=$(echo "scale=2; $total_processing_time / $current_process" | bc -l)
    # Move cursor to row 3, column 86
    tput cup 3 86
    # Write Waiting time
    echo $avg_waiting_time

    # Move cursor to row 3, column 109
    tput cup 3 109
    echo $avg_process_time

done
tput cup $((last_row+last_row+6)) 1

