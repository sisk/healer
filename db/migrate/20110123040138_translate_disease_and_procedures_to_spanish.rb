class TranslateDiseaseAndProceduresToSpanish < ActiveRecord::Migration
  def self.up
    rename_column :procedures, :base_name, :name_en
    add_column :procedures, :name_es, :string
    rename_column :diseases, :base_name, :name_en
    add_column :diseases, :name_es, :string
    rename_column :body_parts, :name, :name_en
    add_column :body_parts, :name_es, :string
  end

  def self.down
    remove_column :body_parts, :name_es
    rename_column :body_parts, :name_en
    remove_column :diseases, :name_es
    rename_column :diseases, :name_en
    remove_column :procedures, :name_es
    rename_column :procedures, :name_en
  end
end