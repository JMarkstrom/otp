.. Updated by Jonas Markström on June 3, 2021

====================================
Thales OTP (OATH) for 3rd party use
====================================

.. toctree::
   :hidden:
   :maxdepth: 3


   index


Overview
********************

OATH or Open Authentication is a `standard <https://openauthentication.org/about-oath/>`_ ensuring interoperability between authenticators and authentication servers.
Implementing for :abbr:`OATH(Open Authentication)` is what allows **Microsoft**, **DUO**, **Okta** and a range of other providers to use Thales authenticators such as the OTP 110 or the OTP Display Card. 

.. thumbnail:: /images/otp/otp110.png
   :width: 80%
   :title: Figure: Thales OTP 110 (not accurate scale).
   :show_caption: true
|
This document provide step-by-step guidance on how to support the most popular third party services. In addition, this document also provides information around the technology involved (see Appendix) so as to equip You to make further integrations or adaptations.


Determining what authenticator to order
=======================================

The following diagram provides a simplified decision tree for selecting an authenticator with respect to use case or authentication server used. Work with your Thales account team to map the authenticator requirement to a valid SKU. When in doubt: request a 'sample'.

.. thumbnail:: /images/otp/decisionTree.png
   :width: 100%
   :title: Figure: Determining what authenticator to use.
   :show_caption: true
|
.. note::
   This decision tree focuses on the use of OATH OTP authenticators. Additional authenticators are available through Thales, e.g: **smartcard**, **pattern-based** (GrIdSure), **SMS**, **Voice**, **Email**, **authenticator app**...


Microsoft Azure AD & Office365
******************************

This guide documents the procedure for importing the OTP 110 authenticator for use with Office365 or Azure AD when the SafeNet Trusted Access IdP *is not* used for Access Management.

.. warning::
   Before attempting seed import into a Microsoft environment, establish that:
   
   * Your seed file adheres to the required format.
   * You have Global Administrator privileges in Microsoft Azure.   

Microsoft proprietary seed format
=================================

The "seed" contains the unique programming of each authenticator including it's shared secret and associated attributes. Importantly, Microsoft does not implement best practices seed transport protocols (:abbr:`PSKC (Portable Symmetric Key Container)`) and requires the seed be provided in clear text over :abbr:`CSV (Comma-Separated Values)`. This format is only available from Thales on request using a specific SKU.


Review current Azure AD tenant settings
=======================================

Once the seed file has been updated, you need to establish that the Azure AD (AAD) tenant supports the configuration of MFA, and if so: that settings are *fit* for purpose.

To review Azure AD tenant settings:

#. Open your browser of choice and navigate to the AAD portal at: https://portal.azure.com
#. When prompted, authenticate with administrative privileges
#. Click the search bar (top) and enter "MFA" selecting :guilabel:`&Multi-Factor Authentication` from the results:

   .. thumbnail:: /images/otp/mfaInAzure.png
     :width: 100%
     :title: Figure: Search or navigate to ‘Multi-Factor Authentication’.
     :show_caption: true
 
   .. attention::
      If the 'Multi-Factor Authentication' page is not listed the customer organization lacks the necessary subscription level (P1 or P2) with Microsoft. In this case it is best to position SafeNet Trusted Access (STA) instead of upgrading the Microsoft plan.

#. In the ‘Multi-Factor Authentication’ view, click :guilabel:`&Additional cloud-based MFA settings`:

   .. thumbnail:: /images/otp/additionalMfaSettings.png
     :width: 100%
     :title: Figure: Click to review or configure additional MFA settings.
     :show_caption: true

#. Scroll down the page and review the various settings, then click :guilabel:`&Save`

   .. thumbnail:: /images/otp/verificationOptions.png
     :width: 100%
     :title: Figure: Make sure only relevant options are enabled.
     :show_caption: true

   .. attention::
      Consider deactivating 'call to phone', 'text message to phone' due to risks associated with SIM cloning and social engineering. In the example below we have deactivated all but app and hardware token. Unfortunately no further granularity is available at this time through Microsoft. For higher assurance authenticators and enforcement, consider SafeNet Trusted Access (STA).


Enable MFA for user(s) in O365
==============================

Once we have established that the AAD tenant supports (hardware-based) MFA we need to enable it for target users. This is a two-step process starting with enabling MFA for the user(s) in O365 (this section) and then allocating MFA authenticators to the users in the AAD portal (step 4).

