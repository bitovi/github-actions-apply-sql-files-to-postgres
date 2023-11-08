# GitHub Actions apply SQL files to Postgres Database
Iterate through .sql files inside a folder using the psql command.

## Action Summary
The main purpose of this action is to apply SQL file(s) to initialize the Postgres database in an automated way, right after creating it using our own [Deploy RDS GitHub Action](https://github.com/bitovi/github-actions-deploy-rds)

If you would like to deploy a backend app/service, check out our other actions:
| Action | Purpose |
| ------ | ------- |
| [Deploy Docker to EC2](https://github.com/marketplace/actions/deploy-docker-to-aws-ec2) | Deploys a repo with a Dockerized application to a virtual machine (EC2) on AWS |
| [Deploy React to GitHub Pages](https://github.com/marketplace/actions/deploy-react-to-github-pages) | Builds and deploys a React application to GitHub Pages. |
| [Deploy static site to AWS (S3/CDN/R53)](https://github.com/marketplace/actions/deploy-static-site-to-aws-s3-cdn-r53) | Hosts a static site in AWS S3 with CloudFront |
<br/>

**And more!**, check our [list of actions in the GitHub marketplace](https://github.com/marketplace?category=&type=actions&verification=&query=bitovi)

# Need help or have questions?
This project is supported by [Bitovi, A DevOps consultancy](https://www.bitovi.com/services/devops-consulting).
You can **get help or ask questions** on our:
- [Discord Community](https://discord.gg/J7ejFsZnJ4Z)

Or, you can hire us for training, consulting, or development. [Set up a free consultation](https://www.bitovi.com/services/devops-consulting).

## Prerequisites
- An [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) and [Access Keys](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
- The following secrets should be added to your GitHub actions secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
- A Postgres Database. Could use [This deploy RDS GitHub Action](https://github.com/bitovi/github-actions-deploy-rds) to create one and store the secrets in AWS Secrets Manager.

## Example usage

Create a Github Action Workflow `.github/workflow/deploy-ghr.yaml` with the following to build on push to the `main` branch.

### Basic example
```yaml
name: Initialize DB
on:
  push:
    branches: [ main ]

jobs:
  Deploy:
    runs-on: ubuntu-latest # Or self-hosted 
    steps:
      - name: Initialize RDS Postgres DB
        uses: bitovi/github-actions-apply-sql-scripts-to-postgres@v0.0.1
        with:
            aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
            aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
            aws_default_region: us-east-1 
            aws_secret_name: some-secret-name-to-read-data-from
            sql_scripts_path: sql-files # (This is the folder in your repo. Leave empty for root.)
            dry_run: false # Defaults to true, set it to false to run
```

## Customizing
Setting the variable `aws_secret_name` will fetch a secret from AWS. We expect to find **DB_HOST** **DB_USER** **DB_NAME** **DB_PORT** **DB_PASSWORD** and **DB_NAME**.

Still in the works, the possibility to override those using the variables with the same name. 

### Inputs

The following inputs can be used as `steps.with` keys:

### Inputs
1. [GitHub main inputs](#github-main-inputs)
1. [AWS Specific](#aws-specific)
1. [Database settings](#database-settings)

#### **GitHub main inputs**
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `checkout` | Boolean | Set to `false` if the code is already checked out. (Default is `true`). |
| `sql_scripts_path` | String | Path containing the sql files. If none defined, will look for files in the root folder. |
<br/>

#### **AWS Specific**
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `aws_access_key_id` | String | AWS access key ID |
| `aws_secret_access_key` | String | AWS secret access key |
| `aws_default_region` | String | AWS default region. Defaults to `us-east-1` |
| `aws_role_to_assume` | String | AWS Role to assume. Default is empty. |
<br/>

#### **Database settings**
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `aws_secret_name` | String | AWS Secrets Manager secret name to pull database variables from. |
| `db_host` | String | Database hostname to connect to. Should be publicly accessible if not running in a self-hosted GH Runner.` |
| `db_port` | String | Database port to connect to. |
| `db_username` | String | Defines the username to use for connecting to the database. |
| `db_password` | String | Defines the username to use for connecting to the database.  |
| `db_name` | String | Define the database name to use. |
| `sql_connection_string` | String | Defaults to `PGPASSWORD=${DB_PASSWORD} /usr/bin/psql -h ${DB_HOST} -p ${DB_PORT} -U ${DB_USER} -d ${DB_NAME}`
| `dry_run` | Boolean | Echo the commands to be executed and does nothing to the database. Will test connection by listing the DB's. Defaults to `false` |
<br/>

## Contributing
We would love for you to contribute to [bitovi/github-actions-deploy-github-runner-to-ec2](https://github.com/bitovi/github-actions-deploy-github-runner-to-ec2).
Would you like to see additional features?  [Create an issue](https://github.com/bitovi/github-actions-deploy-github-runner-to-ec2/issues/new) or a [Pull Requests](https://github.com/bitovi/github-actions-deploy-github-runner-to-ec2/pulls). We love discussing solutions!

## License
The scripts and documentation in this project are released under the [MIT License](https://github.com/bitovi/github-actions-deploy-github-runner-to-ec2/blob/main/LICENSE).
