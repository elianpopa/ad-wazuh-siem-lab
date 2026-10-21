# Atomic Red Team setup and the tests used in this lab.
# Run in an ELEVATED PowerShell on CLIENT1, in an isolated lab VM only.

# --- Setup -------------------------------------------------------------
Set-ExecutionPolicy Bypass -Scope Process -Force
Add-MpPreference -ExclusionPath "C:\AtomicRedTeam"     # lab VM only, so Defender doesn't remove test files
IEX (IWR 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1' -UseBasicParsing)
Install-AtomicRedTeam -getAtomics -Force
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force

# --- List the available tests for a technique (test numbers vary) --------
Invoke-AtomicTest T1136.001 -ShowDetailsBrief

# --- T1136.001 Create Account: Local Account ------------------------------
# Test 4: create a new user in a command prompt
Invoke-AtomicTest T1136.001 -TestNumbers 4
Invoke-AtomicTest T1136.001 -TestNumbers 4 -Cleanup

# --- T1053.005 Scheduled Task ----------------------------------------------
# Test 2: scheduled task (local), creates a task named "spawn"
Invoke-AtomicTest T1053.005 -TestNumbers 2
Invoke-AtomicTest T1053.005 -TestNumbers 2 -Cleanup
schtasks /query /tn spawn      # should report that the task no longer exists

# --- T1059.001 PowerShell (encoded command tests) --------------------------
Invoke-AtomicTest T1059.001 -ShowDetailsBrief
# Run the chosen encoded-command test, then clean it up:
# Invoke-AtomicTest T1059.001 -TestNumbers <n>
# Invoke-AtomicTest T1059.001 -TestNumbers <n> -Cleanup
