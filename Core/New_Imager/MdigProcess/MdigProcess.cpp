/***************************************************************************************/
/*
 * File name: MdigProcess.cpp
 * Last modified: 02/02/2021 - Shea Wells
 *
 * Synopsis:  This program shows the use of the MdigProcess() function and its multiple
 *            buffering acquisition to do robust real-time processing.
 *
 *            The user's processing code to execute is located in a callback function 
 *            that will be called for each frame acquired (see ProcessingFunction()).
 *
 *      Note: The average processing time must be shorter than the grab time or some
 *            frames will be missed. Also, if the processing results are not displayed
 *            and the frame count is not drawn or printed, the CPU usage is reduced 
 *            significantly.
 *
 * Copyright © Matrox Electronic Systems Ltd., 1992-2015.
 * All Rights Reserved
 */
#include <mil.h>
#include <string>
#include <chrono>
#include <thread>
#include <iostream>
#include <fstream>
//#include <stdio.h>

/* Number of images in the buffering grab queue.
   Generally, increasing this number gives a better real-time grab.
 */
#define BUFFERING_SIZE_MAX 22 //originally 22

// Save exported frames in this directory (must already exist)
//std::string fileDirectory = "C:/Users/haider-lab/Downloads/frames/";
//#define MY_FRAME_RATE 20 //frames per second
//#define MY_NUMBER_OF_FRAMES 40

/* User's processing function prototype. */
MIL_INT MFTYPE ProcessingFunction(MIL_INT HookType, MIL_ID HookId, void* HookDataPtr);

/* User's processing function hook data structure. */
typedef struct
   {
   MIL_ID  MilDigitizer;
   MIL_ID  MilImageDisp;
   MIL_INT ProcessedImageCount;
   std::string FileDirectory;
   } HookDataStruct;


/* Main function. */
/* ---------------*/

