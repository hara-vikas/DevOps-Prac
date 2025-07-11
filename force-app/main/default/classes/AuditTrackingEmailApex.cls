global class AuditTrackingEmailApex implements Database.Batchable<Sobject>,Database.Stateful




{

   

    public static SetupAuditTraila__c customSettingRec=SetupAuditTraila__c.getInstance();

   

    static Date FromDate=customSettingRec.StartDateForAudit__c;

   

    static Date ToDate=customSettingRec.EndDateForAudit__c;

   

    static List<String> getEmailIdsOfRecepients=customSettingRec.RecipentsId__c.split(',');

   

    static List<SetupAuditTrail> changesTracked=new List<SetupAuditTrail>();

   

    // url orgUrl= System.Url.getOrgDomainUrl();

   

    String urlInstance = String.valueof(System.URL.getSalesforceBaseURL()).replace('Url:[delegate=','').replace(']','');

   

    String messageToDeliver='<head><style>table, th, td { border: 1px solid black; border-collapse: collapse; } </style> </head> <body><h2>Changes In Your Org ' + urlInstance  + '</h2><p>Below changes occured in your org </p><table style="width:100%"><tr> <th>SNO</th> <th>Occured On</th> <th>Created By</th> <th>Action</th>  <th>Section</th> <th>Details</th> <th>Delegated Login</th> </tr>';

   

    Integer count=0;

   

    static Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

   

    global  Database.QueryLocator start(Database.BatchableContext BC)

       

    {

       

        return Database.getQueryLocator([SELECT CreatedById,CreatedBy.UserName,CreatedDate,Display,Section,CreatedByContext,Action,delegateUser

                                         

                                         FROM SetupAuditTrail where createdDate >=:FromDate  and createdDate <=: ToDate and  CreatedBy.username != null  order by CreatedDate desc

                                         

                                        ]);

       

    }

   

    global  void execute(Database.BatchableContext BC,List<SetupAuditTrail> changesTracked)

       

    {

       

        System.debug('Print the dates' + customSettingRec );

       

        if(changesTracked.size()>0 && getEmailIdsOfRecepients.size()>0){

           

            if(!getEmailIdsOfRecepients.isEmpty() || getEmailIdsOfRecepients!=NULL)

               

                for(SetupAuditTrail audit:changesTracked)

               

            {

               

                count++;

               

               

               

               

                messageToDeliver= messageToDeliver + '<TR><TD>' + count + '</TD>' + '<TD>' + audit.CreatedDate + '</TD>' + '<TD>' + audit.CreatedBy.UserName + '</TD>' + '<TD>' + audit.Action + '</TD>' + '<TD>' + audit.Section + '</TD>' +  '<TD>' + audit.Display + '</TD>' +  '<TD>' + audit.DelegateUser + '</TD>' ;

               

               

               

               

            }

           

           

           

           

           

           

        }

       

       

       

       

    }

   

   

   

   

   

    global  void finish(Database.BatchableContext BC)

       

    {

       

       

       

       

        String emailSubject='Metadata Changes Tracked In Your Org #Audit Trails';

       

        message.toAddresses = getEmailIdsOfRecepients;

       

        message.subject = emailSubject;

       

        message.setHtmlBody(messageToDeliver);

       

        //Id customSettingRecId=

        //System.debug('SetupAuditTraila__c.getInstance()>>'+customSettingRecId);

       

       

        SetupAuditTraila__c customSettingRecord = [SELECT Id,StartDateForAudit__c,EndDateForAudit__c

                                                   FROM SetupAuditTraila__c LIMIT 1];

        System.debug('Print the dates' + customSettingRecord );

        customSettingRecord.StartDateForAudit__c=System.Today();

       

       

        customSettingRecord.EndDateForAudit__c=System.Today()+6;

       

        update  customSettingRecord;

       

       

       

       

       

       

       

        try {

           

            List<Messaging.SendEmailResult> results= Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});

           

        } catch(System.CalloutException e) {

           

            System.debug('ERROR:' + e);

           

        }

       

       

       

       

       

    }

   

   

   

   

}