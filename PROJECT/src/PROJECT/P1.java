package PROJECT;

import utils.DataInput;

public class P1 {

    private int numOfRows = 0;
    private static double[] average;
    private static String[] keys;
    private static int[] values;
    private static String[] input;

    public static void main(String[] args) {
        P1 p1 = new P1();
        input = new String[10000];
        keys = new String[10000];
        values = new int[10000];
        p1.getInput(input);

        p1.divideArray(input, keys, values);
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
    private void divideArray(String[] input, String[] keys, int[] values){
        for(int i = 0; i < numOfRows; i++){
            String[] info = input[i].split("\\s+");
            keys[i] = info[0];
            values[i] = Integer.parseInt(info[1]);
        }
    }

    //додам створення масиву з середніми значеннями
    private void getAverage(String[] keys, int[] values){
        for(int i = 0; i < numOfRows; i++){
            calcAverage(keys[i], values);
        }
    }

    private void calcAverage(String key, int[] values){

    }
}
