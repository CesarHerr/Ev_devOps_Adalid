@Test
public void testFlujoActualizacionPeso() {
    WebDriver driver = new ChromeDriver();
    driver.get("http://localhost:8080");
    driver.findElement(By.id("peso")).sendKeys("75.0");
    driver.findElement(By.id("btn-actualizar")).click();
    String pesoActual = driver.findElement(By.id("peso-actual")).getText();
    assertEquals("75.0", pesoActual);
    driver.quit();
}
