# -*- coding: utf-8 -*-
"""
Created on Tue Feb  7 18:01:26 2017

@author: sahoo015
"""

# from sklearn.svm import LinearSVC, SVC
from sklearn.linear_model import LogisticRegression
from MultiGaussClassify import MultiGaussClassify
import math

import numpy as np

def my_cross_val(method, X, y, k):
    
    # Initialize models based on the method name
    if method == "MultiGaussClassify":
        myModel = MultiGaussClassify()
    elif method == "LogisticRegression":
        myModel = LogisticRegression(penalty='l2')
    
    total_samples = y.size
    samples_per_partition = math.ceil(total_samples/k)

    # Initialize all zeros vector for storing error arrays for each fold
    err = np.zeros(k)

    for i in range(0,k):
        
        # For each value of i, reserve the corresponding partition for test purpose
        # Save left and right indices which mark the start and end of test dataset
        test_index_l = i*samples_per_partition
        test_index_r = i*samples_per_partition+samples_per_partition
        # For the last dataset make the right index as the last sample number to avoid any error
        if (i == k-1):
            test_index_r = total_samples
        
        # Save the test dataset
        X_test = X[test_index_l:test_index_r, :]
        y_test = y[test_index_l:test_index_r]
        
        # Save the left part of the training dataset
        X_l = X[0:test_index_l, :]
        y_l = y[0:test_index_l]

        # Save the left part of the training dataset
        X_r = X[test_index_r:total_samples, :]
        y_r = y[test_index_r:total_samples]
        
        # Concatenate both to get the complete training dataset
        X_train = np.concatenate((X_l, X_r))
        y_train = np.concatenate((y_l, y_r))

        # Fit the model using training dataset
        myModel.fit(X_train, y_train)
        
        # Predict the outputs of the test dataset
        y_pred = myModel.predict(X_test)

        # Initialize all zeros array for all the data points
        e = np.zeros(y_test.size)
        
        # Make 1 for all the points where there was an error
        # Predition and test values of target did not match.
        e[y_test != y_pred] = 1

        # Save the error values for each fold
        err[i] = np.mean(e)

    print("Error rate : ", err, " , Mean : ", np.mean(err), " , Standard Deviation : ", np.std(err))
    return err