int MosMain(int argc, char *argv[])
{
   MIL_ID MilApplication;
   MIL_ID MilSystem     ;
   MIL_ID MilDigitizer  ;
   MIL_ID MilDisplay    ;
   MIL_ID MilImageDisp  ;
   MIL_ID MilGrabBufferList[BUFFERING_SIZE_MAX] = { 0 };
   MIL_INT MilGrabBufferListSize;
   MIL_INT ProcessFrameCount   = 0;
   MIL_DOUBLE ProcessFrameRate = 0;
   MIL_INT NbFrames = 0, n = 0;
   HookDataStruct UserHookData;

   // User inputs
   MIL_INT NumberOfFrames = 20; //set to 20 by default
   MIL_DOUBLE AcquisitionFrameRateFps = 0; //set as 0 by default - indicates using existing camera frame rate setting
   std::string fileDirectory = "C:/Users/haider-lab/Downloads/frames/";
   bool enableCLProtocol = true; //enables setting and retrieving camera frame rate property via CL protocol
   bool openFeatureBrowserUponFrameRateChange = true; //open the feature browser to allow user to confirm frame rate

   // Retrieve command line arguments
   switch (argc)
   {
   case 2:
	   NumberOfFrames = (MIL_INT) std::stoi(argv[1]);
	   break;
   case 3:
	   NumberOfFrames = (MIL_INT) std::stoi(argv[1]);
	   AcquisitionFrameRateFps = (MIL_DOUBLE) std::stod(argv[2]);
	   break;
   case 4:
	   NumberOfFrames = (MIL_INT)std::stoi(argv[1]);
	   AcquisitionFrameRateFps = (MIL_DOUBLE)std::stod(argv[2]);
	   fileDirectory = argv[3];
	   break;
   default:
	   break;
   }

   /* Allocate defaults. */
   MappAllocDefault(M_DEFAULT, &MilApplication, &MilSystem, &MilDisplay,
                                                &MilDigitizer, &MilImageDisp);
   //MdispControl(MilDisplay, M_WINDOW_SHOW, M_DISABLE); //disable showing the display window

   /* Allocate the grab buffers and clear them. */
   MappControl(M_DEFAULT, M_ERROR, M_PRINT_DISABLE);
   for(MilGrabBufferListSize = 0; MilGrabBufferListSize<BUFFERING_SIZE_MAX;
                                                        MilGrabBufferListSize++)
      {
      MbufAlloc2d(MilSystem,
                  MdigInquire(MilDigitizer, M_SIZE_X, M_NULL),
                  MdigInquire(MilDigitizer, M_SIZE_Y, M_NULL),
                  8+M_UNSIGNED,
                  M_IMAGE+M_GRAB+M_PROC,
                  &MilGrabBufferList[MilGrabBufferListSize]);
      if (MilGrabBufferList[MilGrabBufferListSize])
         MbufClear(MilGrabBufferList[MilGrabBufferListSize], 0xFF);
      else
         break;
      }
   MappControl(M_DEFAULT, M_ERROR, M_PRINT_ENABLE);

   /* Free buffers to leave space for possible temporary buffers. */
   /*for (n=0; n<2 && MilGrabBufferListSize; n++)
      {
      MilGrabBufferListSize--;
      MbufFree(MilGrabBufferList[MilGrabBufferListSize]);
      }*/

   // Enable CLProtocol
   if (enableCLProtocol)
   {
       MdigControl(MilDigitizer, M_GC_CLPROTOCOL_DEVICE_ID, M_PTR_TO_DOUBLE(MIL_TEXT("M_DEFAULT")));
       MdigControl(MilDigitizer, M_GC_CLPROTOCOL, M_ENABLE);
   }

   // Check frame rate
   MIL_DOUBLE CheckFrameRateFps = 0;
   if (enableCLProtocol)
   {
       MdigInquireFeature(MilDigitizer, M_FEATURE_VALUE, MIL_TEXT("AcquisitionFrameRate"), M_TYPE_DOUBLE, &CheckFrameRateFps);
       MosPrintf(MIL_TEXT("\nInquired frame rate feature = %.1f frames/sec.\n"), CheckFrameRateFps);
   }
   
   // Set frame rate if necessary
   if (enableCLProtocol && AcquisitionFrameRateFps > 0 && (int) AcquisitionFrameRateFps != (int) CheckFrameRateFps) // check if set by user to new value that is different than prior value (rounded to int)
   {
       MdigControlFeature(MilDigitizer, M_FEATURE_VALUE, MIL_TEXT("AcquisitionFrameRate"), M_TYPE_DOUBLE, &AcquisitionFrameRateFps);
       MosPrintf(MIL_TEXT("\nFrame rate = %.1f frames/sec.\n"), AcquisitionFrameRateFps);

       if (openFeatureBrowserUponFrameRateChange)
       {
           // Open camera's feature browser
           MdigControl(MilDigitizer, M_GC_FEATURE_BROWSER, M_OPEN + M_ASYNCHRONOUS);

           // Wait for user
           MosPrintf(MIL_TEXT("\nPlease press enter on the frame rate within the feature browser to ensure it updates.\r"));
           MosPrintf(MIL_TEXT("Press <Enter> to start processing.\r"));
           MosGetch();
       }

	   // Check frame rate
	   CheckFrameRateFps = 0;
	   MdigInquireFeature(MilDigitizer, M_FEATURE_VALUE, MIL_TEXT("AcquisitionFrameRate"), M_TYPE_DOUBLE, &CheckFrameRateFps);
	   MosPrintf(MIL_TEXT("\nInquired frame rate feature = %.1f frames/sec.\n"), CheckFrameRateFps);
   }

   /* Print a message. */
   //MosPrintf(MIL_TEXT("\nMULTIPLE BUFFERED PROCESSING.\n"));
   //MosPrintf(MIL_TEXT("-----------------------------\n\n"));
   //MosPrintf(MIL_TEXT("Press <Enter> to start processing.\r"));

   /* Grab continuously on the display and wait for a key press. */
   //MdigGrabContinuous(MilDigitizer, MilImageDisp);
   //MosGetch();

   /* Halt continuous grab. */
   //MdigHalt(MilDigitizer);

   /* Initialize the user's processing function data structure. */
   UserHookData.MilDigitizer        = MilDigitizer;
   UserHookData.MilImageDisp        = MilImageDisp;
   UserHookData.ProcessedImageCount = 0;
   UserHookData.FileDirectory = fileDirectory;

   MosPrintf(MIL_TEXT("\nProcessing...\r"));

   /* Start the processing. The processing function is called with every frame grabbed. */
   MdigProcess(MilDigitizer, MilGrabBufferList, MilGrabBufferListSize,
               M_START, M_DEFAULT, ProcessingFunction, &UserHookData);


   /* Here the main() is free to perform other tasks while the processing is executing. */
   /* --------------------------------------------------------------------------------- */

   int counter = 0;
   //int counterLimit = 5000; // for testing to ensure that it does not go on for infinity
   while (UserHookData.ProcessedImageCount < NumberOfFrames) //&& counter < counterLimit)
   {
	   counter++;
	   std::this_thread::sleep_for(std::chrono::milliseconds(10));
   }
   //MosPrintf(MIL_TEXT("\nCounter = %d\n"), counter);
   //MosPrintf(MIL_TEXT("\nLimit   = %d\n"), counterLimit);


   /* Print a message and wait for a key press after a minimum number of frames. */
   //MosPrintf(MIL_TEXT("Press <Enter> to stop.                    \n\n"));
   //MosGetch();

   /* Stop the processing. */
   MdigProcess(MilDigitizer, MilGrabBufferList, MilGrabBufferListSize,
               M_STOP, M_DEFAULT, ProcessingFunction, &UserHookData);
   MosPrintf(MIL_TEXT("\nMdigProcess STOPPED\n"));

   /* Print statistics. */
   MdigInquire(MilDigitizer, M_PROCESS_FRAME_COUNT,  &ProcessFrameCount);
   MdigInquire(MilDigitizer, M_PROCESS_FRAME_RATE,   &ProcessFrameRate);
   MosPrintf(MIL_TEXT("\n\n%d frames grabbed at %.1f frames/sec (%.1f ms/frame).\n"),
                        (int)ProcessFrameCount, ProcessFrameRate, 1000.0/ProcessFrameRate);

   // Check frame rate
   if (enableCLProtocol)
   {
       CheckFrameRateFps = 0;
       MdigInquireFeature(MilDigitizer, M_FEATURE_VALUE, MIL_TEXT("AcquisitionFrameRate"), M_TYPE_DOUBLE, &CheckFrameRateFps);
       MosPrintf(MIL_TEXT("\nInquired frame rate feature = %.1f frames/sec.\n"), CheckFrameRateFps);
   }
   

   /* Free the grab buffers. */
   while(MilGrabBufferListSize > 0)
         MbufFree(MilGrabBufferList[--MilGrabBufferListSize]);

   /* Release defaults. */
   MappFreeDefault(MilApplication, MilSystem, MilDisplay, MilDigitizer, MilImageDisp);

   // Create report file to signify finished
   std::ofstream report(fileDirectory + "REPORT.txt");
   report << "ProcessFrameCount = " << std::to_string((int)ProcessFrameCount) << std::endl;
   report << "ProcessFrameRate = " << std::to_string(ProcessFrameRate) << std::endl;
   report.close();
   
   // Create report file with c fprintf
   //std::string reportFilePath = fileDirectory + "REPORT.txt";
   //const char* reportFilePathChar = reportFilePath.c_str();
   //FILE report = fopen(reportFilePathChar, "w");

   // Wait for user
   //MosPrintf(MIL_TEXT("Press <Enter> to end.\n\n"));
   //MosGetch();

   return 0;
}


