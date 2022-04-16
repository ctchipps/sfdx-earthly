#!/bin/bash
# Build the current source into a scratch org

while getopts ':u:i:r:w:f:d' option
do
    case "$option" in
        u)  username=${OPTARG};;
        i)  clientid=${OPTARG};;
        r)  instanceurl=${OPTARG};;
        w)  audience=${OPTARG};;
        f)  jwtkeyfile=${OPTARG};;
        d)  definitionfile=${OPTARG};;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

. ./helpers/install-plugin.sh @dx-cli-toolbox/sfdx-toolbox-package-utils

. ./helpers/authenticate-jwt.sh -u ${username} -f ${jwtkeyfile} -i ${clientid} -r ${instanceurl} -w ${audience} -a DEVHUB -d

. ./helpers/create-scratch.sh -v DEVHUB -d 1 -f ${definitionfile} -w 60

. ./helpers/push-scratch.sh
