@echo off

rem ini�t�@�C���̐ݒ�
set MENU=99_MENU.ini
rem �O����s�����R�}���h�̌��ʃR�[�h
set RET=-1
rem �O����s�����R�}���h�̋L���̈�
set LAST_FUNC=NULL
rem ���j���[�ɔԍ����~�邽�߂̃C���f�b�N�X
set num=0
rem flag�@0�F�O����͂ɑ΂��ăo�b�`���s�ł����@1�F�O����͂ɑ΂��ăo�b�`���s�ł��Ȃ�����
set flag=0

rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    ���C������
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

rem ���̃o�b�`�����݂���t�H���_���J�����g�f�B���N�g����
pushd %0\..

rem �Ǘ��Ҍ������擾���Ă��Ȃ�������擾����
openfiles > nul
if errorlevel 1 (
    PowerShell.exe -Command Start-Process \"%~f0\" -Verb runas
    exit
)

:main_proc
cls
echo *******************************************************************************
echo **                                                                           **
echo **                   ���s���������j���[�𐔎��Ŏw�肵��ENTER                 **
echo **                                                                           **
echo *******************************************************************************
	IF %flag% EQU 1 (
		echo �O����s���ʁF�Y�����郁�j���[�����݂��܂���ł���
		GOTO no_result
	) 

	IF %RET% EQU -1 (
		echo;
	) ELSE IF %RET% EQU 0 (
      echo �O����s���ʁF%LAST_FUNC% ������������
	) ELSE IF %RET% EQU 999 (
      echo �O����s���ʁF�Y�����郁�j���[�����݂��܂���ł����B
	) ELSE (
      echo �O����s���ʁF%LAST_FUNC% �������s�����@�G���[�R�[�h�F%RET%
	) 
	
:no_result
set flag=1

call :disp_menu 
echo;
echo �I���������ꍇ�͉E���[�~]�ŏI��
set /p userkey=">>"
	
rem �Q���ȏ�̃��j���[���ڂɑΉ�	
rem IF not '%userkey%'=='' set userkey=%userkey:~0,1%

call :exec_menu %userkey%

	
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		���j���[�\�����C��
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:disp_menu
FOR /f "eol=; tokens=1*  delims=," %%1 in (%MENU%) do call :disp_sub %%1 
set num=0
exit /B 0
		
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		���j���[�\���T�u
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:disp_sub
set /a num=num+1
echo %num%.%1
exit /B 0
	
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		���j���[���s����
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:exec_menu
FOR /f "eol=; tokens=1*  delims=," %%2 in (%MENU%) do call :exec_sub %%1 %%2 %%3
set num=0

	GOTO main_proc 
	
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rem    		���j���[���s�����T�u
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:exec_sub
set /a num=num+1
	IF %1 EQU %num% (
    	set LAST_FUNC=%3 
    	call %3
    	rem �x�����ϐ��W�J�̂���GOTO�őΉ�
    	GOTO after
    ) 
    exit /B 0
:after  
    set /a RET=%ERRORLEVEL%
    set /a flag=0
	exit /B 0