/* User's processing function called every time a grab buffer is ready. */
/* -------------------------------------------------------------------- */

/* Local defines. */
#define STRING_LENGTH_MAX  20
#define STRING_POS_X       20
#define STRING_POS_Y       20

MIL_INT MFTYPE ProcessingFunction(MIL_INT HookType, MIL_ID HookId, void* HookDataPtr)
   {
   HookDataStruct *UserHookDataPtr = (HookDataStruct *)HookDataPtr;
   MIL_ID ModifiedBufferId;
   MIL_TEXT_CHAR Text[STRING_LENGTH_MAX]= {MIL_TEXT('\0'),};

   /* Retrieve the MIL_ID of the grabbed buffer. */
   MdigGetHookInfo(HookId, M_MODIFIED_BUFFER+M_BUFFER_ID, &ModifiedBufferId);

   /* Increment the frame counter. */
   UserHookDataPtr->ProcessedImageCount++;

   /* Print and draw the frame count (remove to reduce CPU usage). */
   /*MosPrintf(MIL_TEXT("Processing frame #%d.\r"), (int)UserHookDataPtr->ProcessedImageCount);
   MosSprintf(Text, STRING_LENGTH_MAX, MIL_TEXT("%d"), 
                                       (int)UserHookDataPtr->ProcessedImageCount);
   MgraText(M_DEFAULT, ModifiedBufferId, STRING_POS_X, STRING_POS_Y, Text);*/
   
   // Export frame as image
   std::string filenameStr = UserHookDataPtr->FileDirectory + std::to_string((int)UserHookDataPtr->ProcessedImageCount) + ".raw";
   const char* filename = filenameStr.c_str();
   MbufExport(filename, M_RAW, ModifiedBufferId);

   /* Execute the processing and update the display. */
   //MimArith(ModifiedBufferId, M_NULL, UserHookDataPtr->MilImageDisp, M_NOT);
   
   
   #if M_MIL_USE_CE
   // Give execution time to the user interface when the digitizer processing 
   //  queue is full. If necessary, the Sleep value can be increased to give more 
   //  execution time to the user interface.
   
   if(MdigInquire(UserHookDataPtr->MilDigitizer, M_PROCESS_PENDING_GRAB_NUM, M_NULL) <= 1)
      {
      if ((UserHookDataPtr->ProcessedImageCount%10) == 0)
         Sleep(2);
      }
   #endif
   

   return 0;
   }
