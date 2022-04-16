#!/bin/bash
# Creates a scratch org
nonamespace=false
noancestors=false
setdefaultusername=false

usage () { echo "Usage: [-v TARGETDEVHUBUSERNAME] [-u TARGETUSERNAME] [-t TYPE] [-f DEFINITIONFILE] [-n] [-c] [-i CLIENTID] [-s] [-a SETALIAS] [-w WAIT] [-d DURATIONDAYS]"; }

while getopts ':u:f:i:r:w:a:ds' option
do
    case "$option" in
        v)  targetdevhubusername=${OPTARG};;
        u)  targetusername=${OPTARG};;
        t)  type=${OPTARG};;
        f)  definitionfile=${OPTARG};;
        n)  nonamespace=true;;
        c)  noancestors=true;;
        i)  clientid=${OPTARG};;
        s)  setdefaultusername=true;;
        a)  setalias=${OPTARG};;
        w)  wait=${OPTARG};;
        d)  durationdays=${OPTARG};;
        h)  usage; exit;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

org_create_cmd="sfdx force:org:create --json"

if [ ! -z "${targetdevhubusername}" ]
then
  org_create_cmd="${org_create_cmd} --targetdevhubusername ${targetdevhubusername}"
fi

if [ ! -z "${targetusername}" ]
then
  org_create_cmd="${org_create_cmd} --targetusername ${targetusername}"
fi

if [ ! -z "${type}" ]
then
  org_create_cmd="${org_create_cmd} --type ${type}"
fi

if [ ! -z "${definitionfile}" ]
then
  org_create_cmd="${org_create_cmd} --definitionfile ${definitionfile}"
fi

if [ "${nonamespace}" = true ]
then
  org_create_cmd="${org_create_cmd} --nonamespace"
fi

if [ "${noancestors}" = true ]
then
  org_create_cmd="${org_create_cmd} --noancestors"
fi

if [ ! -z "${clientid}" ]
then
  org_create_cmd="${org_create_cmd} --clientid ${clientid}"
fi

if [ "${setdefaultusername}" = true ]
then
  org_create_cmd="${org_create_cmd} --setdefaultusername"
fi

if [ ! -z "${setalias}" ]
then
  org_create_cmd="${org_create_cmd} --setalias ${setalias}"
fi

if [ ! -z "${wait}" ]
then
  org_create_cmd="${org_create_cmd} --wait ${wait}"
fi

if [ ! -z "${durationdays}" ]
then
  org_create_cmd="${org_create_cmd} --durationdays ${durationdays}"
fi

org_create_cmd="${org_create_command}" && (echo $org_create_cmd >&2)
org_create_output=$($org_create_cmd) && (echo $org_create_output | jq '.' >&2)

scratch_org_username="$(jq -r '.result.username' <<< $org_create_output)"
echo $scratch_org_username > SCRATCH_ORG_USERNAME.txt

org_display_cmd="sfdx force:org:display --verbose --targetusername $scratch_org_username --json" && (echo $cmd >&2)
org_display_output$($org_display_cmd)

org_auth_url="$(jq -r '.result.sfdxAuthUrl' <<< $org_display_output)"
echo $org_auth_url > SCRATCH_ORG_AUTH_URL.txt