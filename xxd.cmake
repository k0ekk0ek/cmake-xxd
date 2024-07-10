#
# xxd.cmake -- create hex dump in c include file style
#
# Copyright (c) 2024, NLnet Labs. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#
cmake_minimum_required(VERSION 3.10)

# equivalent of "xxd -i input.file > output.file"

if(NOT INPUT_FILE)
  message(FATAL_ERROR "No input file specified")
endif()

if(NOT OUTPUT_FILE)
  message(FATAL_ERROR "No output file specified")
endif()

# normalize paths
file(TO_CMAKE_PATH "${INPUT_FILE}" input_path)
file(TO_CMAKE_PATH "${OUTPUT_FILE}" output_path)

get_filename_component(output_directory "${output_path}" DIRECTORY)
get_filename_component(input_file "${input_path}" NAME)

# make sure input file exists
if(NOT EXISTS "${input_path}")
  message(FATAL_ERROR "Input file does not exist")
endif()
# make sure output directory exists
if(output_directory AND NOT EXISTS "${output_directory}")
  message(FATAL_ERROR "Output directory (${output_directory}) does not exist")
endif()

# read contents in hexadecimal representation
file(READ "${input_path}" input HEX)

string(LENGTH "${input}" length)

# file contents should be:
#
# unsigned char file_name[] = {
#   0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
#   ...
# };
# unsigned int file_name_len = xxx;

# write to output
string(APPEND output "// generated by xxd.cmake, do not edit\n")
string(MAKE_C_IDENTIFIER "${input_file}" array_name)
string(APPEND output "unsigned char ${array_name}[] = {\n")

set(xx "[0123456789abcdef]") # a-f are guaranteed to be in lower case
set(xx2 "${xx}${xx}")
set(xx20 "${xx2}${xx2}${xx2}${xx2}${xx2}${xx2}${xx2}${xx2}${xx2}${xx2}")
string(REGEX REPLACE "(${xx20})" "\\1;" lines "${input}")
string(REGEX REPLACE "(${xx2})" "0x\\1, " lines "${lines}")
string(REGEX REPLACE ", $" "" lines "${lines}")

foreach(line ${lines})
  string(APPEND output "  ${line}\n")
endforeach()

string(APPEND output "};\n")

math(EXPR array_length "${length} / 2")

string(APPEND output "unsigned int ${array_name}_len = ${array_length};\n")

file(WRITE "${output_path}" "${output}")