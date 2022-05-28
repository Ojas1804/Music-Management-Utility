#!/bin/bash

clear

source $PWD/utilities.sh
scan_songs

while :
do
    echo "COMMANDS:"
    echo "1. Scan Songs"
    echo "2. Remove a song"
    echo "3. List songs"
    echo "4. Search by singer"
    echo "5. Search by album"
    echo "6. Search by keyword"
    echo "7. Open music directory"
    echo "8. PLay a random song"
    echo "9. Exit"
    echo -n "Enter the command number: " 
    read comm
    case $comm in
        1)
            echo "Scanning Songs..."
            scan_songs
            echo "Scan completed."
            ;;
        2)
            echo "Please enter the name of the song:"
            echo  "Enter a name: "
            read song_name
            deleted_songs $song_name
            echo "Song removed."
            ;;
        3)
            list_songs
            ;;
        4)
            echo "Please enter the name of the singer:"
            echo "Enter a name: "
            read singer
            search_by_singer $singer
            ;;
        5)
            echo "Please enter the name of the album:"
            echo "Enter a name: "
            read album
            search_by_singer $album
            ;;
        6)
            echo "Please enter the keyword:"
            echo "Enter a keyword: "
            read keyword
            search_by_singer $keyword
            ;;
        7)
            echo "Song list:"
            echo "__________"
            list_songs
            echo "__________"
            echo "Please enter the song name:"
            read -np "Enter a name: " song_name
            open_dir $song_name
            ;;
        8)
            echo "Playing a random song..."
            random_song
            ;;
        9)
            exit
            ;;
        *)
            echo "Invalid command"
            ;;
    esac
done
