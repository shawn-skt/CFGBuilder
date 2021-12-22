#!/bin/bash
# default parameter: contracts which denotes the contracts directory

function fix_err(){
    for file in `ls $1/json/error/`
    do
        if [ -d $1"/"$file ]
        then
            echo "${file} is a directory"
        else
            filename=${file%.*}
            sed -i '' "s/&#39;/'/g" $1/$filename
            solc --combined-json abi,bin,bin-runtime,srcmap,srcmap-runtime,ast $1/$filename > $1/json/fixed/$filename.json

            if [ $? -ne 0 ]; then
                echo "parsing ${filename} error"
                mv $1/$filename $1/error/$filename
                rm -rf $1/json/fixed/$filename.json
            else
                echo "parsing ${filename} successfully"
                rm -rf $1/json/error/${file}
            fi
        fi
    done
}

fix_err $1