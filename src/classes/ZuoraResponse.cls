public with sharing class ZuoraResponse {
    public Boolean success;
    public String Id;
    public String message;
    public List<ZuoraError> Errors;
    public List<ZuoraError> reasons;

    public String getErrorMessage(String title) {
        String error = title + ' ';
        if (message != null) {
            error += message;
        }
        if (Errors != null) {
            for (ZuoraError err : Errors) {
                error += ' ' + err.message;
            }
        }
        if (reasons != null) {
            for (ZuoraError err : reasons) {
                error += ' ' + err.message;
            }
        }
        return error;
    }

    public class ZuoraError {
        public String message;
        public String code;
    }
}