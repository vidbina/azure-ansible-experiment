# Notes

## Exception Rename
The Ansible project contains a `windows_azure.py` inventory file which uses a
deprecated version of the Python `azure` API.

All `WindowsAzureError` calls [were renamed](https://github.com/Azure/azure-sdk-for-python/blob/fa3119c497e98343c7f789e07d108d1d2d457bd2/ChangeLog.txt#L47)
which leads to breaking changes. Which means that the `windows_azure.py` will
have to be modified to reflect this change.

# Auth
Running `python windows_azure.py` leads to problems because the subscriber ID
and certificate need to be supplied.

```python
from azure.servicemanagement import get_certificate_from_publish_settings

subscription_id = get_certificate_from_publish_settings(
    publish_settings_path='MyAccount.PublishSettings',
    path_to_write_certificate='mycert.pem',
    subscription_id='00000000-0000-0000-0000-000000000000',
)
```

The previous snippet needs `pyopenssl` installed.

## Incomplete Ouput

Upon running `python windows_azure.py` only a few machines are shown that are
no longer in use. My new machines are not showing up.

According to the [documentation](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/#how-to-connect-to-your-subscription)
the Azure AD method has to be used in order to access resources through the
Azure Resource Manager.

[azure-ad-xplat]: https://azure.microsoft.com/en-us/documentation/articles/xplat-cli/
[azure-auth-sp-pass]: https://azure.microsoft.com/en-us/documentation/articles/resource-group-authenticate-service-principal/#_authenticate-service-principal-with-password---azure-cli


http://azure-sdk-for-python.readthedocs.org/en/latest/resourcemanagementauthentication.html

https://azure.microsoft.com/en-us/documentation/articles/resource-group-authenticate-service-principal/#authenticate-service-principal-with-password---azure-cli

Use `ENDPOINT=example.com ./create_ad_application_and_service_provider.sh` to 
create a application and login through the Azure CLI under the AD account 
created. The details of the AD and SP are found in `.azure_ad_app` and 
`.azure_ad_sp`.

[servicemgmt]: http://azure-sdk-for-python.readthedocs.org/en/latest/servicemanagement.html
