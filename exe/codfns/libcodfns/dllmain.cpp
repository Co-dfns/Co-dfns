#include "pch.h"

#define DWA_DISABLE_ASSERTS
#define dwa_enable_asserts(enable) (0)

#if _DEBUG
#undef dwa_enable_asserts
#include <crtdbg.h>
static int dwa_enable_asserts(int enable)
{
    return _CrtSetReportMode(_CRT_ASSERT, enable ? _CRTDBG_MODE_WNDW : _CRTDBG_MODE_DEBUG);
}
#endif

extern "C" HINSTANCE dwa_hInst;

BOOL APIENTRY DllMain( HMODULE h, DWORD reason, LPVOID process_termination)
{
	switch (reason)
	{
	case DLL_PROCESS_ATTACH:
	{
#if defined (DWA_DISABLE_ASSERTS)
		dwa_enable_asserts(0);
#endif
		dwa_hInst = h;
		break;
	}
	}
	return TRUE;
}
