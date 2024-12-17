#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ Welcome to the HAIR PORT ~~\n"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # get and display available services
  echo "SERVICES:"

  SERVICES=$($PSQL "SELECT * FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  # get customer requested service
  echo -e "\nEnter your desired service"
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # send to main menu
    MAIN_MENU "That is not a valid service number."
  else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    # service doesnt exist
    if [[ -z $SERVICE_NAME ]]
    then
      # send to main menu
      MAIN_MENU "Please select from the list below."
    else
      # get customer phone number
      echo -e "\nPlease enter your phone number"
      read CUSTOMER_PHONE
      
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      # if customer does not exist create customer profile
      if [[ -z $CUSTOMER_NAME ]]
      then
        # get customer name
        echo -e "\nPlease enter your name"
        read CUSTOMER_NAME
        INSERT_INTO_CUSTOMERS=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSOTMER_NAME')")
      fi

      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      # get time
      echo -e "\nPlease enter your desired time"
      read SERVICE_TIME

      INSERT_INTO_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      echo $SERVICE_NAME
      echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    fi
  fi

}

MAIN_MENU


