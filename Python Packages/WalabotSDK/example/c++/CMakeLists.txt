cmake_minimum_required (VERSION 2.8.11)

project(WalabotSamples)

find_path(WALABOT_INCLUDE_DIR WalabotAPI.h  PATHS C:\\Program\ Files\\Walabot\\WalabotSDK\\inc)
find_library(WALABOT_LIB WalabotAPI  PATHS C:\\Program\ Files\\Walabot\\WalabotSDK\\bin)
find_file(WALABOT_DLL WalabotAPI.dll PATHS C:\\Program\ Files\\Walabot\\WalabotSDK\\bin)
set(LIBUSB_DLL C:\\Program\ Files\\Walabot\\WalabotSDK\\bin\\libusb-1.0.dll)
set(QT_DLL C:\\Program\ Files\\Walabot\\WalabotSDK\\bin\\Qt5Core.dll)

include_directories(${WALABOT_INCLUDE_DIR})

add_executable(WalabotSensorSampleProject    SensorCodeSample.cpp)
add_executable(WalabotBreathingSampleProject SensorBreathingSampleCode.cpp)
add_executable(WalabotInWallSampleProject    InWallSampleCode.cpp)
add_executable(WalabotTrackerSampleProject    TrackerSampleCode.cpp)

foreach (TARGET_NAME WalabotSensorSampleProject
                     WalabotBreathingSampleProject
                     WalabotInWallSampleProject
                     WalabotTrackerSampleProject)
    
    target_link_libraries(${TARGET_NAME} ${WALABOT_LIB})
   
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            ${WALABOT_DLL} ${LIBUSB_DLL} ${QT_DLL} 
            $<TARGET_FILE_DIR:${TARGET_NAME}>) 

endforeach()
