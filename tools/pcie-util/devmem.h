#ifndef _DRIVER_DEVMEM_H_
#define _DRIVER_DEVMEM_H_

#include <cstdint>
#include <cstddef>
#include <string>

namespace REMU {

class DevMem
{
    int m_fd;
    size_t m_base, m_size;
    void *m_ptr;

public:

    size_t base() const { return m_base; }
    size_t size() const { return m_size; }

    void read(char *buf, size_t offset, size_t len);
    void write(const char *buf, size_t offset, size_t len);
    uint32_t read_u32(size_t offset);
    void write_u32(size_t offset, uint32_t value);

    void fill(char c, size_t offset, size_t len);

    DevMem(size_t base, size_t size, bool sync, std::string dev = "/dev/mem");
    ~DevMem();
};

}

#endif
