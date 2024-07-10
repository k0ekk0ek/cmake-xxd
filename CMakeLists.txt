cmake_minimum_required(VERSION 3.10)
project(cmake-xxd LANGUAGES C)

set(hello_c ${CMAKE_CURRENT_SOURCE_DIR}/hello.c)
set(hello_hex_c ${CMAKE_CURRENT_BINARY_DIR}/hello.hex.c)
set(xxd_cmake ${CMAKE_CURRENT_SOURCE_DIR}/xxd.cmake)

add_custom_command(
  OUTPUT hello.hex.c
  COMMAND ${CMAKE_COMMAND}
  ARGS -DINPUT_FILE=${hello_c} -DOUTPUT_FILE=${hello_hex_c} -P ${xxd_cmake}
  DEPENDS ${hello_c} ${xxd_cmake})

add_custom_target(generate_hello_hex_c DEPENDS ${hello_hex_c})

add_executable(unhex unhex.c ${hello_hex_c})
add_dependencies(unhex generate_hello_hex_c)
