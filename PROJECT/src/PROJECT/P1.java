package PROJECT;

import utils.DataInput;

//Дарія Булавіна
public class P1 {

    private int numOfUniqueKeys = 0;
    private int numOfRows = 0;
    private static double[] average;
    private static String[] uniqueKeys;
    private static String[] keys;
    private static int[] values;
    private static String[] input;

    public static void main(String[] args) {
        P1 p1 = new P1();
        input = new String[10000];
        keys = new String[10000];
        uniqueKeys = new String[10000];
        values = new int[10000];
        average = new double[10000];

        p1.getInput(input);
        p1.divideArray(input, keys, values);
        p1.getAverage(keys, values);

        System.out.println();

        for(int i = 0; i < p1.numOfUniqueKeys; i++){
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
}

