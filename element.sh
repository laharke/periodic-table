#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"


if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

#echo -e "\n\n~~~~ Periodic Table ~~~~\n\n"

#Get el arugmetno uno, y me tiro un search
#puede ser 1, H o Hydrogen y deberia buscar 
#if argument is atomic number
if [[ $1 =~ ^[1-9]+$ ]]
then
  element=$($PSQL "SELECT * FROM properties 
                  JOIN elements ON properties.atomic_number = elements.atomic_number 
                  JOIN types ON properties.type_id = types.type_id
                  WHERE properties.atomic_number = '$1'")
else
  #es string
  element=$($PSQL "SELECT * FROM properties 
                  JOIN elements ON properties.atomic_number = elements.atomic_number
                  JOIN types ON properties.type_id = types.type_id
                  WHERE symbol = '$1' or name = '$1'")
fi


if [[ -z $element ]]
then
  echo I could not find that element in the database.
  exit
fi

#FORMATTING DE LO QUE TENGO QUE MOSTRAR:
#The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. 
#Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
#    1 | 1.008 | -259.1 | -252.9 | 2 | 1 | H | Hydrogen | 2 | nonmetal
#echo $element
echo $element | while read ID BAR MASS BAR MELTING BAR BOLING BAR NO BAR NO BAR SIGLA BAR NAME BAR NO BAR TYPE 
do
  echo "The element with atomic number $ID is $NAME ($SIGLA). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOLING celsius."
done