#. Navigate to the Office 365 admin portal available at: https://portal.office.com/AdminPortal/
#. Using the navigation left hand side, click :guilabel:`&Users` and then :guilabel:`&Active Users`

   .. thumbnail:: /images/otp/activeUsers.png
     :width: 100%
     :title: Figure: Selecting Active Users.
     :show_caption: true

#. In the **Active Users** view, click to select :guilabel:`&Multi-factor authentication`:

   .. thumbnail:: /images/otp/selectMfa.png
     :width: 100%
     :title: Figure: Click Multi-factor authentication to enable MFA for single or multiple users.
     :show_caption: true
	 

#. Follow instructions in the appropriate tab:

   .. tabs::

      .. tab:: Enable MFA for a single user

         #. Click the search action icon to *expand* a search field into view
         #. Type the target user's name hitting the :kbd:`Enter` key to execute the search
         #. Click to enable the checkbox next to the user (left hand side) and then click :guilabel:`&Enable`
         #. When prompted click :guilabel:`&enable multi-factor auth` to proceed
         #. In the confirmation view, click :guilabel:`&Close` to finish.
		 
		 
      .. tab:: Enable MFA for multiple users
	     
         #. In the multi-factor authentication view, click on :guilabel:`&bulk update`
         #. In the popup window, click :guilabel:`&BROWSE FOR FILE…` and select your bulk processing file
         #. Click on the proceed action icon (lower left) to continue with the import
         #. Repeat (proceed) until processing has completed successfully.
         
         .. tip::
            An example bulk import CSV file can be downloaded :download:`here <files/bulk-import.csv>`.		 
	  
Import Authenticator seed file into Azure AD
============================================

Our final step before verifying the solution is to import the authenticator seed file from Step 1 into the AAD tenant.

#. In the AAD portal and in the Multi-Factor Authentication view still, click :guilabel:`&OATH tokens` left hand side:

   .. thumbnail:: /images/otp/selectOathTokens.png
     :width: 100%
     :title: Figure: Select OATH tokens to import hardware authenticator seeds.
     :show_caption: true

#. Click :guilabel:`&Upload` and browse to select your Thales seed file, clicking :guilabel:`&OK` to continue:

   .. thumbnail:: /images/otp/clickUpload.png
     :width: 100%
     :title: Figure: Select Upload to import authenticator seed(s).
     :show_caption: true

#. Click the :guilabel:`&Refresh` button to update the page (or it will remain unchanged):

   .. thumbnail:: /images/otp/clickRefresh.png
     :width: 100%
     :title: Figure: You must click refresh or the view will not reflect changes made.
     :show_caption: true

#. While the process is completing, :guilabel:`&View details` may show completion feedback:

   .. thumbnail:: /images/otp/viewDetails.png
     :width: 100%
     :title: Figure: Clicking view details after refresh may produce import success/failure status.
     :show_caption: true

#. Click :guilabel:`&Refresh` again for good measure and then change the Show selector (dropdown) to the appropriate filter: 

   .. thumbnail:: /images/otp/importedAuthenticators.png
     :width: 100%
     :title: Figure: Applying a show filter should list imported MFA authenticators.
     :show_caption: true

#. Next, flip your hardware authenticators upside down to display their serial numbers:

   .. thumbnail:: /images/otp/flippedAuthenticators.png
      :width: 100%
      :title: Figure: The flip side of each OTP authenticator reveals it's serial number.
      :show_caption: true

#. Matching the authenticator serial to the user displayed in the AAD portal, click :guilabel:`&Activate` in the right-most column
#. Press the authenticator button to generate a One Time Password (OTP) and then enter the passcode in to :guilabel:`&Verification code` field followed by clicking :guilabel:`&OK`

   .. thumbnail:: /images/otp/verificationCode.png
     :width: 100%
     :title: Figure: Activation of authenticator using OTP.
     :show_caption: true

#. Repeat the activation process for any additional authenticator imported.


Verification
============

The integration of Thales OTP 110 authenticators into O365/AAD can be tested simply by authenticating to any app or endpoint part of the O365 offering. The expected behavior prompts for both password and MFA credentials. 

An example login to account.office.com is shown below:

