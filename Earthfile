VERSION 0.1
FROM salesforce/salesforcedx:latest-rc-full
WORKDIR /sfdx-earthly

build:
  ARG username
  ARG clientid
  ARG instanceurl='login.salesforce.com'
  ARG audience='login.salesforce.com'
  ARG jwtprivatekey
  ARG definitionfile='config/project-scratch-def.json'
  RUN build/build.sh -u $username -i clientid -r instanceurl -w audience -f jwtprivatekey -d definitionfile
  SAVE ARTIFACT build/SCRATCH_ORG_USERNAME.txt
  SAVE ARTIFACT build/SCRATCH_ORG_AUTH_URL.txt
