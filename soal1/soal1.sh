a=`awk -F "\t" '
	BEGIN {
		max=0
	}

	{ arr[$13] = arr[$13] + sprintf("%.4f", $21); max = max + 1 }

	END {
		for(key in arr)
			if(arr[key] == 0)
				delete arr[key]

		min_val = 999999
		min_key

		for(key in arr){
			if(min_val > arr[key]){
				min_key = key
				min_val = arr[key]
			}
		}

		print sprintf("%.4f", min_val) "|" min_key
	}
' Sample-Superstore.tsv`

ans_a=`echo $a | awk '{split($0, x, "|"); print x[2]}'`
val_a=`echo $a | awk '{split($0, x, "|"); print x[1]}'`

echo "Jawaban No. 1a : $ans_a, Profit : $val_a"

b=`awk -F "\t" -v var="$ans_a" '
	BEGIN {
		max=0
	}

	$13 == var { arr[$11] = arr[$11] + sprintf("%.4f", $21); max = max + 1 }

	END {
		for(key in arr){
			print sprintf("%.4f", arr[key]) "|" key
		}
	}
' Sample-Superstore.tsv | sort -g -k1,2n | head -n 2`

echo "Jawaban No. 1b :"
b_res=`echo "$b" | awk ' {split($0, x, "|"); print "- "x[2]", Profit : "x[1]}'`

echo "$b_res"

c_1=`echo "$b" | awk ' {split($0, x, "|"); print x[2]}' | head -n 1`
c_2=`echo "$b" | awk ' {split($0, x, "|"); print x[2]}' | tail -n 1`

c=`awk -F "\t" -v state1="$c_1" -v state2="$c_2" '
	BEGIN {
		max=0
	}

	$11 == state1 { arr[$17] = arr[$17] + sprintf("%.4f", $21); max = max + 1 }
	$11 == state2 { arr[$17] = arr[$17] + sprintf("%.4f", $21); max = max + 1 }

	END {
		for(key in arr){
			print sprintf("%.4f", arr[key]) "|" key
		}
	}
' Sample-Superstore.tsv | sort -g -k1,2n | head -n 10`

echo "Jawaban No. 1c :"
c_res=`echo "$c" | awk ' {split($0, x, "|"); print "- "x[2]", Profit : "x[1]}'`

echo "$c_res"