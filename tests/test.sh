#!/bin/bash

SCIPY_ML_TESTDIR=$TESTDIR/scipy-ml-notebook
if ! jupyter nbconvert --execute "${SCIPY_ML_TESTDIR}/scipy-ml-notebook-gpu.ipynb"; then
    echo "Integration test failed"
    echo "could not execute scipy-ml-notebook"
    exit 1
fi

if ! jupyter nbconvert --ExecutePreprocessor.kernel_name=ml-latest "${SCIPY_ML_TESTDIR}/scipy-ml-notebook-gpu.ipynb"; then
    echo "Integration test failed"
    echo "could not execute scipy-ml-notebook"
    exit 1
fi

if ! test -f "${SCIPY_ML_TESTDIR}/scipy-ml-notebook-gpu.html"; then
    echo "Integration test failed"
    echo "Compiled scipy-ml-notebook.html does not exist"
    exit 1
fi

echo "scipy-ml-notebook tests passed!"