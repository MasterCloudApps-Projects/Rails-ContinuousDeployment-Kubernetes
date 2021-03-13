# frozen_string_literal: true

class ProductCreate
  include Sneakers::Worker

  QUEUE_NAME = 'product'
  from_queue QUEUE_NAME, arguments: { 'x-dead-letter-exchange': "#{QUEUE_NAME}-retry" }

  def work(msg)
    data = ActiveSupport::JSON.decode(msg)
    data['products'].each do |product|
      product_user(product.to_h)
    end
    ack!
  rescue StandardError => e
    create_log(false, data, message: e.message)
    reject!
  end

  private

  def product_user(product_hash)
    user = Product.find_by(id: product_hash['id'])
    user.assign_attributes product_hash.slice('title', 'detail', 'price').compact
    user.save!
  rescue StandardError => e
    create_log(false, user, message: e.message)
  end

  def create_log(success, payload, message = {})
    message = {
      success: success,
      payload: payload
    }.merge(message).to_json

    severity = success ? :info : :error
    Rails.logger.send(severity, message)
  end
end