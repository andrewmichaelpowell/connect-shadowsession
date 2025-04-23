# ++++++++++++++++++++++++++++++++++++
# +  Connect-ShadowSession           +
# +  github.com/andrewmichaelpowell  +
# ++++++++++++++++++++++++++++++++++++

Function Connect-ShadowSession{
  Param(
    [Parameter(Mandatory="True")]
    [String]$Computer
  )

    If(Test-Connection -ComputerName $Computer -Count 1 -Quiet){
      query.exe session /server:$Computer
      $Session = Read-Host -Prompt "Enter Session ID"
      mstsc.exe /V:$Computer /shadow:$Session /control /noconsentprompt
  }

  Else{
    Try{
      $Resolve = Resolve-DNSName -ErrorAction Stop -Name $Computer
      If(($Resolve.IPAddress).IndexOf(".") -gt 0){
        Write-Host ""
        Write-Host -NoNewLine -ForegroundColor Yellow "Host "
        Write-Host -NoNewLine -ForegroundColor White $Computer.ToLower()
        Write-Host -ForegroundColor Yellow " has a DNS record, but it is currently offline."
      }

      Else{
        Write-Host ""
        Write-Host -NoNewLine -ForegroundColor Yellow "Host "
        Write-Host -NoNewLine -ForegroundColor White $Computer.ToLower()
        Write-Host -ForegroundColor Yellow " does not have a DNS record."
      }
    }

    Catch{
      Write-Host ""
      Write-Host -NoNewLine -ForegroundColor Yellow "Host "
      Write-Host -NoNewLine -ForegroundColor White $Computer.ToLower()
      Write-Host -ForegroundColor Yellow " does not have a DNS record."
    }
  }
}