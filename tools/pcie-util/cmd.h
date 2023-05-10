#include <string>
#include <vector>

typedef int (CMD_FUNC) (const std::string &dev_name, const std::vector<std::string> &args);

CMD_FUNC cmd_read;
CMD_FUNC cmd_write;
CMD_FUNC cmd_dump;
CMD_FUNC cmd_load;
CMD_FUNC cmd_uart;
