#!/bin/bash
QUESTION_FILE="question.txt"
HIGHSCORE_FILE="highscore.txt"
# create highscore file if missing
touch "$HIGHSCORE_FILE"             # create the file $HIGHSCORE_FILE if not yet created
# check if question file exists
if [[ ! -f "$QUESTION_FILE" ]]; then
    echo "Error: question file '$QUESTION_FILE' not found"          #! -f test whether the file does not exist
    exit 1
fi
# load questions into an array
while IFS= read -r line; do                 #done < file read the file line by line, read -r means read text exactly without interpreting backlashes
    QUESTIONS+=("$line")                    #QUESTIONS+=("$line") append to questiom array(list)
done < "$QUESTION_FILE"
# shuffle questions using shuf
SHUFFLED=($(shuf -i 0-$((${#QUESTIONS[@]} - 1)))) # ${#QUESTION[@]} Number of element in the array while -1 last array of index because arrays start at 0
                                                  # shuf -i 0-n generate a random numbers  from 0 to $
score=0
streak=0
TOTAL_QUESTIONS=${#QUESTIONS[@]} # TOTAL_QUESTION= show number of questions loaded
ask_question() {
    local QUESTION="$1"
    local A="$2"
    local B="$3"           # local is a function which means variable exist only inside a function .
    local C="$4"           # $1,$2,3$..are the function arguments that is it display questions and answers
    local D="$5"
    local ANSWER="$6"
    echo "$QUESTION"
    echo "A) $A"
    echo "B) $B"
    echo "C) $C"
    echo "D) $D"
    read -p "Your answer (A/B/C/D): " USER_ANSWER      # read -p ask user a question and user answer store what they type
    USER_ANSWER=$(echo "$USER_ANSWER" | tr '[:lower:]' '[:upper:]')  # lower and upper convert lower case to upper so both "a" and "B" work
    if [[ $USER_ANSWER == "$ANSWER" ]]; then
        echo "Correct!"
        score=$((score + 1))
        streak=$((streak + 1))
    else
        echo "Wrong! The correct answer was: $ANSWER"
        streak=0
    fi
}
# loop through shuffled questions
for idx in "${SHUFFLED[@]}"; do     # idx in ${SHUFFLED[@]} this means take each index from shuffled and use it to fetch the matching question line
    line="${QUESTIONS[$idx]}"
    Q=$(echo "$line" | cut -d '|' -f1)
    A=$(echo "$line" | cut -d '|' -f2)
    B=$(echo "$line" | cut -d '|' -f3)
    C=$(echo "$line" | cut -d '|' -f4)
    D=$(echo "$line" | cut -d '|' -f5)
    ANSWER=$(echo "$line" | cut -d '|' -f6 | tr -d ' [:space:]')
    ask_question "$Q" "$A" "$B" "$C" "$D" "$ANSWER"
done
echo ""
echo "You scored $score out of $TOTAL_QUESTIONS"

