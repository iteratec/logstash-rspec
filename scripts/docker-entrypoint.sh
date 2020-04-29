#!/bin/bash

trap "echo Exited!; exit;" SIGINT SIGTERM

rspec_tests_to_run="$1"

if [[ "$rspec_tests_to_run" == *"*"* ]]; then
    rspecs_for_chsum="/opt/logstash/rspec-tests"
else
    rspecs_for_chsum="$rspec_tests_to_run"
fi

previous_chsum_rspecs=""
previous_chsum_filters=""
while [[ true ]]
do
    current_chsum_rspecs=`find $rspecs_for_chsum -name *_spec.rb -type f -exec md5sum {} \;`
    current_chsum_filters=`find /opt/logstash/logstash-pipes -name *.conf -type f -exec md5sum {} \;`
    should_run="false"
    if [[ "$previous_chsum_rspecs" == "" ]] && [[ "$previous_chsum_rspecs" == "" ]]; then
        should_run="true"
        previous_chsum_rspecs=$current_chsum_rspecs
        previous_chsum_filters=$current_chsum_filters
    else
        if [[ $previous_chsum_rspecs != $current_chsum_rspecs ]]; then           
            should_run="true"
            echo "-> changed rspec files"
            previous_chsum_rspecs=$current_chsum_rspecs
        fi
        if [[ $previous_chsum_filters != $current_chsum_filters ]]; then           
            should_run="true"
            echo "-> changed filter files"
            previous_chsum_filters=$current_chsum_filters
        fi
    fi
    if [ "$should_run" == "true" ]; then
        echo "=> running tests: $rspec_tests_to_run"
        JAVACMD=`which drip` /opt/logstash/bin/rspec -P $rspec_tests_to_run
    fi
    sleep 2
done