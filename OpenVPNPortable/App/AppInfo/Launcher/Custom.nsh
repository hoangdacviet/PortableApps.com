${SegmentFile}

!include "x64.nsh"
!include "UAC.nsh"

!define APPDIR		"$EXEDIR\App\OpenVPN"
!define DRIVERDIR	"${APPDIR}\driver"
!define DRIVERINF	"OemWin2k.inf"
!define DRIVEREXE	"devcon.exe"
!define DRIVERNAME	"tap0901"

Var Architecture ; 32 or 64 bit

${SegmentPreExecPrimary}
	; Check UAC
	${IfNot} ${UAC_IsAdmin}
		MessageBox MB_OK "OpenVPNPortable needs to be run as administrator."
		Abort
	${EndIf}

	; Get Windows architecture
	${If} ${RunningX64}
		StrCpy $Architecture "amd64"
	${Else}
		StrCpy $Architecture "i386"
	${EndIf}

	; Install TAP driver
	ExecDos::exec `"${DRIVERDIR}\$Architecture\${DRIVEREXE}" install "${DRIVERDIR}\$Architecture\${DRIVERINF}" ${DRIVERNAME}`
	Pop $0
	${IfNot} $0 = 0
		MessageBox MB_OK "OpenVPNPortable was unable to install TAP drivers. (Error $0)"
		Abort
	${EndIf}
!macroend

${SegmentPostPrimary}
	; Uninstall TAP driver
	ExecDos::exec /TOSTACK `"${DRIVERDIR}\$Architecture\${DRIVEREXE}" remove ${DRIVERNAME}`
!macroend