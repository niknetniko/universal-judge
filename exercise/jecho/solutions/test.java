import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String name = reader.readLine();
        System.out.println(name);
    }

    public static String echo(String a, int b) {
        System.out.println(a + "-" + b);
        return a + "-" + b;
    }

    public static void echo2(String a, int b) {
        System.out.println(a + "-" + b);
        var c = a + "-" + b;
    }
}