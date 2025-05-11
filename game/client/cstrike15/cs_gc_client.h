#ifndef KISAKSTRIKE_CS_GC_CLIENT_H
#define KISAKSTRIKE_CS_GC_CLIENT_H

#if !defined( NO_STEAM )

#include "steam/steam_api.h"
#endif

#include "gcsdk/gcclientsdk.h" // /gcsdk stuff
#include "networkvar.h"
#include <gc_clientsystem.h> // base GCClient
#include "cstrike15_gcmessages.pb.h"

#if _MSC_VER >= 1300
#pragma warning(disable : 4511)	// Disable warnings about private copy constructors
#pragma warning(disable : 4121)	// warning C4121: 'symbol' : alignment of a member was sensitive to packing
#pragma warning(disable : 4530)	// warning C4530: C++ exception handler used, but unwind semantics are not enabled. Specify /EHsc (disabled due to std headers having exception syntax)
#endif

class CCSGCClientSystem : public CGCClientSystem//, public GCSDK::ISharedObjectListener
{
    DECLARE_CLASS_GAMEROOT( CCSGCClientSystem, CGCClientSystem );
public:
    CCSGCClientSystem( void );
    ~CCSGCClientSystem( void ) noexcept;

    // CAutoGameSystemPerFrame
    virtual bool Init() OVERRIDE;
    virtual void PostInit() OVERRIDE;
    virtual void LevelInitPreEntity() OVERRIDE;
    virtual void LevelShutdownPostEntity() OVERRIDE;
    virtual void Shutdown() OVERRIDE;
    virtual void Update( float frametime ) OVERRIDE;

    // CGCClientSystem
    virtual void PreInitGC() OVERRIDE;
    virtual void PostInitGC() OVERRIDE;

    // this
    void OnReceivedMatchmakingWelcomeMessage( const CMsgGCCStrike15_v2_MatchmakingGC2ClientHello &msg );
};


CCSGCClientSystem* CCSGCClientSystem();

#endif //KISAKSTRIKE_CS_GC_CLIENT_H
