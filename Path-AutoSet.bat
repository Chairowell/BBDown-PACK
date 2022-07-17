@echo off
color 06

::设置目标
set object=ffmpeg.exe
::备份环境变量
echo %path% >.\Path-backup.txt
echo =================== %object% 环境变量自动安装脚本 ===================
echo 在目标文件夹下生成了环境变量文件Path-backup.txt，当环境变量配置出错请手动恢复
echo ===============================================================
echo ！！！该脚本需要重新启动explorer.exe 请不要在生产时使用，以避免不必要的损失 ！！！
echo ！！！请做好备份再使用，本脚本仅提供学习，系统损坏概不负责 ！！！
echo 脚本运行完若环境变量不生效请手动到环境变量里确认更新或重启，有能力者可以更改脚本60-65行代码

::获取目标文件夹位置和当前环境变量
set myPath=%path%
set curPath=%cd%
set digPath=%curPath%



::判断当前目录是否在环境变量中
echo %path% | find /i "%digPath%">nul && goto A || goto B

:A
echo ===============================================================
echo 当前%digPath%路径已载入环境变量，无需新增，【回车】以检测
pause
echo ===============================================================
%object%
pause
exit


:B
echo ===============================================================
echo 当前环境变量无 %digPath% 可以进行添加，回车以继续
pause
::检测ffmpeg.exe是否在这个文件夹内
if exist ".\%object%" (goto C) else (goto D)

:C
echo ===============================================================
echo %object% 目标存在于 %cd%
echo 你确定将%object% 加入环境变量吗，输入【y】 (小写) 同意，【回车】以退出：
set /p a=
echo ===============================================================
if %a% equ y (goto E) else (exit)

:D
echo ===============================================================
echo %object% 不在此文件夹中，请将脚本放入目标文件夹！！！
pause
exit

:E
::setx -->用户变量 setx /m --->系统变量 wmic where --->原变量上更改 wmic create --->创建新变量 %computername%\%username% --->用户变量 <system> --->系统变量 
::指令均无法直接生效，需重启或是手动开环境变量然后更新，BUG，默认使用第二条，直接成功率比较高
::如果使用setx命令，请注释78，79行代码，如果使用wmic命令请把78，79行注释去除
::setx "Path" "%myPath%;%digPath%"
setx "Path" "%myPath%;%digPath%" /m
::wmic ENVIRONMENT where "name='Path' and username='%computername%\\%username%'" set VariableValue="%myPath%;%digPath%"
::wmic ENVIRONMENT create name="Path",username="%computername%\%username%",VariableValue="%myPath%;%digPath%"
::wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%myPath%;%digPath%"
::wmic ENVIRONMENT create name="Path",username="<system>",VariableValue="%myPath%;%digPath%"

::重启explorer.exe
echo ===============================================================
echo 开始重新启动 explorer.exe 以刷新环境变量，如果你现在有生产活动请【回车】，以避免不必要的损失，输入【y】 (小写) 以继续：
set /p b=
echo ===============================================================
if %b% equ y (goto F) else (exit)

:F
echo 重新启动后，请单击脚本窗口以继续。
pause

::taskkill /im explorer.exe /f
::start explorer.exe
%object%
start "检测环境变量是否生效" cmd /k "Path-AutoSet.bat"
