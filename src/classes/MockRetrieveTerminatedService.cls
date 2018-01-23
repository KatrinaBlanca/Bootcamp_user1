@isTest

global class MockRetrieveTerminatedService implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"GetServiceDetailsResponse":{"status":"S","SIN":"100111500101","initialResponsibleTeam":"1000167","responsibleTeam":"1000167","terminationDate":"2015-12-12","landmarksDirection":"COR.,DONPEPE","name":"THETHOUSANDBUDDHATEMPLEINC","doingBusinessAs":"","customerTitle":"","firstName":"","middleName":"","lastName":"THETHOUSANDBUDDHATEMPLEINC","birthDate":"1995-12-12","emailAddress":"","customerTypeCd":"","isConglomerate":"false","taxIdNumber":"","serviceDescription":"","businessSegmentCd":"BSEGTYP003","appliedLoad":"70.0","phaseCd":"THRPHSW","voltageCd":"CTENS00107","psicCd":"8121","demandFactor":"0.7","loadFactor":"0.3","contractedCapacity":"49.0","serviceRateTypeCd":"140TYSERRA","billingClassCd":"3","discountProgram":"","rateProgram":"100","supplyTypeCd":"SSTIP00001","meteringSchemeCd":"TIMOD00001","retrievalModeCd":"TIHOR00005","serviceWirePhaseCd":"THRPHSW","serviceWireVoltageCd":"CTENS00107","serviceWireType":"LINTYP0002","tln":"112620","poleNumber":"K62277","serviceWireLength":"0","serviceWireSizeCd":"SERWR00001","materialCd":"MATER00002","customerNumber":"19785","isForBusinessCustomer": "false", "address":{"barangayCd":"06035000600000","cityMunicipalCd":"06035000000000","provinceCd":"06000000000000","streetNo":"0010","streetNameCd":"89224","subdivisionCd":"06035000600001","premiseTypeCd":"PLTYP00003","unitNo":"GP(SCHOOL)"}}}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;

    }

}