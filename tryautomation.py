import requests
from openpyxl import load_workbook

# URL of the Excel file
url = 'https://rilcloud.sharepoint.com/:x:/r/sites/Test519/Shared%20Documents/General/Validation%20of%20BPD,%20MANO%20Additional%20sheet%20and%20Traces%20uploaded%20on%20Phabricator%20and%20SharePoint.xlsx?d=w9a46dc6961f34fe188ae988ce501ff65&csf=1&web=1&e=qCSimX'

# Send a GET request to the URL to fetch the file
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Save the file locally
    with open('file.xlsx', 'wb') as file:
        file.write(response.content)
    
    # Load the Excel file using openpyxl
    workbook = load_workbook('file.xlsx')
    
    # Use the workbook object to work with the Excel file
    # For example, you can access sheets and cells
    sheet = workbook.active
    print(sheet['A1'].value)  # Print the value of cell A1
    
    # Close the workbook
    workbook.close()

else:
    print('Failed to fetch the file')