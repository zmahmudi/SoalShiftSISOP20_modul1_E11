grep -E "Location" wget.log > location.log

# parse unique location
unique=`awk '
	BEGIN {
		 adc=0
		 fic=0
		 unique[0]=""
		 uc=0
		 uic=0
	}

	/Location: (.*) \[following\]/ {address[adc] = $2; adc += 1}

	END{
		for(i in address){
			flag=1
			for(j in unique){
				if(address[i] == unique[j]){
					flag=0
				}

			}
			if(flag == 1){
				unique[uc] = address[i]
				uc+=1
				unique_id[uic] = i
				uic+=1
			}else{
				dupe[dc] = address[i]
				dc+=1
				dupe_id[dic] = i
				dic+=1
			}
		}

		for(i in unique){
			print unique_id[i]
		}
	}

' location.log`

# parse duplicate
dupe=`awk '
	BEGIN {
		 adc=0
		 fic=0
		 unique[0]=""
		 uc=0
		 uic=0
	}

	/Location: (.*) \[following\]/ {address[adc] = $2; adc += 1}

	END{
		for(i in address){
			flag=1
			for(j in unique){
				if(address[i] == unique[j]){
					flag=0
				}

			}
			if(flag == 1){
				unique[uc] = address[i]
				uc+=1
				unique_id[uic] = i
				uic+=1
			}else{
				dupe[dc] = address[i]
				dc+=1
				dupe_id[dic] = i
				dic+=1
			}
		}

		for(i in dupe){
			print dupe_id[i]
		}
	}

' location.log`

IFS=$'\n' read -rd '' -a dupearray <<< "$dupe"
IFS=$'\n' read -rd '' -a uniquearray <<< "$unique"

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
	mv "pdkt_kusuma_$i" "kenangan/kenangan_$kenangan_last"
done

for i in ${dupe[@]}; do
	duplicate_last=$((duplicate_last + 1))
	mv "pdkt_kusuma_$i" "duplicate/duplicate_$duplicate_last"
done

# echo "${#unique[@]} ${#dupeunique[@]} ${#dupe[@]}"
mv wget.log wget.log.bak
mv location.log location.log.bak