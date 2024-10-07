# DVC with Azure Blob Storage

## Steps (SAS Token)

1. Create an **Azure Storage Account**
2. Click on **+ Container** > Enter a name for your container > **Create**
3. Click on your new container > Under **Settings** > Click on **Shared access token**
4. Under **Signing method** > Select **Account key**
5. Under **Permissions** > Check **Read**, **Write**, **Delete** and **List**
6. Under **Start** and **Expiry** > Set the date and time
7. Under **Allowed protocols** > Select **HTTPS only**
8. Generate **SAS token and URL** > Copy the **SAS token**

**Note:** Experiment with other forms of authentication https://dvc.org/doc/user-guide/data-management/remote-storage/azure-blob-storage

**Important:** Less reading, more doing

## Steps (DVC)

1. `dvc init`
2. `dvc remote add <REMOTE_NAME> <REMOTE_PATH>`
3. `dvc remote modify --local <REMOTE_NAME> account_name <STORAGE_ACCOUNT>`
4. `dvc remote modify --local <REMOTE_NAME> sas_token <SAS_TOKEN>`
5. Repeat for all other raw data
6. `dvc add <DATA_PATH>`
7. `dvc push <DATA_PATH> --remote <REMOTE_NAME>`
   - You should see a `.dvc` file being generated
8. Commit the `.dvc` files to version control (i.e. GitHub)
   - `git commit -am "Add raw data"`
   - `git push`
9. Delete all raw data from local
10. Run `dvc pull`
    - All raw data should be downloaded from remote to local

## Steps (Update to raw data)

1. `dvc add <DATA_PATH>`
2. `dvc push <DATA_PATH> --remote <REMOTE_NAME>`
3. Commit code changes that resulted in raw data changes

## Steps (Revert to previous version)

1. `git checkout <...>`
2. `dvc checkout`
