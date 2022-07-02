#ifndef PROJECT_NAME_H_
#define PROJECT_NAME_H_

#ifdef _WIN32
#ifdef SHARED_LIB
#ifdef DLL_EXPORT
#define LIB_API extern "C" __declspec(dllexport)
#else
#define LIB_API extern "C" __declspec(dllimport)
#endif
#else
#define LIB_API extern "C"
#endif
#else
#ifdef DLL_EXPORT
#define LIB_API extern "C" __attribute__((visibility ("default")))
#else
#define LIB_API extern "C"
#endif
#endif


LIB_API int run();

#endif  // PROJECT_NAME_H_
