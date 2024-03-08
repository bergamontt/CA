package PROJECT;

import utils.DataInput;

import java.util.Arrays;

//Дарія Булавіна

//програма отримує рядок у вигляді
// *ключ* *число*
// як приклад:
// a1 2
// a2 3
// Після закінчення введення програма розраховує серднє значення унікальних ключів
// і виводить їх посортованими за допомогою mergesort

public class P1 {

    private int numOfUniqueKeys = 0;
    private int numOfRows = 0;
    private double[] average;
    private double[] copyAverage;
    private String[] uniqueKeys;
    private String[] keys;
    private int[] values;
    private String[] input;

    public static void main(String[] args) {
        P1 p1 = new P1();
        p1.setup(p1);
    }

    //основні команди
    private void setup(P1 p1) {
        input = new String[10000];
        keys = new String[10000];
        uniqueKeys = new String[10000];
        values = new int[10000];
        average = new double[10000];

        p1.getInput(input);
        p1.divideArray(input, keys, values);
        p1.getAverage(keys, values);
        copyAverage = new double[numOfUniqueKeys];
        p1.copyArray(copyAverage, average);
        p1.mergeSort(average, 0, p1.numOfUniqueKeys - 1);
        p1.keySort();

        System.out.println();

        for (int i = 0; i < p1.numOfUniqueKeys; i++) {
            System.out.println(uniqueKeys[i] + " " + average[i]);
        }
    }

    //отримує від користувача масив рядків
    private void getInput(String[] input) {
        while (true) {
            String inp = DataInput.getString();
            input[numOfRows] = inp;
            numOfRows++;
            int var = DataInput.getInt("Додати ще число? (1) - так, (2) - ні.");
            if (var == 2)
                break;
        }
    }

    //ділить масив рядків на масив ключів та масив значень
    private void divideArray(String[] input, String[] keys, int[] values) {
        for (int i = 0; i < numOfRows; i++) {
            String[] info = input[i].split("\\s+");
            keys[i] = info[0];
            values[i] = Integer.parseInt(info[1]);
        }
    }

    //створює масив для середніх значень та унікальних ключів
    private void getAverage(String[] keys, int[] values) {
        for (int i = 0; i < numOfRows; i++) {
            calcAverage(keys[i], keys, values);
        }
    }

    //шукає ключі з однаковими значеннями та записує їхнє значення до загальної суми
    private void calcAverage(String key, String[] keys, int[] values) {
        int numOfKeys = 0;
        int sum = 0;
        if (!key.isEmpty()) {
            for (int i = 0; i < numOfRows; i++) {
                if (keys[i].equals(key)) {
                    sum += values[i];
                    numOfKeys++;
                    keys[i] = "";
                }
            }
            uniqueKeys[numOfUniqueKeys] = key;
            average[numOfUniqueKeys] = (double) sum / numOfKeys;
            numOfUniqueKeys++;
        }
    }

    //сортування mergesort
    public void merge(double[] arr, int left, int middle, int right) {
        int n1 = middle - left + 1;
        int n2 = right - middle;

        double[] leftArr = Arrays.copyOfRange(arr, left, left + n1);
        double[] rightArr = Arrays.copyOfRange(arr, middle + 1, middle + 1 + n2);

        int i = 0, j = 0, k = left;
        while (i < n1 && j < n2) {
            if (leftArr[i] >= rightArr[j]) {
                arr[k] = leftArr[i];
                i++;
            } else {
                arr[k] = rightArr[j];
                j++;
            }
            k++;
        }

        while (i < n1) {
            arr[k] = leftArr[i];
            i++;
            k++;
        }

        while (j < n2) {
            arr[k] = rightArr[j];
            j++;
            k++;
        }
    }

    //основа mergesort
    public void mergeSort(double[] arr, int left, int right) {
        if (left < right) {
            int middle = left + (right - left) / 2;
            mergeSort(arr, left, middle);
            mergeSort(arr, middle + 1, right);
            merge(arr, left, middle, right);
        }
    }

    //сортування ключів за середнім значенням
    public void keySort() {
        for (int i = 0; i < numOfUniqueKeys; i++) {
            for (int j = 0; j < numOfUniqueKeys; j++) {
                if (copyAverage[i] == average[j]) {
                    String temp = uniqueKeys[i];
                    uniqueKeys[i] = uniqueKeys[j];
                    uniqueKeys[j] = temp;
                }
            }
        }
    }

    //а - в який копіюють, б - з якого копіюють
    public void copyArray(double[] a, double[] b) {
        for (int i = 0; i < numOfUniqueKeys; i++) {
            a[i] = b[i];
        }
    }
}

