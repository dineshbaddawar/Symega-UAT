public class TestUtility {

    public static Account createAccount(String Accountname){
        Account acc = new Account(Name = Accountname);
        insert acc;
        return acc;
    }
}