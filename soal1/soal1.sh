# sub a

a=`awk -F ',' '
	BEGIN {
		max=0
	}

	{ arr[$13] = arr[$13] + $20; max = max + 1 }

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

		print min_val "|" min_key
	}
' Sample-Superstore.csv`

ans_a=`echo $a | awk '{split($0, x, "|"); print x[2]}'`
val_a=`echo $a | awk '{split($0, x, "|"); print x[1]}'`

echo "Jawaban No. 1a : $ans_a, Profit : $val_a"

# b=`awk -F ',' -v var="$ans_a" '
# 	BEGIN {
# 		max=0
# 	}

# 	$13 == var { arr[$11] = arr[$11] + $20; max = max + 1 }

# 	END {
# 		for(key in arr){
# 			print arr[key] "|" key
# 		}
# 	}
# ' Sample-Superstore.csv > tmp`

# b2=`sort -g -k1,2rn tmp > tmp2`
# b_res=`head -n 2 tmp2`
# `rm tmp`; `rm tmp2` 


b=`awk -F ',' -v var="$ans_a" '
	BEGIN {
		max=0
	}

	$13 == var { arr[$11] = arr[$11] + $20; max = max + 1 }

	END {
		for(key in arr){
			print arr[key] "|" key
		}
	}
' Sample-Superstore.csv | sort -g -k1,2n | head -n 2`

echo "Jawaban No. 1b :"
b_res=`echo "$b" | awk ' {split($0, x, "|"); print "- "x[2]", Profit : "x[1]}'`

echo "$b_res"