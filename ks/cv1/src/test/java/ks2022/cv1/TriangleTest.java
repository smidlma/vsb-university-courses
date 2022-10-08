package ks2022.cv1;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

public class TriangleTest {

    @ParameterizedTest(name = "Triangle test a={0}, b={1}, c={2}, res={3}")
    @CsvSource(value = { "0,0,0,false", "5,2,6,true", "5,-2,6,false" })
    void testIsValid(int a, int b, int c, boolean result) {
        Triangle t = new Triangle(a, b, c);
        assertEquals(result, t.isValid());
    }

    @Test
    void testIsValidZeroTriangle() {
        Triangle t = new Triangle(0, 0, 0);
        assertFalse(t.isValid());
    }

    @Test
    void testIsValidValidTriangle() {
        Triangle t = new Triangle(5, 2, 6);
        assertTrue(t.isValid());
    }
}
