cmake_minimum_required(VERSION 3.2)

project(CFGConstruction)

if(APPLE)
    set(BOOST_CXXFLAGS "cxxflags=-fPIC -std=c++11")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -g -Wall -Wextra -pedantic -target x86_64-apple-darwin20.3.0")
else()
    set(BOOST_CXXFLAGS "cxxflags=-fPIC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -Wall")
endif()

set(CMAKE_BUILD_TYPE Debug)

find_package(Boost CONFIG REQUIRED program_options filesystem regex)

include_directories(CFG)
include_directories(opcodes)
include_directories(SolidityInfo)
include_directories(Utils)
include_directories(${Boost_INCLUDE_DIRS})
add_executable(main main.cpp CFG/cfgbuilder/CfgBuilder.cpp CFG/SymbolicExecution/SymbolicExecutionStack.cpp Utils/Tools.h Utils/fifo_map.hpp)
target_link_libraries(main PUBLIC Boost::program_options Boost::filesystem Boost::regex)
