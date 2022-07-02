#include "project_name/project_name.h"

#include <iostream>

#include "build_from_source.h"
#include "version.h"

int run() {
  std::cout << "Lib version is " << PROJECT_NAME_VERSION_STR << std::endl;
  std::cout << "Now run..." << std::endl;
  build_from_source();

  return 0;
}
