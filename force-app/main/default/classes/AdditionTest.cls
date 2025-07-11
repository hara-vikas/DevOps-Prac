@isTest
public class AdditionTest {
    //test class for addition
    @isTest
    static void addTest() {
        Integer result = Addition.add(1, 2);
        System.assertEquals(3, result, 'True');
    }
}