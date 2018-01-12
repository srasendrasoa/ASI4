import scipy.io
import numpy as np
#import sklearn
from sklearn import svm
#from sklearn.model_selection import train_test_split
X = scipy.io.loadmat('WhiteW.mat')
X = np.array(X)
print(X)
variance = np.var(X)
moyenne = np.mean(X)
print("variance =",variance)
print("moyenne =",moyenne)
