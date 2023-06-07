import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import classification_report, confusion_matrix
####
df = pd.read_csv('dataset/milknew.csv')
print(df.head())
####
print(df.info())
####
df = df.rename(columns={'Temprature': 'Temperature'})
df = df.rename(columns={'Fat ': 'Fat'})
print(df.columns)
####
print(df.describe())
####
sns.countplot(x="Grade", data=df, palette="Blues")
plt.show()
####
sns.set_style("whitegrid")

for parameter in df.columns[:-1]:
    fig, axs = plt.subplots(figsize=(13, 7), nrows=1, ncols=3, sharey=True)
    fig.suptitle('Distribution of {} by Milk Grade'.format(parameter))

    for i, grade in enumerate(['low', 'medium', 'high']):
        data_grade = df[df['Grade'] == grade]
        sns.histplot(data=data_grade[parameter], kde=True, ax=axs[i])
        axs[i].set_xlabel('Value')
        axs[i].set_ylabel('Frequency')
        axs[i].set_title(grade.capitalize())

    plt.tight_layout()
    plt.show()
####
X = df.drop('Grade', axis=1)
y = df['Grade']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
####
dtc = DecisionTreeClassifier()
dtc.fit(X_train, y_train)

train_predictions_dtc = dtc.predict(X_train)
test_predictions_dtc = dtc.predict(X_test)

train_accuracy_dtc = accuracy_score(y_train, train_predictions_dtc)
test_accuracy_dtc = accuracy_score(y_test, test_predictions_dtc)

print("[DTC] Training Accuracy:", train_accuracy_dtc)
print("[DTC] Test Accuracy:", test_accuracy_dtc)
####
rfc = RandomForestClassifier()

rfc.fit(X_train, y_train)
test_prediction_rfc = rfc.predict(X_test)
train_prediction_rfc = rfc.predict(X_train)

test_accuracy_rfc = accuracy_score(y_test, test_prediction_rfc)
train_accuracy_rfc = accuracy_score(y_train, train_prediction_rfc)
print("[RFC] Training Accuracy:", train_accuracy_rfc)
print("[RFC] Test Accuracy:", test_accuracy_rfc)
####
param_grid = {'n_neighbors': range(1, 10)}

knn = KNeighborsClassifier()

grid_search = GridSearchCV(knn, param_grid, cv=5)
grid_search.fit(X_train, y_train)

best_k = grid_search.best_params_['n_neighbors']

print("The best k value:", best_k)
####
knn = grid_search.best_estimator_
knn.fit(X_train, y_train)

train_prediction_knn = knn.predict(X_train)
test_prediction_knn = knn.predict(X_test)

train_accuracy_knn = accuracy_score(train_prediction_knn, y_train)
test_accuracy_knn = accuracy_score(test_prediction_knn, y_test)

print("[KNN] Training Accuracy:", train_accuracy_knn)
print("[KNN] Test Accuracy:", test_accuracy_knn)
####
dtree_importance = dtc.feature_importances_
sorted_indices = np.argsort(dtree_importance)[::-1]
sorted_importance = dtree_importance[sorted_indices]

feature_labels = ['pH', 'Temperature', 'Taste', 'Odor', 'Fat', 'Turbidity', 'Colour']

plt.figure(figsize=(10, 6))
plt.bar(range(len(dtree_importance)), sorted_importance, align='center')
plt.xticks(range(len(dtree_importance)), [feature_labels[i] for i in sorted_indices], rotation=45)
plt.xlabel('Features')
plt.ylabel('Importance')
plt.title('Feature Importance in Decision Tree Classifier')
plt.tight_layout()
plt.show()
####
rfc_importance = rfc.feature_importances_

sorted_indices = np.argsort(rfc_importance)[::-1]
sorted_importance = rfc_importance[sorted_indices]

plt.figure(figsize=(10, 6))
plt.bar(range(len(rfc_importance)), sorted_importance, align='center')
plt.xticks(range(len(rfc_importance)), [feature_labels[i] for i in sorted_indices], rotation=45)
plt.xlabel('Features')
plt.ylabel('Importance')
plt.title('Feature Importance in Random Forest Classifier')
plt.tight_layout()
plt.show()
####
feature_importance = {}
for feature in X_train.columns:
    X_train_subset = X_train.drop(feature, axis=1)
    X_val_subset = X_test.drop(feature, axis=1)

    knn_subset = KNeighborsClassifier()
    knn_subset.fit(X_train_subset, y_train)
    y_pred_subset = knn_subset.predict(X_val_subset)
    accuracy_subset = accuracy_score(y_test, y_pred_subset)

    feature_importance[feature] = accuracy_score(test_prediction_knn, y_test) - accuracy_subset

sorted_importance = sorted(feature_importance.items(), key=lambda x: x[1], reverse=True)

features = [item[0] for item in sorted_importance]
importance_values = [item[1] for item in sorted_importance]

total_importance = sum(importance_values)

normalized_importance = [importance / total_importance for importance in importance_values]

plt.figure(figsize=(10, 6))
plt.bar(features, normalized_importance)
plt.xlabel('Features')
plt.ylabel('Normalized Importance')
plt.title('Normalized Feature Importance in KNN Model')
plt.xticks(rotation=90)
plt.show()
####
models = [dtc, rfc, knn]
names = ['Decision Tree Classifier', 'Random Forest Classifier', 'K-NearestNeighbors']
class_labels = ['high', 'low', 'medium']

for model, name in zip(models, names):
    cm = confusion_matrix(y_true=y_test, y_pred=model.predict(X_test))
    cm_df = pd.DataFrame(cm, index=class_labels, columns=class_labels)
    sns.heatmap(cm_df, annot=True, fmt='d', cmap='Blues')

    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.title(f'Confusion Matrix for {name}')
    plt.show()

    report = classification_report(y_test, model.predict(X_test))
    print(f'Classification report for {name}:', report, sep='\n')