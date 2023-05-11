#include <cstdio>
#include <cstring>

#include <unordered_map>
#include <stdexcept>

#include <unistd.h>
#include <fcntl.h>
#include <termios.h>

#include "cmd.h"
#include "devmem.h"
#include "sighandler.h"

using namespace REMU;

void init_term()
{
    struct termios t;
    tcgetattr(0, &t);
    t.c_lflag &= ~ICANON;
    t.c_lflag &= ~ECHO;
    tcsetattr(0, TCSANOW, &t);

    fcntl(0, F_SETFL, fcntl(0, F_GETFL) | O_NONBLOCK);
}

char uart_recv(DevMem &devmem)
{
    if (!(devmem.read_u32(0x8) & (1 << 0)))
        return 0;

    return devmem.read_u32(0x0);
}

bool uart_send(DevMem &devmem, char ch, int max_retry = 1000)
{
    for (int i=0; i<max_retry; i++) {
        if (!(devmem.read_u32(0x8) & (1 << 3))) {
            devmem.write_u32(0x4, ch);
            return true;
        }
    }

    return false;
}

int cmd_uart(const std::string &dev_name, const std::vector<std::string> &args)
{
    if (args.size() != 2) {
        fprintf(stderr, "wrong argument size\n");
        return 1;
    }

    uint64_t base = std::stoul(args[1], 0, 0);

    try {
        bool running = true;
        char special_char = 0;
        SigIntHandler int_handler([&special_char]() { special_char = 0x03; });
        SigQuitHandler quit_handler([&running]() { running = false; });

        DevMem devmem(base, 0x1000, true, dev_name);

        init_term();
        fprintf(stderr, "Escape key is ctrl+\\ (SIGQUIT)\n");

        while (running) {
            while (running) {
                char ch = uart_recv(devmem);
                if (!ch)
                    break;

                write(1, &ch, 1);
            }

            char ch = 0;
            if (special_char) {
                ch = special_char;
                special_char = 0;
            }
            else {
                read(0, &ch, 1);
            }

            if (ch) {
                uart_send(devmem, ch);
            }

            usleep(100);
        }
    }
    catch (std::runtime_error &e) {
        fprintf(stderr, "ERROR: %s\n", e.what());
        return 1;
    }

    return 0;
}