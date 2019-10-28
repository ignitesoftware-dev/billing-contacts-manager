# Billing Contact Manager
## Setup Guide
### Requirements
* Zuora for Salesforce 360 package (version 4.16 and greater)
### Installation Guide using Unmanaged Package method
1. Log in to your Salesforce instance as System Administrator. If you want to install the package on Production environment, proceed to the following URL: <a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t3i000002adss">Production</a>,
otherwise use this one: <a href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t3i000002adss">Sandbox</a>
2. Then choose profiles for which you want to install the app. Remember to check the checkbox saying that this app comes outside of AppExchange. You can also check the release notes and installed components using details below.
3. Hit the Install button and wait for a few minutes. That’s it! You now have Billing Contacts Manager installed. Now proceed to Post Installation Guide.
## Post Installation Guide
1. OAuthClient needs to be created on Zuora tenant connected to SFDC. To do that, log into Zuora, click on your username in top-right corner of the screen, select Administration. Then select ‘Manage Users’. From the list click on active user that has a ‘Api User’ Role, the best would be to select user that is bound to stay and is a mail Api user on tenant. If there is none - create a new one. On user detail page scroll down to OAuth Clients section, fill the name with something descriptive like ‘Billing Contacts Manager’ and press ‘Create’. Be sure to copy ‘Client Secret’ somewhere safe, after closing the popup You won’t be able to get it again. Also copy the Client Id, it will be needed in the next step.
2. Creating Named Credentials - In Salesforce go to Setup, search for ‘Named Credentials’ and click New Named Credential. Name should be set to Zuora_REST_Api. Set URL to https://rest.apisandbox.zuora.com, if deployment takes place on Sandbox, otherwise use https://rest.zuora.com. Set Identity Type to Named Principal and Authentication Protocol to Password Authentication. Change username (Client Id) and password (Client secret) to those that you got when You created the OAuth Client. In callout options, check Allow Merge Fields in HTTP Header and Allow Merge Fields in HTTP Body, leave Generate Authorization Header unchecked.
3. Enable Billing Contacts Manager User Permission Set for selected users
## Billing Contacts Manager overview: 

1. Searching for and selecting a billing account that users want to review and potentially update Bill To or Sold To contact information for
2. Upon selection, Bill To and Sold To information is retrieved from Zuora to ensure that the most recent and ‘master’ data is displayed
3. Bill To and Sold To contact information is shown to user
4. User can choose to edit bill to and sold to or both, and has the option of selecting an existing Salesforce contact to define the new version of Bill To or Sold To
5. Since Zuora allows a user to select the same contact for Bill To and Sold To and, when this is chosen, there is a reference to only one contact definition, the app also enables a user to ‘split’ Bill To and Sold To if it is shared, so that the Bill To and/or Sold To contact can be updated independently of each other
6. Validation - if the Zuora returns an error on updating contacts (no connection, wrong or missing data) there is a message shown to the user at the top of the page. Moreover, if the operation is successful, there is also a message saying the changes has been made.
7. Upon update, the changes are synced to Zuora directly.
8. After Zuora is updated, a Z360 sync is triggered to make sure that the updated contact information makes its way from Zuora back to Salesforce so that the data in both applications is aligned

![App Menu](screenshots/img0.png?raw=true "App Menu")

You can easily search for a billing account by name or number with a new custom search page
![Search](screenshots/img1.png?raw=true "Search")

And partial search is automated for quick results: 
![Search Results](screenshots/img2.png?raw=true "Search Results")

The app ensures the bill to and sold to data is synced from Zuora so you are looking at the most current data. And there is a tab for bill to and a tab for sold to contacts:
![Sync](screenshots/img3.png?raw=true "Sync")

You can edit existing details or choose a Salesforce contact to update bill to and sold to contact data in Zuora:
![Edit](screenshots/img4.png?raw=true "Edit")

Real time confirmation is provided for peace of mind knowing the updates have been made in Zuora and Salesforce:
![Confirmation](screenshots/img5.png?raw=true "Confirmation")
