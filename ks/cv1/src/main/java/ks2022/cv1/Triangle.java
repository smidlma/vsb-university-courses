package ks2022.cv1;

public class Triangle {
    private int a;
    private int b;
    private int c;

    public Triangle(int a, int b, int c) {
        this.a = a;
        this.b = b;
        this.c = c;
    }

    public boolean isValid() {
        if (a <= 0 || b <= 0 || c <= 0) {
            return false;
        }
        if (a + b <= c) {
            return false;
        }
        if (a + c <= b) {
            return false;
        }
        if (c + b <= a) {
            return false;
        }

        return true;
    }

}
