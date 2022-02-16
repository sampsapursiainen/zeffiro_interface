#!/bin/sh
# This wrapper script is intended to be submitted to Slurm to support
# communicating jobs.
#
# This script uses the following environment variables set by the submit MATLAB code:
# PARALLEL_SERVER_CMR         - the value of ClusterMatlabRoot (may be empty)
# PARALLEL_SERVER_MATLAB_EXE  - the MATLAB executable to use
# PARALLEL_SERVER_MATLAB_ARGS - the MATLAB args to use
# PARALLEL_SERVER_DEBUG       - used to debug problems on the cluster
#
# The following environment variables are forwarded through mpiexec:
# PARALLEL_SERVER_DECODE_FUNCTION     - the decode function to use
# PARALLEL_SERVER_STORAGE_LOCATION    - used by decode function
# PARALLEL_SERVER_STORAGE_CONSTRUCTOR - used by decode function
# PARALLEL_SERVER_JOB_LOCATION        - used by decode function
#
# The following environment variables are set by Slurm:
# SLURM_NODELIST - list of hostnames allocated to this Slurm job

# Copyright 2015-2019 The MathWorks, Inc.

# If PARALLEL_SERVER_ environment variables are not set, assign any
# available values with form MDCE_ for backwards compatibility
PARALLEL_SERVER_CMR=${PARALLEL_SERVER_CMR:="${MDCE_CMR}"}
PARALLEL_SERVER_MATLAB_EXE=${PARALLEL_SERVER_MATLAB_EXE:="${MDCE_MATLAB_EXE}"}
PARALLEL_SERVER_MATLAB_ARGS=${PARALLEL_SERVER_MATLAB_ARGS:="${MDCE_MATLAB_ARGS}"}
PARALLEL_SERVER_DEBUG=${PARALLEL_SERVER_DEBUG:="${MDCE_DEBUG}"}
PARALLEL_SERVER_TOTAL_TASKS=${PARALLEL_SERVER_TOTAL_TASKS:="${MDCE_TOTAL_TASKS}"}

# Echo the nodes that the scheduler has allocated to this job:
echo -e "The scheduler has allocated the following nodes to this job:\n${SLURM_NODELIST:?"Node list undefined"}"

# Can't guarantee that module will be on the system path for non-interactive shell
export MODULEPATH_ROOT=/appl/spack/modulefiles/linux-rhel7-x86_64
export MODULEPATH=${MODULEPATH_ROOT}/Core:/appl/modulefiles
source /appl/spack/install-tree/gcc-4.8.5/lmod-7.8-tf4lqs/lmod/7.8/init/bash

module load intel/18.0.5 intel-mpi/18.0.5
FULL_MPIEXEC=mpiexec.hydra
# Override default bootstrap
# Options are: ssh, rsh, slurm, lsf, and sge
export I_MPI_HYDRA_BOOTSTRAP=slurm
# Ensure that mpiexec is not using the Slurm PMI library
# I_MPI_PMI_LIBRARY must not be defined
unset I_MPI_PMI_LIBRARY

export SLURM_CPU_BIND=none

export TZ="Europe/Helsinki"

# Label stdout/stderr with the rank of the process
MPI_VERBOSE=-l

# Increase the verbosity of mpiexec if PARALLEL_SERVER_DEBUG is true
if [ "X${PARALLEL_SERVER_DEBUG}X" = "XtrueX" ] ; then
    MPI_VERBOSE="${MPI_VERBOSE} -v -print-all-exitcodes"
fi

# Construct the command to run.
CMD="\"${FULL_MPIEXEC}\" ${MPI_VERBOSE} -n ${PARALLEL_SERVER_TOTAL_TASKS} \"${PARALLEL_SERVER_MATLAB_EXE}\" ${PARALLEL_SERVER_MATLAB_ARGS}"

# Echo the command so that it is shown in the output log.
echo $CMD

# Execute the command.
eval $CMD

MPIEXEC_EXIT_CODE=${?}
if [ ${MPIEXEC_EXIT_CODE} -eq 42 ] ; then
    # Get here if user code errored out within MATLAB. Overwrite this to zero in
    # this case.
    echo "Overwriting MPIEXEC exit code from 42 to zero (42 indicates a user-code failure)"
    MPIEXEC_EXIT_CODE=0
fi
echo "Exiting with code: ${MPIEXEC_EXIT_CODE}"
exit ${MPIEXEC_EXIT_CODE}
