trigger AccountAddressTrigger on Account (before insert, before update) {

    for(Account account:Trigger.New){
        if(Account.Match_Billing_Address__c == True){
            account.ShippingPostalCode = account.BillingPostalCode;
        }
    }
}