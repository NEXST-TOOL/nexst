#include "devdma.h"

#include <cstring>

#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <stdexcept>
#include <system_error>

using namespace REMU;

DevDMA::DevDMA(size_t base, size_t size, bool sync, std::string dev) {
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
    throw std::system_error(errno, std::generic_category(),
                            "failed to open " + dev);
}

DevDMA::~DevDMA() { close(m_fd); }

void DevDMA::read(char *buf, size_t offset, size_t len) {
  size_t pos = 0;
  ::lseek(m_fd, m_base + offset, SEEK_SET);
  while (len > 4096) {
    ::read(m_fd, buf + pos, 4096);
    len -= 4096;
    pos += 4096;
  }
  ::read(m_fd, buf + pos, len);
}

void DevDMA::write(const char *buf, size_t offset, size_t len) {
  ::lseek(m_fd, m_base + offset, SEEK_SET);
  ::write(m_fd, buf, len);
}

uint32_t DevDMA::read_u32(size_t offset) {
  uint32_t value;

  if ((offset & 0x3) != 0)
    throw std::invalid_argument("offset must be a multiple of 4");

  ::lseek(m_fd, m_base + offset, SEEK_SET);
  ::read(m_fd, &value, sizeof(value));
  return value;
}

void DevDMA::write_u32(size_t offset, uint32_t value) {
  if ((offset & 0x3) != 0)
    throw std::invalid_argument("offset must be a multiple of 4");

  ::lseek(m_fd, m_base + offset, SEEK_SET);
  ::write(m_fd, &value, sizeof(value));
}

void DevDMA::fill(char c, size_t offset, size_t len) {
  char *buf = new char[len];
  std::memset(buf, c, len);
  write(buf, offset, len);

  ::lseek(m_fd, m_base + offset, SEEK_SET);
  ::write(m_fd, buf, len);

  delete[] buf;
}
