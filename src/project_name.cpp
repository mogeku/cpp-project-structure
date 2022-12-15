#include "my_project/my_project.h"

#include <iostream>

// #include "win_lib/win_lib.h"

// #include "build_from_source.h"
#include "version.h"

int run() {
  std::cout << "Lib version is " << MY_PROJECT_VERSION_STR << std::endl;
  std::cout << "Now run..." << std::endl;
//   build_from_source();
//   win_lib();


  return 0;
}
