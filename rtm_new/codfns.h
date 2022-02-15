#pragma once

#ifdef _WIN32
	#define EXPORT __declspec(dllexport)
	#ifdef EXPORTING
		#define DECLSPEC EXPORT
	#else
		#define DECLSPEC __declspec(dllimport)
	#endif
#elif defined(__GNUC__)
	#define DECLSPEC __attribute__ ((visibility ("default")))
#else
	#define DECLSPEC
#endif

