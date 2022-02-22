#!/bin/sh
# This wrapper script is intended to support independent execution.
#
# This script uses the following environment variables set by the submit MATLAB code:
# PARALLEL_SERVER_MATLAB_EXE  - the MATLAB executable to use
# PARALLEL_SERVER_MATLAB_ARGS - the MATLAB args to use

# Copyright 2010-2019 The MathWorks, Inc.

export TZ="Europe/Helsinki"

# If PARALLEL_SERVER_ environment variables are not set, assign any
# available values with form MDCE_ for backwards compatibility
PARALLEL_SERVER_MATLAB_EXE=${PARALLEL_SERVER_MATLAB_EXE:="${MDCE_MATLAB_EXE}"}
PARALLEL_SERVER_MATLAB_ARGS=${PARALLEL_SERVER_MATLAB_ARGS:="${MDCE_MATLAB_ARGS}"}

if [ ! -z "${SLURM_ARRAY_TASK_ID}" ]; then
    # Use job arrays
    TASK_ID=$((${SLURM_ARRAY_TASK_ID}+${PARALLEL_SERVER_TASK_ID_OFFSET}))
    export PARALLEL_SERVER_TASK_LOCATION="${PARALLEL_SERVER_JOB_LOCATION}/Task${TASK_ID}";
    export MDCE_TASK_LOCATION="${MDCE_JOB_LOCATION}/Task${TASK_ID}";
fi

echo "Executing: ${PARALLEL_SERVER_MATLAB_EXE} ${PARALLEL_SERVER_MATLAB_ARGS}"
eval "${PARALLEL_SERVER_MATLAB_EXE}" ${PARALLEL_SERVER_MATLAB_ARGS}
EXIT_CODE=${?}
echo "Exiting with code: ${EXIT_CODE}"
exit ${EXIT_CODE}
