# Ec2-Powershell
Ec2-Powershell

The script causes the OS to read specific directories’ files on
the EBS volume first, thus causing them to be queued for hydration first 

The version of the script attached targets the Windows directory, and a specific application directory (example in the script is C:\Eclipse)
        
Customize the script to target different directories in the section just following the comment: 

o    “##Select directories to be run in parallel sub processes in thissection.”

The script will run parallel processes logging all starts and stops in the Windows Applicationevent log for measurement.
