#!/bin/bash
#set -vx

INIT=0
SEC=$(date | awk '{print $4}' | cut -b 7-8)
MIN=$(date | awk '{print $4}' | cut -b 4-5)
HR=$(date | awk '{print $4}' | cut -b 1-2)
MONTH=$(date | awk '{print $2}')
DAY=$(date | awk '{print $1}')
YEAR=$(date | awk '{print $5}')
NDAY=$(date | awk '{print $3}')

if [[ "$MONTH" = "Jan" ]]; then
  MONTH=Janvier
elif [[ "$MONTH" = "Feb" ]]; then
  MONTH=Fevrier
elif [[ "$MONTH" = "Mar" ]]; then
  MONTH=Mars
elif [[ "$MONTH" = "Apr" ]]; then
  MONTH=Avril
elif [[ "$MONTH" = "Jay" ]]; then
  MONTH=Mai
elif [[ "$MONTH" = "Jun" ]]; then
  MONTH=Juin
elif [[ "$MONTH" = "Jul" ]]; then
  MONTH=Juillet
elif [[ "$MONTH" = "Aug" ]]; then
  MONTH=Aout
elif [[ "$MONTH" = "Sep" ]]; then
  MONTH=Septembre
elif [[ "$MONTH" = "Oct" ]]; then
  MONTH=Octobre
elif [[ "$MONTH" = "Nov" ]]; then
  MONTH=Novembre
elif [[ "$MONTH" = "Dec" ]]; then
  MONTH=Decembre
fi

if [[ "$DAY" = "Mon" ]]; then
  DAY=Lundi
elif [[ "$DAY" = "Tue" ]]; then
  DAY=Mardi
elif [[ "$DAY" = "Wed" ]]; then
  DAY=Mercredi
elif [[ "$DAY" = "Thu" ]]; then
  DAY=Jeudi
elif [[ "$DAY" = "Fri" ]]; then
  DAY=Vendredi
elif [[ "$DAY" = "Sat" ]]; then
  DAY=Samedi
elif [[ "$DAY" = "Sun" ]]; then
  DAY=Dimanche
fi

cmpt_tmp()
{
while [[ "$INIT" = "0" ]]; do
	if [[ "$SEC" = "60" ]]; then
		MIN=$(($MIN+1))
		SEC=0
	fi
  if [[ "$MIN" = "60" ]]; then
		HR=$(($HR+1))
		MIN=0
	fi
	sleep 1
	SEC=$(($SEC+01))
	clear
   #echo -e "Nous somme le $DAY $NDAY $MONTH $YEAR et il est \c"
   echo -e "## $DAY $NDAY ##"
   echo -e "## \c"
   if [[ "$HR" -lt "10" ]]; then
     echo -e "0$HR:\c"
   else
     echo -e "$HR:\c"
   fi
   if [[ "$MIN" -lt "10" ]]; then
     echo -e "0$MIN:\c"
   else
     echo -e "$MIN:\c"
   fi
   if [[ "$SEC" -lt "10" ]]; then
     echo -e "0$SEC\c"
   else
     echo -e "$SEC\c"
   fi
   echo -e " ##"
   echo -e "## $MONTH $YEAR ##"
done
}

cmpt_tmp







