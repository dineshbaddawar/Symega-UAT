@isTest
public class BeatPlanControllerTest {

    @isTest
    public static void AllRolesXKPICurrentUserTest() {
        
        List<BeatPlanController.WrapperClass> WrapperRecList = new List<BeatPlanController.WrapperClass>();
        
        string startDate = Datetime.now().format('yyyy-MM-dd');
        string endDate = Datetime.now().format('yyyy-MM-dd');
        BeatPlanController.AllRolesXKPICurrentUser();
        BeatPlanController.GetAllMonthlyBeatPlanner(startDate,endDate,WrapperRecList);
    }
}