import numpy as np
import random
import matplotlib.pyplot as plt
import csv

def loadDataSet(filename):
    dataset = []
    labelset = []
    with open(filename, 'r', encoding='utf-8') as csvfile:
        csv_reader = csv.reader(csvfile)
        header = next(csv_reader)
        for row in csv_reader:
            data_row = [float(row[1]), float(row[2]),float(row[3]),float(row[4])]
            dataset.append(data_row)
    return dataset

    
def findCentroids(datMat,k):    #获取三组不同的中心点
    data_set=np.array(datMat)
    init_centers_1 = random.sample(data_set.tolist(), k)
    init_centers_2 = random.sample(data_set.tolist(), k)
    init_centers_3 = random.sample(data_set.tolist(), k)

    centroidsList=[]
    centroidsList.append(np.array(init_centers_1))
    centroidsList.append(np.array(init_centers_2))
    centroidsList.append(np.array(init_centers_3))
    return centroidsList

def distEclud(vecA,vecB):     #计算欧式距离
    return np.sqrt(sum(np.power(vecA-vecB,2)))

def Kmeans(data_get,centroidsList):   #划分k个簇
#    np.array(data_get)     #将数据集转为数组
    distculde = {}   #建立一个字典
    flag = 0        #元素分类标记，记录与相应聚类距离最近的那个类
    for data in data_get:
        vecA = np.array(data)
        minDis = float('inf')     #始化为最大值
        for i in range(len(centroidsList)):
            vecB = centroidsList[i]
            distance = distEclud(vecA, vecB)    #计算距离
            if distance < minDis:     #直至找出距离最小的质点
                minDis = distance
                flag = i
        if flag not in distculde.keys():
            distculde[flag] = list()
        distculde[flag].append(data)
    return distculde

def getCentroids(distculde):   #得到新的质心
    newcentroidsList = []     #建立新质点集
    for key in distculde:    
        cent = np.array(distculde[key])
        newcentroid = np.mean(cent,axis=0)      #计算新质点
        newcentroidsList.append(newcentroid.tolist()) 
    return np.array(newcentroidsList)     #返回新质点数组

def calculate_Var(distculde, centroidsList):
    #计算均方误差
    item_sum = 0.0
    for key in distculde:
        vecA = centroidsList[key]
        dist = 0.0
        for item in distculde[key]:
            vecB = np.array(item)
            dist += distEclud(vecA, vecB)
        item_sum += dist
    return item_sum
        

def showCluster(distculde, centroidsList, initcentrol):
    # 画聚类图像
    plt.figure()
    x = []
    y = []
    x.append(centroidsList[:,0].tolist())
    y.append(centroidsList[:,1].tolist())
    init_centers = np.array(initcentrol)
    x_centers = init_centers[:, 0]
    y_centers = init_centers[:, 1]
    '''
    new_centers = np.array(centroidsList)
    x_centers_new = new_centers[:, 0]
    y_centers_new = new_centers[:, 1]
    '''

    colourList = ['g^', 'bo', 'r^', 'yo']
    for i in distculde:
        # 获取每簇
        centx = []
        centy = []
        for item in distculde[i]:
            centx.append(item[0])
            centy.append(item[1])
        plt.plot(centx, centy, colourList[i])   # 画簇

    plt.scatter(x_centers, y_centers, color='black', label='Init Center Points')
    #plt.scatter(x_centers_new, y_centers_new, color=(1,0,1), label='New Center Points')
    plt.plot(x, y, 'k*')  # 画质点，为黑色*
    plt.legend()
    plt.show()


def kmeansfork(k):
    datMat = loadDataSet('D:\zjw\demo\machine learning\Iris-data.csv')
    centroidsList = findCentroids(datMat, k)     #随机获得k个聚类中心
    for centrolist in centroidsList:
        initcentrol=[]
        initcentrol = centrolist
        distculde = Kmeans(datMat,centrolist)     #第一次聚类迭代
        newVar = calculate_Var(distculde,centrolist)   
        oldVar = -0.0001   #初始化均方误差
        while abs(newVar - oldVar) >= 0.0001:
            centroidsList = getCentroids(distculde)
            distculde = Kmeans(datMat, centrolist)
            oldVar = newVar
            newVar = calculate_Var(distculde, centrolist)
        showCluster(distculde,centrolist,initcentrol)

if __name__ == "__main__":
    k_values = [2, 3, 4]
    for k in k_values:
        kmeansfork(k)
    
