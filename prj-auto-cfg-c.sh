#!/bin/bash

mkdir src
if [ ! -e "src/main.c" ]; then
    printf '#include <stdio.h>\n\nint main(int argc, char* argv[]) {\n\tprintf("Hello world!");\n\treturn 0;\n}' >> src/main.c
fi

echo "Create meson.build"

echo "#Init" > $PWD/meson.build

echo "project('project-name', 'c')" >> $PWD/meson.build

printf "\n#Static library\n" >> $PWD/meson.build

for file in src/*.c
do
    if [[ $file =~ "main.c" ]]; then
        printf ""
    else
        echo "$(basename $file | cut -d. -f1) = static_library('$file')" >> $PWD/meson.build
        echo "Processing $file"
    fi
done

printf "\n#Binary\n" >> $PWD/meson.build

echo "executable('bin', 'src/main.c')" >> $PWD/meson.build

echo "Create Makefile"
printf "all:\n\tmeson compile -C builddir\n\t./builddir/bin\n" > $PWD/Makefile

meson setup builddir
