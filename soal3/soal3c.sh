declare -a unique
declare -a dupeunique
declare -a dupe

uc=0
duc=0
dc=0

# buat file location.log dari grep
grep -E "Location" wget.log > location.log

filein=`ls pdkt_kusuma_*` 

IFS=$'\n' read -rd '' -a filelist <<< "$filein"

filecount=${#filelist[@]}

for (( i = 0; i < $filecount; i++ )); do
	flag=1
	for (( j = 0; j < $filecount; j++ )); do
		d=`diff ${filelist[$i]} ${filelist[$j]}`
		if [[ $d == "" ]]; then
			if [[ $i != $j ]]; then
				flag=0
			fi
		fi
		# echo $d
	done
	if [[ $flag == 1 ]]; then
		unique[$uc]=${filelist[$i]}
		uc=$uc+1
	else
		flag=1
		for (( j = 0; j < $duc; j++ )); do
			d=`diff ${filelist[$i]} ${dupeunique[$j]}`
			if [[ $d == "" ]]; then
				flag=0
			fi
		done

		if [[ $flag == 1 ]]; then
			dupeunique[$duc]=${filelist[$i]}
			duc=$duc+1
		else
			dupe[$dc]=${filelist[$i]}
			dc=$dc+1
		fi
	fi

done

if [[ -f "./duplicate" ]]; then
	mkdir duplicate
fi

if [[ -f "./kenangan" ]]; then
	mkdir kenangan
fi


# cek nomor terakhir di duplicate
kenangan_last=`ls ./kenangan | awk '{split($0, x, "_"); print x[2] }' | sort -n | tail -n 1`
# cek nomor terakhir di kenangan
duplicate_last=`ls ./duplicate | awk '{split($0, x, "_"); print x[2] }' | sort -n | tail -n 1`

if [[ kenangan_last == "" ]]; then
	kenangan_last=-1
fi

if [[ duplicate_last == "" ]]; then
	duplicate_last=-1
fi

for i in ${unique[@]}; do
	kenangan_last=$((kenangan_last + 1))
	mv $i "kenangan/kenangan_$kenangan_last"
done

for i in ${dupeunique[@]}; do
	kenangan_last=$((kenangan_last + 1))
	mv $i "kenangan/kenangan_$kenangan_last"
done
for i in ${dupe[@]}; do
	duplicate_last=$((duplicate_last + 1))
	mv $i "duplicate/duplicate_$duplicate_last"
done

# echo "${#unique[@]} ${#dupeunique[@]} ${#dupe[@]}"
mv wget.log wget.log.bak
mv location.log location.log.bak