require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    Transaction.create!(description: "Salário", kind: "income", category: "Salário", amount_cents: 800_000, occurred_on: Date.current)
    Transaction.create!(description: "Aluguel", kind: "expense", category: "Moradia", amount_cents: 200_000, occurred_on: Date.current)
    Transaction.create!(description: "Mercado", kind: "expense", category: "Alimentação", amount_cents: 100_000, occurred_on: Date.current)
  end

  test "valida tipo, valor e descrição" do
    assert_not Transaction.new(description: "", kind: "x", amount_cents: -1).valid?
  end

  test "totais de receita, despesa e saldo" do
    assert_equal 800_000, Transaction.total_income
    assert_equal 300_000, Transaction.total_expense
    assert_equal 500_000, Transaction.balance
  end

  test "gastos por categoria vêm ordenados do maior para o menor" do
    by_cat = Transaction.expense_by_category
    assert_equal({ "Moradia" => 2000.0, "Alimentação" => 1000.0 }, by_cat)
    assert_equal "Moradia", by_cat.keys.first
  end

  test "resumo mensal cobre o número pedido de meses" do
    summary = Transaction.monthly_summary(months: 6)
    assert_equal 6, summary.size
    atual = summary.last
    assert_equal 8000.0, atual[:income]
    assert_equal 3000.0, atual[:expense]
  end

  test "formata BRL" do
    assert_equal "R$ 5.000,00", Transaction.format_brl(500_000)
  end
end
