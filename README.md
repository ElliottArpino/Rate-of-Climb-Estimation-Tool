# Rate-of-Climb-Estimation-Tool

This MATLAB-based tool estimates and visualizes the Rate of Climb (R.O.C.) for a general aviation aircraft (Piper Cherokee) across multiple altitudes using aircraft performance theory and atmospheric models.

## Features

- Calculates R.O.C. vs Equivalent Airspeed for 0–15,000 ft
- Estimates service ceiling and absolute ceiling
- Plots:
  - R.O.C. vs Airspeed
  - Hodograph (R.O.C. vs Horizontal Speed)
  - Max R.O.C. vs Altitude
  - Time-to-Climb to Ceiling
- Determines best airspeeds for:
  - Steepest Climb
  - Fastest Climb

## Core Concepts

- Induced drag and parasitic drag modeling
- Propeller efficiency curve interpolation
- ISA-based atmospheric density calculations
- Numerical integration for time-to-climb using trapezoidal method

## Files

- [ROC_Estimation.m](ROC_Estimation.m) — Main MATLAB script
- [plots/](plots/) — Output plots (Rate of Climb, Hodograph, Time to Climb, etc.)

## Dependencies

- MATLAB (any version with basic plotting and `interp1`)
- Aerospace Toolbox (for `atmosisa`) or a substitute custom function

## Example Output

![ROC vs Equivalent Airspeed](plots/ROC_vs_EAS.png)

## License

MIT License

