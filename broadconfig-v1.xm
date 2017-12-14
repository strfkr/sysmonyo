<!--
  sysmon-config | A sysmon configuration focused on default high-quality event tracing and easy customization by the community
  Master version:	52 | Date: 2017-07-13
  Master author:	@SwiftOnSecurity, other contributors also credited in-line or on Git.
  Master project:	https://github.com/SwiftOnSecurity/sysmon-config
  Master license:	Creative Commons Attribution 4.0 | You may privatize, fork, edit, teach, publish, or deploy for commercial use - with attribution in the text.

  Fork version:	broadconfig-v1
  Fork author:  Smiller
  Fork license:	Creative Commons Attribution 4.0
  REQUIRED: Sysmon version 6.00 or higher (due to changes in registry syntax)
	https://technet.microsoft.com/en-us/sysinternals/bb545021.aspx
	Note that 6.03 has important fixes for filtering

  NOTE: Do not let the imposing size and complexity of this configuration scare you off building your own or customizing it.
	This configuration is based around known high-quality event tracing, and thus looks extremely complicated.
	Sysmon configurations only have to be a few lines, but significant effort has been invested in front-loading as
	much filtering as possible onto the client. This is to make analysis of intrusions possible by hand, and try to
	surface anomalous activity as quickly as possible to any technician armed only with Event Viewer.

  NOTE:	Sysmon is not hardened against a determined attacker with admin rights. Also, this configuration offers an attacker, willing
	to study it closely, several ways to evade some of the alerting. If you are in a high-threat environment and have significant 
	security staff, you should consider a much broader log-all approach. However, in the vast majority of cases, an attacker
	will bumble along through multiple behavioral traps which this configuration monitors, especially in the first minutes.

  NOTE:	"Image" is a technical term for a compiled binary file like an EXE or DLL. Also, it can match just the filename, or entire path.
		"ProcessGuid" is randomly generated, assigned, and tracked by Sysmon to assist in tracing individual process launches.
		"LoginGuid" is randomly generated, assigned, and tracked by Sysmon to assist in tracing individual user sessions.
-->

