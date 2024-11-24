/**
 * @description: Utils
 * @author Reirysson Costa
 */
public with sharing class Utils {

    private static List<Integer> weight1CNPJ = new List<Integer>{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
    private static List<Integer> weight2CNPJ = new List<Integer>{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2};
    
    private static List<Integer> weight1CPF = new List<Integer>{10, 9, 8, 7, 6, 5, 4, 3, 2};
    private static List<Integer> weight2CPF = new List<Integer>{11, 10, 9, 8, 7, 6, 5, 4, 3, 2};

    
    public static Boolean validaCNPJ(String CNPJ){
        
        if( String.isBlank(CNPJ) || CNPJ.length() < 14 ) return false;

        String cnpjNumber = returnOnlyNumber(CNPJ);

        Integer firstDigit = calculateDigitByWeight(cnpjNumber.substring(0, 12), weight1CNPJ);

        if ( firstDigit != Integer.valueOf(cnpjNumber.substring(12, 13))) return false;

        Integer secondDigit = calculateDigitByWeight(cnpjNumber.substring(0, 13), weight2CNPJ);

        if ( secondDigit != Integer.valueOf(cnpjNumber.substring(13, 14)) && hasSequenceSameCaracter(cnpjNumber) ) return false;

        return true;
    }

    public static String returnOnlyNumber(String variableString){

        Pattern varPattern = Pattern.compile('[^0-9]');

        String formattedString = varPattern.matcher(variableString).replaceAll('');

        return formattedString;
    }

    private static Integer calculateDigitByWeight(String docNumber, List<Integer> weight) {

        Integer sum = 0;

        for (Integer i = 0; i < docNumber.length(); i++) {

            sum += Integer.valueOf(docNumber.substring(i, i + 1)) * weight.get(i);
        }

        Integer remainder = math.mod(sum, 11);

        return remainder < 2 ? 0 : 11 - remainder;
    }

    public static Boolean hasSequenceSameCaracter(String docNumber){
        if(docNumber.equals('00000000000000') 
        || docNumber.equals('11111111111111') 
        || docNumber.equals('22222222222222') 
        || docNumber.equals('33333333333333') 
        || docNumber.equals('44444444444444') 
        || docNumber.equals('55555555555555') 
        || docNumber.equals('66666666666666') 
        || docNumber.equals('77777777777777') 
        || docNumber.equals('88888888888888') 
        || docNumber.equals('99999999999999')) return false;

        return true;
    }

    public static Boolean validaCPF(String CPF){

        if( String.isBlank(CPF) || CPF.length() < 11 ) return false;

        String cpfNumber = returnOnlyNumber(CPF);

        Integer firstDigit = calculateDigitByWeight(cpfNumber.substring(0, 9), weight1CPF);

        Integer secondDigit = calculateDigitByWeight(cpfNumber.substring(0, 9) + firstDigit, weight2CPF);

        if ( !cpfNumber.endsWith(firstDigit + '' + secondDigit) && hasSequenceSameCaracter(cpfNumber) ) return false;

        return true;
    }

}