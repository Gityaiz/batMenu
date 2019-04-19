@echo off

rem iniファイルの設定
set MENU=99_MENU.ini
rem 前回実行したコマンドの結果コード
set RET=-1
rem 前回実行したコマンドの記憶領域
set LAST_FUNC=NULL
rem メニューに番号を降るためのインデックス
set num=0
rem flag　0：前回入力に対してバッチ実行できた　1：前回入力に対してバッチ実行できなかった
set flag=0

rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    メイン処理
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rem このバッチが存在するフォルダをカレントディレクトリに
pushd %0\..

rem 管理者権限を取得していなかったら取得する
openfiles > nul
if errorlevel 1 (
    PowerShell.exe -Command Start-Process \"%~f0\" -Verb runas
    exit
)

:main_proc
cls
echo *******************************************************************************
echo **                                                                           **
echo **                   実行したいメニューを数字で指定してENTER                 **
echo **                                                                           **
echo *******************************************************************************
	IF %flag% EQU 1 (
		echo 前回実行結果：該当するメニューが存在しませんでした
		GOTO no_result
	) 

	IF %RET% EQU -1 (
		echo;
	) ELSE IF %RET% EQU 0 (
      echo 前回実行結果：%LAST_FUNC% ＜＜成功＞＞
	) ELSE IF %RET% EQU 999 (
      echo 前回実行結果：該当するメニューが存在しませんでした。
	) ELSE (
      echo 前回実行結果：%LAST_FUNC% ＜＜失敗＞＞　エラーコード：%RET%
	) 
	
:no_result
set flag=1

call :disp_menu 
echo;
echo 終了したい場合は右上の[×]で終了
set /p userkey=">>"
	
rem ２桁以上のメニュー項目に対応	
rem IF not '%userkey%'=='' set userkey=%userkey:~0,1%

call :exec_menu %userkey%

	
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		メニュー表示メイン
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:disp_menu
FOR /f "eol=; tokens=1*  delims=," %%1 in (%MENU%) do call :disp_sub %%1 
set num=0
exit /B 0
		
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		メニュー表示サブ
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:disp_sub
set /a num=num+1
echo %num%.%1
exit /B 0
	
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		メニュー実行処理
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:exec_menu
FOR /f "eol=; tokens=1*  delims=," %%2 in (%MENU%) do call :exec_sub %%1 %%2 %%3
set num=0

	GOTO main_proc 
	
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		メニュー実行処理サブ
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:exec_sub
set /a num=num+1
	IF %1 EQU %num% (
    	set LAST_FUNC=%3 
    	call %3
    	rem 遅延環境変数展開のためGOTOで対応
    	GOTO after
    ) 
    exit /B 0
:after  
    set /a RET=%ERRORLEVEL%
    set /a flag=0
	exit /B 0