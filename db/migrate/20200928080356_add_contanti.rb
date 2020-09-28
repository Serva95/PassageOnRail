class AddContanti < ActiveRecord::Migration[6.0]
  def change
    execute "INSERT INTO pay_methods (id, intestatario, numero, mese_scadenza, anno_scadenza, cvv, created_at, updated_at) values (0, 'Contanti', 'Contanti', '01', '99', 123, now(), now())"
  end
end
