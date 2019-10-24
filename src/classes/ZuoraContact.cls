public with sharing class ZuoraContact {
    public String Id { get; set; }
    public String AccountId { get; set; }
    public String Address1 { get; set; }
    public String Address2 { get; set; }
    public String City { get; set; }
    public String Country { get; set; }
    public String Fax { get; set; }
    public String FirstName { get; set; }
    public String HomePhone { get; set; }
    public String LastName { get; set; }
    public String MobilePhone { get; set; }
    public String OtherPhone { get; set; }
    public String OtherPhoneType { get; set; }
    public String PersonalEmail { get; set; }
    public String PostalCode { get; set; }
    public String State { get; set; }
    public String WorkEmail { get; set; }
    public String WorkPhone { get; set; }
    public String NickName { get; set; }

    public ZuoraContact() {
    }

    public static Boolean isChanged(ZuoraContact zuoraContact1, ZuoraContact zuoraContact2) {
        return !(zuoraContact1.Id == zuoraContact2.Id || (String.isEmpty(zuoraContact1.Id) && String.isEmpty(zuoraContact2.Id)))
                || !(zuoraContact1.AccountId == zuoraContact2.AccountId || (String.isEmpty(zuoraContact1.AccountId) && String.isEmpty(zuoraContact2.AccountId)))
                || !(zuoraContact1.Address1 == zuoraContact2.Address1 || (String.isEmpty(zuoraContact1.Address1) && String.isEmpty(zuoraContact2.Address1)))
                || !(zuoraContact1.Address2 == zuoraContact2.Address2 || (String.isEmpty(zuoraContact1.Address2) && String.isEmpty(zuoraContact2.Address2)))
                || !(zuoraContact1.City == zuoraContact2.City || (String.isEmpty(zuoraContact1.City) && String.isEmpty(zuoraContact2.City)))
                || !(zuoraContact1.Country == zuoraContact2.Country || (String.isEmpty(zuoraContact1.Country) && String.isEmpty(zuoraContact2.Country)))
                || !(zuoraContact1.Fax == zuoraContact2.Fax || (String.isEmpty(zuoraContact1.Fax) && String.isEmpty(zuoraContact2.Fax)))
                || !(zuoraContact1.FirstName == zuoraContact2.FirstName || (String.isEmpty(zuoraContact1.FirstName) && String.isEmpty(zuoraContact2.FirstName)))
                || !(zuoraContact1.HomePhone == zuoraContact2.HomePhone || (String.isEmpty(zuoraContact1.HomePhone) && String.isEmpty(zuoraContact2.HomePhone)))
                || !(zuoraContact1.LastName == zuoraContact2.LastName || (String.isEmpty(zuoraContact1.LastName) && String.isEmpty(zuoraContact2.LastName)))
                || !(zuoraContact1.MobilePhone == zuoraContact2.MobilePhone || (String.isEmpty(zuoraContact1.MobilePhone) && String.isEmpty(zuoraContact2.MobilePhone)))
                || !(zuoraContact1.OtherPhone == zuoraContact2.OtherPhone || (String.isEmpty(zuoraContact1.OtherPhone) && String.isEmpty(zuoraContact2.OtherPhone)))
                || !(zuoraContact1.OtherPhoneType == zuoraContact2.OtherPhoneType || (String.isEmpty(zuoraContact1.OtherPhoneType) && String.isEmpty(zuoraContact2.OtherPhoneType)))
                || !(zuoraContact1.PersonalEmail == zuoraContact2.PersonalEmail || (String.isEmpty(zuoraContact1.PersonalEmail) && String.isEmpty(zuoraContact2.PersonalEmail)))
                || !(zuoraContact1.PostalCode == zuoraContact2.PostalCode || (String.isEmpty(zuoraContact1.PostalCode) && String.isEmpty(zuoraContact2.PostalCode)))
                || !(zuoraContact1.State == zuoraContact2.State || (String.isEmpty(zuoraContact1.State) && String.isEmpty(zuoraContact2.State)))
                || !(zuoraContact1.WorkEmail == zuoraContact2.WorkEmail || (String.isEmpty(zuoraContact1.WorkEmail) && String.isEmpty(zuoraContact2.WorkEmail)))
                || !(zuoraContact1.WorkPhone == zuoraContact2.WorkPhone || (String.isEmpty(zuoraContact1.WorkPhone) && String.isEmpty(zuoraContact2.WorkPhone)))
                || !(zuoraContact1.NickName == zuoraContact2.NickName || (String.isEmpty(zuoraContact1.NickName) && String.isEmpty(zuoraContact2.NickName)));
    }

    public ZuoraContact copy() {
        ZuoraContact contact = new ZuoraContact();
        contact.Id = this.Id;
        contact.AccountId = this.AccountId ;
        contact.Address1 = this.Address1 ;
        contact.Address2 = this.Address2 ;
        contact.City = this.City ;
        contact.Country = this.Country ;
        contact.Fax = this.Fax ;
        contact.FirstName = this.FirstName ;
        contact.HomePhone = this.HomePhone ;
        contact.LastName = this.LastName ;
        contact.MobilePhone = this.MobilePhone ;
        contact.OtherPhone = this.OtherPhone ;
        contact.OtherPhoneType = this.OtherPhoneType ;
        contact.PersonalEmail = this.PersonalEmail ;
        contact.PostalCode = this.PostalCode ;
        contact.State = this.State ;
        contact.WorkEmail = this.WorkEmail ;
        contact.WorkPhone = this.WorkPhone ;
        contact.NickName = this.NickName ;
        return contact;
    }

    public ZuoraContact(Contact contact, ZuoraContact oldContact) {
        Id = oldContact.Id;
        AccountId = oldContact.AccountId;

        String street = contact.MailingStreet;
        if (street != null) {
            Address1 = street.substring(0, Math.min(255, street.length()));
            if (street.length() > 255) {
                Address2 = street.substring(255, Math.min(255 + 255, street.length()));
            }
        }
        City = contact.MailingCity;
        Country = contact.MailingCountry;
        Fax = contact.Fax;
        FirstName = contact.FirstName;
        HomePhone = contact.HomePhone;
        LastName = contact.LastName;
        MobilePhone = contact.MobilePhone;
        OtherPhone = contact.OtherPhone;
        OtherPhoneType = 'Other';
        PostalCode = contact.MailingPostalCode;
        State = contact.MailingState;
        WorkEmail = contact.Email;
        WorkPhone = contact.Phone;
    }

    public List<SelectOption> getPhoneTypes() {
        return new List<SelectOption>{
                new SelectOption('Work', 'Work'), new SelectOption('Mobile', 'Mobile'), new SelectOption('Home', 'Home'), new SelectOption('Other', 'Other')
        };
    }

    public static HttpRequest getGetRequest(ZuoraTokenResponse token, String id) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:__Zuora_REST_Api/v1/object/contact/' + id);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token.access_token);
        return req;
    }

    public HttpRequest getCreateRequest(ZuoraTokenResponse token) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:__Zuora_REST_Api/v1/object/contact');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('POST');
        req.setBody(JSON.serialize(this, true));
        req.setHeader('Authorization', 'Bearer ' + token.access_token);
        return req;
    }

    public HttpRequest getUpdateRequest(ZuoraTokenResponse token) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:__Zuora_REST_Api/v1/object/contact/' + this.Id);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setMethod('PUT');
        req.setBody(JSON.serialize(this, true));
        req.setHeader('Authorization', 'Bearer ' + token.access_token);
        return req;
    }
}