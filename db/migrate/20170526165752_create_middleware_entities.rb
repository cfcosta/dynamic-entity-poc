class CreateMiddlewareEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :middleware_entities do |t|
      t.string :name
      t.string :klass
      t.json :metadata

      t.timestamps
    end
  end
end
