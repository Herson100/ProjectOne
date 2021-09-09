public class DistanceCalculatorController {
	public Contact[] cusCons {get; set;}
    public Contact single {get; set;}
    public string inputHolder {get; set;}
    public Integer inputNum {get; set;}
    public String tempOutput {get; set;}
    
    public DistanceCalculatorController() {
        cusCons = [SELECT lastName FROM Contact LIMIT 20];
        single = [SELECT lastName FROM Contact LIMIT 1];
        inputHolder = 'initial';
        //adsList = [SELECT Name, Length__c FROM Ad__c WHERE NOT (Length__c = null) LIMIT 20];
        tempOutput = 'initial';
        
        
    }
    
    public void remover() {
        HTTp thing = new HTTp();
        
		HTTpRequest apier = new HTTpRequest();
        apier.setMethod('GET');
        apier.setEndpoint('https://api.tomtom.com/routing/1/calculateRoute/52.50931%2C13.42936%3A52.50274%2C13.43872/xml?avoid=unpavedRoads&key=9sJWV9i2gsog74RN6XwGdFMLosz8iAwN');
        
        HTTpResponse result = thing.send(apier);
        tempOutput = result.getBody();
        
        JSONParser parser = JSON.createParser(tempOutput);
        /*
        for (Integer i = 0; i < 50; i++) {
            parser.nextToken();
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == inputHolder)) {
                parser.nextToken();
                tempOutput = parser.getText();
                break;
            }
        }
        */
        
        //Dom.Document domOutput = result.getBodyDocument();
        /*
        Dom.XMLNode root = domOutput.getRootElement();
        Dom.XMLNode r2 = root.getChildElement('abilities', null);
        Dom.XMLNode r3 = r2.getChildElement('0', null);
        Dom.XMLNode r4 = r3.getChildElement('slot', null);
        String output = r4.getText();
        System.debug(output);
        tempOutput = output;*/
    }
    
    public void decreaser() {/*
        for (Integer i = 0; i < adsList.Size(); i++) {
            adsList[i].Length__c -= InputNum;
            if (adsList[i].Length__c < 0) {
                adsList[i].Length__c = 0 - adsList[i].Length__c;
            }
        }
        reorder();*/
    }
    
    public void reorder() {
        /*List<AdWrapper> toSort = new List<AdWrapper>();
        for (Integer i = 0; i < adsList.Size(); i++) {
            toSort.add(new AdWrapper(adsList[i]));
        }
        toSort.sort();
        for (Integer i = 0; i < adsList.Size(); i++) {
            adsList[i] = toSort[i].ad;
        }*/
    }
}