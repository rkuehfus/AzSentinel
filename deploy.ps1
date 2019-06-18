Connect-AzureRmAccount

#Step 1: Create ResourceGroup after updating the location to one of your choice. Use get-AzureRmLocation to see a list
$envPrefixName = 'p1'
$SecurityResourceGroupName = $envPrefixName + 'MissionVaultRG'
New-AzResourceGroup -Name $SecurityResourceGroupName -Location 'East US'
$rg = get-Azresourcegroup -Name $SecurityResourceGroupName

#Step 2: Create Key Vault and set flag to enable for template deployment with ARM
$VaultName = $envPrefixName + 'MissionInstanceVault'
New-AzKeyVault -VaultName $VaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 3: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzureKeyVaultSecret -VaultName $VaultName -Name "VMPassword" -SecretValue (Get-Credential).Password

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


  