package utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public final class DataInput {

    private static void writeText(String wr) {
        if (wr == null)
            System.out.print("Введіть дані: ");
        else
            System.out.print(wr);
    }

    public static Long getLong(String phrase) throws IOException {
        writeText(phrase);

        String s = getString();
        if (isInteger(s))
            return Long.valueOf(s);
        System.out.println("Введені дані не є числом класу long.");
        return 2147483648L;
    }

    public static char getChar(String phrase) throws IOException {
        writeText(phrase);

        String s = getString();
        return s.charAt(0);
    }

    public static Integer getInt(String phrase) {
        writeText(phrase);
        String s = getString();

        if (isInteger(s)) {
            return Integer.valueOf(s);
        } else {
            System.out.println("Ви ввели щось загадкове.");
            System.exit(0);
        }
        return Integer.valueOf(s);
    }

    public static java.lang.String getString() {

        InputStreamReader isr = new InputStreamReader(System.in);
        BufferedReader br = new BufferedReader(isr);
        String s = null;
        try {
            s = br.readLine();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        return s;
    }

    public static String getString(String phrase) {
        writeText(phrase);
        return getString();
    }

    public static boolean isInteger(String s) {

        if (s.isEmpty())
            return false;

        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '-' && s.length() > 1) {
            } else if (s.charAt(i) < '0' || s.charAt(i) > '9') {
                return false;
            }
        }
        return true;

    }

    public static boolean isString(String s){

        for(int i = 0; i< s.length(); i++){
            if(s.charAt(i) >= '1' && s.charAt(i) < '9')
                return false;
        }

        return true;
    }

    public static double getDouble(String phrase) {

        writeText(phrase);
        String s = getString();
        double d = Double.parseDouble(s);
        if (isDouble(s))
            return d;
        return -1;

    }

    public static boolean isDouble(String s) {
        try {
            double d = Double.parseDouble(s);
        } catch (NumberFormatException e) {
            System.out.println("Введені дані не є числом класу double.");
            return false;
        }
        return true;
    }

    public static String capitalize(String str) {
        if (str == null || str.length() <= 1)
            return str;
        return str.substring(0, 1).toUpperCase() + str.substring(1);
    }

    public static int nextInt(int min, int max) {
        return min + (int) (Math.random() * ((max - min) + 1));
    }

    public static double nextDouble(int min, int max) {
        return min + (Math.random() * ((max - min) + 1));
    }
}