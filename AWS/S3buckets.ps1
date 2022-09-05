Import-Module -Name AWS.Tools.Common -Scope Local

$creds = @{
  AccessKey = 'AKIAIVEJYKV44EKSLFVQ'
  SecretKey = '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'
  StoreAs   = 'MyS3Profile'
}

Set-AWSCredential @creds




$params = @{
  BucketName = 'allmymusic'
  Key        = 'Cube-Music-1/It Is Time For A Love Revolution/Back In Vietnam.mp3'
}

Read-S3Object @params -File ("$env:HOMEDRIVE\temp\{0}" -f ($params.Key).Replace('/','\'))

###################

# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# Open CMD

#Sync Files
#Done aws s3 sync s3://allmymusic/Cube-Music-1 \\buffalo\S3buckets\allmymusic\Cube-Music-1
#aws s3 sync s3://allmymusic/Cube-Music-2 \\buffalo\S3buckets\allmymusic\Cube-Music-2
#aws s3 sync s3://allmymusic/Cube-Music-3 \\buffalo\S3buckets\allmymusic\Cube-Music-3
#aws s3 sync s3://allmymusic/Cube-Music-4 \\buffalo\S3buckets\allmymusic\Cube-Music-4
#aws s3 sync s3://allmymusic/Cube-Music-5 \\buffalo\S3buckets\allmymusic\Cube-Music-5


#aws s3 sync s3://allmymusic \\buffalo\S3buckets\allmymusic
#aws s3 sync s3://backup-cube \\buffalo\S3bu3kets\backup-cube
#aws s3 sync s3://cube-aqs \\buffalo\S3buckets\cube-aqs
#aws s3 sync s3://cube-downloads \\buffalo\S3buckets\cube-downloads
#aws s3 sync s3://cube-migration \\buffalo\S3buckets\cube-migration
#aws s3 sync s3://cube-music \\buffalo\S3buckets\cube-music
#aws s3 sync s3://cube-pictures \\buffalo\S3buckets\cube-pictures
#aws s3 sync s3://cube-software \\buffalo\S3buckets\cube-software

#Done aws s3 sync s3://knarrstudio \\buffalo\S3buckets\knarrstudio


#Copy Files
#aws s3 cp s3://cube-pictures y:\cube-pictures --recursive