#. At the login prompt enter the username (UPN) followed by clicking :guilabel:`&Next`:

   .. thumbnail:: /images/otp/signInUsername.png
     :width: 100%
     :title: Figure: Enter UPN to proceed.
     :show_caption: true

#. Next, enter your fixed password credentials and click :guilabel:`&Sign in`:

   .. thumbnail:: /images/otp/enterPassword.png
     :width: 100%
     :title: Figure: Enter password.
     :show_caption: true

#. Generate a One Time Password (OTP) on your OTP 110 authenticator and then input it into the Enter code field, clicking :guilabel:`&Verify`:

   .. thumbnail:: /images/otp/enterPasscode.png
     :width: 100%
     :title: Figure: Enter OTP as generated on hardware authenticator.
     :show_caption: true

#. Assuming correct authentication, the user is logged in:

   .. thumbnail:: /images/otp/loggedIn.png
     :width: 100%
     :title: Figure: Upon successful authentication the user is granted access.
     :show_caption: true


Nexus Hybrid Access Gateway
***************************

This guide documents the procedure for updating the OTP 110 authenticator seed file for use with Nexus Hybrid Access Gateway when the SafeNet Trusted Access IdP *is not* used for Access Management.

Seed file modification
======================

The seed file provided for 3rd party use in :abbr:`PSKC (Portable Symmetric Key Container)` must be further modified to Nexus requirements. This includes iterating through the XML content to add a child element called :file:`<pskc:Suite>HMAC-SHA1</pskc:Suite>` to each authenticator.

To modify the seed:

#. Download or Copy/paste below code snippet to file ensuring a :file:`.ps1` (powershell) extension
#. Right-click the file and select :guilabel:`&Run With Powershell` from the context menu
#. Follow the on-screen instructions presented by the script.

.. tip::
   To get the latest version of the Nexus script please click :download:`here <files/OATH_authenticator_import_into_Nexus_HAG.ps1>` to download it.


