

# SoalShiftSISOP20_modul1_E11
## Kelompok
- Ammar Alifian Fahdan (05111840000007)
- Zaenal Mahmudi Ismail (05111840000054)

## Pembahasan Soal

### Soal 1

**Deskripsi**

Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum untuk membuat laporan berdasarkan data yang ada pada file “Sample-Superstore.tsv”. Namun dia tidak dapat menyelesaikan tugas tersebut. Laporan yang diminta berupa :

**a**. Tentukan wilayah bagian (region) mana yang memiliki keuntungan (profit) paling sedikit 
**b**.  Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling sedikit berdasarkan hasil poin a
**c**. Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling sedikit berdasarkan 2 negara bagian (state) hasil poin b

Whits memohon kepada kalian yang sudah jago mengolah data untuk mengerjakan laporan tersebut.

**Penjelasan Script**

Untuk penyelesaian soal ini, kami menaruh seluruh solusi dalam satu file *soal1/soal1.sh*.

Pertama, kami menggunakan kode ini untuk menjawab problem 1A;

```
awk -F "\t" '
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
' Sample-Superstore.tsv
```

Pada soal, kami memecah file *.tsv yang diberikan dengan menggunakan parameter -F. Lalu, kami memproses file dengan menggunakan associative array. Jadi untuk setiap baris file, kami melihat value dari Region (kolom ke 13), lalu membuatnya menjadi key dari suatu array untuk menyimpan jumlah profit dari masing-masing region.

Setelah seluruh file diproses, kami melakukan traversing di seluruh array untuk mengecek profit terkecil. Lalu setelah diketahui profit terkecil, kami mereturn region berikut dengan nilai profitnya dengan delimiter "|", untuk mencegah ambiguitas saat diproses nantinya.

Selanjutnya, kami menggunakan perintah ini :
```
ans_a=`echo $a | awk '{split($0, x, "|"); print x[2]}'`
val_a=`echo $a | awk '{split($0, x, "|"); print x[1]}'`

echo "Jawaban No. 1a : $ans_a, Profit : $val_a"
```

Pada kode diatas, bisa dilihat kami memecah region dengan valuenya, lalu kami cetak dengan perintah echo. Nama region ini akan kami gunakan untuk soal bagian B.

```
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
```
Kami melakukan 3 operasi dalam variabel b. Pertama, mirip dengan operasi pada 1A, kami memproses file dan melakukan penambahan dengan associative array. Namun bedanya kami hanya akan melakukan penambahan bila region ($13) sama dengan hasil region dari 1A.

Lalu, kami menggunakan perintah `sort`, yang akan menyortir seluruh output `awk` yang diberikan secara terkecil ke terbesar. Akhirnya kami menggunakan `head` untuk membaca 2 line awal dari hasil sort.

```
echo "Jawaban No. 1b :"
b_res=`echo "$b" | awk ' {split($0, x, "|"); print "- "x[2]", Profit : "x[1]}'`

echo "$b_res"

c_1=`echo "$b" | awk ' {split($0, x, "|"); print x[2]}' | head -n 1`
c_2=`echo "$b" | awk ' {split($0, x, "|"); print x[2]}' | tail -n 1`
```

Disini kami mencetak variabel $b yang sudah kami proses terlebih dahulu selanjutnya, dan menyimpan $b ke variabel c_1 dan c_2 untuk soal 1C.

```
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
```

Disini proses yang kami lakukan sangat mirip dengan 1B, namun bedanya kami menggunakan 2 komparasi untuk kotanya, dan kami menggunakan `head -n 10` karena kami ingin mengambil 10 produk dengan profit terkecil.

### Soal 2

**Deskripsi**

