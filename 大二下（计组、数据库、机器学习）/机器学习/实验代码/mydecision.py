from collections import Counter  
from math import log2  
import numpy as np 

class Node:  
        def __init__(self, feature_index=None, threshold=None, value=None, left=None, right=None, label=None):  
            self.feature_index = feature_index  # 划分特征索引  
            self.threshold = threshold          # 划分阈值（对于连续特征）
            self.value = value                  # 结点值
            self.left = left                    # 左子树  
            self.right = right                  # 右子树  
            self.label = label                  # 叶子节点标签  
  

class DecisionClassifier:  
    def __init__(self, max_depth=None):  
        self.max_depth = max_depth  
        self.root = None  

    def fit(self, X, y):  
        # 计算熵值
        def calculate_entropy(labels):  
            c = Counter(labels)  
            ent = sum(-(c[i] / len(labels)) * log2(c[i] / len(labels)) for i in c)  
            return ent  
  
        #将数据按照threshold分割
        def split_data(X, y, feature_index, threshold):  
            left_indices = [i for i in range(len(X)) if X[i][feature_index] <= threshold]  
            right_indices = [i for i in range(len(X)) if X[i][feature_index] > threshold]  
            return (X[left_indices], y[left_indices]), (X[right_indices], y[right_indices])  
  
        def best_split(X, y):  
            best_gain = 0  
            best_feature_index = None  
            best_threshold = None  
            original_entropy = calculate_entropy(y)  
  
            for feature_index in range(X.shape[1]):  
                thresholds = sorted(set(X[:, feature_index]))  
                for threshold in thresholds:  
                    left_X, left_y = split_data(X, y, feature_index, threshold)[0]  
                    right_X, right_y = split_data(X, y, feature_index, threshold)[1]  
                      
                    if len(left_y) == 0 or len(right_y) == 0:  
                        continue  
  
                    weighted_ent = (len(left_y) / len(y)) * calculate_entropy(left_y) +  (len(right_y) / len(y)) * calculate_entropy(right_y)  
                    gain = original_entropy - weighted_ent  
  
                    if gain > best_gain:  
                        best_gain = gain  
                        best_feature_index = feature_index  
                        best_threshold = threshold  
  
            return best_gain, best_feature_index, best_threshold  
  
        def build_tree(X, y, depth=0):  
            if len(y) == 0 or (self.max_depth is not None and depth >= self.max_depth):  
                return Node(label=Counter(y).most_common(1)[0][0])  
  
            if len(set(y)) == 1:  
                return Node(label=y[0])  
  
            gain, feature_index, threshold = best_split(X, y)  
            if gain <= 0:  
                return Node(label=Counter(y).most_common(1)[0][0])  
  
            left_X, left_y = split_data(X, y, feature_index, threshold)[0]  
            right_X, right_y = split_data(X, y, feature_index, threshold)[1]  
  
            root = Node(feature_index=feature_index, threshold=threshold)  
            root.left = build_tree(left_X, left_y, depth + 1)  
            root.right = build_tree(right_X, right_y, depth + 1)  
  
            return root  
  
        self.root = build_tree(X, y)  
  
    def predict(self, X):  
        def traverse_tree(node, x):  
            if node.label is not None:  
                return node.label  
  
            if x[node.feature_index] <= node.threshold:  
                return traverse_tree(node.left, x)  
            else:  
                return traverse_tree(node.right, x)  
        predictions = []  
        for x in X:  
            predictions.append(traverse_tree(self.root, x))  
        return np.array(predictions)  
    

class DecisionRegressor:  
    def __init__(self, max_depth=None):  
        self.max_depth = max_depth  
        self.root = None  
  
    def fit(self, X, y):  
        def _find_best_split(X, y, depth):   
            best_mse = float('inf')  
            best_feature_index = None  
            best_threshold = None  
    
            for feature_index in range(X.shape[1]):  
                thresholds = sorted(set(X[:, feature_index])) 
                #thresholds = np.unique(X[:, feature_index])  
                for threshold in thresholds:  
                    # 根据阈值分割数据  
                    left_indices = [i for i in range(len(X)) if X[i][feature_index] <= threshold]  
                    right_indices = [i for i in range(len(X)) if X[i][feature_index] > threshold]
                    #left_indices = X[:, feature_index] <= threshold   
                    #right_indices = ~left_indices  
                    left_y = y[left_indices]  
                    right_y = y[right_indices]  

                    if len(left_y) == 0 or len(right_y) == 0:  
                        continue  

                    # 计算MSE  
                    mse_left = np.mean((left_y - np.mean(left_y))**2)  
                    mse_right = np.mean((right_y - np.mean(right_y))**2)  
                    mse = len(left_y) / len(y) * mse_left + len(right_y) / len(y) * mse_right  
    
                    # 如果MSE更小，更新最佳分割  
                    if mse < best_mse:  
                        best_mse = mse  
                        best_feature_index = feature_index  
                        best_threshold = threshold  
    
            return best_feature_index, best_threshold, best_mse  
  
        def build_tree(X, y, depth=0):  
            # 终止条件：达到最大深度或所有样本值相同  
            if depth == self.max_depth or len(np.unique(y)) == 1:  
                return Node(value=np.mean(y))  
  
            # 寻找最佳分割  
            feature_index, threshold, _ = _find_best_split(X, y, depth)  
  
            # 如果没有合适的分割，返回叶子节点  
            if feature_index is None:  
                return Node(value=np.mean(y))  
  
            # 分割数据集  
            left_indices = [i for i in range(len(X)) if X[i][feature_index] <= threshold]  
            right_indices = [i for i in range(len(X)) if X[i][feature_index] > threshold]
            #left_indices = X[:, feature_index] <= threshold  
            #right_indices = ~left_indices  
            left_X = X[left_indices]  
            right_X = X[right_indices]  
            left_y = y[left_indices]  
            right_y = y[right_indices]  
  
            # 递归构建左右子树  
            left_child = build_tree(left_X, left_y, depth + 1)  
            right_child = build_tree(right_X, right_y, depth + 1)  
  
            # 返回节点  
            return Node(feature_index=feature_index, threshold=threshold, left=left_child, right=right_child)  
  
        self.root = build_tree(X, y)  
  
    def predict(self, X):  
        def traverse_tree(node, x):  
            if node.value is not None:  
                return node.value  
  
            if x[node.feature_index] <= node.threshold:  
                return traverse_tree(node.left, x)  
            else:  
                return traverse_tree(node.right, x)  
  
        return np.array([traverse_tree(self.root, x) for x in X]) 