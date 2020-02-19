#!/bin/bash

sikecil=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
sibesar=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

jam=`date +"%k"`

unkapital=${sikecil[$jam]}
unkapital2=${sikecil[$jam-1]}
kapital=${sibesar[$jam]}
kapital2=${sibesar[$jam-1]}

file=`echo "$1" | cut -d '.' -f1`
man="$(echo "$file" | tr ["$unkapital"-za-"$unkapital"] [a-z] | tr ["$kapital"-ZA-"$kapital"] [A-Z])"
mv $1 $man.txt