Pada suatu siang, laptop Randolf dan Afairuzr dibajak oleh seseorang dan kehilangan data-data penting. Untuk mencegah kejadian yang sama terulang kembali mereka meminta bantuan kepada Whits karena dia adalah seorang yang punya banyak ide. Whits memikirkan sebuah ide namun dia meminta bantuan kalian kembali agar ide tersebut cepat diselesaikan. Idenya adalah kalian (a) membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka. (b) Password acak tersebut disimpan pada file berekstensi .txt dengan nama berdasarkan argumen yang diinputkan dan HANYA berupa alphabet. (c) Kemudian supaya file .txt tersebut tidak mudah diketahui maka nama filenya akan di enkripsi dengan menggunakan konversi huruf (string manipulation) yang disesuaikan dengan jam(0-23) dibuatnya file tersebut dengan program terpisah dengan (misal: password.txt dibuat pada jam 01.28 maka namanya berubah menjadi qbttxpse.txt dengan perintah ‘bash soal2_enkripsi.sh password.txt’. Karena p adalah huruf ke 16 dan file dibuat pada jam 1 maka 16+1=17 dan huruf ke 17 adalah q dan begitu pula seterusnya. Apabila melebihi z, akan kembali ke a, contoh: huruf w dengan jam 5.28, maka akan menjadi huruf b.) dan (d) jangan lupa untuk membuat dekripsinya supaya nama file bisa kembali. 


**Penjelasan Script**

Untuk soal ini, kami membuat 2 file, yaitu *soal2/soal2.sh* untuk enkripsi dan *soal2/soal2decrypt.sh* untuk dekripsi

Untuk script soal2, kami mengambil 28 karakter random yang terdiri dari huruf besar, huruf kecil dan angka. 

```
kata=`< /dev/urandom tr -dc A-Za-z0-9 | head -c28`
echo $kata
```
Lalu, kami mengambil jam saat file dienkripsi 

```
jam=`date +"%k"`
```

dan memproses argumen yang diberikan user dengan format:

‘bash soal2_enkripsi.sh password.txt’.

dengan cara *Caesar cipher* dengan key berupa jam saat file dienkripsi seperti yang diminta di soal.

```
sikecil=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
sibesar=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

unkapital=${sikecil[$jam]}
unkapital2=${sikecil[$jam-1]}
kapital=${sibesar[$jam]}
kapital2=${sibesar[$jam-1]}

file=`echo "$1" | cut -d '.' -f1`
man="$(echo "$file" | tr [a-z] ["$unkapital"-za-"$unkapital"] | tr [A-Z] ["$kapital"-ZA-"$kapital2"])"
echo $kata > $man.txt
```

Untuk script soal2decrypt, kami mengambil argumen nama file yang diinputkan, lalu memprosesnya dengan *Caesar cipher*, namun kali ini kami membaliknya sehingga didapatkan plaintext yang asli.

### Soal 3

**Deskripsi**

1 tahun telah berlalu sejak pencampakan hati Kusuma. Akankah sang pujaan hati kembali ke naungan Kusuma? Memang tiada maaf bagi Elen. Tapi apa daya hati yang sudah hancur, Kusuma masih terguncang akan sikap Elen. Melihat kesedihan Kusuma, kalian mencoba menghibur Kusuma dengan mengirimkan gambar kucing. [a] **Maka dari itu, kalian mencoba membuat script untuk mendownload 28 gambar dari "https://loremflickr.com/320/240/cat" menggunakan command wget dan menyimpan file dengan nama "pdkt_kusuma_NO" (contoh: pdkt_kusuma_1, pdkt_kusuma_2, pdkt_kusuma_3) serta jangan lupa untuk menyimpan log messages wget kedalam sebuah file "wget.log".** Karena kalian gak suka ribet, kalian membuat penjadwalan untuk menjalankan script download gambar tersebut. Namun, script download tersebut hanya berjalan[b] **setiap 8 jam dimulai dari jam 6.05 setiap hari kecuali hari Sabtu**. Karena gambar yang didownload dari link tersebut bersifat random, maka ada kemungkinan gambar yang terdownload itu identik. Supaya gambar yang identik tidak dikira Kusuma sebagai spam, maka diperlukan sebuah script untuk memindahkan salah satu gambar identik. Setelah memilah gambar yang identik, maka dihasilkan gambar yang berbeda antara satu dengan yang lain. Gambar yang berbeda tersebut, akan kalian kirim ke Kusuma supaya hatinya kembali ceria. Setelah semua gambar telah dikirim, kalian akan selalu menghibur Kusuma, jadi gambar yang telah terkirim tadi akan kalian simpan kedalam folder /kenangan dan kalian bisa mendownload gambar baru lagi. [c] **Maka dari itu buatlah sebuah script untuk mengidentifikasi gambar yang identik dari keseluruhan gambar yang terdownload tadi. Bila terindikasi sebagai gambar yang identik, maka sisakan 1 gambar dan pindahkan sisa file identik tersebut ke dalam folder ./duplicate dengan format filename "duplicate_nomor" (contoh : duplicate_200, duplicate_201). Setelah itu lakukan pemindahan semua gambar yang tersisa kedalam folder ./kenangan dengan format filename "kenangan_nomor" (contoh: kenangan_252, kenangan_253). Setelah tidak ada gambar di current directory, maka lakukan backup seluruh log menjadi ekstensi ".log.bak".**

