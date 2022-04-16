#!/bin/bash
# Push to a scratch org

usage () { echo "Usage: [-u TARGETUSERNAME]"; }

while getopts ':u:' option
do
    case "$option" in
        u)  targetusername=${OPTARG};;
        h)  usage; exit;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

push_cmd="sfdx force:source:push"

if [ ! -z "${targetusername}" ]
then
  push_cmd="${push_cmd} --targetusername ${targetusername}"
fi

echo "Executing: ${push_cmd}"
eval "${push_cmd} >&2"