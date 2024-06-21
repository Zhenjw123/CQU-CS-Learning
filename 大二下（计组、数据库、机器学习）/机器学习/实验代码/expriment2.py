from __future__ import division
import math
import random
import pandas as pd
import numpy as np
from sklearn import datasets
 
flowerLables = {0: 'Iris-setosa',
                1: 'Iris-versicolor',
                2: 'Iris-virginica'}
 
random.seed(0)
 
def rand(a, b):
    return (b - a) * random.random() + a
 
# 生成矩阵
def makeMatrix(I, J, fill=0.0):
    m = []
    for i in range(I):
        m.append([fill] * J)
    return m
 
# 函数 sigmoid
def sigmoid(x):
    return 1.0 / (1.0 + np.exp(-x))
 
# 函数 sigmoid 的导数
def dsigmoid(x):
    return x * (1 - x)
 
class BP:
    def __init__(self, ni, nh, no):
        # 输入层、隐藏层、输出层的节点（数）
        self.ni = ni + 1  # 增加一个偏差节点
        self.nh = nh + 1
        self.no = no
 
        # 输入层ai，隐藏层ah，输出层ao
        self.ai = [1.0] * self.ni
        self.ah = [1.0] * self.nh
        self.ao = [1.0] * self.no
 
        # 建立权重（矩阵）
        self.wi = makeMatrix(self.ni, self.nh)
        self.wo = makeMatrix(self.nh, self.no)
        # 设为随机值
        for i in range(self.ni):
            for j in range(self.nh):
                self.wi[i][j] = rand(-0.2, 0.2)
        for j in range(self.nh):
            for k in range(self.no):
                self.wo[j][k] = rand(-2, 2)
 
    def update(self, inputs):
        if len(inputs) != self.ni - 1:
            raise ValueError('与输入层节点数不符！')
 
        # 激活输入层
        for i in range(self.ni - 1):
            self.ai[i] = inputs[i]
 
        # 激活隐藏层
        for j in range(self.nh):
            sum = 0.0
            for i in range(self.ni):
                sum = sum + self.ai[i] * self.wi[i][j]
            self.ah[j] = sigmoid(sum)
 
        # 激活输出层
        for k in range(self.no):
            sum = 0.0
            for j in range(self.nh):
                sum = sum + self.ah[j] * self.wo[j][k]
            self.ao[k] = sigmoid(sum)
 
        return self.ao[:]
 
    def backPropagate(self, targets, lr):
        """ 反向传播 """
 
        # 计算输出层的误差
        output_deltas = [0.0] * self.no
        for k in range(self.no):
            error = targets[k] - self.ao[k]
            output_deltas[k] = dsigmoid(self.ao[k]) * error
 
        # 计算隐藏层的误差
        hidden_deltas = [0.0] * self.nh
        for j in range(self.nh):
            error = 0.0
            for k in range(self.no):
                error = error + output_deltas[k] * self.wo[j][k]
            hidden_deltas[j] = dsigmoid(self.ah[j]) * error
 
        # 更新输出层权重
        for j in range(self.nh):
            for k in range(self.no):
                change = output_deltas[k] * self.ah[j]
                self.wo[j][k] = self.wo[j][k] + lr * change
 
        # 更新输入层权重
        for i in range(self.ni):
            for j in range(self.nh):
                change = hidden_deltas[j] * self.ai[i]
                self.wi[i][j] = self.wi[i][j] + lr * change
 
        # 计算误差
        error = 0.0
        error += 0.5 * (targets[k] - self.ao[k]) ** 2
        return error
 
    def weights(self):
        print('输入层权重:')
        for i in range(self.ni):
            tempa=['%.4f'% x for x in self.wi[i]]
            print(tempa)
        # print()
        print('\n输出层权重:')
        for j in range(self.nh):
            tempa = ['%.4f'% x for x in self.wo[j]]
            print(tempa)

 
    def train(self, patterns, iterations=1000, lr=0.1):
        for i in range(iterations):
            error = 0.0
            for p in patterns:
                inputs = p[0]
                targets = p[1]
                self.update(inputs)
                error = error + self.backPropagate(targets, lr)
            if i % (iterations/10) == 0:
                print('error_update: %-.9f' % error)

    def testflower(self, patterns):
        count = 0
        for p in patterns:
            target = flowerLables[(p[1].index(1))]
            result = self.update(p[0])
            index = result.index(max(result))
            print(p[0], ':', target, '->', flowerLables[index])
            count += (target == flowerLables[index])
        accuracy = float(count / len(patterns))
        print('accuracy: %-.9f' % accuracy)

    def testdigit(self, patterns):
        count = 0
        for p in patterns:
            target = (p[1].index(1))
            result = self.update(p[0])
            index = result.index(max(result))
            #print(target, '->', index)
            count += (target == index)
        accuracy = float(count / len(patterns))
        print('accuracy: %-.9f' % accuracy)
 
def Iris():
    data = []
    # 读取数据
    raw = pd.read_csv('D:\zjw\demo\machine learning\Iris-data.csv')
    raw_data = raw.values
    raw_feature = raw_data[0:, 1:4]
    # 数据处理
    for i in range(len(raw_feature)):
        ele = []
        ele.append(list(raw_feature[i]))
        if raw_data[i][5] == 'Iris-setosa':
            ele.append([1, 0, 0])
        elif raw_data[i][5] == 'Iris-versicolor':
            ele.append([0, 1, 0])
        else:
            ele.append([0, 0, 1])
        data.append(ele)
    # 随机排列数据
    random.shuffle(data)
    training = data[0:100]
    test = data[101:]
    bp1 = BP(3, 3, 3)
    bp1.train(training, iterations=100,lr=0.1)
    bp1.testflower(test)
    bp1.weights()

def digit():
    data=[]
    digits = datasets.load_digits()
    dataread = digits.data
    featureread = digits.target
    for i in range(len(featureread)):
        ele=[]
        ele.append(dataread[i])
        zerovector = [0]*10
        zerovector[featureread[i]] = 1
        ele.append(zerovector)
        data.append(ele)
    random.shuffle(data)
    training = data[0:400]
    test = data[400:]
    bp1 = BP(64, 20, 10)
    bp1.train(training, iterations=500,lr=0.2)
    bp1.testdigit(test)
    # bp1.weights()


if __name__ == '__main__':
    Iris()
    digit()