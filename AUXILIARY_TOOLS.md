## 辅助工具

- [VMware Workstation Pro 15](https://my.vmware.com/en/web/vmware/info/slug/desktop_end_user_computing/vmware_workstation_pro/15_0)
- [FileZilla Client](https://filezilla-project.org/download.php?type=client)
- [Putty](https://putty.org/)
- [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html)

#### *start.cmd*

```batch
REM Step1: 删除目录“%UserProfile%\Documents\MobaXterm”
REM Step2: 在“MobaXterm.exe”所在目录下建立“start.cmd”
REM Step3: 双击运行“start.cmd”
@ECHO OFF
CD /D %~dp0
SET LocMobaXterm=.\tmp
SET DocMobaXterm="%UserProfile%\Documents\MobaXterm"
SET BinMobaXterm=MobaXterm.exe
IF EXIST %DocMobaXterm% (
    START "" %BinMobaXterm%
) ELSE (
    REM 关联配置
    IF NOT EXIST %LocMobaXterm% MKDIR %LocMobaXterm%
    MKLINK /J %DocMobaXterm% %LocMobaXterm%
    REM 桌面图标
    CALL :SHOUTCUT MobaXterm "%CD%\start.cmd" "%CD%\MobaXterm.exe"
)
GOTO :EOF
:SHOUTCUT
@SET VBSCript="%Temp%\###$%RANDOM%_SHOUTCUT_%RANDOM%$.vbs"
@ECHO Set argv=WScript.Arguments>%VBSCript%
@ECHO Set s=WScript.CreateObject^("WScript.Shell"^)>>%VBSCript%
@ECHO Set l=s.CreateShortcut^(s.SpecialFolders^("Desktop"^) ^& "\" ^& argv^(0^) ^& ".lnk"^)>>%VBSCript%
@ECHO l.TargetPath = argv^(1^):l.IconLocation = argv^(2^)>>%VBSCript%
@ECHO l.Save:Set l = Nothing:Set s = Nothing:WScript.Quit>>%VBSCript%
@cscript //nologo %VBSCript% "%~1" "%~2" "%~3"
DEL /F /Q %VBSCript%
GOTO :EOF
```
