REM ���������ػ��桿

REM Param1��������ش���
@SET DVD_ISO_DRIVE=G:
REM Param2�������ַ��VMnet1.IP��
@SET SERVER_DOMAIN=192.168.202.1
REM Param3���ļ�Ŀ¼
@SET HTTP_CENTOS_URL=/files/centos7

@ECHO OFF
CD /D %~dp0
IF NOT EXIST "%DVD_ISO_DRIVE%" (
    ECHO û�й��ؾ����ļ���
    PAUSE>NUL
    EXIT
)

REM ���������ļ�
IF NOT EXIST .\test ECHO OK>.\test

REM ӳ��Packages
IF NOT EXIST .\Packages (
    MKLINK /J Packages "%DVD_ISO_DRIVE%\Packages"
) ELSE (
    RMDIR .\Packages 2>NUL && MKLINK /J Packages "%DVD_ISO_DRIVE%\Packages"
)

REM ����RPM-GPG-KEY-CentOS
XCOPY /Y "%DVD_ISO_DRIVE%\RPM-GPG-KEY-CentOS*" .\

REM ����repodata
IF NOT EXIST .\repodata (
    MKDIR .\repodata
    XCOPY "%DVD_ISO_DRIVE%\repodata" .\repodata
    REM ����repodata
    PUSHD .\repodata
    ECHO Sub print^(item^):Wscript.Echo item:End Sub:Set XML = CreateObject^("Microsoft.XMLDOM"^):Set FSO = CreateObject^("Scripting.FileSystemObject"^):XML.load^("repomd.xml"^):Set objNodes = XML.SelectNodes^("/repomd/data"^):For Each objNode in objNodes:    h = objNode.SelectSingleNode^("./checksum"^).text:    h = Trim^(h^):    f = objNode.SelectSingleNode^("./location"^).GetAttributeNode^("href"^).nodevalue:    f = Trim^(Split^(f, "repodata/"^)^(1^)^):    If FSO.FileExists^(h^) Then:        print h:        FSO.MoveFile h, f:    End If:Next>.\_.vbs
    cscript .\_.vbs
    POPD
)

REM �����ֿ��ļ�������wegt��ȡ��
SET repo_url=http://%SERVER_DOMAIN%%HTTP_CENTOS_URL%
set repo_gpgkey=RPM-GPG-KEY-CentOS-7
IF NOT EXIST .\repofiles (
    MKDIR .\repofiles
    PUSHD .\repofiles
    ECHO [LocalDVDISO]>.\local.repo
    ECHO name=Local DVD-ISO Packages>>.\local.repo
    ECHO baseurl=%repo_url%>>.\local.repo
    ECHO enabled=1 >>.\local.repo
    ECHO gpgcheck=1 >>.\local.repo
    ECHO gpgkey=%repo_url%/%repo_gpgkey%>>.\local.repo
)
ECHO Everything is OK.
PAUSE
