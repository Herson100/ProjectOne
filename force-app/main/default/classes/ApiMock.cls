@isTest
public class ApiMock implements HttpCalloutMock {

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

        response.setHeader('Content-Type', 'application/xml');
        response.setBody('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><calculateRouteResponse xmlns="http://api.tomtom.com/routing" formatVersion="0.0.12"><route><summary><lengthInMeters>1147</lengthInMeters><travelTimeInSeconds>137</travelTimeInSeconds></summary></route><route><summary><lengthInMeters>1147</lengthInMeters><travelTimeInSeconds>137</travelTimeInSeconds><trafficDelayInSeconds>0</trafficDelayInSeconds><trafficLengthInMeters>0</trafficLengthInMeters><points><point latitude="52.50930" longitude="13.42937"/><point latitude="52.50904" longitude="13.42913"/></points><arrivalTime>2021-09-11T20:53:37+02:00</arrivalTime></summary></route> </calculateRouteResponse>');
        response.setStatusCode(200);

        return response;
    }
}