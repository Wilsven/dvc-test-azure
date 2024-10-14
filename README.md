# DVC with Azure Blob Storage

## 1. Generate SAS Token

1. Create an **Azure Storage Account**
2. Click on **+ Container** > Enter a name for your container > **Create**
3. Click on your new container > Under **Settings** > Click on **Shared access token**
4. Under **Signing method** > Select **Account key**
5. Under **Permissions** > Check **Read**, **Write**, **Delete** and **List**
6. Under **Start** and **Expiry** > Set the date and time
7. Under **Allowed protocols** > Select **HTTPS only**
8. **Generate SAS token and URL** > Copy the **SAS token**
9. Paste the SAS token into the `.env` file

```
AZURE_URL="azure://<CONTAINER>"
AZURE_STORAGE_ACCOUNT="<STORAGE_ACCOUNT>"
AZURE_STORAGE_SAS_TOKEN="<SAS_TOKEN>"
```

> [!IMPORTANT]  
> Do note down the start and expiry of the SAS token as it is not stored anywhere in Azure.
>
> ```
> Start: 14/10/2024 3:31:09 PM(UTC +08:00)
> Expiry: 10/10/2024 3:31:09 PM (UTC +08:00)
> ```

## 2. Set Up Data Version Control (DVC) (Manually)

1. `dvc init`
2. `dvc remote add <REMOTE_NAME> <REMOTE_PATH>`
3. `dvc remote modify --local <REMOTE_NAME> account_name <STORAGE_ACCOUNT>`
4. `dvc remote modify --local <REMOTE_NAME> sas_token <SAS_TOKEN>`

> [!NOTE]
> Here, `<REMOTE_NAME>` is an alias and `<REMOTE_PATH>` is the path pointing to the directory in your remote storage.
>
> The commands above are ran with a `--local` flag to ensure that credentials or senstive information are not versioned controled.

5. Repeat steps 2-4 for all other raw data
6. `dvc add <DATA_PATH>`

> [!NOTE]
> You should see a `.dvc` file being generated. This is the file that should be versioned controled to GitHub so we know which version of raw data is being used.

7. `dvc push <DATA_PATH> --remote <REMOTE_NAME>`

> [!NOTE]
> Here, `<DATA_PATH>` is the path pointing to your raw data.

8. Commit the `.dvc` files to version control
   - `git commit -am "Add raw data"`
   - `git push`

### 2.1 Validate

1. Delete all raw data from local
2. `dvc pull` and all raw data should be downloaded from your remote into your local

## 3. Update Raw Data

1. Run the cells in [`notebooks/data_transformation.ipynb`](notebooks/data_transformation.ipynb)
2. `dvc add <DATA_PATH>`
3. `dvc push <DATA_PATH> --remote <REMOTE_NAME>`
4. Commit code changes that resulted in raw data changes
   - `git commit -am "Update raw data"`
   - `git push`

## 4. Revert Raw Data

1. `git log` to check for the commit ID of the raw data version you want to revert to

> [!TIP]
> This is where best practices in clear commit messages will help.

2. `git checkout <COMMIT_ID>`
3. `dvc checkout`
4. `git switch main`
5. `dvc add <DATA_PATH>`
6. ~~`dvc push <DATA_PATH> --remote <REMOTE_NAME>`~~ Not required because previous version is already in remote storage.
7. Commit changes to revert raw data version
   - `git commit -am "Revert raw data"`
   - `git push`

---

## (Bonus) Set Up Data Version Control (DVC) (Recommended)

1. `dvc init`
2. `./scripts/setup_dvc.sh`
3. `./scripts/get_raw_data.sh`
