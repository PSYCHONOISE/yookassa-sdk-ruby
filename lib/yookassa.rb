# frozen_string_literal: true

module YooKassa
end

require 'yookassa/version'
require 'yookassa/exceptions'
require 'yookassa/configuration'
require 'yookassa/user_agent'
require 'yookassa/security_helper'

# -- domain models -----------------------------------------------------
require 'yookassa/model/enums'
require 'yookassa/model/base_object'
require 'yookassa/model/generic_object'
require 'yookassa/model/amount'
require 'yookassa/model/recipient'
require 'yookassa/model/confirmation'
require 'yookassa/model/payment_method_data'
require 'yookassa/model/payout_destination'
require 'yookassa/model/settlement'
require 'yookassa/model/transfer'
require 'yookassa/model/airline'
require 'yookassa/model/authorization_details'
require 'yookassa/model/cancellation_details'
require 'yookassa/model/requestor'
require 'yookassa/model/refund_source'
require 'yookassa/model/deal_info'
require 'yookassa/model/receipt_item_supplier'
require 'yookassa/model/receipt_customer'
require 'yookassa/model/receipt_item'
require 'yookassa/model/receipt_data'

# -- HTTP client ---------------------------------------------------------
require 'yookassa/client'

# -- request objects + builders ------------------------------------------
require 'yookassa/request/payment_request'
require 'yookassa/request/capture_payment_request'
require 'yookassa/request/refund_request'
require 'yookassa/request/receipt_request'
require 'yookassa/request/payout_request'
require 'yookassa/request/deal_request'
require 'yookassa/request/webhook_request'

# -- response objects ------------------------------------------------------
require 'yookassa/response/payment_response'
require 'yookassa/response/refund_response'
require 'yookassa/response/receipt_response'
require 'yookassa/response/payout_response'
require 'yookassa/response/deal_response'
require 'yookassa/response/webhook_response'

# -- notifications ---------------------------------------------------------
require 'yookassa/notification/webhook_notification'

# -- resources --------------------------------------------------------------
require 'yookassa/resource_helpers'
require 'yookassa/payment'
require 'yookassa/refund'
require 'yookassa/receipt'
require 'yookassa/payout'
require 'yookassa/deal'
require 'yookassa/webhook'
require 'yookassa/settings'
