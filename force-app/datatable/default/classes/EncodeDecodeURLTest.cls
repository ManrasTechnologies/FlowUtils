@isTest
public with sharing class EncodeDecodeURLTest {

    @isTest
    public static void testEncodeDecode() {

        string decoded = '2:{class: slds-theme_shade slds-theme_error}';
        string encoded = '2%3A%7Bclass%3A+slds-theme_shade+slds-theme_error%7D';

        EncodeDecodeURL.Requests testRequest = new EncodeDecodeURL.Requests();

        /* Decode */
        List<EncodeDecodeURL.Requests> testDecodeRequestList = new List<EncodeDecodeURL.Requests>();
        testRequest.inputStr = encoded;
        testDecodeRequestList.add(testRequest);
        List<EncodeDecodeURL.Results> testDecodeResponseList = EncodeDecodeURL.decodeStringForURL(testDecodeRequestList);
        System.assertEquals(decoded, testDecodeResponseList[0].outputStr);

        /* Encode */
        List<EncodeDecodeURL.Requests> testEncodeRequestList = new List<EncodeDecodeURL.Requests>();
        testRequest.inputStr = decoded;
        testRequest.encode = true;
        testEncodeRequestList.add(testRequest);
        List<EncodeDecodeURL.Results> testEncodeResponseList = EncodeDecodeURL.decodeStringForURL(testEncodeRequestList);
        System.assertEquals(encoded, testEncodeResponseList[0].outputStr);

    }
}
