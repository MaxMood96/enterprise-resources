#!/bin/bash
# Destroys your Codecov enterprise stack
# WARNING: this deletes all of your configuration and uploaded coverage reports!

# Due to pgsql permissions issues, this user must be removed from tf state
# to allow the database to be deleted
terraform state rm google_sql_user.codecov

terraform destroy
