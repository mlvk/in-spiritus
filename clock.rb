require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler {|job| job.perform_async}

  every(1.day, CleanTmpFilesWorker, :at => '00:00')

  every(10.seconds, SyncLocalItemsWorker)
  every(10.seconds, SyncLocalCompaniesWorker)
  every(10.seconds, SyncLocalSalesOrdersWorker)
  every(10.seconds, SyncLocalCreditNotesWorker)
  every(10.seconds, ProcessRouteVisitWorker)
  every(10.seconds, ProcessStockLevelsWorker)

  every(1.hour, SyncRemoteItemsWorker)
  every(1.hour, SyncRemoteCompaniesWorker)
  every(1.hour, SyncRemoteSalesOrdersWorker)
  every(1.hour, SyncRemoteCreditNotesWorker)
end
