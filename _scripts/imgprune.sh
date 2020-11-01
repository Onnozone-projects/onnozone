imagepaths=$(find . -name '*.jpg' -o -name '*.jpeg' -o -name '*.png')
counter=0

for imagepath in $imagepaths; do
    filename=$(basename -- $imagepath)
    echo "Checking $imagepath"
    if ! grep -q -r --exclude-dir=".git" $filename .; then
        git rm $imagepath
        counter=$((counter+1))
    fi
done

if [ "$counter" -eq "0" ]; then
    echo "No images were removed!"
else
    echo "Removed a total $counter images, w00t!"
fi