#! /bin/bash

PSQL="psql --username=postgres --dbname=salon -t --no-align -c"


echo -e "\n\n~~~~~ MY SALON ~~~~~\n\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){

if [[ -n $1 ]]
then
echo -e "$1\n"
fi

echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim\n"
read SERVICE_ID_SELECTED

case $SERVICE_ID_SELECTED in 

1) SET_APPOINTMENT "cut" ;;
2) SET_APPOINTMENT "color" ;;
3) SET_APPOINTMENT "perm" ;;
4) SET_APPOINTMENT "style" ;;
5) SET_APPOINTMENT "trim" ;;
*) MAIN_MENU "\nI could not find that service. What would you like today?" ;;
esac

}

SET_APPOINTMENT(){
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z "$CUSTOMER_NAME" ]]
    then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    echo -e "\nWhat time would you like your $1, $CUSTOMER_NAME?"
    read SERVICE_TIME
    SUBMIT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
    SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE name='$1'")
    SUBMIT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
    if [[ -n $SUBMIT_APPOINTMENT ]]
    then
    echo "I have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
    else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $1, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
    SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE name='$1'")
    SUBMIT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
    echo "I have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."

    fi

}

MAIN_MENU




