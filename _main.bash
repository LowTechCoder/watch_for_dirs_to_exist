# bash _main.bash 1 5 run_this.bash
sleep_time=$1
attempts=$2
run_when_all_good=$3

path_good_count=0
i=0
sed -i -e '$a\' "paths.conf" # add new line at eof if not there
paths_line_count=$(cat paths.conf | wc -l | awk '{$1=$1};1')
echo "paths_line_count: $paths_line_count"
while [[ $i -lt $attempts ]] ; do
    sleep $sleep_time
    echo "$i"
    while read p; do # join lines with loop
        if [ -d "$p" ] # if dir exists
        then
            (( path_good_count += 1 ))
        else
            echo "path not found, yet."
        fi
    done < "paths.conf"
    echo "path_good_count: $path_good_count"
    if [ "$path_good_count" -ge "$paths_line_count" ]
    then
        echo "paths all accounted for"
        bash "$run_when_all_good"
        i=$attempts
    else
        echo "path missing"
    fi

    path_good_count=0
    (( i += 1 ))
done