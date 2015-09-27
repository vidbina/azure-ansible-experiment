import requests
import os

def get_token_from_client_credentials(endpoint, client_id, client_secret):
    payload = {
        'grant_type': 'client_credentials',
        'client_id': client_id,
        'client_secret': client_secret,
        'resource': 'https://management.core.windows.net/'
    }
    response = requests.post(endpoint, data=payload).json()
    print(response)
    return response['access_token']

auth_token = get_token_from_client_credentials(
    endpoint=os.getenv('AZURE_ENDPOINT'), #'https://login.microsoftonline.com/0ec590e9-f54b-487a-80b7-294fe9527aab/oauth2/token',
    client_id=os.getenv('AZURE_CLIENT_ID'), # '4707fa0f-1cc6-4a5e-8cb7-25b5375413cc',
    client_secret=os.getenv('AZURE_SECRET') #'secrets kill'
)
print(auth_token)
