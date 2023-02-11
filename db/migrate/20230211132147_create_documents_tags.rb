class CreateDocumentsTags < ActiveRecord::Migration[7.0]
  def change
    create_table :documents_tags do |t|
      t.references :document, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end
  end
end
