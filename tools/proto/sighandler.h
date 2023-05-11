#ifndef _SIGHANDLER_H_
#define _SIGHANDLER_H_

#include <functional>

namespace REMU {

struct SigIntHandler
{
    SigIntHandler(std::function<void()> handler);
    ~SigIntHandler();
};

struct SigQuitHandler
{
    SigQuitHandler(std::function<void()> handler);
    ~SigQuitHandler();
};

}

#endif
