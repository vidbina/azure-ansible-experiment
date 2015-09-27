from azure.servicemanagement import get_certificate_from_publish_settings

subscription_id = get_certificate_from_publish_settings(
    publish_settings_path='latest.publishsettings',
    path_to_write_certificate='azurecert.pem',
    subscription_id='6210d80f-6574-4940-8f97-62e3f455d194',
)
