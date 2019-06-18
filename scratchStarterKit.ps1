#test connection
Get-AzureRmLocation | ? {$_.DisplayName -like '*East*'}

#demo how to find Azure API versions for a specific resource
Get-AzureRmResourceProvider -Location eastus -ListAvailable | ft ProviderNamespace
(Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | ft ResourceTypeName
((Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Network).ResourceTypes | Where-Object ResourceTypeName -eq publicIPAddresses).ApiVersions


#Step 1: Create Key Vault and set flag to enable for template deployment with ARM
$rgname=""
New-AzureRmResourceGroup -Name $rgname -Location eastus 
$rg = Get-AzureRmResourceGroup -Name $rgname
$manName = 'poc'
$manVaultName = $AsHackName + 'manVault'
New-AzureRmKeyVault -VaultName $manVaultName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location -EnabledForTemplateDeployment

#Step 2: Add password as a secret.  Note:this will prompt you for a user and password.  User should be vmadmin and a password that meet the azure pwd police like P@ssw0rd123!!
Set-AzureKeyVaultSecret -VaultName $manVaultName -Name "manDefaultPassword" -SecretValue (Get-Credential).Password

#Step 3: Update azuredeploy.parameters.json file with your envPrefixName and Key Vault info example- /subscriptions/{guid}/resourceGroups/{group-name}/providers/Microsoft.KeyVault/vaults/{vault-name}
Get-AzureRmKeyVault -VaultName $manVaultName | Select-Object VaultName, ResourceId

#az keyvault secret show --name ubuntuDefaultPassword --vault-name robAsHackVault --query value --output tsv

#Change the parameters file and redeploy
$rgname=""
New-AzureRmResourceGroup -Name $rgname -Location eastus 
$rg = Get-AzureRmResourceGroup -Name $rgname

$AlertVMs = @("mon12sqlSrv16","mon12VSSrv17","web2linux")
$rgname="mon12"
$rg = Get-AzureRmResourceGroup -Name $rgname
$job = 'job.' + ((Get-Date).ToUniversalTime()).tostring("MMddyy.HHmm")
$template="C:\Users\rokuehfu\Documents\OneDrivev2\OneDrive\Tech Decks\Azure Alerts\GenerateNetworkInAlerts.json"
New-AzureRmResourceGroupDeployment `
  -Name $job `
  -ResourceGroupName $rg.ResourceGroupName `
  -TemplateFile $template `
  -alertVMs $AlertVMs


  #create a simple array
$rgNames = @("armwwt1","armwwt2","armwwt3")

New-AzureRmDeployment `
  -Name demoARM `
  -Location eastus `
  -TemplateFile "C:\Users\rokuehfu\Documents\OneDrivev2\OneDrive\Tech Decks\Azure Starter Template\Network\demo.json" `
  -rgNames $rgNames `
  -storagePrefix demo `
  -rgLocation eastus

  $rgNames = @("arm","arm2","arm3")


  $rgs = Get-AzureRmResourceGroup -Name demo*
  foreach($rg in $rgs){
    Get-AzureRmResourceGroup -Name $rg.ResourceGroupName | Remove-AzureRmResourceGroup -Verbose -Force
  }

  Search-AzureRmGraph -Query "summarize count()"

  Search-AzureRmGraph -Query "where type =~ 'microsoft.compute/virtualmachines'| summarize count() by OS = tostring(aliases['Microsoft.Compute/virtualMachines/storageProfile.osDisk.osType']), OsVersion = tostring(properties.storageProfile.imageReference.version)"

    #Sample $Alertinfo.data.status or $Alertinfo.data.context.activityLog.level
    $rgname = "SecCenterAttackDemo"
    $location = "eastus"
    $name = "default"
    $vm = "/subscriptions/8b2ef784-0c0d-424c-8a7a-aa1304a0366a/resourceGroups/SecCenterAttackDemo/providers/Microsoft.Compute/virtualMachines/badguy"
    $kind = "Basic"

    Set-AzureRmJitNetworkAccessPolicy -ResourceGroupName $rgname -Location $location -Name $name -VirtualMachine $vm -Kind $kind

  Set-AzureRmJitNetworkAccessPolicy -ResourceGroupName "myService1" -Location "centralus" -Name "default" -VirtualMachine $vmRules -Kind "Basic"

  start-AzureRmJitNetworkAccessPolicy -ResourceGroupName "myService1" -Location "centralus" -Name "default" -Kind "Basic" -VirtualMachine $vms

  $name = "goodguy"
  $rg = "SecCenterAttackDemo"
  $stoppableStates = "starting", "running"
 $vm = Get-AzureRmVM -ResourceGroupName $rg -Name $name -Status

  $state = ($vm.Statuses[1].DisplayStatus -split " ")[1]
    if($state -in $stoppableStates) {
        Write-Output "Stopping '$($name)' ..."
        #Stop-AzureRmVM -ResourceGroupName $rg -Name $name -Force
       
    }else {
        Write-Output ($name + ": already stopped. State: " + $state) 
    }

   
  
$TagName = "SecurityState"
$TagValue = "Test"
$vmid = "/subscriptions/8b2ef784-0c0d-424c-8a7a-aa1304a0366a/resourceGroups/SecCenterAttackDemo/providers/Microsoft.Compute/virtualMachines/goodguy"


$split = $vmid -split "/";
$subscriptionId = $split[2]; 
$rg = $split[4];
$name = $split[8];
Write-Output ("Subscription Id: " + $subscriptionId)
Write-Output ("ResourceGroup: " + $rg)
Get-AzureRmVM -ResourceGroupName $rg -Name $name | ForEach-Object { $tags = (Get-AzureRmResource -ResourceGroupName $_.ResourceGroupName -Name $_.Name).Tags; $tags= @{$TagName=$TagValue}; Set-AzureRmResource -ResourceGroupName $_.ResourceGroupName -Name $_.Name -ResourceType "Microsoft.Compute/VirtualMachines" -Tag $tags -Force }
      


New-AzureRmVm `
    -ResourceGroupName "mon12" `
    -Name "mon12egvm" `
    -Location "East US" `
    -VirtualNetworkName "mon12Vnet" `
    -SubnetName "FESubnetName" `
    -SecurityGroupName "fesng" `
    -PublicIpAddressName "mon12egpip" `
    -OpenPorts 80,3389