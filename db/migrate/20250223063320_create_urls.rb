# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :short_url
      t.string :code
      t.string :redirect_url
      t.timestamps

      t.index ['code'], name: 'index_urls_on_code'
      t.index ['original_url'], name: 'index_urls_on_original_url'
    end
  end
end
