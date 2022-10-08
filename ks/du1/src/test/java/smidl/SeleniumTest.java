package smidl;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.Duration;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

/**
 * Testing Authetization and Authorization system of bakery shop
 */
public class SeleniumTest {
    public WebDriver driver;

    @BeforeEach
    public void setup() {
        driver = new ChromeDriver();

    }

    @AfterEach
    public void quit() {
        driver.quit();
    }

    /**
     * Test correct login credentials
     */
    @Test
    public void testCorrectLogin() {
        driver.get("https://bakery-flow.demo.vaadin.com/login");
        driver.manage().timeouts().implicitlyWait(Duration.ofMillis(500));

        WebElement username = driver.findElement(By.id("vaadinLoginUsername"));
        username.sendKeys("admin@vaadin.com");
        WebElement password = driver.findElement(By.id("vaadinLoginPassword"));
        password.sendKeys("admin");
        WebElement loginBtn = driver.findElement(By.tagName("vaadin-button"));
        loginBtn.click();

        String title = driver.getTitle();
        assertEquals("Storefront", title);

    }

    /**
     * Test incorrect email address
     */
    @Test
    public void testIncorrectCredentials() {
        driver.get("https://bakery-flow.demo.vaadin.com/login");
        driver.manage().timeouts().implicitlyWait(Duration.ofMillis(500));

        WebElement username = driver.findElement(By.id("vaadinLoginUsername"));
        username.sendKeys("invalid@vaadin.com");
        WebElement password = driver.findElement(By.id("vaadinLoginPassword"));
        password.sendKeys("admin");
        WebElement loginBtn = driver.findElement(By.tagName("vaadin-button"));
        loginBtn.click();
        String errorUrl = driver.getCurrentUrl();
        assertEquals("https://bakery-flow.demo.vaadin.com/login?error", errorUrl);

    }

    /**
     * Test that barista user cannot acces admin pages
     */
    @Test
    public void testAuthorization() {
        // Login as Barista
        driver.get("https://bakery-flow.demo.vaadin.com/login");
        driver.manage().timeouts().implicitlyWait(Duration.ofMillis(500));

        WebElement username = driver.findElement(By.id("vaadinLoginUsername"));
        username.sendKeys("barista@vaadin.com");
        WebElement password = driver.findElement(By.id("vaadinLoginPassword"));
        password.sendKeys("barista");
        WebElement loginBtn = driver.findElement(By.tagName("vaadin-button"));
        loginBtn.click();

        // Access secured route
        driver.get("https://bakery-flow.demo.vaadin.com/users");
        assertEquals("Access denied", driver.getTitle());
    }

}
