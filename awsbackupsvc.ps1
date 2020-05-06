function Set-AWSBackupDDB {
	<#
	.SYNOPSIS
	Sets DynamoDB Backups using AWS Backup Service
	.DESCRIPTION
	Sets Backups for all DynamoDB Tables in the selected region
	.EXAMPLE
	Set-AWSBackupDDB -Region 'us-east-1' -BackupPlanID '07f82d33-b1e6-4b3e-a8be-48d7a7834e55' -$BackupServiceIAMARN 'arn:aws:iam::307217575381:role/aws-backup-full-access'
	.PARAMETER Title
	Desired title
	#>
	[CmdletBinding()]
	param
	(	
		[Parameter(
			Mandatory=$True,
			ValueFromPipeline = $true,
			HelpMessage='Please provide the AWS Region'
		)]
        [String]$Region,
        [Parameter(
			Mandatory=$True,
			ValueFromPipeline = $true,
			HelpMessage='Please provide the Backup Plan ID'
		)]
        [String]$BackupPlanID,
        [Parameter(
			Mandatory=$True,
			ValueFromPipeline = $true,
			HelpMessage='Please provide the ARN of the IAM role for Aws backup Service'
		)]
        [String]$BackupServiceIAMARN
	)
    
    #Set the AWS Region
    Write-Host "Setting Region to:" $Region
    Start-Sleep -s 5
    Set-DefaultAWSRegion -Region $Region

    Write-Host "Region set successfully"
    
    #Get all DDB Table ARNs
    $tables = Get-DDBTables

    Write-Host "Acquiring All DynamoDB Tables. . ."
    Start-Sleep -s 10

    $tables


    Write-Host "Adding tables to backup plan ID:" $BackupPlanID


    #Recurse through all DDBTables and extract the TableARN Property
    foreach ($b in $tables) 
        {
            $tableARN=(Get-DDBTable -TableName $b).TableARN
            New-BAKBackupSelection -BackupPlanId $BackupPlanID -BackupSelection_IamRoleArn $BackupServiceIAMARN -BackupSelection_Resource $tableARN -BackupSelection_SelectionName $tableARN -ErrorAction SilentlyContinue
        }
}

