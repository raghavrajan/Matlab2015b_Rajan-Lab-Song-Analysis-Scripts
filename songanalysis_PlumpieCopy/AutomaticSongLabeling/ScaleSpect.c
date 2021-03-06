 /* Scaling the spectrogram
 * MEX file
 * 
 * Raghav 2009
 * 
 * inputs: Spect
 *       
 *        data: this is the spectrogram values in an m x n array

 * outputs:outputs
 *          
 *         outputs: this is an m x n array with indices indicating number of decibels from maximum of 100db
 *          
 * version 1.0
 -----------------------------------*/

#include "mex.h"
#include <math.h>
#include <matrix.h>

void mexFunction(
  int nOUT, mxArray *outputs[],
  int nINP, const mxArray *inputs[])
{
  
      double *data, *OutputSpect;
      int length_data, i, Rows, Cols, OutputIndex;
      double max_value;
      
      if (nINP < 1) 
        mexErrMsgTxt("1 input required");
      
      if (nOUT > 1) 
        mexErrMsgTxt("Too many output arguments");
      
      data = (double *)mxGetPr(inputs[0]);
      
      length_data = mxGetM(inputs[0]) * mxGetN(inputs[0]);
      Rows = mxGetM(inputs[0]);
      Cols = mxGetN(inputs[0]);
      
      /* First find the max value */
      max_value = 0;
      for(i = 0; i < length_data; i++)
      {
          if (data[i] > max_value)
              max_value = data[i];
      }
      
      /* Now make sure there are no zeros in the data */
      for(i = 0; i < length_data; i++)
      {
          if (data[i] < (0.000000001 * max_value))
              data[i] = 0.000000001 * max_value;
      }
      
      /* Now get power in db */
      for(i = 0; i < length_data; i++)
          data[i] = 20 * log10(data[i]);
      
      /* Now get power relative to max in db */
      max_value = 0;
      for(i = 0; i < length_data; i++)
      {
          if (data[i] > max_value)
              max_value = data[i];
      }
      
      for(i = 0; i < length_data; i++)
          data[i] = data[i] - max_value;
          

      /* Now truncate at -100 dB */
      for(i = 0; i < length_data; i++)
      {
          if (data[i] < -100)
              data[i] = -100;
      }

      outputs[0] = mxCreateDoubleMatrix(Rows, Cols, mxREAL);
      OutputSpect = mxGetPr(outputs[0]);

      /* Now set index values for range 1-100 with index indicating number of decibels from maximum */
      for(i = 0; i < length_data; i++)
      {
          OutputSpect[i] = fabs(floor(data[i]));
          if (OutputSpect[i] < 1)
              OutputSpect[i] = 1;
      }
}
