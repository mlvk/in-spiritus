require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler {|job| job.perform_async}

  every(5.seconds, SyncLocalItemsWorker)
  every(5.seconds, SyncLocalCompaniesWorker)
  every(5.seconds, SyncLocalSalesOrdersWorker)
  every(5.seconds, SyncLocalCreditNotesWorker)

  every(1.hour, SyncRemoteItemsWorker)
  every(1.hour, SyncRemoteCompaniesWorker)
  every(1.hour, SyncRemoteSalesOrdersWorker)
  every(1.hour, SyncRemoteCreditNotesWorker)

end
