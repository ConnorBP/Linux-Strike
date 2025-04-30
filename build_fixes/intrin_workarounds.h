#pragma once

#if defined(_MSC_VER) && _MSC_VER < 1928
    #include <emmintrin.h>
    #ifndef _mm_loadu_si64
        #define _mm_loadu_si64(p) _mm_loadl_epi64(reinterpret_cast<const __m128i*>(p))
    #endif
#endif
