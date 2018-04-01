class CreateDiversities < ActiveRecord::Migration[5.1]
  def change
    create_view :diversities
  end
end
