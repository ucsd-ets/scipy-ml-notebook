#!/bin/bash

SCIPY_ML_TESTDIR=/usr/share/datahub/tests/scipy-ml-notebook

if ! jupyter nbconvert --execute "${SCIPY_ML_TESTDIR}/scipy-ml-notebook-cpu.ipynb"; then
    echo "Integration test failed"
    echo "could not execute scipy-ml-notebook"
    exit 1
fi

if ! jupyter nbconvert --ExecutePreprocessor.kernel_name=ml-latest "${SCIPY_ML_TESTDIR}/scipy-ml-notebook-cpu.ipynb"; then
    echo "Integration test failed"
    echo "could not execute scipy-ml-notebook"
    exit 1
fi

if ! test -f "${SCIPY_ML_TESTDIR}/scipy-ml-notebook-cpu.html"; then
    echo "Integration test failed"
    echo "Compiled scipy-ml-notebook.html does not exist"
    exit 1
fi

if ! nvcc --version; then
    echo "Integration test failed"
    echo "Nvidia Compiler(nvcc) does not exist"
    exit 1
fi

echo "scipy-ml-notebook tests passed!"