#include "WalabotAPI.h"
#include <iostream>
#include <stdio.h>
#include <string>

#ifdef __LINUX__
	#define CONFIG_FILE_PATH "/etc/walabotsdk.conf"
#else
	#define CONFIG_FILE_PATH "C:\\Program Files\\Walabot\\WalabotSDK\\bin\\.config"
#endif

#define CHECK_WALABOT_RESULT(result, func_name)					\
{																\
	if (result != WALABOT_SUCCESS)								\
	{															\
		const char* errorStr = Walabot_GetErrorString();		\
		std::cout << std::endl << func_name << " error: "       \
                  << errorStr << std::endl;                     \
		std::cout << "Press enter to continue ...";				\
		std::string dummy;										\
		std::getline(std::cin, dummy);							\
		return;													\
	}															\
}

void PrintBreathingEnergy(double energy)
{
#ifdef __LINUX__
	printf("\033[2J\033[1;1H");
#else
	system("cls");
#endif
	printf("Energy = %lf\n ", energy  * 1e7);
}

void SensorBreathing_SampleCode()
{
	// --------------------
	// Variable definitions
	// --------------------
	WALABOT_RESULT res;

	// Walabot_GetStatus - output parameters
	APP_STATUS appStatus;
	double calibrationProcess; // Percentage of calibration completed, if status is STATUS_CALIBRATING

							   // Walabot_GetImageEnergy 
	double energy;

	// ------------------------
	// Initialize configuration
	// ------------------------

	// Walabot_SetArenaR - input parameters
	double minInCm = 30;
	double maxInCm = 150;
	double resICm = 1;

	// Walabot_SetArenaTheta - input parameters
	double minIndegrees = -4;
	double maxIndegrees = 4;
	double resIndegrees = 2;

	// Walabot_SetArenaPhi - input parameters
	double minPhiInDegrees = -4;
	double maxPhiInDegrees = 4;
	double resPhiInDegrees = 2;

	// ----------------------
	// Sample Code Start Here
	// ----------------------

	/*
		For an image to be received by the application, the following need to happen :
		1) Connect
		2) Configure
		3) Start
		4) Trigger
		5) Get action
		6) Stop/Disconnect
	*/

	res = Walabot_Initialize(CONFIG_FILE_PATH);
	CHECK_WALABOT_RESULT(res, "Walabot_Initialize");

	//	1) Connect : Establish communication with Walabot.
	//	==================================================
	res = Walabot_ConnectAny();
	CHECK_WALABOT_RESULT(res, "Walabot_ConnectAny");

	//  2) Configure : Set scan profile and arena
	//	=========================================

	// Set Profile - to Sensor -Narrow. 
	//			Walabot recording mode is configured with the following attributes:
	//			-> Distance scanning through air; 
	//			-> lower - resolution images for a fast capture rate (useful for tracking quick movement)
	res = Walabot_SetProfile(PROF_SENSOR_NARROW);
	CHECK_WALABOT_RESULT(res, "Walabot_SetProfile");

	// Setup arena - specify it by Cartesian coordinates(ranges and resolution on the x, y, z axes); 
	//	In Sensor mode there is need to specify Spherical coordinates(ranges and resolution along radial distance and Theta and Phi angles).
	res = Walabot_SetArenaR(minInCm, maxInCm, resICm);
	CHECK_WALABOT_RESULT(res, "Walabot_SetArenaR");

	// Sets polar range and resolution of arena (parameters in degrees).
	res = Walabot_SetArenaTheta(minIndegrees, maxIndegrees, resIndegrees);
	CHECK_WALABOT_RESULT(res, "Walabot_SetArenaTheta");

	// Sets azimuth range and resolution of arena.(parameters in degrees).
	res = Walabot_SetArenaPhi(minPhiInDegrees, maxPhiInDegrees, resPhiInDegrees);
	CHECK_WALABOT_RESULT(res, "Walabot_SetArenaPhi");

	// Dynamic-imaging filter for the specific frequencies typical of breathing
	res = Walabot_SetDynamicImageFilter(FILTER_TYPE_DERIVATIVE);
	CHECK_WALABOT_RESULT(res, "Walabot_SetDynamicImageFilter");

	//	3) Start: Start the system in preparation for scanning.
	//	=======================================================
	res = Walabot_Start();
	CHECK_WALABOT_RESULT(res, "Walabot_Start");

	bool recording = true;

	while (recording)
	{
		// calibrates scanning to ignore or reduce the signals
		res = Walabot_GetStatus(&appStatus, &calibrationProcess);
		CHECK_WALABOT_RESULT(res, "Walabot_GetStatus");

		//	4) Trigger: Scan(sense) according to profile and record signals to be 
		//	available for processing and retrieval.
		//	====================================================================
		res = Walabot_Trigger();
		CHECK_WALABOT_RESULT(res, "Walabot_Trigger");

		//	5) 	Get action : retrieve the last completed triggered recording 
		//	================================================================
		res = Walabot_GetImageEnergy(&energy);
		CHECK_WALABOT_RESULT(res, "Walabot_GetImageEnergy");

		//	******************************
		//	TODO: add processing code here
		//	******************************
		PrintBreathingEnergy(energy);
	}

	//	6) Stop and Disconnect.
	//	======================
	res = Walabot_Stop();
	CHECK_WALABOT_RESULT(res, "Walabot_Stop");

	res = Walabot_Disconnect();
	CHECK_WALABOT_RESULT(res, "Walabot_Disconnect");

	res = Walabot_Clean();
	CHECK_WALABOT_RESULT(res, "Walabot_Clean");
}

int main()
{
	SensorBreathing_SampleCode();
}
