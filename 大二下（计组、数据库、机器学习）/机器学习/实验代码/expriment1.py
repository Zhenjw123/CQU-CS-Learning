import csv
import numpy as np
from sklearn.model_selection import train_test_split

#读取西瓜数据集中的数据并返回
def loadDataset1(filename):
    dataset = []
    labelset = []
    with open(filename, 'r', encoding='utf-8') as csvfile:
        csv_reader = csv.reader(csvfile)
        header = next(csv_reader)
        for row in csv_reader:
            data_row = [float(row[1]), float(row[2])]
            dataset.append(data_row)
            labelset.append(int(row[3]))
    return dataset, labelset

#读取鸢尾花数据集中的数据并返回（2和2p2分别对应两种分类方式）
def loadDataset2(filename):
    dataset = []
    labelset = []
    with open(filename, 'r', encoding='utf-8') as csvfile:
        csv_reader = csv.reader(csvfile)
        header = next(csv_reader)
        for row in csv_reader:
            data_row = [float(row[1]), float(row[2]),float(row[3]),float(row[4])]
            dataset.append(data_row)
            if row[5]=='Iris-setosa' or row[5]=='Iris-versicolor':
                labelset.append(1)
            else:
                labelset.append(0)
    return dataset, labelset

def loadDataset2p2(filename):
    dataset = []
    labelset = []
    with open(filename, 'r', encoding='utf-8') as csvfile:
        csv_reader = csv.reader(csvfile)
        header = next(csv_reader)
        for row in csv_reader:
            data_row = [float(row[1]), float(row[2]),float(row[3]),float(row[4])]
            if row[5]=='Iris-setosa':
                labelset.append(1)
                dataset.append(data_row)
            elif row[5]=='Iris-versicolor':
                labelset.append(0)
                dataset.append(data_row)
    return dataset, labelset

#定义sigmoid函数
def sigmoid(z):
	return 1.0 / (1 + np.exp(-z))

#计算准确率
def test(dataset,labelset,w):
    data=np.mat(dataset)

    y=sigmoid(np.dot(data,w))
    b,c=np.shape(y)
    #功能是查看矩阵或者数组的维数。
    rightcount=0

    for i in range(b):
        flag=-1
        if y[i,0]>0.5:
            flag=1
        elif y[i,0]<0.5:
            flag=0
        if labelset[i] == flag:
            rightcount+=1

    rightrate=rightcount/len(dataset)
    #print(rightrate)
    return rightrate

#迭代求w
def training(dataset,labelset,highw):
    data=np.mat(dataset).astype(float)
    label=np.mat(labelset).transpose()
    w = np.ones((len(dataset[0]),1))

    #步长
    n=0.0001

    # 每次迭代计算一次正确率（在测试集上的正确率）
    # 达到highw的正确率，停止迭代
    rightrate=0.0
    while rightrate<highw:
        c=sigmoid(np.dot(data,w))
        b=c-label
        change = np.dot(np.transpose(data),b)
        w=w-change*n
        #预测，更新准确率
        rightrate = test(dataset,labelset,w)
    return w

#西瓜
dataset=[]
labelset=[]
filename = 'D:\zjw\demo\machine learning\watermelon_3a.csv'
dataset,labelset=loadDataset1(filename)
X_train, X_test, y_train, y_test = train_test_split(dataset, labelset, test_size=0.1, random_state=42)
w=training(X_train,y_train,0.90)
print("西瓜数据集：")
print("若使得准确率大于90%，则此时的w为：\n",w)
accuracy = test(X_test, y_test, w)
print("测试集上的准确率：%f" % (accuracy * 100) + "%")

#鸢尾花
dataset=[]
labelset=[]
filename = 'D:\zjw\demo\machine learning\Iris-data.csv'
dataset,labelset=loadDataset2(filename)
X_train, X_test, y_train, y_test = train_test_split(dataset, labelset, test_size=0.2, random_state=42)
w1=training(X_train,y_train,0.95)
print("鸢尾花数据集：")
print("对于第一次分类，准确率大于0.95，则此时的w为：\n",w1)
r1= test(X_test, y_test, w1)
print("测试集上的准确率为:%f"%(r1*100)+"%")

dataset,labelset=loadDataset2p2(filename)
X_train, X_test, y_train, y_test = train_test_split(dataset, labelset, test_size=0.2, random_state=42)
w2=training(X_train,y_train,0.95)
print("对于第二次分类，准确率大于0.95，则此时的w为：\n",w2)
r2 = test(X_test, y_test, w2)
print("测试集上的准确率为:%f"%(r2*100)+"%")