.. code-block:: sh
   :linenos:

   ##########################################################################
   # BROWSE TO SOURCE FILE FUNCTION:

   Function Open-File ([string]$initialDirectory) {

   [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
   $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
   $OpenFileDialog.Title = "Open source Nexus seed file:"
   $OpenFileDialog.initialDirectory = $OpenInitialPath
   $OpenFileDialog.filter = "XML (*.xml)| *.xml"
   $OpenFileDialog.FileName = $OpenFileName
   $OpenFileDialog.ShowDialog() | Out-Null
   return $OpenFileDialog.filename
   }

   # Call the browse function above and store the selected file in a variable:
   $results = Open-File 

   ##########################################################################
   # APPEND SEED FILE WITH ELEMENTS/NODES

   # A hash table holds the namespace we need to be able to navigate with xPath:
   $ns = @{pskc = "urn:ietf:params:xml:ns:keyprov:pskc" }

   # load it into an XML object: 
   $xml = New-Object -TypeName XML
   $xml.Load($results)

   # Iterate the XML document using xPath to locate the AlgorithmParameters element:
   Foreach ($item in (Select-XML -Xml $xml -XPath 
   /pskc:KeyContainer/pskc:KeyPackage/pskc:Key/pskc:AlgorithmParameters -Namespace $ns)) {
   
   # Add element/node to AlgorithmParameters parent WITH namespace:
   $newElement = $xml.createElement('pskc:Suite', 'urn:ietf:params:xml:ns:keyprov:pskc')
   # Add the value to the key:
   $newElement.innerText = 'HMAC-SHA1'
   # Create the new node AND restrict it from writing to terminal:
   $item.node.AppendChild($newElement) | Out-null

   # Here is an example of updating an existing value within selected element:
   #$item.node.Lenght = "8"
   } 

   ##########################################################################
   # SAVE THE RESULTS:

   # Function to prompt the user to save the new CSV file created:
   Function Save-File ([string]$initialSaveDirectory) {

   [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
   
   $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
   $SaveFileDialog.Title = "Save generated Nexus HAG seed file as:"
   $SaveFileDialog.initialSaveDirectory = $SaveInitialPath
   $SaveFileDialog.filter = "XML (*.xml)| *.xml"
   $SaveFileDialog.FileName = $SaveFileName
   $SaveFileDialog.ShowDialog() | Out-Null
   $global:selectedFilePath = $SaveFileDialog.filename
   return $SaveFileDialog.filename
   }

   # Call the function to save the file prompting the user for location:
   $SaveMyFile = Save-File
   $xml.Save($selectedFilePath)


Appendix
********

CSV
===

According to `Wikipedia <https://en.wikipedia.org/wiki/Comma-separated_values#:~:text=A%20comma%2Dseparated%20values%20(CSV,name%20for%20this%20file%20format.>`_: "A comma-separated values (CSV) file is a delimited text file that uses a comma to separate values. Each line of the file is a data record. Each record consists of one or more fields, separated by commas. The use of the comma as a field separator is the source of the name for this file format."

.. attention::
   If your authentication server requires the authenticator seed in :abbr:`CSV (Comma-Separated Values)` format you will need to pay special attention to the product SKU when ordering! Failure to do so will result in a :abbr:`PSKC (Portable Symmetric Key Container)` seed file (default). 

An example :abbr:`CSV (Comma-Separated Values)` document:

.. code-block::

   Serial Number,Secret Key,Manufacturer,Model,Start Date,Time Interval
   GALT10949319,OPJI2CGKO083NKC37DI5NBGDI6MLFLTB,THALES,OTP110,2021-06-04T04:46:26,30
   GALT10949320,0KR865GQTFRK2GSPRQI7PCL6AOKHK3H4,THALES,OTP110,2021-06-04T04:46:26,30
   GALT10949324,PNMEAK6HM0ISADI9L4F1K3I5MS3EEM43,THALES,OTP110,2021-06-04T04:46:26,30


PSKC
====

PSKC or Portable Symmetric Key Container is a standardized container format used for transporting symmetric keys and their metadata. In context of OTP, adherence to the :abbr:`PSKC (Portable Symmetric Key Container)` standard ensures interoperability between manufacturers of authenticators and authentication systems. 

.. note::
   Because *interpretation* may differ across vendors it is some times necessary to manipulate the PSKC to achieve interoperability. In other cases, as with Microsoft, the standard is not followed at all and another format must be produced.

.. tip::
   For more information about :abbr:`PSKC (Portable Symmetric Key Container)`, please refer to `IETF <https://tools.ietf.org/id/draft-ietf-keyprov-pskc-03.xml>`_ 


XML
---

As noted, the authenticator seed for is typically provided as a Portable Symmetric Key Container (PSKC) which in turn is provided as an Extensible Markup Language (XML) document (with additional layers of security through the Thales fulfillment process). In order to modify the :abbr:`PSKC (Portable Symmetric Key Container)` to fit specific and sometimes proprietary requirements of the 3rd party authentication server it is important to have a basic understanding of :abbr:`XML (Extensible Markup Language)`.

To begin with, :abbr:`XML (Extensible Markup Language)` documents have hierarchical tree-like structure with branches or nodes *extending* from a root. The root is referred to as the **root element** with the next item being a **child element** (or child 'node') of the root. From the immediate child's point of view, the node above is a **parent element** (or parent 'node') and again the child below is a **child element** (or child 'node') or a **sub child** seen from the root.

An example :abbr:`XML (Extensible Markup Language)` document structure:

.. code-block:: xml
   
   <root>
     <child>
      <subchild>.....</subchild>
     </child>
   </root>

.. Note::
   It is important to understand these relationships in order to be able to manipulate the :abbr:`XML (Extensible Markup Language)` in order to add, remove or update content in the :abbr:`PSKC (Portable Symmetric Key Container)` document.
 

Namespaces
----------

According to `Wikipedia <https://en.wikipedia.org/wiki/XML_namespace#:~:text=XML%20namespaces%20are%20used%20for,more%20than%20one%20XML%20vocabulary.&text=Both%20the%20customer%20element%20and,a%20child%20element%20named%20id.>`_: "XML namespaces are used for providing uniquely named elements and attributes in an XML document. They are defined in a W3C recommendation. An XML instance may contain element or attribute names from more than one XML vocabulary."


An example :abbr:`XML (Extensible Markup Language)` document structure with namespace:

.. code-block:: xml
   
   <root xmlns:ns="urn:abc:ns">
     <ns:child>
      <ns:subchild>.....</ns:subchild>
     </ns:child>
   </ns:root>
	
.. note::
   The importance of namespaces on :abbr:`PSKC (Portable Symmetric Key Container)` is that the elements inside the :abbr:`XML (Extensible Markup Language)` contains namespaces and that these must be handled when navigating the file programatically.
