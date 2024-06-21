from sklearn.datasets import load_iris  
from sklearn.datasets import load_breast_cancer  
from sklearn.model_selection import train_test_split    
from sklearn.metrics import accuracy_score   
from sklearn.metrics import mean_squared_error 
import mydecision
import pandas as pd 
import numpy as np

 #分类任务

def taskfenlei(X_train, X_test, y_train, y_test):
    clf = mydecision.DecisionClassifier()  
    clf.fit(X_train, y_train)  #训练
    y_pred = clf.predict(X_test)  #测试集
    accuracy = accuracy_score(y_test, y_pred)
    print(f'这是决策树分类,精准度Accuracy:\n {accuracy}')

#回归任务
def taskhuigui(X_train, X_test, y_train, y_test):
    reg = mydecision.DecisionRegressor()   
    reg.fit(X_train, y_train)    
    y_pred = reg.predict(X_test)   
    '''
    valid_indices = ~np.isnan(y_test) & ~np.isnan(y_pred)  
    y_true_valid = y_test[valid_indices]  
    y_pred_valid = y_pred[valid_indices]  
    rmse = np.sqrt(np.mean((y_true_valid - y_pred_valid) ** 2))
    '''
    mse = mean_squared_error(y_test, y_pred)  
    rmse = np.sqrt(mse) 
    print(f'这是决策树回归，均方根误差RMSE:\n {rmse}')

def classify():
    # 加载鸢尾花数据集  
    iris = load_iris()  
    X = iris.data  
    y = iris.target  
    # 划分数据集  
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5, random_state=42) 
    print('数据集：鸢尾花')
    taskfenlei(X_train, X_test, y_train, y_test)
    
    # 加载乳腺癌数据集  
    breast_cancer = load_breast_cancer()  
    X = breast_cancer.data  
    y = breast_cancer.target    
    y = y.astype(int)  
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42) 
    print('数据集：乳腺癌') 
    taskfenlei(X_train, X_test, y_train, y_test)

def regressor():
    # 加州房价数据集：数据处理
    datafile = 'D:\zjw\demo\machine learning\housing.data'
    data = np.fromfile(datafile, sep=' ')
    feature_names = [ 'CRIM', 'ZN', 'INDUS', 'CHAS', 'NOX', 'RM', 'AGE','DIS', 
                    'RAD', 'TAX', 'PTRATIO', 'B', 'LSTAT', 'MEDV' ]
    feature_num = len(feature_names)
    data = data.reshape([data.shape[0] // feature_num, feature_num])
    ratio = 0.8 #此处的含义就是将80%的数据用于训练
    offset = int(data.shape[0] * ratio)
    maximums, minimums= data.max(axis=0),data.min(axis=0)
    # 对数据进行归一化处理
    for i in range(feature_num):
        data[:, i] = (data[:, i] - minimums[i]) / (maximums[i] - minimums[i])
    test_data = data[offset:]
    x = data[:, :-1]
    y = data[:, -1:]
    X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)
    print('数据集：加州房价数据集')
    taskhuigui(X_train, X_test, y_train, y_test)

    file_path = 'D:\zjw\demo\machine learning\mpg.csv'  
    mpg_data = pd.read_csv(file_path)  
    # 选择需要的列（最后一列是名字不需要）  
    selected_columns = ['mpg', 'cylinders', 'displacement', 'horsepower', 'weight', 'acceleration', 'model_year', 'origin']  
    mpg_selected_data = mpg_data[selected_columns]   
    # 独热编码转换三分类数据
    mpg_one_hot = pd.get_dummies(mpg_selected_data, columns=['origin'])  
    # 显示处理后的数据  
    x_init = mpg_one_hot.drop('mpg',axis=1)
    y_init = mpg_one_hot['mpg']
    x=x_init.values
    y=y_init.values
    X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)
    print('数据集：mpg，燃油价格数据集')
    taskhuigui(X_train, X_test, y_train, y_test)


if __name__ == '__main__':
    classify()
    regressor()