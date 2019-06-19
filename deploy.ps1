#Make sure you are connecting to the correct tenant and subscription in Azure.  Also send the context for the subscription. 
Connect-AzAccount -Tenant '59be3e0c-c7bb-4d0f-9c6c-a22bc6f891b7' -SubscriptionId '3b6f7be1-bacc-4e26-818f-7f541058d669'
$context = Get-AzSubscription -SubscriptionId '3b6f7be1-bacc-4e26-818f-7f541058d669'
Set-AzContext $context

#Step 1: Create ResourceGroup after updating the location to one of your choice. Use get-AzLocation to see a list
#envPrefix needs to be between 2-5 char, all lowercase and no special char.
$envPrefixName = 'play1'
$SecurityResourceGroupName = $envPrefixName + 'MissionVaultRG'
New-AzResourceGroup -Name $SecurityResourceGroupName -Location 'East US'
$rg = get-Azresourcegroup -Name $SecurityResourceGroupName

#Step 2: Create Key Vault and set flag to enable for template deployment with ARM
$VaultName = $envPrefixName + 'MissionVault'
New-AzKeyVault -VaultName $VaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 3: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzKeyVaultSecret -VaultName $VaultName -Name "VMPassword" -SecretValue (Get-Credential).Password

#Step 4: Update Masterdeploy.parameters.json file with your envPrefixName and Key Vault info example- /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
(Get-AzKeyVault -VaultName $VaultName).ResourceId

$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
$template=".\missiondeploy.json"
$parameterfile=".\missiondeploy.parameters.json"

New-AzDeployment `
  -Name $job `
  -Location eastus `
  -TemplateFile $template `
  -TemplateParameterFile $parameterfile `
  -envPrefixName $envPrefixName `
  -SecurityKeyVaultName $VaultName `
  -resourceGroupLocation eastus

  #nmap 10.0.2.0/24 -Pn


  