#!/bin/bash

kata=`< /dev/urandom tr -dc A-Za-z0-9 | head -c28`
echo $kata

sikecil=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
sibesar=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

jam=`date +"%k"`

unkapital=${sikecil[$jam]}
unkapital2=${sikecil[$jam-1]}
kapital=${sibesar[$jam]}
kapital2=${sibesar[$jam-1]}

file=`echo "$1" | cut -d '.' -f1`
man="$(echo "$file" | tr [a-z] ["$unkapital"-za-"$unkapital"] | tr [A-Z] ["$kapital"-ZA-"$kapital2"])"
echo $kata > $man.txt
