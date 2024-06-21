iris_file_path = "D:\zjw\demo\machine learning\Iris-data.csv"
with open(iris_file_path, 'r', encoding='utf-8') as file:
    iris_data = file.readlines()

for line in iris_data[:5]:
    print(line.strip())