**Penjelasan Script**

Kami memisah masing-masing file menjadi 3 bagian, untuk 3A, 3B dan 3C.

Untuk 3A, kode yang kami gunakan cukup simpel. 
```
for (( i = 0; i < 28; i++ )); do
	wget -O "pdkt_kusuma_$i" "https://loremflickr.com/320/240/cat" -a "wget.log"
done
```

Kode tersebut digunakan untuk melakukan `wget` dan melakukan penyimpanan file dengan nama custom dan menyimpan log di `wget.log`.

Untuk 3C,
```
declare -a unique
declare -a dupeunique
declare -a dupe

uc=0
duc=0
dc=0

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
mv *.log *.log.bak
```
Kode yang kami gunakan cukup panjang. Namun, garis besarnya adalah :

 1. Pertama, lakukan deklarasi 3 array dan 3 counter, yaitu *unique* (untuk menyimpan file unik), *dupeunique* (untuk menyimpan satu file duplikat), *dupe* (untuk menyimpan sisa duplikat).
 2.  Lalu, lakukan `ls` untuk membaca seluruh nama file dengan awalan `pdkt_kusuma_`, dan buat array dari kumpulan nama file itu.
 3. Untuk setiap nama file di array, lakukan komparasi antara satu dengan yang lain. Kami menggunakan command `diff` untuk mengecek apakah dua file adalah file identik atau tidak.
 4. Bila file benar-benar unik dengan yang lainnya, masukkan ke dalam array *unique*.
 5. Bila file memiliki duplikat, cari apakah file duplikat ada di array *dupeunique*. Bila tidak ada, masukkan ke array *dupeunique*. Bila ada, berarti file tersebut adalah duplikat dan dimasukkan ke *dupe*.
 6. Buat dua folder `./kenangan` dan `./duplicate`bila masih belum ada.
 7. Proses semua file di array `unique` dan `dupeunique` untuk dimasukkan ke kenangan, dan `dupe` dimasukkan ke duplicate.
 8. Akhirnya, rename file `*.log` ke `.log.bak`.

**Pendekatan Lain**

Selain cara diatas, kami juga menemukan cara lain yang menggunakan `awk`. Source code dari pendekatan ini bisa diunduh di [sini](https://github.com/zmahmudi/SoalShiftSISOP20_modul1_E11/blob/master/soal3/soal3c_anotherapproach.sh).

Kode kami untuk pendekatan ini adalah sebagai berikut 
```
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
```

Cara dari soal diatas adalah sebagai berikut :
1. Buat suatu file location.bak dari hasil `grep`location di wget.log.
2. Lakukan dua kali processing file location.log, pertama untuk mencari file unik (di variable `unique`) dan kedua untuk mencari file duplikat (di variable `dupe`)
 3. Buat dua folder `./kenangan` dan `./duplicate`bila masih belum ada.
 4. Proses semua file di array `unique` dan `dupe` untuk dimasukkan ke kenangan, dan `dupe` dimasukkan ke duplicate.
 5. Akhirnya, rename file `*.log` ke `.log.bak`.
