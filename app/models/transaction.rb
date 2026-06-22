class Transaction < ApplicationRecord
  KINDS = %w[income expense].freeze
  CATEGORIES = ["Salário", "Moradia", "Alimentação", "Transporte", "Lazer", "Saúde", "Investimentos", "Outros"].freeze

  validates :description, presence: true
  validates :kind, inclusion: { in: KINDS }
  validates :amount_cents, numericality: { greater_than: 0 }
  validates :occurred_on, presence: true

  scope :incomes,  -> { where(kind: "income") }
  scope :expenses, -> { where(kind: "expense") }
  scope :in_month, ->(date) { where(occurred_on: date.beginning_of_month..date.end_of_month) }

  def amount = (amount_cents || 0) / 100.0
  def income?  = kind == "income"
  def expense? = kind == "expense"

  # --- Agregações para o dashboard ---

  def self.total_income  = incomes.sum(:amount_cents)
  def self.total_expense = expenses.sum(:amount_cents)
  def self.balance       = total_income - total_expense

  # Gastos por categoria (para o gráfico de pizza): { "Moradia" => 250000, ... }
  def self.expense_by_category
    expenses.group(:category).sum(:amount_cents)
            .transform_values { |c| c / 100.0 }
            .sort_by { |_, v| -v }.to_h
  end

  # Receitas x despesas por mês (para o gráfico de barras).
  def self.monthly_summary(months: 6)
    range = (months - 1).downto(0).map { |i| i.months.ago.to_date.beginning_of_month }
    range.map do |month_start|
      label = I18n.l(month_start, format: "%b/%Y") rescue month_start.strftime("%m/%Y")
      {
        month: label,
        income:  in_month(month_start).incomes.sum(:amount_cents) / 100.0,
        expense: in_month(month_start).expenses.sum(:amount_cents) / 100.0
      }
    end
  end

  def self.format_brl(cents)
    ActiveSupport::NumberHelper.number_to_currency(cents / 100.0, unit: "R$ ", separator: ",", delimiter: ".")
  end
end
