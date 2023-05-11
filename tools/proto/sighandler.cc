#include "sighandler.h"
#include <csignal>
#include <stdexcept>

using namespace REMU;

namespace {

struct SigIntDispatcher
{
    std::function<void()> sigint_handler;
    std::function<void()> sigquit_handler;
    static void sys_handler(int);
    SigIntDispatcher();
};

struct SigIntDispatcher dispatcher;

void SigIntDispatcher::sys_handler(int signum)
{
    switch (signum) {
        case SIGINT:
            if (dispatcher.sigint_handler)
                dispatcher.sigint_handler();
            break;
        case SIGQUIT:
            if (dispatcher.sigquit_handler)
                dispatcher.sigquit_handler();
            break;
    }
}

SigIntDispatcher::SigIntDispatcher()
{
    signal(SIGINT, sys_handler);
    signal(SIGQUIT, sys_handler);
}

} // namespace

SigIntHandler::SigIntHandler(std::function<void()> handler)
{
    if (dispatcher.sigint_handler)
        throw std::runtime_error("try to register multiple SIGINT handler");

    dispatcher.sigint_handler = handler;
}

SigIntHandler::~SigIntHandler()
{
    dispatcher.sigint_handler = 0;
}

SigQuitHandler::SigQuitHandler(std::function<void()> handler)
{
    if (dispatcher.sigquit_handler)
        throw std::runtime_error("try to register multiple SIGQUIT handler");

    dispatcher.sigquit_handler = handler;
}

SigQuitHandler::~SigQuitHandler()
{
    dispatcher.sigquit_handler = 0;
}
