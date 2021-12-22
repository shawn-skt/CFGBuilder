#!/bin/bash
# the parameter denotes the contracts directory

function preprocess(){
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]  	# "-d" recognize directory
        then
            echo "${file} is a directory"
        else
            file_name=$1"/"$file
            echo $file_name
            solc --combined-json abi,bin,bin-runtime,srcmap,srcmap-runtime,ast $file_name > $1/json/$file.json
            if [ $? -ne 0 ]; then
                echo "parsing ${file_name} error"
                mv $1/json/$file.json $1/json/error/$file.json
            else
                echo "parsing ${file_name} successfully to ${1}/json/${file}.json"
            fi
        fi
    done
}

# execute preprocess
preprocess $1
