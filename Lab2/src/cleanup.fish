function cleanup
set target_directory $argv[1] #Αναθέτω το path του target_directory
set days_inactive $argv[2]
set recursive $argv[3]
set dry_run $argv[4]
set excluded_files_dirs (string split " " $argv[5]) 
#Στο $excluded_files_dirs αναθέτω μία λίστα που τα στοιχεία της είναι paths συγκεκριμένων αρχείων ή υποφακέλων μέσα στο $target_directory. 
#Οπότε όταν καλώ την cleanup , στο 5ο όρισμα εισόδου βάζω "$list" , όπου list είναι η λίστα που περιέχει τα paths που εξαιρώ από την διαγραφή. 
#Επίσης, χρησιμοποιώ την εντολή (string split " " $argv[5]) ώστε κάθε στοιχείο της λίστας να περαστεί σαν ξεχωριστό στοιχείο στο $excluded_files_dirs και όχι ως ένα ενιαίο string.
set sort_type $argv[6]
set confirmation $argv[7]
if test (count $argv) -eq 7 #Ελέγχω αν δόθηκε το σωστό πλήθος ορισμάτων εισόδου
echo "Correct arguments"
else
echo "Give correct arguments"
return 1
end
set target_dir_list""
for i in $target_directory/**
set target_dir_list $target_dir_list $i #Στη λίστα $target_dir_list περνάω το path κάθε αρχείου και κάθε υποφακέλου που υπάρχει μέσα στο $target_directory
end
set found false
for val in $target_dir_list #Ελέγχω αν οι λίστες  $excluded_files_dirs και $target_dir_list περιέχουν ίδια paths (που προφανώς περιέχουν)
for i in $excluded_files_dirs
if test $val = $i
set found true #Κάθε φορά που εντοπίζεται ιδιο path στις 2 λίστες , θέτω τη μεταβλητή found ίση με true
break
end
end
if test $found = true
set target_dir_list (string match -v $val $target_dir_list) 
#Διαγράφω ΜΟΝΟ το "όνομα" του κοινού path από την $target_dir_list και ΟΧΙ το ίδιο το αρχείο ή τον υποφάκελο που αντιστοιχεί σε αυτό το path. 
#Έτσι, εξαιρώ από την διαγραφή τα περιεχόμενα της λίστας $excluded_files_dirs.
end
set found false
end
set found false
set list_inactive""
#Παρακάτω υπολογίζω τον αριθμό των ημερών που πέρασαν από την τελευταία πρόσβαση στα στοιχεία της $target_dir_list
#Αν ο αριθμός των ημερών που πέρασαν από την τελευταία πρόσβαση στο αρχείο/υποφάκελο είναι μεγαλύτερος ή ίσος του $days_inactive , τότε το path του συγκεκριμένου αρχείου/υποφακέλου καταχωρείται στην λίστα $list_inactive  
set current_time (date +%s)
for item in $target_dir_list
set access_time (stat -c %X $item)
set elapsed_time (math $current_time - $access_time)
set days (math $elapsed_time / 86400) # 86400 = 60*60*24
set days (math "floor($days)")
echo "$days days have passed since the last access to $item"
if test $days -ne $days_inactive
if test $days -gt $days_inactive
set list_inactive $list_inactive $item
end
end
if test $days -eq $days_inactive
set list_inactive $list_inactive $item
end
end
set file_folder_sizes"" #Σε αυτή την λίστα αποθηκεύω τα μεγέθη των στοιχείων της $list_inactive
set j 0
for i in $list_inactive
set j (math $j + 1)
set size (stat -c %s $i)
set file_folder_sizes[$j] $size
end
echo "File/subfolder sizes without sorting: $file_folder_sizes" #Εκτυπώνω την λίστα $file_folder_sizes
set t (count $list_inactive)
#Παρακάτω υλοποιώ ένα ascending bubble sort για την ταξινόμηση των στοιχείων της $list_inactive κατά μέγεθος
if test $sort_type = "asc"
for i in (seq $t -1 1)
for j in (seq 1 (math $i -1))
if test $file_folder_sizes[$j] -gt $file_folder_sizes[(math $j + 1)] #Για να σορτάρω τα στοιχεία της $list_inactive,συγκρίνω τα μεγέθη τους
#Εκμεταλλεύομαι το γεγονός ότι το path ενός στοιχείου στη $list_inactive έχει τον ίδιο αριθμοδείκτη με το μέγεθός του που βρίσκεται στο $file_folders_sizes
set temp $file_folder_sizes[$j]
set file_folder_sizes[$j] $file_folder_sizes[(math $j + 1)]
set file_folder_sizes[(math $j + 1)] $temp
set temp1 $list_inactive[$j]
set list_inactive[$j] $list_inactive[(math $j + 1)]
set list_inactive[(math $j + 1)] $temp1
end
end
end
end
#Παρακάτω υλοποιώ ένα descending bubble short
if test $sort_type = "desc"
for i in (seq 1 $t)
for j in (seq 1 (math $t - $i))
if test $file_folder_sizes[$j] -lt $file_folder_sizes[(math $j + 1)]
set temp2 $file_folder_sizes[$j]
set file_folder_sizes[$j] $file_folder_sizes[(math $j + 1)]
set file_folder_sizes[(math $j + 1)] $temp2
set temp3 $list_inactive[$j]
set list_inactive[$j] $list_inactive[(math $j + 1)]
set list_inactive[(math $j + 1)] $temp3
end
end
end
end
if test $sort_type != "asc"
if test $sort_type != "desc"
echo "Invalid value for sort_type"
return 1
end
end
#dry_run
if test $dry_run = true
echo "The subfolders and files to be deleted sorted by size in $sort_type order: $list_inactive"
echo "The following files and subfolders will be deleted: "
echo $list_inactive
end
if test $dry_run = true
if test $confirmation = true #προτροπή επιβεβαίωσης πριν την διαγραφή
echo "Are you sure you want to proceed? (yes/no)"
set ans (read)
if test $ans != "yes"
echo "Cleanup canceled"
return 1
end
end
end
if test $recursive = true #Αναδρομική διαγραφή 
for i in (seq 1 (count $list_inactive))
if test -e $list_inactive[$i] #Ελέγχω αν το στοιχείο της $list_inactive έχει διαγραφεί ήδη , σε περίπτωση που διαγράφηκε ο υποφάκελος μέσα στον οποίο βρίσκονταν
echo $list_inactive[$i] | xargs -n 1 rm -r
echo "$list_inactive[$i] deleted recursively"
else
echo "$list_inactive[$i] does not exist"
end
end
end
if test $recursive = false #Μη αναδρομική διαγραφή
for i in (seq 1 (count $list_inactive))
if test -e $list_inactive[$i]
find $list_inactive[$i] -maxdepth 0 | xargs -n 1 rm -r
echo "$list_inactive[$i] deleted non recursively"
else
echo "$list_inactive[$i] does not exist"
end
end
end
end
