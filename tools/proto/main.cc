#include <cstdio>
#include <cstring>

#include <string>
#include <vector>
#include <unordered_map>
#include <fstream>

#include "cmd.h"
#include "devmem.h"

using namespace REMU;

void show_help(const char * argv_0)
{
    //   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
    fprintf(stderr,
        "Usage: %s <device> <command> <args>..\n"
        "Commands:\n"
        "    read <addr>\n"
        "        Read a 32-bit word.\n"
        "    write <addr> <value>\n"
        "        Write a 32-bit word.\n"
        "    dump <addr> <max_size> <file>\n"
        "        Dump data to the file.\n"
        "    load <addr> <max_size> <file>\n"
        "        Load data from the file.\n"
        "    uart <base>\n"
        "        Launch uart lite host.\n"
        "\n"
        , argv_0);
}

int cmd_read(const std::string &dev_name, const std::vector<std::string> &args)
{
    if (args.size() != 2) {
        fprintf(stderr, "wrong argument size\n");
        return 1;
    }

    uint64_t addr = std::stoul(args[1], 0, 0);
    uint64_t base = addr & ~0xffful;
    uint32_t offset = addr & 0xfffu;

    try {
        DevMem devmem(base, 0x1000, true, dev_name);
        printf("%08x\n", devmem.read_u32(offset));
    }
    catch (std::runtime_error &e) {
        fprintf(stderr, "ERROR: %s\n", e.what());
        return 1;
    }

    return 0;
}

int cmd_write(const std::string &dev_name, const std::vector<std::string> &args)
{
    if (args.size() != 3) {
        fprintf(stderr, "wrong argument size\n");
        return 1;
    }

    uint64_t addr = std::stoul(args[1], 0, 0);
    uint64_t base = addr & ~0xffful;
    uint32_t offset = addr & 0xfffu;

    uint32_t value = std::stoul(args[2], 0, 0);

    try {
        DevMem devmem(base, 0x1000, true, dev_name);
        devmem.write_u32(offset, value);
    }
    catch (std::runtime_error &e) {
        fprintf(stderr, "ERROR: %s\n", e.what());
        return 1;
    }

    return 0;
}

int cmd_dump(const std::string &dev_name, const std::vector<std::string> &args)
{
    if (args.size() != 4) {
        fprintf(stderr, "wrong argument size\n");
        return 1;
    }

    uint64_t addr = std::stoul(args[1], 0, 0);
    uint64_t base = addr & ~0xffful;
    uint32_t offset = addr & 0xfffu;

    uint64_t size = std::stoul(args[2], 0, 0);
    uint64_t aligned_size = (size + 0xffful) & ~0xffful;

    std::string file = args[3];

    auto buf = new char[size];

    try {
        std::ofstream f(file, std::ios::binary);
        if (f.fail()) {
            fprintf(stderr, "ERROR: failed to open file %s\n", file.c_str());
            return 1;
        }

        DevMem devmem(base, aligned_size, true, dev_name);
        devmem.read(buf, offset, size);
        f.write(buf, size);
    }
    catch (std::runtime_error &e) {
        fprintf(stderr, "ERROR: %s\n", e.what());
        return 1;
    }

    delete[] buf;

    return 0;
}

int cmd_load(const std::string &dev_name, const std::vector<std::string> &args)
{
    if (args.size() != 4) {
        fprintf(stderr, "wrong argument size\n");
        return 1;
    }

    uint64_t addr = std::stoul(args[1], 0, 0);
    uint64_t base = addr & ~0xffful;
    uint32_t offset = addr & 0xfffu;

    uint64_t size = std::stoul(args[2], 0, 0);
    uint64_t aligned_size = (size + 0xffful) & ~0xffful;

    std::string file = args[3];

    auto buf = new char[size];

    try {
        std::ifstream f(file, std::ios::binary);
        if (f.fail()) {
            fprintf(stderr, "ERROR: failed to open file %s\n", file.c_str());
            return 1;
        }

        DevMem devmem(base, aligned_size, true, dev_name);
        f.read(buf, size);
        size = f.gcount();
        devmem.write(buf, offset, size);
    }
    catch (std::runtime_error &e) {
        fprintf(stderr, "ERROR: %s\n", e.what());
        return 1;
    }

    delete[] buf;

    return 0;
}

std::unordered_map<std::string, CMD_FUNC*> cmd_map = {
    {"read",    cmd_read},
    {"write",   cmd_write},
    {"dump",    cmd_dump},
    {"load",    cmd_load},
    {"uart",    cmd_uart},
};

int main(int argc, const char *argv[])
{
    if (argc < 3) {
        show_help(argv[0]);
        return 1;
    }

    int argidx = 1;

    std::string dev_name = argv[argidx++];

    std::vector<std::string> args(argv + argidx, argv + argc);

    auto it = cmd_map.find(args.at(0));
    if (it == cmd_map.end()) {
        fprintf(stderr, "unrecognized command %s\n", args.at(0).c_str());
        return 1;
    }

    return it->second(dev_name, args);
}
