Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$storageName,
    [parameter(Mandatory=$false)][string]$imageRootFolder,
    [parameter(Mandatory=$false)][string]$servicePrincipalId,
    [parameter(Mandatory=$false)][string]$servicePrincipalSecret,
    [parameter(Mandatory=$false)][string]$tenant
)

# az login using service principle
if ($servicePrincipalId){
    az login --tenant $tenant --service-principal --username $servicePrincipalId --password $servicePrincipalSecret
}

$storage = $(az storage account show -n $storageName -g $resourceGroup -o json | ConvertFrom-Json)

if (-not $storage) {
    Write-Host "Storage $storageName not found in RG $resourceGroup" -ForegroundColor Red
    exit 1
}

$url = $storage.primaryEndpoints.blob
$constr = $(az storage account show-connection-string -n $storageName -g $resourceGroup -o json | ConvertFrom-Json).connectionString

Write-Host "Connecting to storage using $constr and creating containers" -ForegroundColor Green
az storage container create --name "coupon-list" --public-access blob --connection-string "$constr" 
az storage container create --name "product-detail" --public-access blob --connection-string "$constr"
az storage container create --name "product-list" --public-access blob --connection-string "$constr"
az storage container create --name "profiles-list" --public-access blob --connection-string "$constr"
Write-Host "Copying images..." -ForegroundColor Green

$accountName=$storage.name
az storage blob upload-batch --destination "$url" --destination coupon-list  --source $imageRootFolder\tt-images\coupon-list --account-name $accountName
az storage blob upload-batch --destination "$url" --destination product-detail --source $imageRootFolder\tt-images\product-detail --account-name  $accountName
az storage blob upload-batch --destination "$url" --destination product-list --source $imageRootFolder\tt-images\product-list --account-name $accountName
az storage blob upload-batch --destination "$url" --destination profiles-list --source $imageRootFolder\tt-images\profiles-list --account-name $accountName








