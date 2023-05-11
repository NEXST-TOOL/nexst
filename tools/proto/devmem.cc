#include "devmem.h"

#include <cstring>

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>

#include <stdexcept>
#include <system_error>

using namespace REMU;

DevMem::DevMem(size_t base, size_t size, bool sync, std::string dev)
{
    size_t pg_size = sysconf(_SC_PAGE_SIZE);
    if (base % pg_size != 0)
        throw std::invalid_argument("base must be a multiple of system page size");

    m_base = base;
    m_size = size;

    int flag = O_RDWR;
    if (sync)
        flag |= O_SYNC;
    m_fd = open(dev.c_str(), flag);
    if (m_fd < 0)
        throw std::system_error(errno, std::generic_category(), "failed to open " + dev);

    m_ptr = mmap(nullptr, size, PROT_READ | PROT_WRITE, MAP_SHARED, m_fd, base);
    if (m_ptr == MAP_FAILED) {
        close(m_fd);
        throw std::system_error(errno, std::generic_category(), "failed to mmap " + dev);
    }
}

DevMem::~DevMem()
{
    munmap(m_ptr, m_size);
    close(m_fd);
}

void DevMem::read(char *buf, size_t offset, size_t len)
{
    memcpy(buf, ((char *)m_ptr) + offset, len);
}

void DevMem::write(const char *buf, size_t offset, size_t len)
{
    memcpy(((char *)m_ptr) + offset, buf, len);
}

uint32_t DevMem::read_u32(size_t offset)
{
    if ((offset & 0x3) != 0)
        throw std::invalid_argument("offset must be a multiple of 4");

    return ((volatile uint32_t *)m_ptr)[offset >> 2];
}

void DevMem::write_u32(size_t offset, uint32_t value)
{
    if ((offset & 0x3) != 0)
        throw std::invalid_argument("offset must be a multiple of 4");

    ((volatile uint32_t *)m_ptr)[offset >> 2] = value;
}

void DevMem::fill(char c, size_t offset, size_t len)
{
    memset((char *)m_ptr + offset, c, len);
}
