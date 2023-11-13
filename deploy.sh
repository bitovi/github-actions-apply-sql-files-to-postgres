#!/bin/bash
echo "::group::Translating variables ..." 
#  GH_ACTION_REPO: ${{ github.action_path }}
#  SNAME: ${{ inputs.aws_secret_name }}
#  DB_HOST: ${{ inputs.db_host }}
#  DB_PORT: ${{ inputs.db_port }}
#  DB_USER: ${{ inputs.db_username }}
#  DB_PASSWORD: ${{ inputs.db_password }}
#  DB_NAME: ${{ inputs.db_name }}
#  CONN_STR: ${{ inputs.sql_connection_string }}
#  DRY_RUN: ${{ inputs.dry_run }}
#  SCRIPTS_PATH: ${{ inputs.sql_scripts_path }}

# ()
if [ -n "$SNAME" ]; then
  SNAME=$(echo "$SNAME" | tr '[:lower:]' '[:upper:]' |  tr '-' '_')
  DB_HOST_VAR="${SNAME}_DB_HOST"
  DB_PORT_VAR="${SNAME}_DB_PORT"
  DB_NAME_VAR="${SNAME}_DB_NAME"
  DB_USER_VAR="${SNAME}_DB_USERNAME"
  DB_PASS_VAR="${SNAME}_DB_PASSWORD"
fi
# Setting var's if empty
[ -z "$DB_HOST" ] && DB_HOST=${!DB_HOST_VAR}
[ -z "$DB_PORT" ] && DB_PORT=${!DB_PORT_VAR}
[ -z "$DB_NAME" ] && DB_NAME=${!DB_NAME_VAR}
[ -z "$DB_USERNAME" ] && DB_USERNAME=${!DB_USER_VAR}
[ -z "$DB_PASSWORD" ] && DB_PASSWORD=${!DB_PASS_VAR}
echo "::endgroup::"

echo "::group::Postgres client install"  
sudo apt update -y -q && sudo apt install postgresql-client -y -q
echo "::endgroup::"
echo "::group::Listing contents"
echo $GITHUB_WORKSPACE/$SCRIPTS_PATH
cd $GITHUB_WORKSPACE/$SCRIPTS_PATH
ls -l *.sql
echo "::endgroup::"
echo "::group::Applying files"
if [ "$DRY_RUN" ]; then
  echo "Would have executed:"
  for file in $(ls *.sql); do
    # Execute each .sql file using PSQL
    echo "$CONN_STR -f ./$file"
    echo "Testing connection. Listing databases."
    $CONN_STR -l
  done
else if ![ "$DRY_RUN" ]; then
  for file in $(ls *.sql); do
    # Execute each .sql file using PSQL
    echo Running $CONN_STR -f $GITHUB_WORKSPACE/$SCRIPTS_PATH/$file
    $CONN_STR -f "$GITHUB_WORKSPACE/$SCRIPTS_PATH/$file"
  done
  fi
fi
echo "::endgroup::"