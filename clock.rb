require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler {|job| job.perform_async}

  every(1.day, CleanTmpFilesWorker, :at => '00:00')
  every(1.day, NotifyAdminWorker, :at => '23:00')

  every(30.seconds, SyncLocalItemsWorker)
  every(30.seconds, SyncLocalCompaniesWorker)
  every(30.seconds, SyncLocalSalesOrdersWorker)
  every(30.seconds, SyncLocalPurchaseOrdersWorker)
  every(30.seconds, SyncLocalCreditNotesWorker)
  every(10.seconds, ProcessRouteVisitWorker)
  every(10.seconds, ProcessStockLevelsWorker)
  every(10.seconds, NotificationWorker)

  every(1.hour, SyncRemoteItemsWorker)
  every(1.hour, SyncRemoteCompaniesWorker)

  # Not using due to xero lineitemid issue
  # every(1.hour, SyncRemoteSalesOrdersWorker)
  # every(1.hour, SyncRemotePurchaseOrdersWorker)
  # every(1.hour, SyncRemoteCreditNotesWorker)
end
