cmake_minimum_required(VERSION 3.16)
project(GrowthCalculator)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Enable Qt
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt6 packages
find_package(Qt6 COMPONENTS Core Gui Qml Quick Charts REQUIRED)

# Compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -O2")

# Source files
set(SOURCES
    main_qml.cpp
    growthcalculator.h
    growthcalculator.cpp
)

# QML resource files
set(QML_FILES
    qml/main.qml
    qml/ChartView.qml
)

# Create resource file
qt6_add_resources(RESOURCES resources.qrc)

# Add executable
add_executable(growth_calc ${SOURCES} ${RESOURCES})

# Link Qt libraries
target_link_libraries(growth_calc
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::Charts
    m pthread
)

# Installation
install(TARGETS growth_calc DESTINATION /usr/local/bin)

# Print build information
message(STATUS "")
message(STATUS "Growth Pattern Calculator - Build Configuration")
message(STATUS "================================================")
message(STATUS "C++ Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "Output: growth_calc")
message(STATUS "================================================")
message(STATUS "")
