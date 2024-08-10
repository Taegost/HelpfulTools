while IFS= read -r line; do
    rm -f $line
done < ~/dupe_files.txt