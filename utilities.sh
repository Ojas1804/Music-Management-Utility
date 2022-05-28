#!/bin/bash


function check_file {
    touch temp
    ls ~ > temp

    while read line
    do
        if [[ $line == "music" ]]
        then
            rm -rf temp
            return 1
        fi
    done < temp

    rm -rf temp
    return 0
}



# random
function random_song {
    n=0
    while read line;
    do
        n=$(( $n + 1 ))
    done < ~/music/song_locations

    num=$(( ( RANDOM % $n )  + 1 ))

    n=0
    while read line;
    do
        n=$(( $n + 1 ))
        if [[ $n -eq $num ]]
        then
            IFS=" | "
            set $line
            IFS=" "
            nvlc $1
        fi
    done < ~/music/song_locations
}



# search by singer
function search_by_singer {
    touch temp
    grep -i "$1" ~/music/song_data > temp

    echo
    echo
    echo "Songs by $1 are : "
    echo "-----------------------"
    n=1
    IFS=" | "
    while read line;
    do
        set $line
        echo "$n : $4"
        n=$(( $n + 1 ))
    done < temp

    echo -n "Enter the song number to be played : "
    read song_num

    n=0
    while read line;
    do
        n=$(( $n + 1 ))
        if [[ $n -eq $song_num ]]
        then
            IFS=" | "
            set $line
            IFS=" "
            song_loc=`grep -i $4 ~/music/song_locations`
            nvlc $song_loc
        fi
    done < temp
    IFS=" "
}



# search by album name
function search_by_album {
    touch temp
    grep -i $1 ~/music/song_data > temp

    echo
    echo
    echo "Songs in the $1 album are : "
    echo "-------------------------------"
    n=1
    IFS=" | "
    while read line;
    do
        set $line
        echo "$n : $4"
        n=$(( $n+1 ))
    done < temp

    echo -n "Enter the song number to be played : "
    read song_num

    n=0
    while read line;
    do
        n=$(( $n+1 ))
        if [[ $n -eq $song_num ]]
        then
            IFS=" | "
            set $line
            IFS=" "
            song_loc=`grep -i $4 ~/music/song_locations`
            nvlc $song_loc
        fi
    done < ~/music/song_data
    IFS=" "
}



# search by keyword
function search_by_keyword {
    touch temp
    grep -i $1 ~/music/song_data > temp

    echo "Songs containing $1 in some sense are : "
    echo "------------------------------------------"
    IFS=" | "
    n=1
    while read line;
    do
        set $line
        echo "$n : $4"
        n=$(( $n+1 ))
    done < temp

    echo -n "Enter the song number to be played : "
    read song_num

    n=0
    while read line;
    do
        n=$(( $n+1 ))
        if [[ $n -eq $song_num ]]
        then
            IFS=" | "
            set $line
            IFS=" "
            song_loc=`grep -i $4 ~/music/song_locations`
            nvlc $song_loc
        fi
    done < ~/music/song_data
    IFS=" "
}



# open directory
function open_dir {
    song_name=$1
    touch temp
    grep -i $song_name ~/music/song_data > temp

    IFS=" | "
    while read line;
    do
        set $line
        IFS=" "
        xdg-open $2
    done < temp
    rm -rf temp
}



function scan_songs {
    cd ~
    rm -rf music/song_data music/song_names music/song_locations
    check_file
    if [[ $? == "0" ]]
    then
        mkdir ~/music
        touch ~/music/song_locations
    fi

    cd ~
    find ~ -name "*.mp3" > ~/music/song_locations

    while read line;
    do
        entry=""
        entry+=$line
        entry+=" | "
        IFS=" "
        touch song_meta1
        touch meta1
        location=$line
        # mediainfo $line
        mediainfo $line > meta1
        grep -i performer meta1 > song_meta1
        grep -i album meta1 >> song_meta1

        IFS=":"
        while read line1;
        do
            set $line1
            entry+="$2"
            entry+=" | "
        done < song_meta1
        rm -rf meta1 song_meta1

        IFS="/"
        read -r -a arr <<< "$line"
        song_name=${arr[-1]}

        entry+=${song_name}
        entry+=" | "
        echo $song_name >> ~/music/song_names
        echo $entry >> ~/music/song_data
    done < ~/music/song_locations
    rm -rf temp

} # add genre as well



function list_songs {
    echo
    echo
    touch temp
    cat ~/music/song_names > temp
    n=0
    while read line;
    do
        n=$(( $n + 1 ))
        if [[ $n%4 -eq 0 ]]
        then
            echo "$n : $line        "
        else
            echo -n "$n : $line        "
        fi
    done < temp
    echo
    echo
    rm -rf temp
}



# deleted_list
function deleted_songs {
    touch ~/music/deleted_song_list
    echo $1 >> ~/music/deleted_song_list

    IFS="/"
    while read line;
    do
        read -r -a arr <<< $line
        song_name=${arr[-1]}
        if [[ song_name == $1 ]]
        then
            rm -rf $line
            scan_songs
        fi
    done < ~/music/song_data
    IFS=" "
}