<Sysmon schemaversion="3.30">
	<HashAlgorithms>md5,imphash</HashAlgorithms>
	<EventFiltering>

	<!--SYSMON EVENT ID 1 : PROCESS CREATION-->
		<!--DATA: UtcTime, ProcessGuid, ProcessID, Image, CommandLine, CurrentDirectory, User, LogonGuid, LogonId, TerminalSessionId, IntegrityLevel, Hashes, ParentProcessGuid, ParentProcessId, ParentImage, ParentCommandLine-->
		<ProcessCreate onmatch="exclude">
		<!--COMMENT:	All process launched will be included, except for what matches a rule below. It's best to be as specific as possible, to
				avoid user-mode executables imitating other process names to avoid logging, or if malware drops files in an existing directory.
				Ultimately, you must weigh CPU time checking many detailed rules, against the risk of malware exploiting the blindness created.-->
			<!--SECTION: Microsoft Windows-->
			<CommandLine condition="begin with">C:\Windows\system32\DllHost.exe /Processid</CommandLine> <!--Microsoft:Windows-->
			<CommandLine condition="is">C:\Windows\system32\SearchIndexer.exe /Embedding</CommandLine> <!--Microsoft:Windows: Search Indexer-->
			<Image condition="end with">C:\Windows\System32\CompatTelRunner.exe</Image> <!--Microsoft:Windows:Customer Experience Improvement-->
			<Image condition="is">C:\Windows\System32\MusNotification.exe</Image> <!--Microsoft:Windows: Update popups-->
			<Image condition="is">C:\Windows\System32\MusNotificationUx.exe</Image> <!--Microsoft:Windows: Update popups-->
			<Image condition="is">C:\Windows\System32\audiodg.exe</Image> <!--Microsoft:Windows: Launched constantly-->
			<Image condition="is">C:\Windows\System32\conhost.exe</Image> <!--Microsoft:Windows: Command line interface host process-->
			<Image condition="is">C:\Windows\System32\powercfg.exe</Image> <!--Microsoft:Power configuration management-->
			<Image condition="is">C:\Windows\System32\wbem\WmiApSrv.exe</Image> <!--Microsoft:Windows: WMI performance adapter host process-->
			<Image condition="is">C:\Windows\System32\wermgr.exe</Image> <!--Microsoft:Windows:Windows error reporting/telemetry-->
			<Image condition="is">C:\Windows\SysWOW64\wermgr.exe</Image> <!--Microsoft:Windows:Windows error reporting/telemetry-->
			<Image condition="is">C:\Windows\system32\sppsvc.exe</Image> <!--Microsoft:Windows: Software Protection Service-->
			<IntegrityLevel condition="is">AppContainer</IntegrityLevel> <!--Microsoft:Windows: Don't care about sandboxed processes-->
			<ParentCommandLine condition="begin with">%%SystemRoot%%\system32\csrss.exe ObjectDirectory=\Windows</ParentCommandLine> <!--Microsoft:Windows:CommandShell: Triggered when programs use the command shell, but without attribution-->
			<ParentImage condition="is">C:\Windows\system32\SearchIndexer.exe</ParentImage> <!--Microsoft:Windows:Search: Launches many uninteresting sub-processes-->
			<!--SECTION: Microsoft:Windows:Defender-->
			<Image condition="begin with">C:\Program Files\Windows Defender</Image> <!--Microsoft:Windows:Defender in Win10-->
			<Image condition="is">C:\Windows\System32\MpSigStub.exe</Image> <!--Microsoft:Windows: Microsoft Malware Protection Signature Update Stub-->
			<Image condition="begin with">C:\Windows\SoftwareDistribution\Download\Install\AM_Base</Image> <!--Microsoft:Defender: Full signature updates-->
			<Image condition="begin with">C:\Windows\SoftwareDistribution\Download\Install\AM_Delta</Image> <!--Microsoft:Defender: Delta signature updates-->
			<Image condition="begin with">C:\Windows\SoftwareDistribution\Download\Install\AM_Engine</Image> <!--Microsoft:Defender: Engine updates-->
			<!--SECTION: Microsoft:Windows:svchost-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k appmodel</CommandLine> <!--Microsoft:Windows 10-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k dcomLaunch</CommandLine> <!--Microsoft:Windows services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k defragsvc</CommandLine> <!--Microsoft:Windows defrag-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k imgsvc</CommandLine> <!--Microsoft:The Windows Image Acquisition Service-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k localServiceAndNoImpersonation</CommandLine> <!--Microsoft:Windows: Network services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k localServiceNetworkRestricted</CommandLine> <!--Microsoft:Windows: Network services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k localSystemNetworkRestricted</CommandLine> <!--Microsoft:Windows: Network services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k netsvcs</CommandLine> <!--Microsoft:Windows: Network services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k networkServiceNetworkRestricted</CommandLine> <!--Microsoft:Windows: Network services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k rPCSS</CommandLine> <!--Microsoft:Windows Services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k swprv</CommandLine> <!--Microsoft:Software Shadow Copy Provider-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k unistackSvcGroup</CommandLine> <!--Microsoft:Windows 10-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k utcsvc</CommandLine> <!--Microsoft:Windows Services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k wbioSvcGroup</CommandLine> <!--Microsoft:Windows Services-->
			<CommandLine condition="is">C:\Windows\System32\svchost.exe -k wsappx</CommandLine> <!--Microsoft:Windows 10-->
			<CommandLine condition="is">C:\Windows\system32\svchost.exe -k networkService</CommandLine> <!--Microsoft:Windows: Network services-->
			<CommandLine condition="is">C:\windows\System32\svchost.exe -k werSvcGroup</CommandLine> <!--Microsoft:Windows: ErrorReporting-->
			<ParentCommandLine condition="is">C:\Windows\System32\svchost.exe -k netsvcs</ParentCommandLine> <!--Microsoft:Windows: Network services: Spawns Consent.exe-->
			<ParentCommandLine condition="is">C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted</ParentCommandLine> <!--Microsoft:Windows: Network services-->
			<!--SECTION: Microsoft:dotNet-->
			<CommandLine condition="begin with">C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngen.exe</CommandLine> <!--Microsoft:DotNet-->
			<Image condition="is">C:\Windows\Microsoft.NET\Framework64\v4.0.30319\mscorsvw.exe</Image> <!--Microsoft:DotNet-->
			<Image condition="is">C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorsvw.exe</Image> <!--Microsoft:DotNet-->
			<Image condition="is">C:\Windows\Microsoft.Net\Framework64\v3.0\WPF\PresentationFontCache.exe</Image> <!--Microsoft:Windows: Font cache service-->
			<Image condition="is">C:\Windows\Microsoft.Net\Framework64\v3.0\WPF\PresentationFontCache.exe</Image> <!--Microsoft:Windows: Font cache service-->
			<ParentCommandLine condition="contains">C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngentask.exe</ParentCommandLine>
			<ParentImage condition="is">C:\Windows\Microsoft.NET\Framework64\v4.0.30319\mscorsvw.exe</ParentImage> <!--Microsoft:DotNet-->
			<ParentImage condition="is">C:\Windows\Microsoft.NET\Framework64\v4.0.30319\ngentask.exe</ParentImage> <!--Microsoft:DotNet-->
			<ParentImage condition="is">C:\Windows\Microsoft.NET\Framework\v4.0.30319\mscorsvw.exe</ParentImage> <!--Microsoft:DotNet-->
			<ParentImage condition="is">C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngentask.exe</ParentImage> <!--Microsoft:DotNet-->
			<ParentImage condition="is">C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngentask.exe</ParentImage> <!--Microsoft:DotNet: Spawns thousands of ngen.exe processes-->
			<!--SECTION: Microsoft:Office-->
			<Image condition="is">C:\Program Files (x86)\Microsoft Office\Office16\MSOSYNC.EXE</Image> <!--Microsoft:Office: Background process-->
			<Image condition="is">C:\Program Files\Common Files\Microsoft Shared\OfficeSoftwareProtectionPlatform\OSPPSVC.EXE</Image> <!--Microsoft:Office: Background process-->
			<!--SECTION: Microsoft:Office:Click2Run-->
			<Image condition="is">C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe</Image> <!--Microsoft:Office: Background process-->
			<ParentImage condition="end with">C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe</ParentImage> <!--Microsoft:Office: Background process-->
			<ParentImage condition="is">C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe</ParentImage> <!--Microsoft:Office: Background process-->
			<!--SECTION: Google-->
			<CommandLine condition="begin with">"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --type=</CommandLine> <!--Google:Chrome: massive command-line arguments-->
			<CommandLine condition="begin with">"C:\Program Files\Google\Chrome\Application\chrome.exe" --type=</CommandLine> <!--Google:Chrome: massive command-line arguments-->
			<Image condition="begin with">C:\Program Files (x86)\Google\Update\</Image> <!--Google:Chrome: Updater-->
			<ParentImage condition="begin with">C:\Program Files (x86)\Google\Update\</ParentImage> <!--Google:Chrome: Updater-->
			<!--SECTION: Firefox-->
			<CommandLine condition="begin with">"C:\Program Files\Mozilla Firefox\plugin-container.exe" --channel</CommandLine> <!-- Mozilla:Firefox: Large command-line arguments | Credit @Darkbat91 -->
			<CommandLine condition="begin with">"C:\Program Files (x86)\Mozilla Firefox\plugin-container.exe" --channel</CommandLine> <!-- Mozilla:Firefox: Large command-line arguments | Credit @Darkbat91 -->
			<!--SECTION: Adobe-->
			<CommandLine condition="contains">AcroRd32.exe" /CR </CommandLine> <!--Adobe:AcrobatReader: Uninteresting sandbox subprocess-->
			<CommandLine condition="contains">AcroRd32.exe" --channel=</CommandLine> <!--Adobe:AcrobatReader: Uninteresting sandbox subprocess-->
			<Image condition="end with">C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\AcroCEF\AcroCEF.exe</Image> <!--Adobe:Acrobat: Sandbox subprocess, still evaluating security exposure-->
			<ParentImage condition="end with">C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\AGSService.exe</ParentImage>
			<Image condition="end with">C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroCEF\RdrCEF.exe</Image> <!--Adobe:AcrobatReader: Sandbox subprocess, still evaluating security exposure-->
			<Image condition="end with">C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\LogTransport2.exe</Image>
			<!--SECTION: Adobe:Flash-->
			<Image condition="end with">C:\Windows\SysWOW64\Macromed\Flash\FlashPlayerUpdateService.exe</Image> <!--Adobe:Flash: Properly hardened updater, not a risk-->
			<!--SECTION: Adobe:Updater-->
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARM.exe</Image> <!--Adobe:Updater: Properly hardened updater, not a risk-->
			<ParentImage condition="end with">C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARM.exe</ParentImage> <!--Adobe:Updater: Properly hardened updater, not a risk-->
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\armsvc.exe</Image> <!--Adobe:Updater: Properly hardened updater, not a risk-->
			<!--SECTION: Adobe:Supporting processes-->
			<Image condition="end with">C:\Program Files (x86)\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe</Image>
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\Adobe Desktop Common\HEX\Adobe CEF Helper.exe</Image>
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\AdobeGCClient\AdobeGCClient.exe</Image> <!--Adobe:Creative Cloud-->
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\OOBE\PDApp\P6\adobe_licutil.exe</Image> <!--Adobe:License utility-->
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\OOBE\PDApp\P7\adobe_licutil.exe</Image> <!--Adobe:License utility-->
			<ParentImage condition="end with">C:\Program Files (x86)\Common Files\Adobe\OOBE\PDApp\P7\adobe_licutil.exe</ParentImage> <!--Adobe:License utility-->
			<Image condition="end with">C:\Program Files (x86)\Common Files\Adobe\OOBE\PDApp\UWA\updaterstartuputility.exe</Image>
			<ParentImage condition="is">C:\Program Files (x86)\Common Files\Adobe\OOBE\PDApp\UWA\updaterstartuputility.exe</ParentImage>
			<!--SECTION: Adobe:Creative Cloud-->
			<Image condition="end with">C:\Program Files (x86)\Adobe\Adobe Creative Cloud\ACC\Creative Cloud.exe</Image>
			<ParentImage condition="end with">C:\Program Files (x86)\Adobe\Adobe Creative Cloud\ACC\Creative Cloud.exe</ParentImage>
			<ParentImage condition="end with">C:\Program Files (x86)\Adobe\Adobe Creative Cloud\CCXProcess\CCXProcess.exe</ParentImage>
			<ParentImage condition="end with">C:\Program Files (x86)\Adobe\Adobe Creative Cloud\CoreSync\CoreSync.exe</ParentImage>
			<!--SECTION: Drivers-->
			<CommandLine condition="begin with">"C:\Program Files\DellTPad\ApMsgFwd.exe" -s{</CommandLine>
			<Image condition="begin with">C:\Program Files\NVIDIA Corporation\</Image> <!--Nvidia:Driver: routine actions-->
			<Image condition="begin with">C:\Program Files\Realtek\</Image> <!--Realtek:Driver: routine actions-->
			<ParentImage condition="end with">C:\Program Files\DellTPad\HidMonitorSvc.exe</ParentImage>
			<ParentImage condition="end with">C:\Program Files\Realtek\Audio\HDA\RtkAudioService64.exe</ParentImage> <!--Realtek:Driver: routine actions-->
			<!--SECTION: Dropbox-->
			<Image condition="end with">C:\Program Files (x86)\Dropbox\Update\DropboxUpdate.exe</Image> <!--Dropbox:Updater: Lots of command-line arguments-->
			<ParentImage condition="end with">C:\Program Files (x86)\Dropbox\Update\DropboxUpdate.exe</ParentImage>
			<!--SECTION: Dell-->
			<ParentImage condition="image">C:\Program Files (x86)\Dell\CommandUpdate\InvColPC.exe</ParentImage> <!--Dell:CommandUpdate: Detection process-->
		 	<!--SECTION: Blackie10-->
      			<Image condition="end with">Everything\Everything.exe</Image>
	    		<Image condition="end with">Lookeen\LookeenFileParser.Exe</Image>
	    		<Image condition="contains">slack\app-2.9.0\slack.exe</Image>
	    		<Image condition="contains">Program Files (x86)\NVIDIA Corporation</Image>
	    		<Image condition="contains">Program Files\NVIDIA Corporation</Image>
	    		<Image condition="contains">Windows\System32\sppsvc.exe</Image>
	    		<Image condition="contains">Sysmon\Sysmon.exe</Image>
	    		<Image condition="contains">Windows\System32\XblGameSaveTask.exe</Image>
	    		<Image condition="contains">Windows\System32\msfeedssync.exe</Image>
	    		<Image condition="contains">Program Files\Internet Explorer\ielowutil.exe</Image>
	    		<Image condition="contains">Windows\System32\msfeedssync.exe</Image>
	    		<Image condition="contains">C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARM.exe</Image>
	    		<Image condition="contains">C:\Windows\Microsoft.NET\Framework\v4.0.30319\ngen.exe</Image>
	    		<Image condition="contains">C:\Windows\System32\SystemSettingsBroker.exe</Image>
	    		<Image condition="contains">C:\Program Files (x86)\Google\</Image>
	    		<Image condition="contains">C:\Windows\WinSxS\amd64</Image>
	    		<Image condition="contains">C:\Windows\servicing\TrustedInstaller.exe</Image>
	    		<Image condition="contains">C:\Program Files\rempl\remsh.exe</Image> <!-- Windows Remediation Performance Logging, has something to do with Sysmon event filtering</!-->
    			<Image condition="contains">C:\Program Files (x86)\Common Files\Apple\Mobile Device Support\</Image>
		</ProcessCreate>

	<!--SYSMON EVENT ID 2 : FILE CREATION TIME RETROACTIVELY CHANGED IN THE FILESYSTEM-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image, TargetFilename, CreationUtcTime, PreviousCreationUtcTime-->
		<FileCreateTime onmatch="include">
			<Image condition="begin with">C:\Users</Image> <!--Look for timestomping in user area-->
		</FileCreateTime>
		<FileCreateTime onmatch="exclude">
			<Image condition="image">OneDrive.exe</Image> <!--OneDrive constantly changes file times-->
			<Image condition="contains">setup</Image> <!--Ignore setups-->
      		<!--SECTION: Blackie10-->
      		<Image condition="is">C:\Windows\System32\RuntimeBroker.exe</Image>
			<Image condition="is">c:\windows\system32\svchost.exe</Image>
			<Image condition="is">C:\WINDOWS\system32\MpSigStub.exe</Image>
			<Image condition="is">C:\WINDOWS\System32\LogonUI.exe</Image>
			<Image condition="is">C:\WINDOWS\ImmersiveControlPanel\SystemSettings.exe</Image>
			<Image condition="is">C:\WINDOWS\system32\SettingSyncHost.exe</Image>
			<Image condition="is">C:\WINDOWS\explorer.exe</Image>
			<Image condition="is">C:\WINDOWS\system32\mmc.exe</Image>
			<Image condition="is">C:\windows\CCM\CcmExec.exe</Image>
			<Image condition="is">C:\WINDOWS\system32\msiexec.exe</Image>
			<Image condition="is">C:\WINDOWS\system32\taskmgr.exe</Image>
			<Image condition="is">C:\Program Files (x86)\Origin\Origin.exe</Image>
	  		<Image condition="contains">WINDOWS\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe</Image>
			<Image condition="contains">WINDOWS\system32\backgroundTaskHost.exe</Image>
			<Image condition="contains">Mozilla Firefox\firefox.exe</Image>
			<Image condition="contains">Google\Chrome\Application\chrome.exe</Image>
			<Image condition="contains">Steam\steam.exe</Image>
			<Image condition="contains">C:\Program Files\Windows Defender\MpCmdRun.exe</Image>
			<Image condition="contains">C:\Program Files\iTunes\iTunes.exe</Image>
			<Image condition="contains">C:\Program Files (x86)\Razer\Synapse\RzSynapse.exe</Image>
		</FileCreateTime>

	<!--SYSMON EVENT ID 3 : NETWORK CONNECTION INITIATED-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image, User, Protocol, Initiated, SourceIsIpv6, SourceIp, SourceHostname, SourcePort, SourcePortName, DestinationIsIpV6, DestinationIP, DestinationHostname, DestinationPort, DestinationPortName-->
		<NetworkConnect onmatch="include">
		<!--COMMENT:	Takes a very conservative approach to network logging, limit to extremely high-signal events.-->
		<!--TECHNICAL:	For the DestinationHostname, Sysmon uses the GetNameInfo API, which may not always have the information or may be a CDN. Using that field is best-effort only.-->
		<!--TECHNICAL:	These exe's do not initiate their connections, and cannot be included: BITSADMIN-->
			<!--Suspicious sources-->
			<Image condition="begin with">C:\Users</Image> <!--Tools downloaded by users can use other processes for networking, but this is a very valuable indicator.-->
			<Image condition="begin with">C:\ProgramData</Image> <!--Normally, network communications should be sourced from "Program Files" not from ProgramData, something to look at-->
			<Image condition="begin with">C:\Windows\Temp</Image> <!--Suspicious anything would communicate from the system-level temp directory-->
			<!--Suspicious Windows tools-->
			<Image condition="image">at.exe</Image> <!--Microsoft:Windows: Remote task scheduling | Credit @ion-storm -->
			<Image condition="image">certutil.exe</Image> <!--Microsoft:Windows: Certificate tool can contact outbound | Credit @ion-storm and @FVT [ https://twitter.com/FVT/status/834433734602530817 ] -->
			<Image condition="image">cmd.exe</Image> <!--Microsoft:Windows: Command prompt-->
			<Image condition="image">cscript.exe</Image> <!--Microsoft:WindowsScriptingHost: | Credit @Cyb3rOps [ https://gist.github.com/Neo23x0/a4b4af9481e01e749409 ] -->
			<Image condition="image">java.exe</Image> <!--Java: Monitor usage of vulnerable application | Credit @ion-storm -->
			<Image condition="image">mshta.exe</Image> <!--Microsoft:Windows: HTML application executes scripts without IE protections | Credit @ion-storm [ https://en.wikipedia.org/wiki/HTML_Application ] -->
			<Image condition="image">msiexec.exe</Image> <!--Microsoft:Windows: Can install from http:// paths | Credit @vector-sec -->
			<Image condition="image">net.exe</Image> <!--Microsoft:Windows: "net use"/"net view" used by attackers to surveil and connect with file shares from command line | Credit @ion-storm -->
			<Image condition="image">net1.exe</Image>
			<Image condition="image">notepad.exe</Image> <!--Microsoft:Windows: [ https://blog.cobaltstrike.com/2013/08/08/why-is-notepad-exe-connecting-to-the-internet/ ] -->
			<Image condition="image">powershell.exe</Image> <!--Microsoft:Windows: PowerShell interface-->
			<Image condition="image">qwinsta.exe</Image> <!--Microsoft:Windows: Remotely query login sessions on a server or workstation | Credit @ion-storm -->
			<Image condition="image">reg.exe</Image> <!--Microsoft:Windows: Remote Registry | Credit @ion-storm -->
			<Image condition="image">regsvr32.exe</Image> <!--Microsoft:Windows: [ https://subt0x10.blogspot.com/2016/04/bypass-application-whitelisting-script.html ] -->
			<Image condition="image">rundll32.exe</Image> <!--Microsoft:Windows: [ https://blog.cobaltstrike.com/2016/07/22/why-is-rundll32-exe-connecting-to-the-internet/ ] -->
			<Image condition="image">sc.exe</Image> <!--Microsoft:Windows: Remotely change Windows service settings from command line | Credit @ion-storm -->
			<Image condition="image">wmic.exe</Image> <!--Microsoft:WindowsManagementInstrumentation: Credit @Cyb3rOps [ https://gist.github.com/Neo23x0/a4b4af9481e01e749409 ] -->
			<Image condition="image">wscript.exe</Image> <!--Microsoft:WindowsScriptingHost: | Credit @arekfurt -->
			<!--Relevant 3rd Party Tools: Remote Access-->
			<Image condition="image">psexec.exe</Image> <!--Sysinternals:PsExec client side | Credit @Cyb3rOps -->
			<Image condition="image">psexesvc.exe</Image> <!--Sysinternals:PsExec server side | Credit @Cyb3rOps -->
			<Image condition="image">vnc.exe</Image> <!-- VNC client | Credit @Cyb3rOps -->
			<Image condition="image">vncviewer.exe</Image> <!-- VNC client | Credit @Cyb3rOps -->
			<Image condition="image">vncservice.exe</Image> <!-- VNC server | Credit @Cyb3rOps -->
			<Image condition="image">winexesvc.exe</Image> <!-- Winexe service executable | Credit @Cyb3rOps -->
			<Image condition="image">\AA_v</Image> <!-- Ammy Admin service executable (e.g. AA_v3.0.exe AA_v3.5.exe ) | Credit @Cyb3rOps -->
			<!-- Often exploited services --> 
			<Image condition="image">omniinet.exe</Image> <!-- HP Data Protector https://www.cvedetails.com/vulnerability-list/vendor_id-10/product_id-20499/HP-Data-Protector.html | Credit @Cyb3rOps -->
			<Image condition="image">hpsmhd.exe</Image> <!-- HP System Management Homepage https://www.cvedetails.com/vulnerability-list/vendor_id-10/product_id-7244/HP-System-Management-Homepage.html | Credit @Cyb3rOps -->
			<!--Malware related-->
			<Image condition="image">tor.exe</Image> <!--Tor [ https://www.hybrid-analysis.com/sample/800bf028a23440134fc834efc5c1e02cc70f05b2e800bbc285d7c92a4b126b1c?environmentId=100 ] -->
			<!--Ports: Suspicious-->
			<DestinationPort condition="is">22</DestinationPort> <!--SSH protocol-->
			<DestinationPort condition="is">23</DestinationPort> <!--Telnet protocol-->
			<DestinationPort condition="is">25</DestinationPort> <!--SMTP mail protocol-->
			<DestinationPort condition="is">3389</DestinationPort> <!--Microsoft:Windows:RDP-->
			<DestinationPort condition="is">5800</DestinationPort> <!--VNC protocol-->
			<DestinationPort condition="is">5900</DestinationPort> <!--VNC protocol-->
			<!--Ports: Proxy-->
			<DestinationPort condition="is">1080</DestinationPort> <!--Socks proxy port | Credit @ion-storm-->
			<DestinationPort condition="is">3128</DestinationPort> <!--Socks proxy port | Credit @ion-storm-->
			<DestinationPort condition="is">8080</DestinationPort> <!--Socks proxy port | Credit @ion-storm-->
			<!--Ports: Tor-->
			<DestinationPort condition="is">1723</DestinationPort> <!--Tor protocol | Credit @ion-storm-->
			<DestinationPort condition="is">4500</DestinationPort> <!--Tor protocol | Credit @ion-storm-->
			<DestinationPort condition="is">9001</DestinationPort> <!--Tor protocol [ http://www.computerworlduk.com/tutorial/security/tor-enterprise-2016-blocking-malware-darknet-use-rogue-nodes-3633907/ ] -->
			<DestinationPort condition="is">9030</DestinationPort> <!--Tor protocol [ http://www.computerworlduk.com/tutorial/security/tor-enterprise-2016-blocking-malware-darknet-use-rogue-nodes-3633907/ ] -->
		</NetworkConnect>
		<NetworkConnect onmatch="exclude">
			<Image condition="image">OneDrive.exe</Image> <!--Microsoft:OneDrive-->
			<Image condition="image">Spotify.exe</Image> <!--Spotify-->
			<Image condition="end with">AppData\Roaming\Dropbox\bin\Dropbox.exe</Image> <!--Dropbox-->
			<!--SECTION: Microsoft-->
			<Image condition="image">OneDriveStandaloneUpdater.exe</Image> <!--Microsoft:OneDrive-->
			<DestinationHostname condition="end with">microsoft.com</DestinationHostname> <!--Microsoft:Update delivery-->
			<DestinationHostname condition="end with">microsoft.com.akadns.net</DestinationHostname> <!--Microsoft:Update delivery-->
			<DestinationHostname condition="end with">microsoft.com.nsatc.net</DestinationHostname> <!--Microsoft:Update delivery-->
      			<!--SECTION: Blackie10-->
      			<Image condition="end with">AppData\Roaming\Dropbox\bin\Dropbox.exe</Image> <!--Dropbox-->
		  	<Image condition="image">OneDriveStandaloneUpdater.exe</Image> <!--Microsoft:OneDrive-->
		  	<Image condition="contains">chrome.exe</Image>
	    		<Image condition="contains">iexplore.exe</Image>
	    		<Image condition="contains">firefox.exe</Image>
	   		<Image condition="contains">outlook.exe</Image>
	    		<Image condition="contains">Skype.exe</Image>
	    		<Image condition="contains">lync.exe</Image>
	    		<Image condition="contains">GoogleUpdate.exe</Image>
		  	<Image condition="contains">qbittorrent.exe</Image>
		  	<Image condition="contains">OfficeClickToRun.exe</Image>
		  	<Image condition="contains">Windows\SystemApps\Microsoft.Windows.Cortana</Image>	  
		  	<Image condition="contains">OneDrive.exe</Image>	  
		  	<Image condition="contains">Windows\System32\svchost.exe</Image>	
		  	<Image condition="contains">System32\backgroundTaskHost.exe</Image>
		  	<Image condition="contains">Skype\Browser\SkypeBrowserHost.exe</Image>
		  	<Image condition="contains">Free Download Manager\fdm.exe</Image>
		  	<Image condition="contains">slack\app-2.9.0\slack.exe</Image>
		  	<Image condition="contains">C:\Program Files (x86)\Origin</Image>
		  	<Image condition="contains">C:\Program Files (x86)\NVIDIA Corporation</Image>
      			<DestinationIp condition="begin with">172.</DestinationIp>
		  	<DestinationIp condition="begin with">10.</DestinationIp>
		  	<DestinationIp condition="begin with">192.</DestinationIp>
		  	<DestinationIp condition="is">0.0.0.0</DestinationIp>
		</NetworkConnect>

	<!--SYSMON EVENT ID 4 : RESERVED FOR SYSMON STATUS MESSAGES, THIS LINE IS INCLUDED FOR DOCUMENTATION PURPOSES ONLY-->
		<!--DATA: UtcTime, State, Version, SchemaVersion-->
		<!--Cannot be filtered.-->

	<!--SYSMON EVENT ID 5 : PROCESS ENDED-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image-->
		<ProcessTerminate onmatch="include">
		<!--COMMENT:	Useful data in building infection timelines.-->
			<Image condition="begin with">C:\Users</Image> <!--Process terminations by user binaries-->
		</ProcessTerminate>

	<!--SYSMON EVENT ID 6 : DRIVER LOADED INTO KERNEL-->
		<!--DATA: UtcTime, ImageLoaded, Hashes, Signed, Signature, SignatureStatus-->
		<DriverLoad onmatch="exclude">
		<!--COMMENT:	Because drivers with bugs can be used to escalate to kernel permissions, be extremely selective
				about what you exclude from monitoring. Low event volume, little incentive to exclude.-->
			<Signature condition="contains">microsoft</Signature> <!--Exclude signed Microsoft drivers-->
			<Signature condition="contains">windows</Signature> <!--Exclude signed Microsoft drivers-->
			<Signature condition="begin with">Intel </Signature> <!--Exclude signed Intel drivers-->
      			<Signature condition="is">Microsoft Windows</Signature>		
	    		<Signature condition="is">Microsoft Corporation</Signature>	
	    		<Signature condition="is">NVIDIA Corporation</Signature>	
		</DriverLoad>

	<!--SYSMON EVENT ID 7 : DLL (IMAGE) LOADED BY PROCESS-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image, ImageLoaded, Hashes, Signed, Signature, SignatureStatus-->
		<ImageLoad onmatch="include">
    			<Signed condition="is">False</Signed>
		<!--COMMENT:	Can cause high system load, disabled by default, important examples included below.-->
		</ImageLoad>
	  	<ImageLoad onmatch="exclude">
	   		<ImageLoaded condition="contains">C:\Windows\assembly\NativeImages</ImageLoaded>
	    		<ImageLoaded condition="contains">Axonic\Lookeen\LookeenFileParser.exe</ImageLoaded>
	    		<ImageLoaded condition="contains">slack\app-2.9.0</ImageLoaded>
	    		<ImageLoaded condition="contains">Program Files\WindowsApps\Microsoft</ImageLoaded>
	    		<ImageLoaded condition="contains">C:\Program Files (x86)\CorsairLink4</ImageLoaded>
	  	</ImageLoad>
    
	<!--SYSMON EVENT ID 8 : REMOTE THREAD CREATED-->
		<!--DATA: UtcTime, SourceProcessGuid, SourceProcessId, SourceImage, TargetProcessId, TargetImage, NewThreadId, StartAddress, StartModule, StartFunction-->
		<CreateRemoteThread onmatch="exclude">
		<!--COMMENT:	Monitor for processes injecting code into other processes. Often used by malware to cloak their actions.
				Exclude mostly-safe sources and log anything else.-->
			<SourceImage condition="is">C:\Windows\System32\wbem\WmiPrvSE.exe</SourceImage>
			<SourceImage condition="is">C:\Windows\System32\svchost.exe</SourceImage>
			<SourceImage condition="is">C:\Windows\System32\wininit.exe</SourceImage>
			<SourceImage condition="is">C:\Windows\System32\csrss.exe</SourceImage>
			<SourceImage condition="is">C:\Windows\System32\services.exe</SourceImage>
			<SourceImage condition="is">C:\Windows\System32\winlogon.exe</SourceImage>
			<SourceImage condition="is">C:\Windows\System32\audiodg.exe</SourceImage>
			<StartModule condition="is">C:\windows\system32\kernel32.dll</StartModule>
			<TargetImage condition="end with">Google\Chrome\Application\chrome.exe</TargetImage>
		</CreateRemoteThread>

	<!--SYSMON EVENT ID 9 : RAW DISK ACCESS-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image, Device-->
		<RawAccessRead onmatch="include">
		<!--COMMENT:	Monitor for raw sector-level access to the disk, often used to bypass access control lists or access locked files.
				Disabled by default since including even one entry here activates this component. Reward/performance/rule maintenance decision.
				Encourage you to experiment with this feature yourself.-->
		<!--COMMENT:	You will likely want to set this to a full capture on domain controllers, where no process should be doing raw reads.-->
		</RawAccessRead>
    		<!--SECTION: Blackie10-->
		<RawAccessRead onmatch="exclude">
		  <Image condition="is">System</Image>
		  <Image condition="is">C:\Windows\CCM\CcmExec.exe</Image>
		  <Image condition="is">C:\Windows\System32\svchost.exe</Image>
		  <Image condition="is">C:\Program Files\Windows Defender\MsMpEng.exe</Image>
		  <Image condition="is">C:\Windows\System32\SrTasks.exe</Image>
		  <Image condition="is">C:\Windows\System32\MRT.exe</Image>
		  <Image condition="is">C:\Windows\System32\SearchIndexer.exe</Image>
		  <Image condition="is">C:\Windows\System32\winlogon.exe</Image>
		  <Image condition="is">C:\Windows\System32\smss.exe</Image>
		  <Image condition="is">C:\Windows\System32\autochk.exe</Image>
		  <Image condition="is">C:\Windows\System32\CompatTelRunner.exe</Image>
		  <Image condition="is">C:\Windows\System32\DeviceCensus.exe</Image>
		  <Image condition="is">C:\Windows\System32\wininit.exe</Image>
		  <Image condition="is">C:\Windows\System32\VSSVC.exe</Image>
		  <Image condition="is">C:\Windows\System32\bcdedit.exe</Image>
		  <Image condition="is">C:\Windows\System32\WinSAT.exe</Image>
		  <Image condition="is">C:\Windows\SysWOW64\msiexec.exe</Image>
		  <Image condition="is">C:\Windows\explorer.exe</Image>
		  <Image condition="is">C:\Windows\System32\DiskSnapshot.exe</Image>
		  <Image condition="is">C:\Program Files\Intel\Intel(R) Rapid Storage Technology\IAStorDataMgrSvc.exe</Image>
		</RawAccessRead>

	<!--SYSMON EVENT ID 10 : INTER-PROCESS ACCESS-->
		<!--DATA: UtcTime, SourceProcessGuid, SourceProcessId, SourceThreadId, SourceImage, TargetProcessGuid, TargetProcessId, TargetImage, GrantedAccess, CallTrace-->
<!-- 		<ProcessAccess onmatch="include">
		COMMENT:	Monitor for processes accessing other process' memory. This can be valuable, but can cause a huge number of events.
		</ProcessAccess> -->
		<ProcessAccess onmatch="include">
			<TargetImage condition="is">C:\Windows\system32\lsass.exe</TargetImage>
		  <TargetImage condition="is">C:\Windows\system32\winlogon.exe</TargetImage>		
		  <TargetImage condition="is">"C:\Program Files\Google\Chrome\Application\chrome.exe"</TargetImage>	
		  <TargetImage condition="is">"C:\Program Files\Internet Explorer\iexplore.exe"</TargetImage>	
		  <TargetImage condition="is">"C:\Program Files (x86)\Mozilla Firefox\firefox.exe"</TargetImage>	
		</ProcessAccess>
		<ProcessAccess onmatch="exclude">
		  <!--COMMENT:	this will catch the dump hash operation from lsass. tested by mimikatz,wce-->
			<GrantedAccess condition="is">0x1400</GrantedAccess>
			<GrantedAccess condition="is">0x1000</GrantedAccess>
			<SourceImage condition="is">C:\Windows\System32\wbem\WmiPrvSE.exe</SourceImage>
			<!--SECTION: Blackie10-->
      			<SourceImage condition="is">c:\windows\system32\svchost.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\wbem\wmiprvse.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\System32\perfmon.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\LogonUI.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\MRT.exe</SourceImage>
      			<SourceImage condition="is">C:\Windows\System32\MsiExec.exe</SourceImage>
      			<SourceImage condition="is">C:\windows\CCM\CcmExec.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\taskmgr.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\lsass.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\services.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\wininit.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\system32\csrss.exe</SourceImage>
      			<SourceImage condition="is">C:\WINDOWS\System32\smss.exe</SourceImage>
      			<SourceImage condition="is">C:\Program Files\Windows Defender Advanced Threat Protection\MsSense.exe</SourceImage>
      			<SourceImage condition="is">C:\Windows\syswow64\MsiExec.exe</SourceImage>
      			<SourceImage condition="is">C:\Program Files (x86)\Common Files\Adobe\ARM\1.0\AdobeARMHelper.exe</SourceImage>
      			<SourceImage condition="contains">Program Files\Windows Defender\MsMpEng.exe</SourceImage>
      			<SourceImage condition="contains">VMware\VMware Workstation\vmware-authd.exe</SourceImage>
      			<SourceImage condition="contains">Program Files (x86)\Google\Update</SourceImage>
		</ProcessAccess>



	<!--SYSMON EVENT ID 11 : FILE CREATED-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image, TargetFilename, CreationUtcTime-->
		<FileCreate onmatch="include">
			<TargetFilename condition="contains">\Start Menu</TargetFilename> <!--Microsoft:Windows: Startup links and shortcut modification-->
			<TargetFilename condition="contains">\Startup</TargetFilename> <!--Microsoft:Office: Changes to user's autoloaded files under AppData-->
			<TargetFilename condition="contains">\Content.Outlook\</TargetFilename> <!--Microsoft:Outlook: attachments--> <!--PRIVACY WARNING-->
			<TargetFilename condition="contains">\Downloads\</TargetFilename> <!--Downloaded files. Does not include "Run" files in IE--> <!--PRIVACY WARNING-->
			<TargetFilename condition="end with">.application</TargetFilename> <!--Microsoft:ClickOnce: [ https://blog.netspi.com/all-you-need-is-one-a-clickonce-love-story/ ] -->
			<TargetFilename condition="end with">.appref-ms</TargetFilename> <!--Microsoft:ClickOnce application | Credit @ion-storm -->
			<TargetFilename condition="end with">.bat</TargetFilename> <!--Batch scripting-->
			<TargetFilename condition="end with">.cmd</TargetFilename> <!--Batch scripting: Batch scripts can also use the .cmd extension | Credit: @mmazanec -->
			<TargetFilename condition="end with">.cmdline</TargetFilename> <!--Microsoft:dotNet: Executed by cvtres.exe-->
			<TargetFilename condition="end with">.docm</TargetFilename> <!--Microsoft:Office:Word: Macro-->
			<TargetFilename condition="end with">.exe</TargetFilename> <!--Executable-->
			<TargetFilename condition="end with">.hta</TargetFilename> <!--Scripting-->
			<TargetFilename condition="end with">.pptm</TargetFilename> <!--Microsoft:Office:Word: Macro-->
			<TargetFilename condition="end with">.ps1</TargetFilename> <!--PowerShell [ More information: http://www.hexacorn.com/blog/2014/08/27/beyond-good-ol-run-key-part-16/ ] -->
			<TargetFilename condition="end with">.sys</TargetFilename> <!--System driver files-->
			<TargetFilename condition="end with">.vbs</TargetFilename> <!--VisualBasicScripting-->
			<TargetFilename condition="end with">.rtf</TargetFilename> <!--Rich text format-->
			<TargetFilename condition="end with">.xlsm</TargetFilename> <!--Microsoft:Office:Word: Macro-->
			<TargetFilename condition="begin with">C:\Users\Default</TargetFilename> <!--Microsoft:Windows: Changes to default user profile-->
			<TargetFilename condition="begin with">C:\Windows\System32\Drivers</TargetFilename> <!--Microsoft: Drivers dropped here-->
			<TargetFilename condition="begin with">C:\Windows\SysWOW64\Drivers</TargetFilename> <!--Microsoft: Drivers dropped here-->
			<TargetFilename condition="begin with">C:\Windows\System32\GroupPolicy\Machine\Scripts</TargetFilename> <!--Group policy [ More information: http://www.hexacorn.com/blog/2017/01/07/beyond-good-ol-run-key-part-52/ ] -->
			<TargetFilename condition="begin with">C:\Windows\System32\GroupPolicy\User\Scripts</TargetFilename> <!--Group policy [ More information: http://www.hexacorn.com/blog/2017/01/07/beyond-good-ol-run-key-part-52/ ] -->
			<TargetFilename condition="begin with">C:\Windows\System32\Tasks</TargetFilename> <!--Microsoft:ScheduledTasks-->
			<TargetFilename condition="begin with">C:\Windows\System32\Wbem</TargetFilename> <!--Microsoft:WMI: [ More information: http://2014.hackitoergosum.org/slides/day1_WMI_Shell_Andrei_Dumitrescu.pdf ] -->
			<TargetFilename condition="begin with">C:\Windows\SysWOW64\Wbem</TargetFilename> <!--Microsoft:WMI: [ More information: http://2014.hackitoergosum.org/slides/day1_WMI_Shell_Andrei_Dumitrescu.pdf ] -->
			<TargetFilename condition="begin with">C:\Windows\System32\WindowsPowerShell</TargetFilename> <!--Microsoft:Powershell: Look for modifications for persistence [ https://www.malwarearchaeology.com/cheat-sheets ] -->
			<TargetFilename condition="begin with">C:\Windows\SysWOW64\WindowsPowerShell</TargetFilename> <!--Microsoft:Powershell: Look for modifications for persistence [ https://www.malwarearchaeology.com/cheat-sheets ] -->
			<TargetFilename condition="begin with">C:\Windows\Tasks\</TargetFilename> <!--Microsoft:ScheduledTasks-->
		</FileCreate>
		<FileCreate onmatch="exclude">
			<!--SECTION: Microsoft:Office:Click2Run-->
			<Image condition="is">C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe</Image> <!-- Microsoft:Office Click2Run-->
			<!--SECTION: Microsoft:Windows-->
			<Image condition="is">C:\Windows\System32\smss.exe</Image> <!-- Microsoft:Windows: Session Manager SubSystem: Creates swapfile.sys,pagefile.sys,hiberfile.sys-->
			<Image condition="is">C:\Windows\system32\CompatTelRunner.exe</Image> <!-- Microsoft:Windows: Windows 10 app, creates tons of cache files-->
			<Image condition="is">\\?\C:\Windows\system32\wbem\WMIADAP.EXE</Image> <!-- Microsoft:Windows: WMI Performance updates-->
			<TargetFilename condition="begin with">C:\Windows\System32\DriverStore\Temp\</TargetFilename> <!-- Microsoft:Windows: Temp files by DrvInst.exe-->
			<TargetFilename condition="begin with">C:\Windows\System32\wbem\Performance\</TargetFilename> <!-- Microsoft:Windows: Created in wbem by WMIADAP.exe-->
			<TargetFilename condition="end with">WRITABLE.TST</TargetFilename> <!-- Microsoft:Windows: Created in wbem by svchost-->
			<!--SECTION: Microsoft:Windows:Updates-->
			<TargetFilename condition="begin with">C:\$WINDOWS.~BT\Sources\SafeOS\SafeOS.Mount\</TargetFilename> <!-- Microsoft:Windows: Feature updates containing lots of .exe and .sys-->
			<Image condition="begin with">C:\WINDOWS\winsxs\amd64_microsoft-windows</Image> <!-- Microsoft:Windows: Windows update-->
			<!--SECTION: Dell-->
			<Image condition="is">C:\Program Files (x86)\Dell\CommandUpdate\InvColPC.exe</Image>
			<!--SECTION: Intel-->
			<Image condition="is">C:\Windows\system32\igfxCUIService.exe</Image> <!--Intel: Drops bat and other files in \Windows in normal operation-->
		</FileCreate>

	<!--SYSMON EVENT ID 12 & 13 & 14 : REGISTRY MODIFICATION-->
		<!--NOTE:	It may appear this section is missing important entries, but many of them match multiple areas, so look carefully to see if something is already covered.-->
		<!--NOTE:	"contains" conditions below are formatted to reduce CPU load, so they may appear written inconsistently, but this is on purpose from tuning.-->
		<!--NOTE:	"contains" works by finding the first letter, then matching the second, etc, so the first letters should be as low-occurence as possible.-->
		<!--NOTE:	Windows writes hundreds or thousands of registry keys a minute, so just because you're not changing stuff, doesn't mean these rules aren't being run.-->
		<!--NOTE:	You don't have to spend a lot of time worrying about this, CPUs are fast, but it's something to consider. Every rule and condition type has a cost.-->
		<!--DATA: EventType, UtcTime, ProcessGuid, ProcessId, Image, TargetObject, Details, NewName-->
		<!--TECHNICAL:	Possible prefixes are HKLM, HKCR, and HKEY_USERS-->
		<!--CRITICAL:	Schema version 3.30 and higher use HKLM and HKEY_USERS and HKCR and CurrentControlSet instead of REGISTRY\MACHINE\ and \REGISTRY\USER\ and ControlSet001-->
		
		<RegistryEvent onmatch="include">
			<!--Autorun or Startups-->
			<!--ADDITIONAL REFERENCE: [ http://www.ghacks.net/2016/06/04/windows-automatic-startup-locations/ ] -->
			<!--ADDITIONAL REFERENCE: [ https://view.officeapps.live.com/op/view.aspx?src=https://arsenalrecon.com/downloads/resources/Registry_Keys_Related_to_Autorun.ods ] -->
			<!--ADDITIONAL REFERENCE: [ http://www.silentrunners.org/launchpoints.html ] -->
			<TargetObject condition="contains">\CurrentVersion\Run</TargetObject> <!--Microsoft:Windows: Run keys, incld RunOnce, RunOnceEx, RunServices, RunServicesOnce [Also covers terminal server] -->
			<TargetObject condition="contains">\Group Policy\Scripts</TargetObject> <!--Microsoft:Windows: Group policy scripts-->
			<TargetObject condition="contains">\Windows\System\Scripts</TargetObject> <!--Microsoft:Windows: Logon, Loggoff, Shutdown-->
			<TargetObject condition="contains">\Policies\Explorer\Run</TargetObject> <!--Microsoft:Windows | Credit @ion-storm-->
			<TargetObject condition="end with">\ServiceDll</TargetObject> <!--Microsoft:Windows: Points to a service's DLL [ https://blog.cylance.com/windows-registry-persistence-part-1-introduction-attack-phases-and-windows-services ] -->
			<TargetObject condition="end with">\ImagePath</TargetObject> <!--Microsoft:Windows: Points to a service's EXE [ https://github.com/crypsisgroup/Splunkmon/blob/master/sysmon.cfg ] -->
			<TargetObject condition="end with">\Start</TargetObject> <!--Microsoft:Windows: Services start mode changes (Disabled, Automatically, Manual)-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\</TargetObject> <!--Microsoft:Windows: Autorun location [ https://www.cylance.com/windows-registry-persistence-part-2-the-run-keys-and-search-order ] -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit\</TargetObject> <!--Microsoft:Windows: Autorun location [ https://www.cylance.com/windows-registry-persistence-part-2-the-run-keys-and-search-order ] -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows NT\CurrentVersion\Drivers32</TargetObject> <!--Microsoft:Windows: Legacy driver loading | Credit @ion-storm -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\BootExecute</TargetObject> <!--Microsoft:Windows: Autorun | Credit @ion-storm | [ https://www.cylance.com/windows-registry-persistence-part-2-the-run-keys-and-search-order ] -->
			<!-- AppInit DLLs -->
		  	<TargetObject condition="contains">Software\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs</TargetObject>
      			<!-- Known DLLs -->
		  	<TargetObject condition="contains">SYSTEM\CurrentControlSet\Control\Session Manager\KnownDLLs</TargetObject>
      			<!--CLSID launch commands and file association changes-->
			<TargetObject condition="contains">\Explorer\FileExts\</TargetObject> <!--Microsoft:Windows: Changes to file extension mapping-->
			<TargetObject condition="contains">\shell\install\command\</TargetObject> <!--Microsoft:Windows: Sensitive subkey under file associations and CLSID that map to launch command-->
			<TargetObject condition="contains">\shell\open\command\</TargetObject> <!--Microsoft:Windows: Sensitive subkey under file associations and CLSID that map to launch command-->
			<TargetObject condition="contains">\shell\open\ddeexec\</TargetObject> <!--Microsoft:Windows: Sensitive subkey under file associations and CLSID that map to launch command-->
			<!--Windows COM-->
			<TargetObject condition="end with">\InprocServer32\(Default)</TargetObject> <!--Microsoft:Windows:COM Object Hijacking [ https://blog.gdatasoftware.com/2014/10/23941-com-object-hijacking-the-discreet-way-of-persistence ] | Credit @ion-storm -->
			<!--Windows shell hijack-->
			<TargetObject condition="contains">\Classes\*\</TargetObject> <!--Microsoft:Windows:Explorer: [ http://www.silentrunners.org/launchpoints.html ] -->
			<TargetObject condition="contains">\Classes\AllFilesystemObjects\</TargetObject> <!--Microsoft:Windows:Explorer: [ http://www.silentrunners.org/launchpoints.html ] -->
			<TargetObject condition="contains">\Classes\Directory\</TargetObject> <!--Microsoft:Windows:Explorer: [ https://stackoverflow.com/questions/1323663/windows-shell-context-menu-option ] -->
			<TargetObject condition="contains">\Classes\Drive\</TargetObject> <!--Microsoft:Windows:Explorer: [ https://stackoverflow.com/questions/1323663/windows-shell-context-menu-option ] -->
			<TargetObject condition="contains">\Classes\Folder\</TargetObject> <!--Microsoft:Windows:Explorer: ContextMenuHandlers, DragDropHandlers, CopyHookHandlers, [ https://stackoverflow.com/questions/1323663/windows-shell-context-menu-option ] -->
			<TargetObject condition="contains">\ContextMenuHandlers\</TargetObject> <!--Microsoft:Windows: [ http://oalabs.openanalysis.net/2015/06/04/malware-persistence-hkey_current_user-shell-extension-handlers/ ] -->
			<TargetObject condition="contains">\CurrentVersion\Shell</TargetObject> <!--Microsoft:Windows: Shell Folders, ShellExecuteHooks, ShellIconOverloadIdentifers, ShellServiceObjects, ShellServiceObjectDelayLoad [ http://oalabs.openanalysis.net/2015/06/04/malware-persistence-hkey_current_user-shell-extension-handlers/ ] -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\Software\Microsoft\Windows\CurrentVersion\explorer\ShellExecuteHooks</TargetObject> <!--Microsoft:Windows: ShellExecuteHooks-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\Software\Microsoft\Windows\CurrentVersion\explorer\ShellServiceObjectDelayLoad</TargetObject> <!--Microsoft:Windows: ShellExecuteHooks-->
			<!--AppPaths hijacking-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\</TargetObject> <!--Microsoft:Windows: Credit to @Hexacorn [ http://www.hexacorn.com/blog/2013/01/19/beyond-good-ol-run-key-part-3/ ] -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\AppCertDlls\</TargetObject> <!--Microsoft:Windows: Credit to @Hexacorn [ http://www.hexacorn.com/blog/2013/01/19/beyond-good-ol-run-key-part-3/ ] -->
			<!--Terminal service boobytraps-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\InitialProgram</TargetObject>
			<!--Group Policy interity-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\GPExtensions\</TargetObject> <!--Microsoft:Windows: Group Policy internally uses a plugin architecture that nothing should be modifying-->
			<!--Winsock and Winsock2-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Services\WinSock\</TargetObject> <!--Microsoft:Windows: Wildcard, includes Winsock and Winsock2-->
			<TargetObject condition="end with">\ProxyServer</TargetObject> <!--Microsoft:Windows: System and user proxy server-->
			<!--Credential providers-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Provider</TargetObject> <!--Wildcard, includes Credental Providers and Credential Provider Filters-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SecurityProviders</TargetObject> <!--Microsoft:Windows: Changes to WDigest-UseLogonCredential for password scraping [ https://www.trustedsec.com/april-2015/dumping-wdigest-creds-with-meterpreter-mimikatzkiwi-in-windows-8-1/ ] -->
			<!--Networking-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\NetworkProvider\Order\</TargetObject> <!--Microsoft:Windows: Order of network providers that are checked to connect to destination [ https://www.malwarearchaeology.com/cheat-sheets ] -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles</TargetObject> <!--Microsoft:Windows: | Credit @ion-storm -->
			<!--DLLs that get injected into every process launch-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\Appinit_Dlls\</TargetObject> <!--Microsoft:Windows: [ https://msdn.microsoft.com/en-us/library/windows/desktop/dd744762(v=vs.85).aspx ] -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\Appinit_Dlls\</TargetObject> <!--Microsoft:Windows: [ https://msdn.microsoft.com/en-us/library/windows/desktop/dn280412(v=vs.85).aspx ] -->
			<!--Office-->
			<TargetObject condition="contains">\Microsoft\Office\Outlook\Addins\</TargetObject> <!--Microsoft:Office: Outlook add-ins-->
			<!--IE-->
			<TargetObject condition="contains">\Internet Explorer\Toolbar\</TargetObject> <!--Microsoft:InternetExplorer: Machine and user-->
			<TargetObject condition="contains">\Internet Explorer\Extensions\</TargetObject> <!--Microsoft:InternetExplorer: Machine and user-->
			<TargetObject condition="contains">\Browser Helper Objects\</TargetObject> <!--Microsoft:InternetExplorer: Machine and user [ https://msdn.microsoft.com/en-us/library/bb250436(v=vs.85).aspx ] -->
			<!--Magic registry keys-->
			<TargetObject condition="contains">{AB8902B4-09CA-4bb6-B78D-A8F59079A8D5}\</TargetObject> <!--Microsoft:Windows: Thumbnail cache autostart [ http://blog.trendmicro.com/trendlabs-security-intelligence/poweliks-levels-up-with-new-autostart-mechanism/ ] -->
			<!--Infection artifacts-->
			<TargetObject condition="end with">\UrlUpdateInfo</TargetObject> <!--Microsoft:ClickOnce: [ https://subt0x10.blogspot.com/2016/12/mimikatz-delivery-via-clickonce-with.html ] -->
			<TargetObject condition="end with">\InstallSource</TargetObject> <!--Microsoft:Windows: Source folder for certain program and componenent installations-->
			<!--Windows UAC tampering-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA</TargetObject> <!--Detect: UAC Tampering | Credit @ion-storm -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LocalAccountTokenFilterPolicy</TargetObject> <!--Detect: UAC Tampering | Credit @ion-storm -->
			<!--Microsoft Firewall modifications-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List</TargetObject> <!--Windows Firewall authorized applications | Credit @ion-storm -->
			<!--Microsoft Security Center tampering | Credit @ion-storm -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\AllAlertsDisabled</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\AntiVirusDisableNotify</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\DisableMonitoring</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\FirewallDisableNotify</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\FirewallOverride</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\UacDisableNotify</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Security Center\UpdatesDisableNotify</TargetObject>
			<!--Windows Defender tampering | Credit @ion-storm -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiSpyware</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiVirus</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableBehaviorMonitoring</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableOnAccessProtection</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableScanOnRealtimeEnable</TargetObject>
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet\SpyNetReporting</TargetObject>
			<!--Windows internals integrity monitoring-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\</TargetObject> <!--Microsoft:Windows: Malware likes changing IFEO-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\</TargetObject> <!--Microsoft:Windows:UAC: Detect malware changes to UAC prompt level-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\</TargetObject> <!--Microsoft:Windows: Event log system integrity and ACLs-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\</TargetObject> <!--Microsoft:Defender: Detect changes to Defender administrative settings to monitor for disablement-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Safeboot\</TargetObject> <!--Microsoft:Windows: Services approved to load in safe mode-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Winlogon\</TargetObject> <!--Microsoft:Windows: Providers notified by WinLogon-->
			<TargetObject condition="end with">\FriendlyName</TargetObject> <!--Microsoft:Windows: New devices connected and remembered-->
			<TargetObject condition="is">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\InProgress\(Default)</TargetObject> <!--Microsoft:Windows: See when WindowsInstaller is engaged-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_</TargetObject> <!-- Often used by malware -->
			<!-- Testing - Unknown log volume but relevant registry keys -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Services\</TargetObject> <!--Windows Services -->
			<!--Persistence Methods-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Custom</TargetObject> <!-- Custom SHIM:FireEye FIN7 report - https://www.fireeye.com/blog/threat-research/2017/05/fin7-shim-databases-persistence.html -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\InstalledSDB</TargetObject> <!-- Custom SHIM:FireEye FIN7 report - https://www.fireeye.com/blog/threat-research/2017/05/fin7-shim-databases-persistence.html -->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\services\DNS\Parameters\</TargetObject> <!--Microsoft:Windows:DNS: ServerLevelPluginDll Issue https://medium.com/@esnesenon/feature-not-bug-dnsadmin-to-dc-compromise-in-one-line-a0f779b8dc83 -->
		  	<!-- Active Setup/StubPath  -->
		 	<TargetObject condition="contains">Microsoft\Active Setup\Installed Components</TargetObject>
      			<!-- Old Scheduled Tasks XP, NT, 2K  -->
		  	<TargetObject condition="contains">Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler</TargetObject> 
		  	<!-- Scheduled Tasks Win 10 -->
		  	<TargetObject condition="contains">Microsoft\Windows\Windows NT\CurrentVersion\Schedule\Taskcache</TargetObject> 
    		</RegistryEvent>
		<RegistryEvent onmatch="exclude">
		<!--COMMENT:	Remove low-information noise-->
			<!--SECTION: Microsoft binaries-->
			<Image condition="end with">Office\root\integration\integrator.exe</Image> <!--Microsoft:Office: C2R client-->
			<Image condition="image">C:\WINDOWS\system32\backgroundTaskHost.exe</Image> <!--Microsoft:Windows: Changes association registry keys-->
			<Image condition="is">C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe</Image> <!--Microsoft:Office: C2R client-->
			<Image condition="is">C:\Program Files\Windows Defender\MsMpEng.exe</Image> <!--Microsoft:Windows:Defender-->
			<Image condition="is">C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe</Image> <!--Microsoft:Cortana-->
			<!--Misc-->
			<TargetObject condition="end with">Toolbar\WebBrowser</TargetObject> <!--Microsoft:IE: Extraneous activity-->
			<TargetObject condition="end with">Toolbar\WebBrowser\ITBar7Height</TargetObject> <!--Microsoft:IE: Extraneous activity-->
			<TargetObject condition="end with">Toolbar\ShellBrowser\ITBar7Layout</TargetObject> <!--Microsoft:Windows:Explorer: Extraneous activity-->
			<TargetObject condition="end with">Internet Explorer\Toolbar\Locked</TargetObject> <!--Microsoft:Windows:Explorer: Extraneous activity-->
			<TargetObject condition="end with">ShellBrowser</TargetObject> <!--Microsoft:InternetExplorer: Noise-->
			<TargetObject condition="end with">\CurrentVersion\Run</TargetObject> <!--Microsoft:Windows: Remove noise from the "\Windows\CurrentVersion\Run" wildcard-->
			<TargetObject condition="end with">\CurrentVersion\RunOnce</TargetObject> <!--Microsoft:Windows: Remove noise from the "\Windows\CurrentVersion\Run" wildcard-->
			<TargetObject condition="end with">\CurrentVersion\App Paths</TargetObject> <!--Microsoft:Windows: Remove noise from the "\Windows\CurrentVersion\App Paths" wildcard-->
			<TargetObject condition="end with">\CurrentVersion\Image File Execution Options</TargetObject> <!--Microsoft:Windows: Remove noise from the "\Windows\CurrentVersion\Image File Execution Options" wildcard-->
			<TargetObject condition="end with">\CurrentVersion\Shell Extensions\Cached</TargetObject> <!--Microsoft:Windows: Remove noise from the "\CurrentVersion\Shell Extensions\Cached" wildcard-->
			<TargetObject condition="end with">\CurrentVersion\Shell Extensions\Approved</TargetObject> <!--Microsoft:Windows: Remove noise from the "\CurrentVersion\Shell Extensions\Approved" wildcard-->
			<TargetObject condition="end with">}\PreviousPolicyAreas</TargetObject> <!--Microsoft:Windows: Remove noise from \Winlogon\GPExtensions by svchost.exe-->
			<TargetObject condition="contains">\Control\WMI\Autologger\</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Services\UsoSvc\Start</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<TargetObject condition="end with">\Lsa\OfflineJoin\CurrentValue</TargetObject> <!--Microsoft:Windows: Sensitive value during domain join-->
			<TargetObject condition="end with">\Components\TrustedInstaller\Events</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Winlogon-->
			<TargetObject condition="end with">\Components\TrustedInstaller</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Winlogon-->
			<TargetObject condition="end with">\Components\Wlansvc</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Winlogon-->
			<TargetObject condition="end with">\Components\Wlansvc\Events</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Winlogon-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\</TargetObject> <!--Microsoft:Windows: Remove noise monitoring installations run as system-->
			<TargetObject condition="end with">\Directory\shellex</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Classes-->
			<TargetObject condition="end with">\Directory\shellex\DragDropHandlers</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Classes-->
			<TargetObject condition="end with">\Drive\shellex</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Classes-->
			<TargetObject condition="end with">\Drive\shellex\DragDropHandlers</TargetObject> <!--Microsoft:Windows: Remove noise monitoring Classes-->
			<TargetObject condition="contains">_Classes\AppX</TargetObject> <!--Microsoft:Windows: Remove noise monitoring "Shell\open\command"--> <!--Win8+-->
			<TargetObject condition="begin with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Publishers\</TargetObject> <!--Microsoft:Windows: SvcHost Noise-->
			<Image condition="is">C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe</Image> <!--Microsoft:Windows: Remove noise from Windows 10 Cortana | Credit @ion-storm--> <!--Win10-->
			<!--Bootup Control noise-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\Audit</TargetObject> <!--Microsoft:Windows:lsass.exe: Boot noise--> <!--Win8+-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\Audit\AuditPolicy</TargetObject> <!--Microsoft:Windows:lsass.exe: Boot noise--> <!--Win8+-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\Audit\PerUserAuditing\System</TargetObject> <!--Microsoft:Windows:lsass.exe: Boot noise--> <!--Win8+-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\SspiCache</TargetObject> <!--Microsoft:Windows:lsass.exe: Boot noise--> <!--Win8+-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Domains</TargetObject> <!--Microsoft:Windows:lsass.exe: Boot noise--> <!--Win8+-->
			<TargetObject condition="end with">\REGISTRY\MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit</TargetObject> <!--Microsoft:Windows:lsass.exe: Boot noise--> <!--Win8+-->
			<!--Sevices autostart noise-->
			<TargetObject condition="end with">\services\clr_optimization_v2.0.50727_32\Start</TargetObject> <!--Microsoft:dotNet: Windows 7-->
			<TargetObject condition="end with">\services\clr_optimization_v2.0.50727_64\Start</TargetObject> <!--Microsoft:dotNet: Windows 7-->
			<TargetObject condition="end with">\services\clr_optimization_v4.0.30319_32\Start</TargetObject> <!--Microsoft:dotNet: Windows 10-->
			<TargetObject condition="end with">\services\clr_optimization_v4.0.30319_64\Start</TargetObject> <!--Microsoft:dotNet: Windows 10-->
			<TargetObject condition="end with">\services\DeviceAssociationService\Start</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<TargetObject condition="end with">\services\BITS\Start</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<TargetObject condition="end with">\services\TrustedInstaller\Start</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<TargetObject condition="end with">\services\tunnel\Start</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<TargetObject condition="end with">\services\UsoSvc\Start</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "\Start"-->
			<!--FileExts noise filtering-->
			<TargetObject condition="contains">\OpenWithProgids</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "FileExts"-->
			<TargetObject condition="end with">\OpenWithList</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "FileExts"-->
			<TargetObject condition="end with">\UserChoice</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "FileExts"-->
			<TargetObject condition="end with">\UserChoice\ProgId</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "FileExts"--> <!--Win8+-->
			<TargetObject condition="end with">\UserChoice\Hash</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "FileExts"--> <!--Win8+-->
			<TargetObject condition="end with">\OpenWithList\MRUList</TargetObject> <!--Microsoft:Windows: Remove noise from monitoring "FileExts"-->
			<TargetObject condition="end with">} 0xFFFF</TargetObject> <!--Microsoft:Windows: Remove noise from explorer.exe from monitoring ShellCached binary keys--> <!--Win8+-->
			<!--SECTION: 3rd party-->
			<Image condition="is">C:\Program Files\WIDCOMM\Bluetooth Software\btwdins.exe</Image> <!--Constantly writes to HKLM-->
			<Image condition="is">C:\Program Files (x86)\Webroot\WRSA.exe</Image> <!--Webroot-->
			<!-- Services Noise -->
			<TargetObject condition="contains">\CurrentVersion\NetworkList\Profiles\</TargetObject>
		</RegistryEvent>

	<!--SYSMON EVENT ID 15 : ALTERNATE DATA STREAM CREATED-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, Image, TargetFilename, CreationUtcTime, Hash-->
		<FileCreateStreamHash onmatch="include">
		<!--COMMENT:	Any files created with an NTFS Alternate Data Stream which match these rules will be hashed and logged.
				[ https://blogs.technet.microsoft.com/askcore/2013/03/24/alternate-data-streams-in-ntfs/ ]
				ADS's are used by browsers and email clients to mark files as originating from the Internet or other foreign sources.
				[ https://textslashplain.com/2016/04/04/downloads-and-the-mark-of-the-web/ ] -->
			<TargetFilename condition="contains">Content.Outlook</TargetFilename> <!--Microsoft:Outlook: Attachments--> <!--PRIVACY WARNING-->
			<TargetFilename condition="contains">Downloads</TargetFilename> <!--Downloaded files. Does not include "Run" files in IE-->
			<TargetFilename condition="contains">Temp\7z</TargetFilename> <!--7zip extractions-->
			<TargetFilename condition="end with">.bat</TargetFilename> <!--Batch scripting-->
			<TargetFilename condition="end with">.cmd</TargetFilename> <!--Batch scripting | Credit @ion-storm -->
			<TargetFilename condition="end with">.hta</TargetFilename> <!--Scripting-->
			<TargetFilename condition="end with">.lnk</TargetFilename> <!--Shortcut file | Credit @ion-storm -->
			<TargetFilename condition="end with">.ps1</TargetFilename> <!--Powershell-->
			<TargetFilename condition="end with">.ps2</TargetFilename> <!--Powershell-->
			<TargetFilename condition="end with">.reg</TargetFilename> <!--Registry File-->
			<TargetFilename condition="end with">.vb</TargetFilename> <!--VisualBasicScripting files-->
			<TargetFilename condition="end with">.vbe</TargetFilename> <!--VisualBasicScripting files-->
			<TargetFilename condition="end with">.vbs</TargetFilename> <!--VisualBasicScripting files-->
			<TargetFilename condition="end with">.sct</TargetFilename> <!--Script used to create a Component Object Model (.COM) component-->
			<TargetFilename condition="end with">.rtf</TargetFilename> <!--Rich text files-->
		</FileCreateStreamHash>

	<!--SYSMON EVENT ID 16 : SYSMON CONFIGURATION CHANGE, THIS LINE IS INCLUDED FOR DOCUMENTATION PURPOSES ONLY-->
		<!--DATA: UtcTime, Configuration, ConfigurationFileHash-->
		<!--Cannot be filtered.-->

	<!--SYSMON EVENT ID 17 & 18 : PIPE CREATED / PIPE CONNECTED-->
		<!--DATA: UtcTime, ProcessGuid, ProcessId, PipeName, Image-->
		<PipeEvent onmatch="include">
			<!--ADDITIONAL REFERENCE: [ https://www.cobaltstrike.com/help-smb-beacon ] -->
			<!--ADDITIONAL REFERENCE: [ https://blog.cobaltstrike.com/2015/10/07/named-pipe-pivoting/ ] -->
		</PipeEvent>

	</EventFiltering>
</Sysmon>
