## Airflow Helm Chart

This is the base airflow helm chart provided by apache community to install airflow components in kubernetes.

### How to make changes to airflow helm chart?

- Un tar the file by running this command - `tar -xvf airflow-8.5.2.tgz`
- The above step will extract folder `airflow`
- Make the required changes to the files in this folder
- Delete the existing tar file by running this command - `rm -rf airflow-8.5.2.tgz`
- Create a tar file out of above folder by running this command - `tar -cvzf airflow-8.5.2.tgz airflow/`
- Add the change description to the CHANGELOG [here](./CHANGELOG.md)
- Publish the updated version to the **msosdu** ACR.

```shell
helm registry login ${dst_registry}.azurecr.io \
    --username "00000000-0000-0000-0000-000000000000" \
    --password ""
helm push airflow-8.5.2.tgz oci://${dst_registry}.azurecr.io/helm
```
