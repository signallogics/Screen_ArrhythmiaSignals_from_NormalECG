# -*- coding: utf-8 -*-
"""
Created on Sun May  7 14:35:19 2017

@author: sahoo015
"""

from sklearn.svm import LinearSVC, SVC
from sklearn.linear_model import LogisticRegression
import math
import scipy.io as sio
import numpy as np

train_data_path = 'C:\\Users\\sahoo015\\Desktop\\project_FLDA\\data\\train\\ecg_signal.mat'
train_data = sio.loadmat(train_data_path)
y_train = train_data['ecg_sig_target']
y_train[y_train==0] = -1
train_data_path = 'C:\\Users\\sahoo015\\Desktop\\project_FLDA\\data\\train\\features\\db4.mat'
train_data = sio.loadmat(train_data_path)
X_train = train_data['wavelet_features']


test_data_path = 'C:\\Users\\sahoo015\\Desktop\\project_FLDA\\data\\test\\ecg_signal.mat'
test_data = sio.loadmat(test_data_path)
y_test = test_data['ecg_sig_target']
y_test[y_test==0] = -1
test_data_path = 'C:\\Users\\sahoo015\\Desktop\\project_FLDA\\data\\test\\features\\db4.mat'
test_data = sio.loadmat(test_data_path)
X_test = test_data['wavelet_features']

#parti = int(X_train.shape[0]*0.8)
#
#X_test = X_train[parti+1:-1,:]
#y_test = y_train[parti+1:-1]
#X_train = X_train[0:parti,:]
#y_train = y_train[0:parti]

err = np.zeros((3,1))

my_model = LinearSVC();
my_model.fit(X_train,y_train)

y_pred = my_model.predict(X_test)
e = np.zeros(y_test.size)
e[np.squeeze(y_test) != y_pred] = 1
err[0] = np.mean(e)

#my_model = SVC();
#my_model.fit(X_train,y_train)
#
#y_pred = my_model.predict(X_test)
#e = np.zeros(y_test.size)
#e[np.squeeze(y_test) != y_pred] = 1
#err[1] = np.mean(e)

my_model = LogisticRegression();
my_model.fit(X_train,y_train)

y_pred = my_model.predict(X_test)
e = np.zeros(y_test.size)
e[np.squeeze(y_test) != y_pred] = 1
err[2] = np.mean(e)