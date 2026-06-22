Transaction.delete_all

# Gera 6 meses de lançamentos realistas.
6.downto(0) do |i|
  month = i.months.ago.to_date

  # Receita mensal (salário)
  Transaction.create!(description: "Salário", kind: "income", category: "Salário",
                      amount_cents: 850_000, occurred_on: month.change(day: 5))

  # Despesas recorrentes + variáveis
  [
    ["Aluguel",            "Moradia",       180_000],
    ["Supermercado",       "Alimentação",   95_000 + rand(0..40) * 1000],
    ["Transporte/Combustível", "Transporte", 32_000 + rand(0..20) * 1000],
    ["Plano de saúde",     "Saúde",         42_000],
    ["Streaming e lazer",  "Lazer",         18_000 + rand(0..25) * 1000],
    ["Aporte investimento","Investimentos", 120_000]
  ].each do |desc, cat, cents|
    Transaction.create!(description: desc, kind: "expense", category: cat,
                        amount_cents: cents, occurred_on: month.change(day: 10 + rand(0..15)))
  end
end

puts "Lançamentos: #{Transaction.count} | saldo: #{Transaction.format_brl(Transaction.balance)}"
