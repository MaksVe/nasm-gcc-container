# compile asm file

file=$(basename -- "$1")
echo "file to compile: $file"

filename="${file%%.*}"
echo "bare filename: $filename"

rm -f $filename.o
rm -f $filename.out

nasm -felf64 $file -o $filename.o
ld -o $filename.out $filename.o
chmod u+x $filename.out