#!/bin/sh

for i in yang/*\@$(date +%Y-%m-%d).yang
do
    name=$(echo $i | cut -f 1 -d '.')
    echo "Validating $name.yang"
    if test "${name#^example}" = "$name"; then
        response=`pyang --lint --strict --canonical -p dependencies -f tree --max-line-length=72 --tree-line-length=69 $name.yang > $name-tree.txt.tmp`
    else
        response=`pyang --ietf --strict --canonical -p dependencies -f tree --max-line-length=72 --tree-line-length=69 $name.yang > $name-tree.txt.tmp`
    fi
    if [ $? -ne 0 ]; then
        printf "$name.yang failed pyang validation\n"
        printf "$response\n\n"
        echo
	rm yang/*-tree.txt.tmp
        exit 1
    fi
    fold -w 71 $name-tree.txt.tmp > $name-tree.txt

    echo "Generating abridged tree for $name.yang"
    if test "${name#^example}" = "$name"; then
        response=`pyang --lint --strict --canonical -p dependencies -f tree --max-line-length=72 --tree-line-length=69 --tree-depth=2 $name.yang > $name-abridged-tree.txt.tmp`
    else            
        response=`pyang --ietf --strict --canonical -p dependencies -f tree --max-line-length=72 --tree-line-length=69 --tree-depth=2 $name.yang > $name-abridged-tree.txt.tmp`
    fi
    if [ $? -ne 0 ]; then
        printf "$name.yang failed pyang abridged tree generation.\n"
        printf "$response\n\n"
        echo
	rm yang/*-abridged-tree.txt.tmp
        exit 1
    fi
    fold -w 71 $name-abridged-tree.txt.tmp > $name-abridged-tree.txt

    response=`yanglint -p ../../ $name.yang`
    if [ $? -ne 0 ]; then
        printf "$name.yang failed yanglint validation\n"
        printf "$response\n\n"
        echo
        exit 1
    fi
done
rm yang/*-tree.txt.tmp

echo "Validating examples"

for i in yang/example-tcp-configuration-*.xml
do
    name=$(echo $i | cut -f 1-4 -d '.')
    echo "Validating $name"
    response=`yanglint -s -i -t auto -p dependencies yang/ietf-tcp\@$(date +%Y-%m-%d).yang $name`
    if [ $? -ne 0 ]; then
       printf "failed (error code: $?)\n"
       printf "$response\n\n"
       echo
       exit 1
    fi
done
